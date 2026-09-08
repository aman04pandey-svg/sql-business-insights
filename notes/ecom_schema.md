# E-commerce Schema Notes

## 1. Overview

This project uses a PostgreSQL e-commerce database under the `ecom` schema.

The database supports analysis across:

- Customers and orders
- Products, variants and categories
- Website sessions and conversion funnel
- Payments and payment failures
- Returns and refunds
- Shipping and delivery performance
- Marketing attribution

The analysis is designed around business questions rather than individual tables, so multiple related tables are often joined to calculate a final KPI.

---

## 2. Core Table Inventory

| Table | Business Purpose | Key Columns Used |
|---|---|---|
| `customers` | Customer master data | `customer_id`, signup/created date |
| `orders` | Customer order transactions | `order_id`, `customer_id`, `created_at`, `status`, `payment_status`, `total` |
| `order_items` | Individual products within orders | `order_id`, `variant_id`, `qty`, `unit_price`, `line_discount`, `line_total` |
| `product_variants` | Product variant mapping | `variant_id`, `product_id` |
| `products` | Product master data | `product_id`, `product_name`, `category_id` |
| `categories` | Product category hierarchy | `category_id`, `category_name`, `parent_id` |
| `return_items` | Returned product items | `return_id`, `variant_id`, `qty`, `reason_id` |
| `order_refunds` | Order-level refund transactions | `order_id`, `refund_amount` |
| `sessions` | Customer website sessions | `session_id`, `customer_id` |
| `session_channels` | Acquisition channel for sessions | `session_id`, `channel` |
| `session_events` | Events within a session | `session_id`, `event_type` |
| `attribution_touches` | Marketing attribution touchpoints | `session_id`, `channel`, `touched_at` |
| `payment_intents` | Payment intent records | `payment_intent_id`, `payment_method_id` |
| `payment_transactions` | Payment attempts and outcomes | `txn_id`, `payment_intent_id`, `status`, `error_code`, `error_message` |
| `payment_methods` | Payment method master data | `payment_method_id`, `method_name` |
| `shipments` | Shipment and delivery records | `carrier_id`, `shipping_method_id`, `shipped_at`, `delivered_at` |
| `shipping_carriers` | Carrier master data | `carrier_id`, `carrier_name` |
| `shipping_methods` | Shipping method master data | `shipping_method_id`, `method_name` |

---

## 3. Verified Relationships

### Customer → Orders

```text
customers
   |
   └── orders
         customer_id


Orders → Order Items
orders
   |
   └── order_items
         order_id

One order can contain multiple order items.

This is important because joining order-level data directly to order items can multiply order-level amounts.

Order Items → Products
order_items
   |
   └── product_variants
          |
          └── products

order_items.variant_id maps to product_variants.variant_id, which maps the purchased variant to a product.

Products → Categories
categories
   |
   └── products
          |
          └── product_variants

Products are associated with categories through category_id.

Orders → Refunds
orders
   |
   └── order_refunds
         order_id

Refunds are stored at the order level.

Therefore, an order-level refund should NOT be directly joined to every product row when calculating product-level refunds.

For Q4, refunds were allocated proportionally based on each product's share of the order revenue to avoid double counting.

Sessions → Funnel
sessions
   |
   ├── session_channels
   |
   └── session_events

Session channels identify acquisition sources, while session events track funnel behaviour such as:

product_view
add_to_cart
begin_checkout
purchase

Q3 uses these tables to calculate channel-level funnel conversion.

Sessions → Attribution
sessions
   |
   └── attribution_touches

Attribution touches contain channel and timestamp information used to calculate first-touch and last-touch attribution.

Orders → Payments
orders
   |
   └── payment_intents
          |
          └── payment_transactions
                 |
                 └── payment_methods

Payment transactions contain individual payment attempts and their status/error information.

Q6 uses this relationship to calculate payment failure rates and identify the most common failure reason by payment method.

Shipments → Carriers / Shipping Methods
shipments
   |
   ├── shipping_carriers
   |
   └── shipping_methods

Shipment dates are used to calculate delivery time and identify deliveries that exceed the 5-day SLA.

4. Important Data Findings
4.1 Order Status vs Payment Status

orders.status and orders.payment_status represent different business concepts.

status represents the order/fulfillment state.
payment_status represents the payment state.

For paid-order revenue analysis, payment_status = 'paid' should be used rather than treating the order status as a payment indicator.

4.2 Order-Level Refund Double Counting

order_refunds.refund_amount is an order-level value.

If an order contains multiple products and the refund table is joined directly to order_items, the same refund can be repeated for every product.

The Q4 analysis therefore allocates the order refund proportionally to each product's contribution to the order value.

The allocated refund total was validated against the source refund total.

4.3 Funnel Metrics Use Session-Level Counts

Funnel conversion is calculated using distinct sessions rather than raw event counts.

This prevents multiple events from the same session from artificially increasing the number of users/sessions at a funnel stage.

The expected funnel relationship is:

Sessions
   >= Product Views
   >= Add to Cart
   >= Checkout
   >= Purchase
4.4 Delivery SLA

The delivery SLA analysis uses:

delivery_days = delivered_at::date - shipped_at::date

A delivery taking more than 5 days is classified as a late delivery.

Shipments that have not yet been delivered are excluded from the delivered-order performance calculations.

5. Analytical Grain

Different tables operate at different levels of detail.

Analysis	Grain
Orders	One row per order
Order Items	One row per product line/item within an order
Sessions	One row per customer session
Session Events	One row per session event
Payment Transactions	One row per payment attempt
Shipments	One row per shipment
Attribution	One row per attribution touch

Understanding the grain before joining tables is essential to prevent duplicate counting and incorrect KPIs.

6. Data Quality Principles Used

The project applies the following checks:

Avoid duplicate counting when joining tables with different grains.
Use COUNT(DISTINCT ...) where the business metric requires unique entities.
Use COALESCE() for missing related records.
Use NULLIF() to avoid division-by-zero errors.
Validate percentages and rates against expected ranges.
Cross-check important revenue/refund totals against source-level totals.
Separate payment status from order/fulfillment status.
Exclude incomplete shipment records from delivery performance calculations.
7. Key Analytical Learning

The main lesson from schema exploration is that correct SQL is not only about syntax.

Before writing a query, the analyst should understand:

What business question is being answered?
What is the grain of each table?
Which table contains the metric?
Which table contains the required dimensions?
Can a JOIN multiply rows?
Should the metric use COUNT, COUNT(DISTINCT ...), SUM, or another aggregation?
What validation check proves the result is reliable?

This schema understanding was used throughout the 10-query business analysis project.


