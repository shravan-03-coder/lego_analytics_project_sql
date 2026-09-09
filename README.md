# 🧱 LEGO Product Portfolio Analytics Using MySQL

![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-blue?logo=mysql)
![SQL](https://img.shields.io/badge/SQL-Advanced-orange)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-Business%20Insights-green)
![Status](https://img.shields.io/badge/Project-Completed-success)

## 📌 Project Overview

**LEGO Product Portfolio Analytics** is an end-to-end SQL data analytics project built entirely in **MySQL**.

The objective of this project is to analyze LEGO's historical product portfolio and answer practical business questions related to:

* 📈 Product growth and launch trends
* 🧱 Product portfolio performance
* 🎨 Theme and category performance
* 💰 Pricing strategy
* 📦 Product size and piece count
* 👨‍👩‍👧 Recommended customer age segments
* 👤 Minifigure distribution
* 🏆 Premium product positioning
* 📊 Portfolio segmentation
* 💡 Business opportunities and decision-making

The project focuses on transforming raw product-level data into **actionable business insights using SQL**.

---

# 🎯 Business Objective

The main goal is to understand **how LEGO's product portfolio has evolved over time and which product segments/themes appear commercially important based on product count, pricing, size, and customer positioning.**

### Key business questions

1. How has LEGO's product portfolio grown over the years?
2. Which themes have the largest product portfolios?
3. Which themes command higher average launch prices?
4. Which categories contribute the most products?
5. Which themes combine high product volume with high pricing?
6. Which products are the largest by piece count?
7. Which products have the highest price per piece?
8. What age groups are most commonly targeted?
9. Are higher-priced products associated with older recommended age groups?
10. Which themes appear to be premium-focused?
11. Which themes have large sets but relatively affordable pricing?
12. Which product segments could represent mass-market, core, premium, or rationalization opportunities?

---

# 🗂️ Dataset

The project uses a LEGO product dataset containing historical product information.

### Main Table

`lego_sets`

### Data Dictionary Table

`lego_sets_data_dictionary`

### Important Columns

| Column           | Description                   |
| ---------------- | ----------------------------- |
| `sets_id`         | Official LEGO set/item number |
| `name`           | LEGO set name                 |
| `year`           | Product release year          |
| `theme`          | LEGO theme                    |
| `subtheme`       | LEGO subtheme                 |
| `themeGroup`     | Overall theme group           |
| `category`       | Product category              |
| `pieces`         | Number of pieces              |
| `minifigs`       | Number of minifigures         |
| `agerange_min`   | Minimum recommended age       |
| `US_retailPrice` | US retail price at launch     |
| `bricksetURL`    | Brickset product URL          |
| `thumbnailURL`   | Product thumbnail             |
| `imageURL`       | Product image                 |

---

# 🔍 Project Workflow

```text
Raw LEGO Dataset
       ↓
Data Understanding
       ↓
Data Quality Checks
       ↓
Exploratory Data Analysis
       ↓
Product Portfolio Analysis
       ↓
Theme & Category Analysis
       ↓
Pricing Analysis
       ↓
Customer/Age Analysis
       ↓
Product Segmentation
       ↓
Business KPI Analysis
       ↓
Business Insights
       ↓
Management Recommendations
```

---

# 🧹 1. Data Quality & Validation

Before performing business analysis, the dataset is checked for:

* Duplicate LEGO set IDs
* Missing values
* Invalid years
* Invalid piece counts
* Invalid prices
* Invalid minifigure counts
* Invalid age values
* Missing commercial information
* Data completeness by year

### Example

```sql
-- Check whether any LEGO set IDs appear more than once

SELECT
    sets_id,
    COUNT(*) AS duplicate_count
FROM lego_sets
GROUP BY sets_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
```

---

# 📈 2. Product Launch & Growth Analysis

Analyze how LEGO's product portfolio has changed over time.

### Questions answered

* How many sets were released each year?
* Which years had the highest number of launches?
* Is the portfolio expanding?
* How quickly did annual product launches change?
* What is the year-over-year growth?

### Techniques Used

* `COUNT()`
* `GROUP BY`
* `LAG()`
* Window functions
* Running totals
* Percentage change

Example:

```sql
SELECT
    year,
    COUNT(*) AS total_sets,
    LAG(COUNT(*)) OVER (ORDER BY year) AS previous_year_sets,
    ROUND(
        (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY year))
        * 100.0 /
        NULLIF(LAG(COUNT(*)) OVER (ORDER BY year), 0),
        2
    ) AS yoy_growth_pct
FROM lego_sets
GROUP BY year
ORDER BY year;
```

---

# 🎨 3. Theme Performance Analysis

Themes are analyzed to understand which areas have the strongest product presence.

### Analysis includes

* Number of sets by theme
* Average launch price
* Average piece count
* Average minifigures
* Theme ranking
* Theme contribution to portfolio
* Theme performance over time
* Top themes by year

Example:

```sql
SELECT
    theme,
    COUNT(*) AS total_sets,
    ROUND(AVG(US_retailPrice), 2) AS avg_launch_price,
    ROUND(AVG(pieces), 0) AS avg_pieces,
    ROUND(AVG(minifigs), 2) AS avg_minifigs
FROM lego_sets
GROUP BY theme
ORDER BY total_sets DESC;
```

---

# 🏆 4. Theme Ranking

Advanced SQL window functions are used to rank themes.

```sql
SELECT
    theme,
    COUNT(*) AS total_sets,
    DENSE_RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS theme_rank
FROM lego_sets
GROUP BY theme;
```

### SQL Concepts Demonstrated

* `DENSE_RANK()`
* `ROW_NUMBER()`
* Window functions
* Aggregation

---

# 💰 5. Pricing & Commercial Strategy

Pricing analysis evaluates LEGO's **launch/list-price positioning**.

### Questions answered

* What is the average launch price?
* Which themes have the highest average prices?
* Which sets are the most expensive?
* What percentage of products are premium-priced?
* Which themes have both high volume and high prices?
* How does pricing change over time?

### Important Note

`US_retailPrice` represents the **retail/list price at launch**.

It should **not be interpreted as actual revenue**, because the dataset does not contain units sold.

---

# 💎 6. Premium Product Analysis

For portfolio segmentation, products priced above a defined threshold can be treated as **premium products**.

Example:

```sql
SELECT
    name,
    theme,
    year,
    pieces,
    US_retailPrice
FROM lego_sets
WHERE US_retailPrice >= 100
ORDER BY US_retailPrice DESC;
```

This helps identify products that belong to the higher-priced portion of the portfolio.

---

# 📦 7. Product Size Analysis

Analyze products based on piece count.

### Business questions

* Which are the largest LEGO sets?
* Which themes produce larger products?
* Does a higher piece count generally correspond to a higher price?
* Which themes have the largest average sets?

Example:

```sql
SELECT
    name,
    theme,
    pieces,
    US_retailPrice
FROM lego_sets
WHERE pieces IS NOT NULL
ORDER BY pieces DESC
LIMIT 20;
```

---

# 💵 8. Price Per Piece Analysis

A useful product-level metric is:

```text
Price Per Piece = US Retail Price / Number of Pieces
```

Example:

```sql
SELECT
    name,
    theme,
    pieces,
    US_retailPrice,
    ROUND(US_retailPrice / NULLIF(pieces, 0), 3) AS price_per_piece
FROM lego_sets
WHERE pieces > 0
  AND US_retailPrice > 0
ORDER BY price_per_piece DESC;
```

This can help identify products with relatively high pricing compared with their piece count.

> **Note:** Price per piece is an analytical proxy, not a complete measure of product value. It does not account for piece type, licensing, complexity, rarity, or inflation.

---

# 👨‍👩‍👧 9. Customer & Age Segmentation

The dataset's recommended minimum age is used to understand product positioning.

Example segments:

```text
4–6      → Early Kids
7–9      → Kids
10–12    → Pre-Teen
13–17    → Teen
18+      → Adult
```

Example SQL:

```sql
SELECT
    CASE
        WHEN agerange_min BETWEEN 4 AND 6 THEN 'Early Kids'
        WHEN agerange_min BETWEEN 7 AND 9 THEN 'Kids'
        WHEN agerange_min BETWEEN 10 AND 12 THEN 'Pre-Teen'
        WHEN agerange_min BETWEEN 13 AND 17 THEN 'Teen'
        WHEN agerange_min >= 18 THEN 'Adult'
        ELSE 'Unknown'
    END AS customer_segment,
    COUNT(*) AS total_sets,
    ROUND(AVG(US_retailPrice), 2) AS avg_price
FROM lego_sets
GROUP BY customer_segment
ORDER BY total_sets DESC;
```

---

# 👤 10. Minifigure Analysis

Analyze the role of minifigures across LEGO products.

### Questions

* Which sets contain the most minifigures?
* Which themes have the highest average minifigure count?
* Are minifigure-heavy sets more expensive?
* How does minifigure count vary across categories?

---

# 🧠 11. Business Portfolio Segmentation

One of the most important analyses in this project is portfolio segmentation.

Products/themes can be classified based on:

* Product volume
* Average launch price

### Strategic framework

| Segment             | Volume | Price | Business Interpretation        |
| ------------------- | ------ | ----- | ------------------------------ |
| 🟢 Core / Strategic | High   | High  | Important high-value portfolio |
| 🔵 Mass Market      | High   | Low   | Large customer reach           |
| 🟣 Premium / Niche  | Low    | High  | Potential premium opportunity  |
| ⚪ Rationalization   | Low    | Low   | Lower portfolio priority       |

Example approach:

```sql
WITH theme_metrics AS (
    SELECT
        theme,
        COUNT(*) AS total_sets,
        AVG(US_retailPrice) AS avg_price
    FROM lego_sets
    WHERE US_retailPrice IS NOT NULL
    GROUP BY theme
),
benchmarks AS (
    SELECT
        AVG(total_sets) AS avg_theme_volume,
        AVG(avg_price) AS avg_theme_price
    FROM theme_metrics
)
SELECT
    tm.theme,
    tm.total_sets,
    ROUND(tm.avg_price, 2) AS avg_price,
    CASE
        WHEN tm.total_sets >= b.avg_theme_volume
             AND tm.avg_price >= b.avg_theme_price
            THEN 'Core / Strategic'

        WHEN tm.total_sets >= b.avg_theme_volume
             AND tm.avg_price < b.avg_theme_price
            THEN 'Mass Market'

        WHEN tm.total_sets < b.avg_theme_volume
             AND tm.avg_price >= b.avg_theme_price
            THEN 'Premium / Niche'

        ELSE 'Rationalization Candidate'
    END AS portfolio_segment
FROM theme_metrics tm
CROSS JOIN benchmarks b
ORDER BY tm.total_sets DESC;
```

---

# 📊 12. Business KPI Analysis

The project calculates management-level KPIs such as:

* Total LEGO sets
* Number of themes
* Number of categories
* Average launch price
* Average piece count
* Average minifigure count
* Premium product percentage
* Annual product launches
* Largest product
* Most expensive product
* Top-performing themes
* Average price per piece

Example:

```sql
SELECT
    COUNT(*) AS total_sets,
    COUNT(DISTINCT theme) AS total_themes,
    COUNT(DISTINCT category) AS total_categories,
    ROUND(AVG(US_retailPrice), 2) AS avg_launch_price,
    ROUND(AVG(pieces), 0) AS avg_pieces,
    ROUND(AVG(minifigs), 2) AS avg_minifigs,
    ROUND(
        SUM(CASE WHEN US_retailPrice >= 100 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(US_retailPrice),
        2
    ) AS premium_set_percentage
FROM lego_sets;
```

---

# 📌 13. Business Insight Queries

The project specifically answers real-world business questions such as:

### Product Strategy

* Which themes dominate LEGO's portfolio?
* Which themes are expanding?
* Which themes have a long product lifespan?
* Which categories have the strongest product presence?

### Pricing Strategy

* Which themes have premium pricing?
* Which products have the highest price per piece?
* Which themes combine high volume with high average price?

### Customer Strategy

* Which age groups receive the most products?
* Which themes target older customers?
* Are premium products concentrated in older age segments?

### Portfolio Strategy

* Which themes are core strategic areas?
* Which themes are mass-market?
* Which themes could represent premium opportunities?
* Which themes have low volume and low pricing?

---

# 🧪 14. Data Completeness Analysis

Because some commercial and product attributes contain missing values, the project explicitly evaluates data completeness.

Important fields include:

* `pieces`
* `minifigs`
* `agerange_min`
* `US_retailPrice`
* Image URLs

Example:

```sql
SELECT
    COUNT(*) AS total_records,

    SUM(CASE WHEN pieces IS NULL THEN 1 ELSE 0 END)
        AS missing_pieces,

    SUM(CASE WHEN minifigs IS NULL THEN 1 ELSE 0 END)
        AS missing_minifigs,

    SUM(CASE WHEN agerange_min IS NULL THEN 1 ELSE 0 END)
        AS missing_age,

    SUM(CASE WHEN US_retailPrice IS NULL THEN 1 ELSE 0 END)
        AS missing_price
FROM lego_sets;
```

This ensures business conclusions are based on appropriate records rather than blindly using incomplete data.

---

# 🛠️ SQL Skills Demonstrated

This project demonstrates practical and advanced MySQL skills:

### Fundamental SQL

* `SELECT`
* `WHERE`
* `GROUP BY`
* `ORDER BY`
* `HAVING`
* `DISTINCT`
* `LIMIT`

### Aggregation

* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`

### Advanced SQL

* `CASE`
* `NULLIF()`
* CTEs
* Subqueries
* Window Functions
* `LAG()`
* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`

### Business Analytics

* Year-over-Year Growth
* Running totals
* Percentage contribution
* Product segmentation
* Price-per-piece analysis
* Portfolio analysis
* KPI analysis
* Data quality analysis

### SQL Engineering

* Reusable analytical views
* Structured query organization
* Performance-conscious filtering
* Business-oriented query design

---

# 📁 Recommended GitHub Project Structure

```text
LEGO-Product-Portfolio-Analytics/
│
├── README.md
│
├── SQL/
│   ├── 01_data_profiling.sql
│   ├── 02_data_quality.sql
│   ├── 03_product_analysis.sql
│   ├── 04_growth_analysis.sql
│   ├── 05_theme_analysis.sql
│   ├── 06_category_analysis.sql
│   ├── 07_pricing_analysis.sql
│   ├── 08_product_value_analysis.sql
│   ├── 09_customer_age_analysis.sql
│   ├── 10_portfolio_segmentation.sql
│   ├── 11_business_kpis.sql
│   ├── 12_business_insights.sql
│   └── 13_views.sql
│
└── Data/
    ├── lego_sets.csv
    └── lego_sets_data_dictionary.csv
```

---

# 📈 Key Business Insights

The final analysis should focus on insights rather than simply displaying SQL outputs.

Examples of the type of conclusions produced:

### 1. Portfolio Growth

Identify periods where LEGO significantly increased or decreased the number of products launched.

### 2. Theme Concentration

Determine whether LEGO's portfolio is heavily concentrated in a small number of themes or broadly diversified.

### 3. Premium Strategy

Identify themes with relatively high average launch prices and determine whether they also maintain meaningful product volume.

### 4. Mass-Market Strategy

Identify themes with high product volume but relatively lower pricing, indicating broader-market positioning.

### 5. Product Economics

Compare piece counts with launch prices to identify products with unusually high or low price-per-piece metrics.

### 6. Customer Targeting

Understand which recommended age groups receive the greatest product coverage and whether premium products are concentrated in particular age segments.

---

# ⚠️ Analytical Limitations

This dataset has several limitations that should be considered when interpreting the results.

* Retail price is **launch/list price**, not actual sales revenue.
* There is no sales volume or quantity-sold information.
* Missing values exist in several product attributes.
* Price-per-piece is only a proxy metric.
* Historical prices are not adjusted for inflation.
* A high product count does not necessarily mean high profitability.
* Theme popularity cannot be directly determined without sales/customer data.

Therefore, the analysis is best interpreted as **product portfolio and pricing analysis**, rather than a complete financial performance analysis.

---

# 🚀 Future Improvements

If additional data becomes available, the project could be expanded with:

* Sales volume
* Revenue
* Profit margin
* Inventory
* Customer ratings
* Product reviews
* Geographic sales
* Product retirement dates
* Inflation-adjusted pricing
* Customer purchase behavior

These additions would allow deeper analysis of:

```text
Revenue Performance
        ↓
Profitability
        ↓
Customer Behavior
        ↓
Demand Forecasting
        ↓
Product Strategy
```

---

# 💼 Resume Description

### LEGO Product Portfolio Analytics — MySQL

> Analyzed 18K+ LEGO product records using MySQL to evaluate product launch trends, theme performance, pricing strategy, product size, and customer age segmentation. Performed data quality validation and advanced SQL analysis using CTEs, window functions, ranking, YoY growth, price-per-piece metrics, portfolio segmentation, and reusable analytical views to generate business-oriented insights.

### Skills

`MySQL` `SQL` `Data Analysis` `Data Cleaning` `EDA` `CTEs` `Window Functions` `LAG()` `ROW_NUMBER()` `DENSE_RANK()` `CASE` `Subqueries` `Views` `Business Intelligence`

---

# 👨‍💻 Author

**Shravan Bhosale**

Data Science & Data Analysis Student
Pune, Maharashtra, India

---

⭐ **If you found this project useful, consider giving the repository a star!**
