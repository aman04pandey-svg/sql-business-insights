-- ==========================================================
-- Q8: Customer LTV + Bucket Share of Revenue
-- ==========================================================
-- Business Question:
-- Who are our top spenders, and what share of revenue
-- do they represent?
--
-- LTV Buckets:
-- 0-999
-- 1000-4999
-- 5000-19999
-- 20000+
--
-- Output:
-- customer_id,
-- first_order_date,
-- last_order_date,
-- total_orders,
-- total_revenue,
-- aov,
-- ltv_bucket,
-- ltv_bucket_share_of_revenue
--
-- Business Logic:
-- 1. Exclude cancelled orders.
-- 2. Calculate customer-level order and revenue metrics.
-- 3. Assign each customer to an LTV bucket using CASE WHEN.
-- 4. Calculate each bucket's share of total revenue using
--    window functions.
--
-- Grain:
-- One row per customer.
-- ==========================================================

WITH customer_ltv AS (

    SELECT
        o.customer_id,

        MIN(o.created_at) AS first_order_date,

        MAX(o.created_at) AS last_order_date,

        COUNT(o.order_id) AS total_orders,

        SUM(o.total) AS total_revenue,

        AVG(o.total) AS aov

    FROM ecom.orders o

    WHERE o.status <> 'cancelled'

    GROUP BY
        o.customer_id

),

bucketed AS (

    SELECT
        *,

        CASE
            WHEN total_revenue <= 999
                THEN '0-999'

            WHEN total_revenue <= 4999
                THEN '1000-4999'

            WHEN total_revenue <= 19999
                THEN '5000-19999'

            ELSE '20000+'
        END AS ltv_bucket

    FROM customer_ltv

)

SELECT
    customer_id,
    first_order_date,
    last_order_date,
    total_orders,
    total_revenue,
    aov,
    ltv_bucket,

    SUM(total_revenue) OVER (
        PARTITION BY ltv_bucket
    ) * 1.0
    / NULLIF(
        SUM(total_revenue) OVER (),
        0
    ) AS ltv_bucket_share_of_revenue

FROM bucketed;
