-- ============================================================
-- LEGO PRODUCT PORTFOLIO ANALYTICS
-- 13 - REUSABLE ANALYTICAL VIEWS
-- ============================================================
-- Purpose:
-- Create reusable datasets for Power BI, Tableau or Excel.
--
-- Note:
-- These are VIEWS, not physical tables.
-- ============================================================

USE lego_analytics;

-- ============================================================
-- VIEW 1: Product Value View
-- ============================================================

CREATE OR REPLACE VIEW vw_lego_product_value AS

SELECT
    sets_id,
    name,
    year,
    theme,
    subtheme,
    themeGroup,
    category,
    pieces,
    minifigs,
    agerange_min,
    US_retailPrice,

    CASE
        WHEN pieces > 0
             AND US_retailPrice IS NOT NULL
        THEN ROUND(US_retailPrice / pieces, 3)
        ELSE NULL
    END AS price_per_piece,

    CASE
        WHEN US_retailPrice >= 200
            THEN 'Luxury / Collector'
        WHEN US_retailPrice >= 100
            THEN 'Premium'
        WHEN US_retailPrice >= 50
            THEN 'Mid-Range'
        WHEN US_retailPrice IS NOT NULL
            THEN 'Entry-Level'
        ELSE 'Unknown'
    END AS price_segment

FROM lego_sets;


-- Check the view
SELECT *
FROM vw_lego_product_value
LIMIT 20;


-- ============================================================
-- VIEW 2: Yearly Portfolio Performance
-- ============================================================

CREATE OR REPLACE VIEW vw_lego_yearly_performance AS

SELECT
    year,

    COUNT(*) AS total_sets,

    ROUND(AVG(pieces), 2) AS average_pieces,

    ROUND(AVG(US_retailPrice), 2) AS average_launch_price,

    COUNT(
        CASE
            WHEN US_retailPrice >= 100 THEN 1
        END
    ) AS premium_sets

FROM lego_sets

GROUP BY year;


-- Check the view
SELECT *
FROM vw_lego_yearly_performance
ORDER BY year;


-- ============================================================
-- VIEW 3: Theme Performance
-- ============================================================

CREATE OR REPLACE VIEW vw_lego_theme_performance AS

SELECT
    theme,

    COUNT(*) AS total_sets,

    ROUND(AVG(pieces), 2) AS average_pieces,

    ROUND(AVG(US_retailPrice), 2) AS average_price,

    COUNT(
        CASE
            WHEN US_retailPrice >= 100 THEN 1
        END
    ) AS premium_sets,

    ROUND(
        AVG(
            CASE
                WHEN pieces > 0
                 AND US_retailPrice IS NOT NULL
                THEN US_retailPrice / pieces
            END
        ),
        3
    ) AS average_price_per_piece

FROM lego_sets

GROUP BY theme;


-- Check the view
SELECT *
FROM vw_lego_theme_performance
ORDER BY total_sets DESC;


-- ============================================================
-- VIEW 4: Business Dashboard View
-- ============================================================

CREATE OR REPLACE VIEW vw_lego_business_dashboard AS

SELECT

    year,

    theme,

    category,

    COUNT(*) AS total_products,

    ROUND(AVG(pieces), 2) AS average_pieces,

    ROUND(AVG(US_retailPrice), 2) AS average_price,

    COUNT(
        CASE
            WHEN US_retailPrice >= 100 THEN 1
        END
    ) AS premium_products,

    COUNT(
        CASE
            WHEN pieces >= 1000 THEN 1
        END
    ) AS large_products

FROM lego_sets

GROUP BY
    year,
    theme,
    category;


-- Check the dashboard view
SELECT *
FROM vw_lego_business_dashboard
ORDER BY year, total_products DESC;