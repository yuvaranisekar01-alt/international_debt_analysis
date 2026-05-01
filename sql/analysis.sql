-- ============================================================
--   INTERNATIONAL DEBT ANALYSIS — SQL QUERIES
--   Table : df_clean
--   DB    : PostgreSQL
-- ============================================================
--   Columns:
--     year, value, value_billion, income_group, country_name,
--     lending_category, measure, unit, indicator_name, region,
--     country_code, indicator_code
-- ============================================================


-- ============================================================
-- SECTION 1: DATA VERIFICATION
-- ============================================================

-- 1.1 Preview the table
SELECT * FROM df_clean LIMIT 10;

-- 1.2 Total number of records
SELECT COUNT(*) AS total_records FROM df_clean;

-- 1.3 Year range in dataset
SELECT MIN(year) AS earliest_year, MAX(year) AS latest_year FROM df_clean;

-- 1.4 Distinct countries, indicators, regions
SELECT COUNT(DISTINCT country_name)    AS distinct_countries  FROM df_clean;
SELECT COUNT(DISTINCT indicator_name)  AS distinct_indicators FROM df_clean;
SELECT COUNT(DISTINCT region)          AS distinct_regions     FROM df_clean;
SELECT COUNT(DISTINCT income_group)    AS distinct_income_groups FROM df_clean;

-- 1.5 Check for NULL values in key columns
SELECT
    COUNT(*)                                            AS total_rows,
    COUNT(*) FILTER (WHERE value IS NULL)               AS null_value,
    COUNT(*) FILTER (WHERE value_billion IS NULL)       AS null_value_billion,
    COUNT(*) FILTER (WHERE country_name IS NULL)        AS null_country,
    COUNT(*) FILTER (WHERE indicator_name IS NULL)      AS null_indicator,
    COUNT(*) FILTER (WHERE region IS NULL)              AS null_region,
    COUNT(*) FILTER (WHERE income_group IS NULL)        AS null_income_group
FROM df_clean;

-- 1.6 All unique regions
SELECT DISTINCT region FROM df_clean ORDER BY region;

-- 1.7 All unique income groups
SELECT DISTINCT income_group FROM df_clean ORDER BY income_group;

-- 1.8 All unique lending categories
SELECT DISTINCT lending_category FROM df_clean ORDER BY lending_category;


-- ============================================================
-- SECTION 2: COUNTRY-WISE DEBT ANALYSIS
-- ============================================================

-- 2.1 Total debt per country (in Billions USD)
SELECT
    country_name,
    country_code,
    region,
    ROUND(SUM(value_billion)::NUMERIC, 2)   AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)   AS avg_debt_billion,
    COUNT(*)                                AS data_points
FROM df_clean
GROUP BY country_name, country_code, region
ORDER BY total_debt_billion DESC;

-- 2.2 Top 10 countries with HIGHEST total debt
SELECT
    country_name,
    country_code,
    region,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
FROM df_clean
GROUP BY country_name, country_code, region
ORDER BY total_debt_billion DESC
LIMIT 10;

-- 2.3 Top 10 countries with LOWEST total debt
SELECT
    country_name,
    country_code,
    region,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
FROM df_clean
GROUP BY country_name, country_code, region
ORDER BY total_debt_billion ASC
LIMIT 10;

-- 2.4 Country debt with % share of global total
SELECT
    country_name,
    country_code,
    ROUND(SUM(value_billion)::NUMERIC, 2)   AS total_debt_billion,
    ROUND(
        ((SUM(value_billion) / SUM(SUM(value_billion)) OVER()) * 100
    )::NUMERIC, 4)  AS pct_of_global_debt
FROM df_clean
GROUP BY country_name, country_code
ORDER BY total_debt_billion DESC;

-- 2.5 Rank countries by total debt using RANK()
SELECT
    country_name,
    region,
    ROUND(SUM(value_billion)::NUMERIC, 2)  AS total_debt_billion,
    RANK() OVER (ORDER BY SUM(value_billion) DESC)  AS debt_rank
FROM df_clean
GROUP BY country_name, region
ORDER BY debt_rank;


-- ============================================================
-- SECTION 3: INDICATOR-WISE DEBT ANALYSIS
-- ============================================================

-- 3.1 Total debt by indicator
SELECT
    indicator_name,
    indicator_code,
    ROUND(SUM(value_billion)::NUMERIC, 2)   AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)   AS avg_debt_billion,
    COUNT(DISTINCT country_name)            AS countries_count
FROM df_clean
GROUP BY indicator_name, indicator_code
ORDER BY total_debt_billion DESC;

-- 3.2 Top 5 debt indicators globally
SELECT
    indicator_name,
    indicator_code,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
FROM df_clean
GROUP BY indicator_name, indicator_code
ORDER BY total_debt_billion DESC
LIMIT 5;

