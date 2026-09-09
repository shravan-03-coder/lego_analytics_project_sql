-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 03 - PRODUCT ANALYSIS
-- ============================================================
-- Purpose:
-- Understand the LEGO product portfolio at individual
-- product level.
-- ============================================================

USE lego_analytics;

-- 1. Largest LEGO sets by number of pieces
SELECT
    sets_id,
    name,
    theme,
    year,
    pieces
FROM lego_sets
WHERE pieces IS NOT NULL
ORDER BY pieces DESC
LIMIT 20;


-- 2. Most expensive LEGO sets
SELECT
    sets_id,
    name,
    theme,
    year,
    US_retailPrice
FROM lego_sets
WHERE US_retailPrice IS NOT NULL
ORDER BY US_retailPrice DESC
LIMIT 20;


-- 3. Products with the highest number of minifigures
SELECT
    sets_id,
    name,
    theme,
    minifigs
FROM lego_sets
WHERE minifigs IS NOT NULL
ORDER BY minifigs DESC
LIMIT 20;


-- 4. Latest LEGO products
SELECT
    sets_id,
    name,
    theme,
    year
FROM lego_sets
ORDER BY year DESC
LIMIT 20;


-- 5. Oldest LEGO products
SELECT
    sets_id,
    name,
    theme,
    year
FROM lego_sets
ORDER BY year ASC
LIMIT 20;


-- 6. Products with both high pieces and high price
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice
FROM lego_sets
WHERE pieces >= 1000
  AND US_retailPrice >= 100
ORDER BY pieces DESC;


-- 7. Products suitable for a value-focused customer
-- Higher pieces with relatively lower launch price.
SELECT
    sets_id,
    name,
    pieces,
    US_retailPrice,
    ROUND(US_retailPrice / pieces, 3) AS price_per_piece
FROM lego_sets
WHERE pieces IS NOT NULL
  AND US_retailPrice IS NOT NULL
  AND pieces > 0
ORDER BY price_per_piece ASC
LIMIT 20;