-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 05 - THEME ANALYSIS
-- ============================================================
-- Purpose:
-- Identify the strongest themes and understand where the
-- LEGO portfolio is concentrated.
-- ============================================================

USE lego_analytics;

-- 1. Number of products by theme
SELECT
    theme,
    COUNT(*) AS total_sets
FROM lego_sets
GROUP BY theme
ORDER BY total_sets DESC;


-- 2. Top 20 themes by product count
SELECT
    theme,
    COUNT(*) AS total_sets
FROM lego_sets
GROUP BY theme
ORDER BY total_sets DESC
LIMIT 20;


-- 3. Average pieces by theme
SELECT
    theme,
    COUNT(*) AS total_sets,
    ROUND(AVG(pieces), 2) AS average_pieces
FROM lego_sets
WHERE pieces IS NOT NULL
GROUP BY theme
ORDER BY average_pieces DESC;


-- 4. Average price by theme
SELECT
    theme,
    COUNT(*) AS priced_sets,
    ROUND(AVG(US_retailPrice), 2) AS average_price
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
GROUP BY theme
HAVING COUNT(*) >= 10
ORDER BY average_price DESC;


-- 5. Themes with the highest total listed-price value
-- This is NOT revenue because units sold are not available.
SELECT
    theme,
    COUNT(*) AS total_sets,
    ROUND(SUM(US_retailPrice), 2) AS total_listed_price_value
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
GROUP BY theme
ORDER BY total_listed_price_value DESC;


-- 6. Most expensive theme based on average price
SELECT
    theme,
    ROUND(AVG(US_retailPrice), 2) AS average_price
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
GROUP BY theme
HAVING COUNT(*) >= 10
ORDER BY average_price DESC
LIMIT 10;


-- 7. Themes with large products
SELECT
    theme,
    COUNT(*) AS large_set_count
FROM lego_sets
WHERE pieces >= 1000
GROUP BY theme
ORDER BY large_set_count DESC
LIMIT 20;


-- 8. Theme-level minifigure analysis
SELECT
    theme,
    COUNT(*) AS sets_with_minifigs,
    ROUND(AVG(minifigs), 2) AS average_minifigs
FROM lego_sets
WHERE minifigs IS NOT NULL
GROUP BY theme
ORDER BY average_minifigs DESC
LIMIT 20;