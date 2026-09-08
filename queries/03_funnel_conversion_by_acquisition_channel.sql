-- Q3: Funnel Conversion by Acquisition Channel
-- Business Question:
-- Which acquisition channel loses the most users
-- at each stage of the conversion funnel?
--
-- Owner: Aman Pandey
--
-- Sanity Check:
-- 1. Funnel stages should be monotonically decreasing:
--    Sessions >= Product View >= Add to Cart >= Checkout >= Purchase
-- 2. All conversion rates should be between 0 and 1 (or 0% to 100%).

with channel_summary as (

    select

        sc.channel,

        count(distinct sc.session_id) as sessions,

        count(distinct sc.session_id)
            filter (where se.event_type = 'product_view')
            as product_view_sessions,

        count(distinct sc.session_id)
            filter (where se.event_type = 'add_to_cart')
            as add_to_cart_sessions,

        count(distinct sc.session_id)
            filter (where se.event_type = 'begin_checkout')
            as begin_checkout_sessions,

        count(distinct sc.session_id)
            filter (where se.event_type = 'purchase')
            as purchase_sessions

    from ecom.session_channels sc

    join ecom.session_events se
        on sc.session_id = se.session_id

    group by sc.channel

)

select

    channel,

    sessions,

    product_view_sessions,

    add_to_cart_sessions,

    begin_checkout_sessions,

    purchase_sessions,

    round(
        add_to_cart_sessions::decimal
        / nullif(product_view_sessions, 0),
        2
    ) as view_to_cart_rate,

    round(
        begin_checkout_sessions::decimal
        / nullif(add_to_cart_sessions, 0),
        2
    ) as cart_to_checkout_rate,

    round(
        purchase_sessions::decimal
        / nullif(begin_checkout_sessions, 0),
        2
    ) as checkout_to_purchase_rate,

    round(
        purchase_sessions::decimal
        / nullif(sessions, 0),
        2
    ) as session_to_purchase_rate

from channel_summary

order by session_to_purchase_rate desc;
