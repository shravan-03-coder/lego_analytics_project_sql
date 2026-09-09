-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 10 - PORTFOLIO SEGMENTATION
-- ============================================================
-- Purpose:
-- Divide LEGO products into practical business segments
-- using price, pieces and product complexity.
-- ============================================================
USE lego_analytics;

-- 1. Simple product segmentation
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice,

    CASE
        WHEN US_retailPrice >= 200 THEN 'Luxury / Collector'
        WHEN US_retailPrice >= 100 THEN 'Premium'
        WHEN US_retailPrice >= 50 THEN 'Mid-Range'
        ELSE 'Entry-Level'
    END AS price_segment

FROM lego_sets
WHERE US_retailPrice IS NOT NULL;


-- 2. Product size segmentation
SELECT
    sets_id,
    name,
    pieces,

    CASE
        WHEN pieces >= 2000 THEN 'Very Large'
        WHEN pieces >= 1000 THEN 'Large'
        WHEN pieces >= 500 THEN 'Medium'
        ELSE 'Small'
    END AS size_segment

FROM lego_sets
WHERE pieces IS NOT NULL;


-- 3. Combined portfolio segmentation
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice,

    CASE
        WHEN pieces >= 2000
             AND US_retailPrice >= 150
            THEN 'Large Premium'

        WHEN pieces >= 1000
             AND US_retailPrice < 100
            THEN 'Large Value'

        WHEN pieces < 500
             AND US_retailPrice < 50
            THEN 'Small Entry-Level'

        WHEN US_retailPrice >= 100
            THEN 'Premium'

        ELSE 'Core Portfolio'
    END AS portfolio_segment

FROM lego_sets
WHERE pieces IS NOT NULL
  AND US_retailPrice IS NOT NULL;


-- 4. Count products in each portfolio segment
SELECT
    portfolio_segment,
    COUNT(*) AS total_products
FROM (
    SELECT
        CASE
            WHEN pieces >= 2000
                 AND US_retailPrice >= 150
                THEN 'Large Premium'

            WHEN pieces >= 1000
                 AND US_retailPrice < 100
                THEN 'Large Value'

            WHEN pieces < 500
                 AND US_retailPrice < 50
                THEN 'Small Entry-Level'

            WHEN US_retailPrice >= 100
                THEN 'Premium'

            ELSE 'Core Portfolio'
        END AS portfolio_segment
    FROM lego_sets
    WHERE pieces IS NOT NULL
      AND US_retailPrice IS NOT NULL
) segments
GROUP BY portfolio_segment
ORDER BY total_products DESC;


-- 5. Premium but small products
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice
FROM lego_sets
WHERE pieces < 500
  AND US_retailPrice >= 100
ORDER BY US_retailPrice DESC;


-- 6. Large but relatively affordable products
SELECT
    sets_id,
    name,
    theme,
    pieces,
    US_retailPrice
FROM lego_sets
WHERE pieces >= 1000
  AND US_retailPrice < 100
ORDER BY pieces DESC;