-- 3.3 Indicator % share of global debt
SELECT
    indicator_name,
    ROUND(SUM(value_billion)::NUMERIC, 2)                        AS total_debt_billion,
    ROUND(
       ( (SUM(value_billion) / SUM(SUM(value_billion)) OVER()) * 100)
    ::NUMERIC, 4)                                                          AS pct_of_global_debt
FROM df_clean
GROUP BY indicator_name
ORDER BY total_debt_billion DESC;

-- 3.4 Debt per country per indicator
SELECT
    country_name,
    indicator_name,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
FROM df_clean
GROUP BY country_name, indicator_name
ORDER BY country_name, total_debt_billion DESC;


-- ============================================================
-- SECTION 4: REGIONAL ANALYSIS
-- ============================================================

-- 4.1 Total debt by region
SELECT
    region,
    ROUND(SUM(value_billion)::NUMERIC, 2)       AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)       AS avg_debt_billion,
    COUNT(DISTINCT country_name)                AS num_countries,
    ROUND(
        ((SUM(value_billion) / SUM(SUM(value_billion)) OVER()) * 100)
   ::NUMERIC,4)                                         AS pct_of_global_debt
FROM df_clean
GROUP BY region
ORDER BY total_debt_billion DESC;

-- 4.2 Top country in each region by total debt
SELECT DISTINCT ON (region)
    region,
    country_name,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
FROM df_clean
GROUP BY region, country_name
ORDER BY region, total_debt_billion DESC;

-- 4.3 Rank countries within their region
SELECT
    country_name,
    region,
    ROUND(SUM(value_billion)::NUMERIC, 2)                               AS total_debt_billion,
    RANK() OVER (PARTITION BY region ORDER BY SUM(value_billion) DESC)  AS rank_in_region
FROM df_clean
GROUP BY country_name, region
ORDER BY region, rank_in_region;


-- ============================================================
-- SECTION 5: INCOME GROUP ANALYSIS
-- ============================================================

-- 5.1 Total debt by income group
SELECT
    income_group,
    ROUND(SUM(value_billion)::NUMERIC, 2)   AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)   AS avg_debt_billion,
    COUNT(DISTINCT country_name)            AS num_countries
FROM df_clean
GROUP BY income_group
ORDER BY total_debt_billion DESC;

-- 5.2 Top country per income group
SELECT DISTINCT ON (income_group)
    income_group,
    country_name,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion
FROM df_clean
GROUP BY income_group, country_name
ORDER BY income_group, total_debt_billion DESC;

-- 5.3 Debt by lending category
SELECT
    lending_category,
    ROUND(SUM(value_billion)::NUMERIC, 2)   AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)   AS avg_debt_billion,
    COUNT(DISTINCT country_name)            AS num_countries
FROM df_clean
GROUP BY lending_category
ORDER BY total_debt_billion DESC;


-- ============================================================
-- SECTION 6: TREND ANALYSIS (YEAR-WISE)
-- ============================================================

-- 6.1 Global debt trend per year
SELECT
    year,
    ROUND(SUM(value_billion)::NUMERIC, 2)   AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)   AS avg_debt_billion,
    COUNT(DISTINCT country_name)            AS countries_reporting
FROM df_clean
GROUP BY year
ORDER BY year;

-- 6.2 Year-over-year (YoY) debt change globally
SELECT
    year,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion,
    ROUND(
        (SUM(value_billion) - LAG(SUM(value_billion)) OVER (ORDER BY year))::NUMERIC
    , 2) AS yoy_change_billion,
    ROUND(
        ((SUM(value_billion) - LAG(SUM(value_billion)) OVER (ORDER BY year))
        / NULLIF(LAG(SUM(value_billion)) OVER (ORDER BY year), 0) * 100)::NUMERIC
    , 2) AS yoy_pct_change
FROM df_clean
GROUP BY year
ORDER BY year;

-- 6.3 Yearly debt trend per country
SELECT
    country_name,
    year,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS yearly_debt_billion
FROM df_clean
GROUP BY country_name, year
ORDER BY country_name, year;

-- 6.4 Yearly debt trend per region
SELECT
    region,
    year,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS yearly_debt_billion
FROM df_clean
GROUP BY region, year
ORDER BY region, year;


-- ============================================================
-- SECTION 7: KPI SUMMARY
-- ============================================================

-- 7.1 Overall global KPIs
SELECT
    ROUND(SUM(value_billion)::NUMERIC, 2)       AS grand_total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)       AS global_avg_debt_billion,
    ROUND(MAX(value_billion)::NUMERIC, 2)       AS max_single_debt_billion,
    ROUND(MIN(value_billion)::NUMERIC, 4)       AS min_single_debt_billion,
    COUNT(DISTINCT country_name)                AS total_countries,
    COUNT(DISTINCT indicator_name)              AS total_indicators,
    COUNT(DISTINCT year)                        AS years_covered
FROM df_clean;

-- 7.2 Single highest debt record
SELECT
    country_name,
    indicator_name,
    year,
    ROUND(value_billion::NUMERIC, 2) AS debt_billion
