-- ==========================================================
-- Q6: Payment Failure Analysis
-- ==========================================================
-- Business Question:
-- Which payment methods fail most, and what is the top reason?
--
-- Output:
-- payment_method,
-- attempts,
-- failures,
-- failure_rate,
-- top_error_code,
-- top_error_message,
-- top_error_share_of_failures
--
-- Approach:
-- 1. Calculate attempts, failures and failure rate
--    for each payment method.
-- 2. Rank error codes within each payment method.
-- 3. Keep the top error using ROW_NUMBER() and rn = 1.
--
-- Grain:
-- One row per payment method.
-- ==========================================================

WITH method_stats AS (

    SELECT
        pm.method_name AS payment_method,

        COUNT(pt.txn_id) AS attempts,

        COUNT(
            CASE
                WHEN pt.status = 'failed' THEN 1
            END
        ) AS failures,

        COUNT(
            CASE
                WHEN pt.status = 'failed' THEN 1
            END
        ) * 1.0
        / NULLIF(COUNT(pt.txn_id), 0) AS failure_rate

    FROM ecom.payment_transactions pt

    JOIN ecom.payment_intents pi
        ON pt.payment_intent_id = pi.payment_intent_id

    JOIN ecom.payment_methods pm
        ON pi.payment_method_id = pm.payment_method_id

    GROUP BY
        pm.method_name

),

error_rank AS (

    SELECT
        pm.method_name AS payment_method,

        pt.error_code,

        pt.error_message,

        COUNT(*) AS error_count,

        ROW_NUMBER() OVER (
            PARTITION BY pm.method_name
            ORDER BY COUNT(*) DESC
        ) AS rn

    FROM ecom.payment_transactions pt

    JOIN ecom.payment_intents pi
        ON pt.payment_intent_id = pi.payment_intent_id

    JOIN ecom.payment_methods pm
        ON pi.payment_method_id = pm.payment_method_id

    WHERE pt.status = 'failed'

    GROUP BY
        pm.method_name,
        pt.error_code,
        pt.error_message

)

SELECT
    ms.payment_method,
    ms.attempts,
    ms.failures,
    ms.failure_rate,

    er.error_code AS top_error_code,
    er.error_message AS top_error_message,

    er.error_count * 1.0
    / NULLIF(ms.failures, 0)
        AS top_error_share_of_failures

FROM method_stats ms

LEFT JOIN error_rank er
    ON ms.payment_method = er.payment_method
    AND er.rn = 1

ORDER BY
    ms.failure_rate DESC;
