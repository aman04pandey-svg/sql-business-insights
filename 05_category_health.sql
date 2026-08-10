-- ==========================================================
-- Q5: Category Health - Purchases to Returns
-- ==========================================================
-- Business Question:
-- Which categories generate the most revenue, and which
-- categories have the highest return rates?
--
-- Output:
-- category,
-- orders_with_category,
-- units_sold,
-- revenue,
-- returns,
-- return_rate_pct
--
-- Business Logic:
-- Revenue = SUM(line_total) from paid orders
-- Return Rate = Returns / Orders with Category
--
-- Grain:
-- One row per category
--
-- Pattern:
-- Two CTEs:
-- 1. category_sales
-- 2. category_returns
--
-- Return join chain:
-- return_items
--     -> product_variants
--     -> products
--     -> categories
--
-- This join chain is required because return_items references
-- variants rather than products directly.
-- ==========================================================

WITH category_sales AS (

    SELECT
        c.category_name AS category,

        COUNT(DISTINCT oi.order_id) AS orders_with_category,

        SUM(oi.qty) AS units_sold,

        SUM(oi.line_total) AS revenue

    FROM ecom.order_items oi

    JOIN ecom.orders o
        ON oi.order_id = o.order_id

    JOIN ecom.product_variants pv
        ON oi.variant_id = pv.variant_id

    JOIN ecom.products p
        ON pv.product_id = p.product_id

    JOIN ecom.categories c
        ON p.category_id = c.category_id

    WHERE o.status = 'paid'

    GROUP BY
        c.category_name

),

category_returns AS (

    SELECT
        c.category_name AS category,

        COUNT(ri.return_id) AS returns

    FROM ecom.return_items ri

    JOIN ecom.product_variants pv
        ON ri.variant_id = pv.variant_id

    JOIN ecom.products p
        ON pv.product_id = p.product_id

    JOIN ecom.categories c
        ON p.category_id = c.category_id

    GROUP BY
        c.category_name

)

SELECT
    cs.category,

    cs.orders_with_category,

    cs.units_sold,

    cs.revenue,

    COALESCE(cr.returns, 0) AS returns,

    ROUND(
        COALESCE(cr.returns, 0) * 100.0
        / NULLIF(cs.orders_with_category, 0),
        2
    ) AS return_rate_pct

FROM category_sales cs

LEFT JOIN category_returns cr
    ON cs.category = cr.category

ORDER BY
    cs.revenue DESC;
