-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 01 - DATA PROFILING
-- ============================================================
-- Purpose:
-- Understand the structure, size and basic characteristics
-- of the LEGO product dataset before starting analysis.
-- ============================================================
USE lego_analytics;


-- 1. Check the total number of LEGO sets
SELECT 
    COUNT(*) AS total_lego_sets
FROM lego_sets;


-- 2. Preview the dataset
SELECT *
FROM lego_sets
LIMIT 20;


-- 3. Check the columns and data types
DESCRIBE lego_sets;


-- 4. Check the data dictionary
SELECT *
FROM lego_sets_data_dictionary;


-- 5. Find the earliest and latest LEGO release year
SELECT
    MIN(year) AS earliest_release_year,
    MAX(year) AS latest_release_year
FROM lego_sets;


-- 6. Count unique themes
SELECT
    COUNT(DISTINCT theme) AS total_themes
FROM lego_sets;


-- 7. Count unique categories
SELECT
    COUNT(DISTINCT category) AS total_categories
FROM lego_sets;


-- 8. Count unique theme groups
SELECT
    COUNT(DISTINCT themeGroup) AS total_theme_groups
FROM lego_sets;


-- 9. Count unique age recommendations
SELECT
    COUNT(DISTINCT agerange_min) AS unique_age_ranges
FROM lego_sets;


-- 10. Basic product statistics
SELECT
    MIN(pieces) AS minimum_pieces,
    MAX(pieces) AS maximum_pieces,
    ROUND(AVG(pieces), 2) AS average_pieces,
    MIN(US_retailPrice) AS minimum_price,
    MAX(US_retailPrice) AS maximum_price,
    ROUND(AVG(US_retailPrice), 2) AS average_price
FROM lego_sets;


-- 11. Number of sets released by year
SELECT
    year,
    COUNT(*) AS sets_released
FROM lego_sets
GROUP BY year
ORDER BY year;


-- 12. Most common LEGO themes
SELECT
    theme,
    COUNT(*) AS number_of_sets
FROM lego_sets
GROUP BY theme
ORDER BY number_of_sets DESC
LIMIT 20;