-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 06 - CATEGORY ANALYSIS
-- ============================================================
-- Purpose:
-- Understand how the LEGO portfolio is distributed across
-- different product categories.
-- ============================================================
USE lego_analytics;

-- 1. Number of products by category
SELECT
    category,
    COUNT(*) AS total_sets
FROM lego_sets
GROUP BY category
ORDER BY total_sets DESC;


-- 2. Average pieces by category
SELECT
    category,
    COUNT(*) AS total_sets,
    ROUND(AVG(pieces), 2) AS average_pieces
FROM lego_sets
WHERE pieces IS NOT NULL
GROUP BY category
ORDER BY average_pieces DESC;


-- 3. Average launch price by category
SELECT
    category,
    COUNT(*) AS priced_sets,
    ROUND(AVG(US_retailPrice), 2) AS average_price
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
GROUP BY category
HAVING COUNT(*) >= 5
ORDER BY average_price DESC;


-- 4. Most common theme group
SELECT
    themeGroup,
    COUNT(*) AS total_sets
FROM lego_sets
GROUP BY themeGroup
ORDER BY total_sets DESC;


-- 5. Category and theme group combination
SELECT
    themeGroup,
    category,
    COUNT(*) AS total_sets
FROM lego_sets
GROUP BY themeGroup, category
ORDER BY total_sets DESC;


-- 6. Categories with premium products
SELECT
    category,
    COUNT(*) AS premium_sets
FROM lego_sets
WHERE US_retailPrice >= 100
GROUP BY category
ORDER BY premium_sets DESC;


-- 7. Category-level price efficiency
SELECT
    category,
    ROUND(AVG(US_retailPrice / NULLIF(pieces, 0)), 3)
        AS avg_price_per_piece
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
  AND pieces IS NOT NULL
  AND pieces > 0
GROUP BY category
ORDER BY avg_price_per_piece;