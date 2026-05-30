-- ══════════════════════════════════════
--   CAR SALES ANALYSIS — SQL QUERIES
--   Author: Anas Khan
--   Database: PostgreSQL 18
-- ══════════════════════════════════════

-- ── DATA CLEANING ──────────────────────

-- Fix case inconsistencies
UPDATE car_sales SET car_company = INITCAP(car_company);
UPDATE car_sales SET model = INITCAP(model);
UPDATE car_sales SET body = INITCAP(body);
UPDATE car_sales SET transmission = LOWER(transmission);

-- Fix brand names
UPDATE car_sales SET car_company = 'BMW' WHERE LOWER(car_company) = 'bmw';
UPDATE car_sales SET car_company = 'MINI' WHERE LOWER(car_company) = 'mini';
UPDATE car_sales SET car_company = 'GMC' WHERE LOWER(car_company) IN ('gmc', 'gmc truck');
UPDATE car_sales SET car_company = 'Land Rover' WHERE LOWER(car_company) IN ('land rover', 'landrover');
UPDATE car_sales SET car_company = 'Volkswagen' WHERE LOWER(car_company) IN ('volkswagen', 'vw');
UPDATE car_sales SET car_company = 'Mercedes-Benz' WHERE LOWER(car_company) IN ('mercedes-benz', 'mercedes-b', 'mercedes');
UPDATE car_sales SET car_company = 'Ford' WHERE LOWER(car_company) IN ('ford', 'ford tk', 'ford truck');
UPDATE car_sales SET car_company = 'Dodge' WHERE LOWER(car_company) IN ('dodge', 'dodge tk');

-- Remove bad data
DELETE FROM car_sales WHERE LOWER(car_company) IN ('unknown', 'dot');

-- Remove low sample companies
DELETE FROM car_sales
WHERE car_company IN ('Tesla', 'Aston Martin', 'Geo', 'Plymouth', 'Airstream');

-- Remove duplicate VINs
CREATE TABLE car_sales_clean AS
SELECT DISTINCT ON (vin) *
FROM car_sales
ORDER BY vin;

DROP TABLE car_sales;
ALTER TABLE car_sales_clean RENAME TO car_sales;

-- ── BASIC ANALYSIS ─────────────────────

-- Q1: Total cars sold
SELECT COUNT(*) AS total_cars FROM car_sales;

-- Q2: Distinct car companies
SELECT DISTINCT car_company FROM car_sales ORDER BY car_company;

-- Q3: Sales by country
SELECT country, COUNT(*) AS total_sold
FROM car_sales
GROUP BY country
ORDER BY total_sold DESC;

-- Q4: Average selling price
SELECT ROUND(AVG(selling_price), 2) AS avg_price FROM car_sales;

-- Q5: Transmission breakdown
SELECT transmission, COUNT(*) AS total_sold
FROM car_sales
GROUP BY transmission
ORDER BY total_sold DESC;

-- ── PRICING ANALYSIS ───────────────────

-- Q6: Top companies by avg selling price
SELECT car_company,
       ROUND(AVG(selling_price), 2) AS avg_price,
       COUNT(*) AS total_sold
FROM car_sales
GROUP BY car_company
ORDER BY avg_price DESC
LIMIT 10;

-- Q7: AVG vs Median profit/loss overall
SELECT
    ROUND(AVG(selling_price - mmr::numeric), 2) AS avg_profit_loss,
    PERCENTILE_CONT(0.5) WITHIN GROUP
    (ORDER BY selling_price - mmr::numeric) AS median_profit_loss,
    COUNT(*) AS total
FROM car_sales;

-- Q8: Median vs AVG profit/loss by company
SELECT car_company,
       PERCENTILE_CONT(0.5) WITHIN GROUP
       (ORDER BY selling_price - mmr::numeric) AS median_profit_loss,
       ROUND(AVG(selling_price - mmr::numeric), 2) AS avg_profit_loss,
       COUNT(*) AS total_sold
FROM car_sales
GROUP BY car_company
ORDER BY median_profit_loss DESC;

-- Q9: Companies with low sample size
SELECT car_company, COUNT(*) AS total_sold
FROM car_sales
GROUP BY car_company
HAVING COUNT(*) < 10
ORDER BY total_sold ASC;

-- ── SALES VOLUME ───────────────────────

-- Q10: Top 10 companies by sales volume
SELECT car_company, COUNT(*) AS total_sold
FROM car_sales
GROUP BY car_company
ORDER BY total_sold DESC
LIMIT 10;

