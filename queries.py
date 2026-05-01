import pandas as pd
from connect_db import get_connection

conn = get_connection()

# ============================================================
# SECTION 1 — KPI SUMMARY
# ============================================================

kpi_summary = pd.read_sql("""
    SELECT
        ROUND(SUM(value_billion)::NUMERIC, 2)   AS total_debt_billion,
        ROUND(AVG(value_billion)::NUMERIC, 2)   AS avg_debt_billion,
        COUNT(DISTINCT country_name)            AS total_countries,
        COUNT(DISTINCT indicator_name)          AS total_indicators,
        MIN(year)                               AS from_year,
        MAX(year)                               AS to_year
    FROM clean_debt
""", conn)

# ============================================================
# SECTION 2 — COUNTRY ANALYSIS
# ============================================================

top_10_countries = pd.read_sql("""
    SELECT country_name, region,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
    FROM clean_debt
    GROUP BY country_name, region
    ORDER BY total_debt_billion DESC
    LIMIT 10
""", conn)

bottom_10_countries = pd.read_sql("""
    SELECT country_name, region,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
    FROM clean_debt
    GROUP BY country_name, region
    ORDER BY total_debt_billion ASC
    LIMIT 10
""", conn)

country_pct_share = pd.read_sql("""
    SELECT country_name,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion,
        ROUND(
            ((SUM(value_billion) / SUM(SUM(value_billion)) OVER()) * 100)::NUMERIC
        , 4) AS pct_of_global_debt
    FROM clean_debt
    GROUP BY country_name
    ORDER BY total_debt_billion DESC
""", conn)

# ============================================================
# SECTION 3 — REGIONAL ANALYSIS
# ============================================================

region_summary = pd.read_sql("""
    SELECT region,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion,
        COUNT(DISTINCT country_name)          AS num_countries
    FROM clean_debt
    GROUP BY region
    ORDER BY total_debt_billion DESC
""", conn)

# ============================================================
# SECTION 4 — INCOME GROUP & LENDING CATEGORY
# ============================================================

income_group_summary = pd.read_sql("""
    SELECT income_group,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion,
        COUNT(DISTINCT country_name)          AS num_countries
    FROM clean_debt
    GROUP BY income_group
    ORDER BY total_debt_billion DESC
""", conn)

lending_category_summary = pd.read_sql("""
    SELECT lending_category,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion,
        COUNT(DISTINCT country_name)          AS num_countries
    FROM clean_debt
    GROUP BY lending_category
    ORDER BY total_debt_billion DESC
""", conn)

# ============================================================
# SECTION 5 — INDICATOR ANALYSIS
# ============================================================

top_5_indicators = pd.read_sql("""
    SELECT indicator_name,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
    FROM clean_debt
    GROUP BY indicator_name
    ORDER BY total_debt_billion DESC
    LIMIT 5
""", conn)

# ============================================================
# SECTION 6 — TREND ANALYSIS
# ============================================================

yearly_trend = pd.read_sql("""
    SELECT year,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
    FROM clean_debt
    GROUP BY year
    ORDER BY year
""", conn)

yoy_change = pd.read_sql("""
    SELECT year,
        ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion,
        ROUND(
            (SUM(value_billion) - LAG(SUM(value_billion)) OVER (ORDER BY year))::NUMERIC
        , 2) AS yoy_change_billion,
        ROUND(
            ((SUM(value_billion) - LAG(SUM(value_billion)) OVER (ORDER BY year))
            / NULLIF(LAG(SUM(value_billion)) OVER (ORDER BY year), 0) * 100)::NUMERIC
        , 2) AS yoy_pct_change
    FROM clean_debt
    GROUP BY year
    ORDER BY year
""", conn)

# ============================================================
# SECTION 7 — OUTLIERS
# ============================================================

above_avg_countries = pd.read_sql("""
    WITH global_avg AS (
        SELECT AVG(value_billion) AS avg_val FROM clean_debt
    )
    SELECT country_name, region,
        ROUND(AVG(cd.value_billion)::NUMERIC, 2) AS country_avg_debt_billion,
        ROUND(g.avg_val::NUMERIC, 2)             AS global_avg_debt_billion
    FROM clean_debt cd
    CROSS JOIN global_avg g
    GROUP BY country_name, region, g.avg_val
    HAVING AVG(cd.value_billion) > 2 * g.avg_val
    ORDER BY country_avg_debt_billion DESC
""", conn)

# ============================================================
# TEST — Print all DataFrames
# ============================================================

if __name__ == "__main__":
    print("✅ KPI Summary:")
    print(kpi_summary)

    print("\n✅ Top 10 Countries:")
    print(top_10_countries)

    print("\n✅ Bottom 10 Countries:")
    print(bottom_10_countries)

    print("\n✅ Country % Share:")
    print(country_pct_share)

    print("\n✅ Region Summary:")
    print(region_summary)

    print("\n✅ Income Group:")
    print(income_group_summary)

    print("\n✅ Lending Category:")
    print(lending_category_summary)

    print("\n✅ Top 5 Indicators:")
    print(top_5_indicators)

    print("\n✅ Yearly Trend:")
    print(yearly_trend)

    print("\n✅ YoY Change:")
    print(yoy_change)

    print("\n✅ Above Avg Countries:")
    print(above_avg_countries)

    print("\n✅ All queries ran successfully!")

    