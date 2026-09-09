-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 08 - PRODUCT VALUE ANALYSIS
-- ============================================================
-- Purpose:
-- Evaluate product value using pieces, price and
-- price-per-piece metrics.
-- ============================================================

USE lego_analytics;

-- 1. Calculate price per piece
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice,
    ROUND(US_retailPrice / pieces, 3) AS price_per_piece
FROM lego_sets
WHERE pieces > 0
  AND US_retailPrice IS NOT NULL
ORDER BY price_per_piece ASC;


-- 2. Best price-per-piece products
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice,
    ROUND(US_retailPrice / pieces, 3) AS price_per_piece
FROM lego_sets
WHERE pieces > 0
  AND US_retailPrice IS NOT NULL
ORDER BY price_per_piece ASC
LIMIT 20;


-- 3. Highest price-per-piece products
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice,
    ROUND(US_retailPrice / pieces, 3) AS price_per_piece
FROM lego_sets
WHERE pieces > 0
  AND US_retailPrice IS NOT NULL
ORDER BY price_per_piece DESC
LIMIT 20;


-- 4. Average price per piece by theme
SELECT
    theme,
    ROUND(AVG(US_retailPrice / pieces), 3)
        AS average_price_per_piece
FROM lego_sets
WHERE pieces > 0
  AND US_retailPrice IS NOT NULL
GROUP BY theme
HAVING COUNT(*) >= 10
ORDER BY average_price_per_piece;


-- 5. Large sets with relatively low price per piece
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice,
    ROUND(US_retailPrice / pieces, 3) AS price_per_piece
FROM lego_sets
WHERE pieces >= 1000
  AND US_retailPrice IS NOT NULL
ORDER BY price_per_piece ASC
LIMIT 20;


-- 6. High-piece premium products
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice,
    ROUND(US_retailPrice / pieces, 3) AS price_per_piece
FROM lego_sets
WHERE pieces >= 2000
  AND US_retailPrice >= 100
ORDER BY pieces DESC;


-- 7. Product value segmentation
SELECT
    sets_id,
    name,
    pieces,
    US_retailPrice,
    CASE
        WHEN pieces >= 2000 AND US_retailPrice >= 150
            THEN 'Large Premium'
        WHEN pieces >= 1000 AND US_retailPrice < 100
            THEN 'Large Value'
        WHEN pieces < 500 AND US_retailPrice >= 100
            THEN 'Small Premium'
        ELSE 'Standard'
    END AS product_segment
FROM lego_sets
WHERE pieces IS NOT NULL
  AND US_retailPrice IS NOT NULL;