-- Q11: Complete picture - volume + price + profit
SELECT car_company,
       COUNT(*) AS total_sold,
       ROUND(AVG(selling_price), 2) AS avg_price,
       PERCENTILE_CONT(0.5) WITHIN GROUP
       (ORDER BY selling_price - mmr::numeric) AS median_profit_loss
FROM car_sales
GROUP BY car_company
HAVING COUNT(*) >= 100
ORDER BY total_sold DESC
LIMIT 15;

-- ── BODY TYPE ANALYSIS ─────────────────

-- Q12: Body type performance
SELECT body,
       COUNT(*) AS total_sold,
       ROUND(AVG(selling_price), 2) AS avg_price,
       PERCENTILE_CONT(0.5) WITHIN GROUP
       (ORDER BY selling_price - mmr::numeric) AS median_profit_loss
FROM car_sales
WHERE body != 'Unknown'
GROUP BY body
HAVING COUNT(*) >= 100
ORDER BY total_sold DESC;

-- ── TIME ANALYSIS ──────────────────────

-- Q13: Monthly sales trend
SELECT month,
       COUNT(*) AS total_sold,
       ROUND(AVG(selling_price), 2) AS avg_price,
       PERCENTILE_CONT(0.5) WITHIN GROUP
       (ORDER BY selling_price - mmr::numeric) AS median_profit_loss
FROM car_sales
GROUP BY month
ORDER BY month;

-- ── COUNTRY ANALYSIS ───────────────────

-- Q14: Sales by country
SELECT country,
       COUNT(*) AS total_sold,
       ROUND(AVG(selling_price), 2) AS avg_price,
       PERCENTILE_CONT(0.5) WITHIN GROUP
       (ORDER BY selling_price - mmr::numeric) AS median_profit_loss
FROM car_sales
GROUP BY country
ORDER BY total_sold DESC;

-- ── CONDITION ANALYSIS ─────────────────

-- Q15: Condition vs price
SELECT
    CASE
        WHEN condition BETWEEN 1  AND 10 THEN '1-Poor'
        WHEN condition BETWEEN 11 AND 25 THEN '2-Fair'
        WHEN condition BETWEEN 26 AND 40 THEN '3-Good'
        ELSE '4-Excellent'
    END AS condition_group,
    COUNT(*) AS total,
    ROUND(AVG(selling_price), 2) AS avg_price,
    PERCENTILE_CONT(0.5) WITHIN GROUP
    (ORDER BY selling_price - mmr::numeric) AS median_profit_loss
FROM car_sales
GROUP BY condition_group
ORDER BY condition_group;

-- ── ODOMETER ANALYSIS ──────────────────

-- Q16: Odometer vs price
SELECT
    CASE
        WHEN odometer < 20000  THEN '1-Low (under 20k)'
        WHEN odometer < 50000  THEN '2-Mid (20-50k)'
        WHEN odometer < 100000 THEN '3-High (50-100k)'
        ELSE '4-Very High (100k+)'
    END AS odometer_group,
    COUNT(*) AS total,
    ROUND(AVG(selling_price), 2) AS avg_price,
    PERCENTILE_CONT(0.5) WITHIN GROUP
    (ORDER BY selling_price - mmr::numeric) AS median_profit_loss
FROM car_sales
WHERE odometer < 500000
GROUP BY odometer_group
ORDER BY odometer_group;

-- ── COLOR ANALYSIS ─────────────────────

-- Q17: Color popularity and price
SELECT color,
       COUNT(*) AS total_sold,
       ROUND(AVG(selling_price), 2) AS avg_price,
       PERCENTILE_CONT(0.5) WITHIN GROUP
       (ORDER BY selling_price - mmr::numeric) AS median_profit_loss
FROM car_sales
WHERE color != 'Unknown'
GROUP BY color
HAVING COUNT(*) >= 100
ORDER BY total_sold DESC;

-- ── ADVANCED ANALYSIS ──────────────────

-- Q18: Month Over Month (MOM) Growth Analysis
-- Uses CTE + LAG Window Function
WITH A AS (
    SELECT month, 
           SUM(selling_price) AS sales 
    FROM car_sales 
    GROUP BY month
)
SELECT *,
       ROUND(((sales - prev_month) / prev_month * 100), 2) AS MOM_growth_pct
FROM (
    SELECT *, 
           LAG(sales, 1) OVER (ORDER BY month) AS prev_month 
    FROM A
) B;

-- Results show:
-- Biggest drop  → September (-2.59%)
-- Biggest growth → October (+1.35%)
-- Pattern: Sales follow wave pattern throughout year
