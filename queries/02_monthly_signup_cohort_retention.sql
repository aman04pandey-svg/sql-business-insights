-- Q2: Monthly Signup Cohort Retention
-- Business Question:
-- For each month's new signups, how many customers returned
-- in Month 1, Month 2 and Month 3?
--
-- Owner: Aman Pandey
--
-- Sanity Check:
-- 1. Cohort Size = Total Signups in that Month
-- 2. M1, M2, M3 <= Cohort Size
-- 3. Retention % must be between 0 and 100

with customer_orders as (

    select
        c.customer_id,
        date_trunc('month', c.created_at) as cohort_month,
        date_trunc('month', o.created_at) as order_month

    from ecom.customers c

    left join ecom.orders o
        on c.customer_id = o.customer_id
       and date_trunc('month', o.created_at) >= date_trunc('month', c.created_at)

       -- Uncomment if cancelled orders should be excluded
       -- and lower(o.status) <> 'cancelled'

),

retention as (

    select

        cohort_month,

        count(distinct customer_id) as cohort_size,

        count(distinct case
            when order_month = cohort_month + interval '1 month'
            then customer_id
        end) as m1_retained,

        count(distinct case
            when order_month = cohort_month + interval '2 month'
            then customer_id
        end) as m2_retained,

        count(distinct case
            when order_month = cohort_month + interval '3 month'
            then customer_id
        end) as m3_retained

    from customer_orders

    group by cohort_month

)

select

    cohort_month,

    cohort_size,

    m1_retained,

    m2_retained,

    m3_retained,

    round(
        m1_retained * 100.0 / nullif(cohort_size,0),
        2
    ) as m1_retention_pct,

    round(
        m2_retained * 100.0 / nullif(cohort_size,0),
        2
    ) as m2_retention_pct,

    round(
        m3_retained * 100.0 / nullif(cohort_size,0),
        2
    ) as m3_retention_pct

from retention

order by cohort_month;
