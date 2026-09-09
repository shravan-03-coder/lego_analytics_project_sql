-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 04 - GROWTH ANALYSIS
-- ============================================================
-- Purpose:
-- Analyze how LEGO's product portfolio has changed over time.
-- ============================================================

USE lego_analytics;

-- 1. Number of sets released each year
SELECT
    year,
    COUNT(*) AS sets_released
FROM lego_sets
GROUP BY year
ORDER BY year;


-- 2. Year with the highest number of launches
SELECT
    year,
    COUNT(*) AS sets_released
FROM lego_sets
GROUP BY year
ORDER BY sets_released DESC
LIMIT 1;


-- 3. Top 10 launch years
SELECT
    year,
    COUNT(*) AS sets_released
FROM lego_sets
GROUP BY year
ORDER BY sets_released DESC
LIMIT 10;


-- 4. Average pieces by year
SELECT
    year,
    ROUND(AVG(pieces), 2) AS average_pieces
FROM lego_sets
WHERE pieces IS NOT NULL
GROUP BY year
ORDER BY year;


-- 5. Average launch price by year
SELECT
    year,
    ROUND(AVG(US_retailPrice), 2) AS average_launch_price
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
GROUP BY year
ORDER BY year;


-- 6. Portfolio growth by decade
SELECT
    decade,
    COUNT(*) AS total_sets
FROM (
    SELECT
        CONCAT(FLOOR(year / 10) * 10, 's') AS decade
    FROM lego_sets
) AS decade_data
GROUP BY decade
ORDER BY decade;

-- 7. Compare recent years
SELECT
    year,
    COUNT(*) AS sets_released,
    ROUND(AVG(pieces), 2) AS avg_pieces,
    ROUND(AVG(US_retailPrice), 2) AS avg_price
FROM lego_sets
WHERE year >= 2015
GROUP BY year
ORDER BY year;


-- 8. Year-over-year change in product launches
SELECT
    year,
    COUNT(*) AS current_year_sets,
    LAG(COUNT(*)) OVER (ORDER BY year) AS previous_year_sets,
    COUNT(*) -
        LAG(COUNT(*)) OVER (ORDER BY year) AS change_from_previous_year
FROM lego_sets
GROUP BY year
ORDER BY year;