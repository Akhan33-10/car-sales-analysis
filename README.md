# 🚗 Car Sales Data Analysis Project

## 📌 Project Overview
A complete end-to-end data analysis project analyzing 88,240 car sales 
records across 10 countries (2014-2015). The project covers data cleaning, 
SQL analysis, and interactive Power BI dashboard creation.

---

## 🛠️ Tools & Technologies
| Tool | Purpose |
|------|---------|
| Python (Pandas) | Data cleaning & preprocessing |
| PostgreSQL | Data storage & SQL analysis |
| pgAdmin 4 | SQL query execution |
| Power BI | Interactive dashboard |

---

## 📂 Project Structure
car-sales-analysis/
│
├── data/
│   ├── Car_sales.csv              # Raw dataset
│   └── Car_sales_cleaned.csv      # Cleaned dataset
│
├── python/
│   └── cleaning.ipynb             # Data cleaning notebook
│
├── sql/
│   └── queries.sql                # All SQL queries
│
├── powerbi/
│   └── car_sales_dashboard.pbix   # Power BI dashboard
│
└── README.md

---

## 🧹 Data Cleaning (Python)
- Removed 347 duplicate VIN records
- Fixed case inconsistencies (BMW/bmw, Porsche/porsche)
- Merged duplicate brand names (Mercedes/Mercedes-Benz/Mercedes-B)
- Removed companies with less than 10 sales (unreliable data)
- Fixed column name whitespace issues
- Standardized all text columns to Title Case
- Reduced companies from 94 to 43 after cleaning

---

## 🗄️ SQL Analysis
### Key Queries Performed
- Sales volume by brand, country, body type
- Average vs Median profit/loss analysis
- Outlier detection using AVG vs PERCENTILE_CONT
- Condition group analysis using CASE WHEN
- Odometer group segmentation
- Monthly sales trend analysis
- Window functions for ranking
- Data quality checks (duplicate VINs)
- Month Over Month (MOM) growth using CTE + LAG
---

## 📊 Power BI Dashboard

### Page 1 — Overview
- Total Cars Sold KPI
- Average Selling Price KPI
- Average MMR (Market Value) KPI
- Average Profit/Loss KPI
- Median Profit/Loss KPI
- Top 10 Car Brands by Sales Volume
- Premium Brands by Avg Selling Price
- Sales Distribution by Body Type
- How Car Condition Affects Price
- Monthly Sales Trend
- Interactive Slicers (Year, Transmission)

### Page 2 — Deep Analysis
- Price Depreciation by Mileage
- Top 10 Most Popular Car Colors by Sales Volume
- Key Insights Summary

---

## 💡 Key Findings

### 🏆 Best Performing
| Category | Winner | Why |
|----------|--------|-----|
| Brand | Honda & Kia | High volume + lowest loss (-$50) |
| Body Type | SUV | Best price ($15K) + low loss (-$100) |
| Color | White | Most efficient (-$25 loss) |
| Condition | Excellent | Only group selling ABOVE market (+$250) |
| Month | March | Lowest loss (-$125) |
| Country | India | Most efficient market (-$100) |

### ❌ Worst Performing
| Category | Worst | Why |
|----------|-------|-----|
| Brand | Mercedes-Benz | -$425 median loss |
| Body Type | Quad Cab | -$400 median loss |
| Color | Purple | -$400 median loss |
| Condition | Fair | -$725 worst loss |
| Month | December | Highest loss (-$175) |
| Country | USA | -$225 despite highest volume |

---

## 🎯 Key Insights

1. Ford dominates volume (14.4K sales) but Honda and Kia
   are most price-efficient brands

2. Excellent condition is the ONLY group selling ABOVE
   market value (+$250 profit)

3. Fair condition performs WORSE than Poor condition
   (-$725 vs -$400) — surprising finding!

4. Price drops 50% every time mileage doubles:
   - Under 20K miles → $20,104
   - 100K+ miles → $4,821

5. AVG profit/loss (-$305) vs Median (-$150) —
   luxury brand outliers skew the average significantly

6. Car sales are consistent year-round — only
   294 car difference between best and worst months

7. Ideal car to sell:
   White Honda/Kia SUV, Excellent condition,
   20K-50K miles, sold in March or June

## 📸 Dashboard Screenshots

### Page 1 — Overview
![Overview](car%20sales%20dashboard.png)

### Page 2 — Deep Analysis
![Deep Analysis](car%20sales%20dashboard%202.png)

## 🚀 How To Run

### Python Cleaning
pip install pandas
jupyter notebook python/cleaning.ipynb

### PostgreSQL Setup
1. Create database: car_sales_analysis
2. Import cleaned CSV via pgAdmin
3. Run queries from sql/queries.sql

### Power BI
1. Open powerbi/car_sales_dashboard.pbix
2. Update PostgreSQL connection credentials
3. Refresh data

---

## 📚 Skills Demonstrated
- Data cleaning and preprocessing
- SQL aggregations and GROUP BY
- Window functions (RANK, PERCENTILE_CONT)
- Statistical analysis (AVG vs Median)
- Outlier detection and removal
- DAX calculations in Power BI
- Interactive dashboard design
- Business insight generation

---

## 👤 Author
Anas Khan
Data Analysis Project — 2025
Tools: Python | SQL | Power BI

