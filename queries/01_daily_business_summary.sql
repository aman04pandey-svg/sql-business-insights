-- Q1: Daily Business Summary with DoD and Same-Weekday WoW
-- Business question:
-- "How are we doing today vs yesterday, and vs the same day last week?"
--
-- Sanity check:
-- paid_order_rate must be between 0 and 1 on every row.
-- sum(orders) must equal count(*) from ecom.orders
-- for the same analysis window.
--
-- Owner: Aman Pandey

with daily_orders as (
    select
        date(o.created_at) as order_date,
        sum(o.subtotal) as revenue,
        count(o.order_id) as orders,
        sum(o.subtotal) * 1.0 / nullif(count(o.order_id), 0) as aov,
        count(*) filter (
            where o.payment_status = 'paid'
        ) * 1.0 / nullif(count(*), 0) as paid_order_rate,
        count(*) filter (
            where lower(o.status) = 'cancelled'
        ) * 1.0 / nullif(count(*), 0) as cancelled_order_rate
    from ecom.orders o
    group by 1
),

daily_refunds as (
    select
        date(r.created_at) as order_date,
        sum(r.amount) as refunds_amount
    from ecom.refunds r
    group by 1
),

daily_summary as (
    select
        dor.order_date,
        dor.revenue,
        dor.orders,
        dor.aov,
        dor.paid_order_rate,
        dor.cancelled_order_rate,
        coalesce(dr.refunds_amount, 0) as refunds_amount
    from daily_orders dor
    left join daily_refunds dr
        on dor.order_date = dr.order_date
)

select
    order_date,
    revenue,
    orders,
    aov,
    paid_order_rate,
    cancelled_order_rate,
    refunds_amount,
    (
        revenue - lag(revenue, 1) over (order by order_date)
    ) * 1.0
    / nullif(
        lag(revenue, 1) over (order by order_date),
        0
    ) as revenue_vs_yesterday_pct,
    (
        revenue - lag(revenue, 7) over (order by order_date)
    ) * 1.0
    / nullif(
        lag(revenue, 7) over (order by order_date),
        0
    ) as revenue_vs_last_weekday_pct
from daily_summary
order by order_date desc;
