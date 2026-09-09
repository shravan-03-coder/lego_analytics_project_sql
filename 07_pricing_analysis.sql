-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 07 - PRICING ANALYSIS
-- ============================================================
-- Purpose:
-- Analyze LEGO launch-price positioning and identify
-- premium and value-oriented products.
-- ============================================================
USE lego_analytics;

-- 1. Basic pricing statistics
SELECT
    MIN(US_retailPrice) AS minimum_price,
    MAX(US_retailPrice) AS maximum_price,
    ROUND(AVG(US_retailPrice), 2) AS average_price,
    ROUND(STDDEV(US_retailPrice), 2) AS price_std_dev
FROM lego_sets
WHERE US_retailPrice IS NOT NULL;


-- 2. Price bands
SELECT
    CASE
        WHEN US_retailPrice < 20 THEN 'Under $20'
        WHEN US_retailPrice < 50 THEN '$20 - $49'
        WHEN US_retailPrice < 100 THEN '$50 - $99'
        WHEN US_retailPrice < 200 THEN '$100 - $199'
        ELSE '$200+'
    END AS price_band,
    COUNT(*) AS number_of_sets
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
GROUP BY price_band
ORDER BY MIN(US_retailPrice);


-- 3. Premium LEGO products
-- Premium threshold defined for this analysis as $100+.
SELECT
    sets_id,
    name,
    theme,
    year,
    US_retailPrice
FROM lego_sets
WHERE US_retailPrice >= 100
ORDER BY US_retailPrice DESC;


-- 4. Count premium products by year
SELECT
    year,
    COUNT(*) AS premium_sets
FROM lego_sets
WHERE US_retailPrice >= 100
GROUP BY year
ORDER BY year;


-- 5. Average price by year
SELECT
    year,
    ROUND(AVG(US_retailPrice), 2) AS average_price
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
GROUP BY year
ORDER BY year;


-- 6. Highest priced product in each theme
SELECT
    theme,
    name,
    US_retailPrice
FROM (
    SELECT
        theme,
        name,
        US_retailPrice,
        ROW_NUMBER() OVER (
            PARTITION BY theme
            ORDER BY US_retailPrice DESC
        ) AS rn
    FROM lego_sets
    WHERE US_retailPrice IS NOT NULL
) ranked
WHERE rn = 1;


-- 7. Premium product concentration by theme
SELECT
    theme,
    COUNT(*) AS premium_products
FROM lego_sets
WHERE US_retailPrice >= 100
GROUP BY theme
ORDER BY premium_products DESC;