FROM df_clean
ORDER BY value_billion DESC
LIMIT 1;

-- 7.3 Single lowest debt record (non-zero)
SELECT
    country_name,
    indicator_name,
    year,
    ROUND(value_billion::NUMERIC, 6) AS debt_billion
FROM df_clean
WHERE value_billion > 0
ORDER BY value_billion ASC
LIMIT 1;


-- ============================================================
-- SECTION 8: OUTLIER DETECTION
-- ============================================================

-- 8.1 Countries with debt more than 2x the global average
WITH global_avg AS (
    SELECT AVG(value_billion) AS avg_val FROM df_clean
)
SELECT
    country_name,
    region,
    ROUND(AVG(df.value_billion)::NUMERIC, 2) AS country_avg_debt_billion,
    ROUND(g.avg_val::NUMERIC, 2)             AS global_avg_debt_billion
FROM df_clean df
CROSS JOIN global_avg g
GROUP BY country_name, region, g.avg_val
HAVING AVG(df.value_billion) > 2 * g.avg_val
ORDER BY country_avg_debt_billion DESC;

-- 8.2 Statistical summary per country (mean, stddev, variance)
SELECT
    country_name,
    ROUND(AVG(value_billion)::NUMERIC, 4)      AS mean_debt,
    ROUND(STDDEV(value_billion)::NUMERIC, 4)   AS stddev_debt,
    ROUND(MAX(value_billion)::NUMERIC, 4)      AS max_debt,
    ROUND(MIN(value_billion)::NUMERIC, 4)      AS min_debt
FROM df_clean
GROUP BY country_name
ORDER BY stddev_debt DESC;


-- ============================================================
-- SECTION 9: VIEWS (for Power BI / Streamlit)
-- ============================================================

-- 9.1 Country debt summary view
CREATE OR REPLACE VIEW vw_country_debt_summary AS
SELECT
    country_name,
    country_code,
    region,
    income_group,
    lending_category,
    ROUND(SUM(value_billion)::NUMERIC, 2)                         AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)                         AS avg_debt_billion,
    ROUND(
        ((SUM(value_billion) / SUM(SUM(value_billion)) OVER()) * 100)::NUMERIC
    , 4)                                                           AS pct_global_debt,
    COUNT(DISTINCT indicator_name)                                AS indicator_count
FROM clean_debt
GROUP BY country_name, country_code, region, income_group, lending_category;

select * from vw_country_debt_summary limit 10;

-- 9.2 Indicator debt summary view
CREATE OR REPLACE VIEW vw_indicator_debt_summary AS
SELECT
    indicator_name,
    indicator_code,
    measure,
    unit,
    ROUND(SUM(value_billion)::NUMERIC, 2)                        AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)                        AS avg_debt_billion,
    COUNT(DISTINCT country_name)                                 AS countries_count,
    ROUND(
        ((SUM(value_billion) / SUM(SUM(value_billion)) OVER()) * 100) :: NUMERIC
    , 4)                                                          AS pct_global_debt
FROM df_clean
GROUP BY indicator_name, indicator_code, measure, unit;

select * from  vw_indicator_debt_summary limit 5;

-- 9.3 Yearly global trend view
CREATE OR REPLACE VIEW vw_yearly_global_trend AS
SELECT
    year,
    ROUND(SUM(value_billion)::NUMERIC, 2)   AS total_debt_billion,
    ROUND(AVG(value_billion)::NUMERIC, 2)   AS avg_debt_billion,
    COUNT(DISTINCT country_name)            AS countries_reporting
FROM df_clean
GROUP BY year
ORDER BY year;

select * from vw_yearly_global_trend limit 5;

-- 9.4 Full flat table view (direct connect for Power BI / Streamlit)
CREATE OR REPLACE VIEW vw_debt_full AS
SELECT
    year,
    country_name,
    country_code,
    region,
    income_group,
    lending_category,
    indicator_name,
    indicator_code,
    measure,
    unit,
    ROUND(value::NUMERIC, 2)         AS value_usd,
    ROUND(value_billion::NUMERIC, 4) AS value_billion
FROM df_clean;

select * from vw_debt_full limit 5;

-- 9.5 Regional yearly trend view
CREATE OR REPLACE VIEW vw_region_yearly_trend AS
SELECT
    region,
    year,
    ROUND(SUM(value_billion)::NUMERIC, 2) AS total_debt_billion,
    COUNT(DISTINCT country_name)          AS countries_count
FROM df_clean
GROUP BY region, year
ORDER BY region, year;

select * from vw_region_yearly_trend limit 5 ;

--9.6 Debt classification
CREATE OR REPLACE VIEW vw_debt_category AS
SELECT *,
    CASE 
        WHEN value_billion >= 10  THEN 'High Debt'
        WHEN value_billion >= 1   THEN 'Medium Debt'
        ELSE                           'Low Debt'
    END AS debt_category
FROM df_clean;


-- ============================================================
-- END OF SCRIPT
-- ============================================================

