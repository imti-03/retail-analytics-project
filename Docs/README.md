
# 🛒 Retail Analytics Project  
**Tools:** PostgreSQL | Power BI | SQL | DAX | VS Code  

---

## 📖 Project Overview

This project explores **retail performance analysis** through a complete end-to-end data workflow — from **raw CSV cleaning in SQL** to **executive-level insights visualized in Power BI**.

The dataset includes **238,000+ transactions** across multiple product categories, customer segments, and payment methods.  

The goal was to design a data pipeline that could answer **three executive business questions:**

1️⃣ **Which customer segments generate the most revenue?**  
2️⃣ **What product categories and brands perform best over time?**  
3️⃣ **How do payment and shipping methods influence total revenue?**

---

## 🧱 Project Structure
```txt
Retail-Analytics-Project/
│
├── Data/
│ ├── Raw/ → new_retail_data.csv
│ └── Cleaned/ → retail_clean_typed.csv
│
├── SQL/
│ ├── init.sql
│ ├── staging.sql
│ ├── clean_table_creation.sql
│ ├── individual_column_cleaning.sql
│ └── final_load.sql
│
├── PowerBI/
│ └── retail_performance_dashboard.pbix
│
├── Visuals/
│ ├── dashboard_full.png
│ ├── customer_segment_chart.png
│ ├── product_trends_chart.png
│ └── finance_matrix_chart.png
│
└── Docs/
├── Column_Cleaning_Log.pdf
└── README.md
```

---

## 🧹 Data Cleaning and Preparation

All cleaning was performed in **PostgreSQL**, managed via **VS Code**.  
The dataset required extensive column-by-column validation (30+ fields cleaned) — ensuring all categorical data, numeric values, and identifiers were standardized for analytical use.

### **Key Cleaning Steps:**
- Removed float formatting issues in IDs (`transaction_id`, `customer_id` → `BIGINT::TEXT`)
- Normalized text casing and whitespace across all string columns (`INITCAP`, `TRIM`)
- Cleaned categorical columns with the `IN` operator to validate only accepted values
- Validated date ranges and null handling for logical consistency
- Ensured schema separation between:
  - `staging.retail_raw` → raw upload layer  
  - `analytics.retail_clean` → validated analytical layer  

Detailed documentation for each column transformation can be found in the [📘 Column Cleaning Log] [Column_Cleaning_Log.pdf](https://github.com/imti-03/retail-analytics-project/blob/main/Docs/Column_Cleaning_Log.pdf)


---

## 📊 Dashboard & Analysis (Power BI)

After cleaning, the **analytics.retail_clean_typed** table was connected to **Power BI**.  
Data modeling involved defining relationships, casting correct data types, and creating **DAX measures** for business KPIs.

### **Main KPIs**
| Metric | Description |
|---------|--------------|
| **Total Revenue** | SUM of all transaction amounts |
| **Distinct Customers** | COUNT of unique `customer_id` |
| **Average Spend Per Customer** | Total revenue ÷ unique customers |
| **Customer Satisfaction Rating** | AVG of `ratings` column |

---

## 🧠 Executive-Level Insights

### 1️⃣ **Customer Segmentation**
A **horizontal bar chart** compares total revenue by customer segment.  
This revealed that **Regular customers** generate the highest overall revenue, suggesting consistent engagement and loyalty opportunities.

![Revenue by Segment](https://github.com/imti-03/retail-analytics-project/raw/main/Visuals/revenue_by_segment.png)

---

### 2️⃣ **Product Trends by Month**
A **multi-line chart** tracks purchase activity per product category over 12 months.  
Electronics and Clothing show strong seasonality, peaking around spring — insights that could guide inventory and campaign timing.

![Product Trends by Month](https://github.com/imti-03/retail-analytics-project/raw/main/Visuals/product_trends_by_month.png)

---

### 3️⃣ **Revenue by Payment & Shipping Method**
A **matrix visual** cross-analyzes payment and shipping combinations.  
Credit Card + Express Shipping yields the **highest average spend**, linking customer convenience directly to revenue growth.

![Payment & Shipping Matrix](https://github.com/imti-03/retail-analytics-project/raw/main/Visuals/payment_shipping_matrix.png)

---

### 4️⃣ **Retail Performance Dashboard Overview**
All visuals were integrated into a single Power BI page to create a unified view of the retail business.

![Retail Performance Dashboard](https://github.com/imti-03/retail-analytics-project/raw/main/Visuals/full_dashboard.png)

---

## 🧩 Technical Workflow

| Stage | Tool | Description |
|-------|------|-------------|
| Data Cleaning | PostgreSQL | Cleaned 30+ columns and validated data using SQL functions |
| Transformation | SQL (CTEs) | Created analytical schema `analytics.retail_clean_typed` |
| Modeling | Power BI | Established relationships and applied DAX measures |
| Visualization | Power BI | Designed KPI cards, charts, and matrix visuals |
| Documentation | Notion + GitHub | Tracked learning log and project stages |

---

## 📚 Learning Outcomes

This was a **fully self-taught** data analytics project — every step, from SQL schema design to Power BI visualization, was built independently through research, trial, and iteration.

Key learning milestones:
- Building a **PostgreSQL-based ETL process** from raw CSV to analytics-ready schema  
- Understanding **data modeling** and DAX within Power BI  
- Designing a **storytelling dashboard** focused on executive decision-making  
- Applying version control and documentation through **GitHub**

---

## 💬 Acknowledgments

A huge thank you to **Luke Barousse**, whose tutorials helped me master the fundamentals of SQL and Power BI.  
His content gave me the courage and technical grounding to bring this project from concept to completion.

---

## 🧾 Project Files

| File | Description |
|------|--------------|
| [📘 Column Cleaning Log (PDF)](https://github.com/imti-03/retail-analytics-project/blob/main/Docs/Column_Cleaning_Log.pdf) | Documentation of all SQL column cleaning steps |
| [💾 Power BI Dashboard (.pbix)](https://github.com/imti-03/retail-analytics-project/blob/main/PowerBI/Retail_project_dashboard.pbix) | Final Power BI dashboard file |
| [📊 Visuals](https://github.com/imti-03/retail-analytics-project/tree/main/Visuals/) | Folder containing exported Power BI dashboard images |

---

## 🧠 Author
**Built by:** [Imtiaz Bhuyan](https://github.com/imti-analytics)  
_Data cleaned in SQL. Visualized in Power BI. Documented on GitHub._

---


