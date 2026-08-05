-- ==========================================================
-- Q4: Top Products by Net Revenue (After Refunds)
-- ==========================================================
-- Business Question:
-- Which products generate the highest net revenue after
-- accounting for returns and refunds?
--
-- Business Logic:
-- Gross Revenue = SUM(line_total)
-- Return Rate = Returns Count / Order Count
-- Net Revenue = Gross Revenue - Refund Amount
--
-- Pattern:
-- 1. product_revenue
-- 2. product_returns
-- 3. product_refunds
-- Join all three CTEs in the final SELECT.
--
-- Sanity Check:
-- Sum(gross_revenue) should approximately match
-- SUM(qty * unit_price) from order_items.
-- ==========================================================

WITH product_revenue AS (

    SELECT
        p.product_id,
        p.product_name,
        c.category_name,

        SUM(oi.line_total) AS gross_revenue,

        COUNT(DISTINCT oi.order_id) AS order_count,

        SUM(oi.qty) AS units_sold

    FROM ecom.order_items oi

    JOIN ecom.product_variants pv
        ON oi.variant_id = pv.variant_id

    JOIN ecom.products p
        ON pv.product_id = p.product_id

    JOIN ecom.categories c
        ON p.category_id = c.category_id

    GROUP BY
        p.product_id,
        p.product_name,
        c.category_name

),

product_returns AS (

    SELECT

        p.product_id,
        p.product_name,

        COUNT(ri.return_id) AS returns_count

    FROM ecom.return_items ri

    JOIN ecom.product_variants pv
        ON ri.variant_id = pv.variant_id

    JOIN ecom.products p
        ON pv.product_id = p.product_id

    GROUP BY
        p.product_id,
        p.product_name

),

product_refunds AS (

    SELECT

        p.product_id,
        p.product_name,

        SUM(orf.refund_amount) AS refunds_amount

    FROM ecom.order_refunds orf

    JOIN ecom.order_items oi
        ON orf.order_id = oi.order_id

    JOIN ecom.product_variants pv
        ON oi.variant_id = pv.variant_id

    JOIN ecom.products p
        ON pv.product_id = p.product_id

    GROUP BY
        p.product_id,
        p.product_name

)

SELECT

    pr.product_id,
    pr.product_name,
    pr.category_name,

    pr.gross_revenue,

    pr.order_count,

    pr.units_sold,

    COALESCE(rt.returns_count, 0) AS returns_count,

    ROUND(
        COALESCE(rt.returns_count, 0) * 100.0
        / NULLIF(pr.order_count, 0),
        2
    ) AS return_rate,

    COALESCE(rf.refunds_amount, 0) AS refunds_amount,

    pr.gross_revenue
    - COALESCE(rf.refunds_amount, 0)
    AS net_revenue

FROM product_revenue pr

LEFT JOIN product_returns rt
    ON pr.product_id = rt.product_id

LEFT JOIN product_refunds rf
    ON pr.product_id = rf.product_id

ORDER BY net_revenue DESC;
