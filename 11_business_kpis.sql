-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 11 - BUSINESS KPIs
-- ============================================================
-- Purpose:
-- Create management-level KPIs that can later be used
-- in Power BI, Tableau or Excel dashboards.
-- ============================================================

USE lego_analytics;

-- 1. Overall portfolio KPIs
SELECT
    COUNT(*) AS total_products,

    COUNT(DISTINCT theme) AS total_themes,

    COUNT(DISTINCT category) AS total_categories,

    MIN(year) AS first_release_year,

    MAX(year) AS latest_release_year,

    ROUND(AVG(pieces), 2) AS average_pieces,

    ROUND(AVG(US_retailPrice), 2) AS average_launch_price,

    ROUND(MAX(US_retailPrice), 2) AS highest_launch_price

FROM lego_sets;


-- 2. Premium portfolio KPI
SELECT
    COUNT(*) AS premium_products,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM lego_sets
         WHERE US_retailPrice IS NOT NULL),
        2
    ) AS premium_product_percentage
FROM lego_sets
WHERE US_retailPrice >= 100;


-- 3. Large-set KPI
SELECT
    COUNT(*) AS large_sets,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM lego_sets
         WHERE pieces IS NOT NULL),
        2
    ) AS large_set_percentage
FROM lego_sets
WHERE pieces >= 1000;


-- 4. Products with minifigures
SELECT
    COUNT(*) AS sets_with_minifigs,
    ROUND(AVG(minifigs), 2) AS average_minifigs
FROM lego_sets
WHERE minifigs IS NOT NULL;


-- 5. Portfolio completeness KPI
SELECT
    ROUND(
        AVG(
            CASE
                WHEN sets_id IS NOT NULL
                 AND name IS NOT NULL
                 AND year IS NOT NULL
                 AND theme IS NOT NULL
                 AND pieces IS NOT NULL
                 AND US_retailPrice IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS core_data_completeness_percentage
FROM lego_sets;


-- 6. Most productive theme
SELECT
    theme,
    COUNT(*) AS total_products
FROM lego_sets
GROUP BY theme
ORDER BY total_products DESC
LIMIT 1;


-- 7. Most active launch year
SELECT
    year,
    COUNT(*) AS products_launched
FROM lego_sets
GROUP BY year
ORDER BY products_launched DESC
LIMIT 1;


-- 8. Highest average-priced theme
SELECT
    theme,
    ROUND(AVG(US_retailPrice), 2) AS average_price
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
GROUP BY theme
HAVING COUNT(*) >= 10
ORDER BY average_price DESC
LIMIT 1;