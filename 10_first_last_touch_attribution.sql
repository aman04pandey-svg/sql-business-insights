-- ==========================================================
-- Q10: First-Touch vs Last-Touch Attribution
-- ==========================================================
-- Business Question:
-- Which channels get credit for customer revenue under
-- first-touch vs last-touch attribution?
--
-- Attribution Models:
-- 1. First-touch  -> first channel a customer interacted with
-- 2. Last-touch   -> last channel a customer interacted with
--
-- Business Logic:
-- 1. Rank attribution touches for each customer by time.
-- 2. Identify the first and last channel.
-- 3. Customers without an attribution touch are treated as
--    direct.
-- 4. Exclude cancelled orders from revenue attribution.
-- 5. Calculate revenue and orders by attribution model/channel.
-- 6. Calculate each channel's share of revenue within
--    each attribution model.
--
-- Grain:
-- One row per attribution model × channel.
-- ==========================================================

WITH ranked_touches AS (

    SELECT
        s.customer_id,
        s.session_id,
        at.channel,
        at.touched_at,

        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY at.touched_at ASC NULLS LAST
        ) AS first_rn,

        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY at.touched_at DESC NULLS LAST
        ) AS last_rn

    FROM ecom.sessions s

    LEFT JOIN ecom.attribution_touches at
        ON s.session_id = at.session_id

),

customer_channels AS (

    SELECT
        customer_id,

        COALESCE(
            MAX(
                CASE
                    WHEN first_rn = 1 THEN channel
                END
            ),
            'direct'
        ) AS first_channel,

        COALESCE(
            MAX(
                CASE
                    WHEN last_rn = 1 THEN channel
                END
            ),
            'direct'
        ) AS last_channel

    FROM ranked_touches

    GROUP BY customer_id

),

attributed AS (

    -- First-touch attribution
    SELECT
        'first_touch' AS attribution_model,

        COALESCE(
            cc.first_channel,
            'direct'
        ) AS channel,

        SUM(o.total) AS revenue,

        COUNT(o.order_id) AS orders

    FROM ecom.orders o

    LEFT JOIN customer_channels cc
        ON o.customer_id = cc.customer_id

    WHERE o.status <> 'cancelled'

    GROUP BY
        COALESCE(
            cc.first_channel,
            'direct'
        )

    UNION ALL

    -- Last-touch attribution
    SELECT
        'last_touch' AS attribution_model,

        COALESCE(
            cc.last_channel,
            'direct'
        ) AS channel,

        SUM(o.total) AS revenue,

        COUNT(o.order_id) AS orders

    FROM ecom.orders o

    LEFT JOIN customer_channels cc
        ON o.customer_id = cc.customer_id

    WHERE o.status <> 'cancelled'

    GROUP BY
        COALESCE(
            cc.last_channel,
            'direct'
        )
)

SELECT
    attribution_model,
    channel,
    revenue,
    orders,

    revenue * 1.0
        / NULLIF(
            SUM(revenue) OVER (
                PARTITION BY attribution_model
            ),
            0
        ) AS share_of_revenue

FROM attributed

ORDER BY
    attribution_model,
    revenue DESC;
