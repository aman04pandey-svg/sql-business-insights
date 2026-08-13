-- ==========================================================
-- Q7: Delivery SLA Breach by Carrier × Shipping Method
-- ==========================================================
-- Business Question:
-- Who is missing the 5-day SLA, and by how much?
--
-- SLA:
-- delivery_days = delivered_at::date - shipped_at::date
--
-- Late Delivery:
-- delivery_days > 5
--
-- Output:
-- carrier,
-- shipping_method,
-- delivered_orders,
-- avg_delivery_days,
-- median_delivery_days,
-- p90_delivery_days,
-- late_deliveries,
-- late_rate
--
-- Business Logic:
-- 1. Exclude shipments that are still in transit
--    (delivered_at IS NULL).
-- 2. Calculate delivery time from shipped date to
--    delivered date.
-- 3. Calculate average, median and P90 delivery days.
-- 4. Identify deliveries taking more than 5 days as late.
--
-- Grain:
-- One row per carrier × shipping method.
--
-- Data Quality:
-- If shipped_at > delivered_at exists, it should be
-- highlighted as a data-quality finding.
-- ==========================================================

SELECT
    sc.carrier_name AS carrier,

    sm.method_name AS shipping_method,

    COUNT(s.delivered_at) AS delivered_orders,

    AVG(
        s.delivered_at::date - s.shipped_at::date
    ) AS avg_delivery_days,

    PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY (
                s.delivered_at::date - s.shipped_at::date
            )
        ) AS median_delivery_days,

    PERCENTILE_CONT(0.9)
        WITHIN GROUP (
            ORDER BY (
                s.delivered_at::date - s.shipped_at::date
            )
        ) AS p90_delivery_days,

    COUNT(
        CASE
            WHEN (
                s.delivered_at::date - s.shipped_at::date
            ) > 5
            THEN 1
        END
    ) AS late_deliveries,

    COUNT(
        CASE
            WHEN (
                s.delivered_at::date - s.shipped_at::date
            ) > 5
            THEN 1
        END
    ) * 1.0
    / NULLIF(COUNT(s.delivered_at), 0) AS late_rate

FROM ecom.shipments s

JOIN ecom.shipping_carriers sc
    ON s.carrier_id = sc.carrier_id

JOIN ecom.shipping_methods sm
    ON s.shipping_method_id = sm.shipping_method_id

WHERE s.delivered_at IS NOT NULL

GROUP BY
    sc.carrier_name,
    sm.method_name

ORDER BY
    late_rate DESC;
