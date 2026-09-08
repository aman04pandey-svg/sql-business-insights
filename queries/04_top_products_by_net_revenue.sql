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
-- Net Revenue = Gross Revenue - Allocated Refund Amount
--
-- Refund Logic:
-- Order-level refunds are allocated to products
-- proportionally based on each product's share of
-- the total order value.
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

-- Step 1:
-- Calculate product revenue within each order
-- and total order revenue.

order_product_revenue AS (

    SELECT
        oi.order_id,
        p.product_id,

        SUM(oi.line_total) AS product_line_total,

        SUM(SUM(oi.line_total)) OVER (
            PARTITION BY oi.order_id
        ) AS order_total

    FROM ecom.order_items oi

    JOIN ecom.product_variants pv
        ON oi.variant_id = pv.variant_id

    JOIN ecom.products p
        ON pv.product_id = p.product_id

    GROUP BY
        oi.order_id,
        p.product_id

),

-- Step 2:
-- Aggregate refunds at order level first.

order_refunds AS (

    SELECT
        order_id,
        SUM(refund_amount) AS refund_amount

    FROM ecom.order_refunds

    GROUP BY
        order_id

),

-- Step 3:
-- Allocate each order's refund proportionally
-- across its products.

product_refunds AS (

    SELECT
        opr.product_id,

        SUM(
            orf.refund_amount
            * opr.product_line_total
            / NULLIF(opr.order_total, 0)
        ) AS refunds_amount

    FROM order_product_revenue opr

    JOIN order_refunds orf
        ON opr.order_id = orf.order_id

    GROUP BY
        opr.product_id

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

    ROUND(
        COALESCE(rf.refunds_amount, 0),
        2
    ) AS refunds_amount,

    ROUND(
        pr.gross_revenue
        - COALESCE(rf.refunds_amount, 0),
        2
    ) AS net_revenue

FROM product_revenue pr

LEFT JOIN product_returns rt
    ON pr.product_id = rt.product_id

LEFT JOIN product_refunds rf
    ON pr.product_id = rf.product_id

ORDER BY
    net_revenue DESC;
