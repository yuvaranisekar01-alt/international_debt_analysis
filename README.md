🌍 International Debt Analysis

📌 Project Overview
This project performs an end-to-end analysis of international debt data
across 119 countries from 2000 to 2024. The goal is to uncover
patterns, trends, and insights about global borrowing behavior using
Python, PostgreSQL, SQL, and Power BI.
The dataset contains 113 debt indicators sourced from the
World Bank's International Debt Statistics, covering regions,
income groups, and lending categories worldwide.

🎯 Objectives

-Analyze country-wise and region-wise debt distribution
-Identify top debtor countries and their debt share
-Explore debt trends over time (2000–2024)
-Examine debt composition by indicators and income groups
-Build an interactive dashboard for visual storytelling

🛠️ Tools & Technologies
Tool                            Purpose
Python                          Data cleaning,EDA, visualization
Pandas                          Data manipulation and preprocessing
Matplotlib & Seaborn            Data visualization
PostgreSQL                      Database storage and SQL analysis
SQLAlchemy                      Python-PostgreSQL connection
SQL                             Aggregations, CTEs, Window Functions
Power BI                        Interactive dashboard
VS Code                         Development environment
GitHub                          Version control and portfolio

🔄 Project Workflow

1. Data Collection       →  5 CSV datasets from World Bank
2. Data Preprocessing    →  Cleaning, merging, standardizing
3. EDA                   →  Statistical analysis & visualization
4. Database Integration  →  PostgreSQL setup & SQL analysis
5. Dashboard             →  Power BI interactive dashboard
6. Insights & Reporting  →  Key findings & conclusions

🧹 Data Preprocessing

-Handled missing values and null records
-Removed duplicate entries
-Performed data type conversions
-Merged 5 datasets into single cleaned DataFrame
-Standardized column names and formats
-Added calculated columns (value_billion)
-Final dataset: df_clean table in PostgreSQL

📊 Exploratory Data Analysis
Visualizations Created:

📊 Top 10 Countries by Total Debt
📈 Global Debt Trend (2000–2024)
🗺️ Debt Distribution by Region
🍩 Debt by Income Group
📊 Top 5 Debt Indicators
📊 Year-over-Year Debt Change (%)
🥧 Country % Share of Global Debt

🗄️ SQL Analysis
Key Queries Written:

Country-wise debt aggregations
Regional debt comparisons
Income group analysis
Year-over-year trend analysis
Window functions (RANK, LAG, OVER)
CTEs for outlier detection
% share calculations
Statistical summaries (mean, stddev, variance)

Views Created for Power BI:

vw_country_debt_summary
vw_indicator_debt_summary
vw_yearly_global_trend
vw_debt_full
vw_region_yearly_trend
vw_yoy_change
vw_debt_category

📈 Power BI Dashboard
Page 1 — Overview

KPI Cards (Total Debt, Countries, Indicators)
Top 10 Countries by Debt (Bar Chart)
Global Debt Trend 2000–2024 (Line Chart)
Debt & Debt Share % by Countries (Filled Map)
Slicers: Year, Income Group, Lending Category

Page 2 — Deep Dive

Debt by Income Group (Donut Chart)
Top 5 Debt Indicators (Bar Chart)
Year-over-Year Debt Change % (Bar Chart)
Detailed insights for each visual

⚙️ How to Run This Project

Python 3.12+
PostgreSQL 17+
Power BI Desktop

-Step 1 — Clone Repository
git clone https://github.com/yuvaranisekar01-alt/international_debt_analysis.git
cd international-debt-analysis
-Step 2 — Create Virtual Environment
python -m venv venv
venv\Scripts\activate
-Step 3 — Install Dependencies
pip install -r requirements.txt
-Step 4 — Setup Environment Variables
Create a .env file:
DB_HOST=localhost
DB_NAME=your_database_name
DB_USER=postgres
DB_PASSWORD=your_password
DB_PORT=5432
-Step 5 — Load Data to PostgreSQL
python load_data.py
-Step 6 — Run Analysis
python queries.py
-Step 7 — Open Notebook
jupyter notebook analysis.ipynb



