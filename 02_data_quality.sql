-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 02 - DATA QUALITY
-- ============================================================
-- Purpose:
-- Identify missing values and unusual records before
-- using the dataset for business analysis.
-- ============================================================

USE lego_analytics;

-- 1. Check missing subthemes
SELECT
    COUNT(*) AS missing_subtheme
FROM lego_sets
WHERE subtheme IS NULL;


-- 2. Check missing pieces
SELECT
    COUNT(*) AS missing_pieces
FROM lego_sets
WHERE pieces IS NULL;


-- 3. Check missing minifigures
SELECT
    COUNT(*) AS missing_minifigs
FROM lego_sets
WHERE minifigs IS NULL;


-- 4. Check missing age information
SELECT
    COUNT(*) AS missing_age
FROM lego_sets
WHERE agerange_min IS NULL;


-- 5. Check missing retail prices
SELECT
    COUNT(*) AS missing_prices
FROM lego_sets
WHERE US_retailPrice IS NULL;


-- 6. Check missing images
SELECT
    COUNT(*) AS missing_images
FROM lego_sets
WHERE imageURL IS NULL;


-- 7. Complete data-quality summary
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE WHEN sets_id IS NULL THEN 1 ELSE 0 END) AS missing_set_id,
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS missing_name,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS missing_year,
    SUM(CASE WHEN theme IS NULL THEN 1 ELSE 0 END) AS missing_theme,
    SUM(CASE WHEN subtheme IS NULL THEN 1 ELSE 0 END) AS missing_subtheme,
    SUM(CASE WHEN pieces IS NULL THEN 1 ELSE 0 END) AS missing_pieces,
    SUM(CASE WHEN minifigs IS NULL THEN 1 ELSE 0 END) AS missing_minifigs,
    SUM(CASE WHEN agerange_min IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN US_retailPrice IS NULL THEN 1 ELSE 0 END) AS missing_price
FROM lego_sets;


-- 8. Check duplicate set IDs
SELECT
    sets_id,
    COUNT(*) AS duplicate_count
FROM lego_sets
GROUP BY sets_id
HAVING COUNT(*) > 1;


-- 9. Check unusual piece counts
SELECT *
FROM lego_sets
WHERE pieces <= 0;


-- 10. Check unusual prices
SELECT *
FROM lego_sets
WHERE US_retailPrice < 0;


-- 11. Check suspicious release years
SELECT *
FROM lego_sets
WHERE year < 1900
   OR year > YEAR(CURDATE());