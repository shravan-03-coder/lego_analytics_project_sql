-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 09 - CUSTOMER AGE ANALYSIS
-- ============================================================
-- Purpose:
-- Understand the age positioning of LEGO products.
-- ============================================================

USE lego_analytics;

-- 1. Number of products by minimum recommended age
SELECT
    agerange_min,
    COUNT(*) AS total_sets
FROM lego_sets
WHERE agerange_min IS NOT NULL
GROUP BY agerange_min
ORDER BY agerange_min;


-- 2. Age segmentation
SELECT
    CASE
        WHEN agerange_min <= 5 THEN 'Young Children'
        WHEN agerange_min <= 8 THEN 'Children'
        WHEN agerange_min <= 12 THEN 'Older Children'
        WHEN agerange_min <= 16 THEN 'Teenagers'
        ELSE 'Adults'
    END AS age_segment,
    COUNT(*) AS total_sets
FROM lego_sets
WHERE agerange_min IS NOT NULL
GROUP BY age_segment
ORDER BY total_sets DESC;


-- 3. Average price by age segment
SELECT
    CASE
        WHEN agerange_min <= 5 THEN 'Young Children'
        WHEN agerange_min <= 8 THEN 'Children'
        WHEN agerange_min <= 12 THEN 'Older Children'
        WHEN agerange_min <= 16 THEN 'Teenagers'
        ELSE 'Adults'
    END AS age_segment,
    COUNT(*) AS total_sets,
    ROUND(AVG(US_retailPrice), 2) AS average_price
FROM lego_sets
WHERE agerange_min IS NOT NULL
  AND US_retailPrice IS NOT NULL
GROUP BY age_segment
ORDER BY average_price DESC;


-- 4. Average pieces by age segment
SELECT
    CASE
        WHEN agerange_min <= 5 THEN 'Young Children'
        WHEN agerange_min <= 8 THEN 'Children'
        WHEN agerange_min <= 12 THEN 'Older Children'
        WHEN agerange_min <= 16 THEN 'Teenagers'
        ELSE 'Adults'
    END AS age_segment,
    ROUND(AVG(pieces), 2) AS average_pieces
FROM lego_sets
WHERE agerange_min IS NOT NULL
  AND pieces IS NOT NULL
GROUP BY age_segment
ORDER BY average_pieces DESC;


-- 5. Premium products aimed at older customers
SELECT
    sets_id,
    name,
    theme,
    agerange_min,
    pieces,
    US_retailPrice
FROM lego_sets
WHERE agerange_min >= 16
  AND US_retailPrice >= 100
ORDER BY US_retailPrice DESC;


-- 6. Themes popular across age groups
SELECT
    theme,
    agerange_min,
    COUNT(*) AS total_sets
FROM lego_sets
WHERE agerange_min IS NOT NULL
GROUP BY theme, agerange_min
ORDER BY theme, total_sets DESC;