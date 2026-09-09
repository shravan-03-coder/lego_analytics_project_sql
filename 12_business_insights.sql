-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 12 - BUSINESS INSIGHTS
-- ============================================================
-- Purpose:
-- Convert raw LEGO data into practical business questions
-- that a product, marketing or strategy team could use.
-- ============================================================

USE lego_analytics;
-- ============================================================
-- INSIGHT 1
-- Which themes have the strongest product presence?
-- ============================================================

SELECT
    theme,
    COUNT(*) AS total_products
FROM lego_sets
GROUP BY theme
ORDER BY total_products DESC
LIMIT 10;


-- ============================================================
-- INSIGHT 2
-- Which themes have the strongest premium positioning?
-- ============================================================

SELECT
    theme,
    COUNT(*) AS premium_products,
    ROUND(AVG(US_retailPrice), 2) AS average_price
FROM lego_sets
WHERE US_retailPrice >= 100
GROUP BY theme
ORDER BY premium_products DESC
LIMIT 10;


-- ============================================================
-- INSIGHT 3
-- Which themes provide large sets at lower price-per-piece?
-- Useful for identifying value-oriented products.
-- ============================================================

SELECT
    theme,
    ROUND(AVG(US_retailPrice / pieces), 3)
        AS average_price_per_piece,
    COUNT(*) AS products
FROM lego_sets
WHERE pieces >= 1000
  AND US_retailPrice IS NOT NULL
GROUP BY theme
HAVING COUNT(*) >= 5
ORDER BY average_price_per_piece ASC;


-- ============================================================
-- INSIGHT 4
-- Which products could represent collector/premium offerings?
-- ============================================================

SELECT
    sets_id,
    name,
    theme,
    year,
    pieces,
    US_retailPrice
FROM lego_sets
WHERE US_retailPrice >= 200
ORDER BY US_retailPrice DESC
LIMIT 20;


-- ============================================================
-- INSIGHT 5
-- Which products combine large size with premium pricing?
-- ============================================================

SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice
FROM lego_sets
WHERE pieces >= 2000
  AND US_retailPrice >= 150
ORDER BY pieces DESC;


-- ============================================================
-- INSIGHT 6
-- Which age segments are associated with higher launch prices?
-- ============================================================

SELECT
    CASE
        WHEN agerange_min <= 5 THEN 'Young Children'
        WHEN agerange_min <= 8 THEN 'Children'
        WHEN agerange_min <= 12 THEN 'Older Children'
        WHEN agerange_min <= 16 THEN 'Teenagers'
        ELSE 'Adults'
    END AS age_segment,

    COUNT(*) AS total_products,

    ROUND(AVG(US_retailPrice), 2) AS average_price

FROM lego_sets
WHERE agerange_min IS NOT NULL
  AND US_retailPrice IS NOT NULL

GROUP BY age_segment
ORDER BY average_price DESC;


-- ============================================================
-- INSIGHT 7
-- Which years saw the strongest expansion in product launches?
-- ============================================================

SELECT
    year,
    COUNT(*) AS products_launched
FROM lego_sets
GROUP BY year
ORDER BY products_launched DESC
LIMIT 10;


-- ============================================================
-- INSIGHT 8
-- Which themes have the largest average sets?
-- ============================================================

SELECT
    theme,
    COUNT(*) AS total_products,
    ROUND(AVG(pieces), 2) AS average_pieces
FROM lego_sets
WHERE pieces IS NOT NULL
GROUP BY theme
HAVING COUNT(*) >= 10
ORDER BY average_pieces DESC
LIMIT 10;


-- ============================================================
-- INSIGHT 9
-- Which products look expensive relative to their piece count?
-- This is a pricing signal, not a profitability calculation.
-- ============================================================

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


-- ============================================================
-- INSIGHT 10
-- Which products look attractive from a piece-value perspective?
-- ============================================================

SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice,
    ROUND(US_retailPrice / pieces, 3) AS price_per_piece
FROM lego_sets
WHERE pieces >= 500
  AND pieces > 0
  AND US_retailPrice IS NOT NULL
ORDER BY price_per_piece ASC
LIMIT 20;


-- ============================================================
-- INSIGHT 11
-- Which themes have a strong mix of product volume and premium
-- products?
-- ============================================================

SELECT
    theme,

    COUNT(*) AS total_products,

    SUM(
        CASE
            WHEN US_retailPrice >= 100 THEN 1
            ELSE 0
        END
    ) AS premium_products,

    ROUND(
        SUM(
            CASE
                WHEN US_retailPrice >= 100 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS premium_share_percentage

FROM lego_sets

GROUP BY theme

HAVING COUNT(*) >= 10

ORDER BY premium_share_percentage DESC;


-- ============================================================
-- INSIGHT 12
-- Where does the portfolio have incomplete commercial data?
-- ============================================================

SELECT
    theme,

    COUNT(*) AS total_products,

    SUM(
        CASE
            WHEN US_retailPrice IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_price_data

FROM lego_sets

GROUP BY theme

ORDER BY missing_price_data DESC;