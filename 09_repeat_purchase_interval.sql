-- ==========================================================
-- Q9: Repeat Purchase Interval
-- ==========================================================
-- Business Question:
-- How long until a customer comes back?
--
-- Analysis:
-- Measure the time between consecutive orders for each customer.
--
-- Output:
-- avg_days_to_next_order,
-- median_days_to_next_order,
-- p90_days_to_next_order,
-- customers_with_repeat_order
--
-- Business Logic:
-- 1. Use LEAD() to identify the next order for each customer.
-- 2. Calculate the number of days between consecutive orders.
-- 3. Exclude customers/orders where there is no next order.
-- 4. Exclude zero or negative intervals.
-- 5. Calculate average, median and P90 repeat-purchase intervals.
--
-- Grain:
-- One row per customer order in the order_intervals CTE.
-- Final output is an overall summary.
-- ==========================================================

WITH customer_orders AS (

    SELECT
        o.customer_id,
        o.order_id,
        o.created_at AS order_date,

        LEAD(o.created_at) OVER (
            PARTITION BY o.customer_id
            ORDER BY o.created_at
        ) AS next_order_date

    FROM ecom.orders o

),

order_intervals AS (

    SELECT
        customer_id,
        order_id,
        order_date,
        next_order_date,

        next_order_date::date
        - order_date::date AS days_to_next_order

    FROM customer_orders

    WHERE next_order_date IS NOT NULL

      AND (
          next_order_date::date
          - order_date::date
      ) > 0

)

SELECT
    AVG(days_to_next_order)
        AS avg_days_to_next_order,

    PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY days_to_next_order
        ) AS median_days_to_next_order,

    PERCENTILE_CONT(0.9)
        WITHIN GROUP (
            ORDER BY days_to_next_order
        ) AS p90_days_to_next_order,

    COUNT(DISTINCT customer_id)
        AS customers_with_repeat_order

FROM order_intervals;
