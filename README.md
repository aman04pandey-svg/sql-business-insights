# SQL Business Insights

A business-focused e-commerce analytics project built using PostgreSQL and SQL.

The project focuses on converting raw e-commerce data into meaningful business insights across revenue, customers, products, payments, deliveries, returns, and marketing attribution.

---

## Executive Summary

| Area | Analysis |
|---|---|
| Business Performance | Daily revenue, orders, AOV and payment metrics |
| Customer Analytics | Cohort retention, LTV and repeat purchase behavior |
| Product Analytics | Product revenue, refunds, returns and category performance |
| Funnel Analytics | Conversion performance by acquisition channel |
| Payment Analytics | Payment failures and error analysis |
| Operations Analytics | Delivery SLA performance by carrier and shipping method |
| Marketing Analytics | First-touch vs last-touch attribution |

---

## Business Objectives

The objective of this project is to answer practical business questions using SQL and convert analytical results into actionable insights.

The analysis is designed for stakeholders such as:

- Business & Finance Teams
- Product Teams
- Category Managers
- Payments Teams
- Operations Teams
- CRM & Marketing Teams

---

## Key Business Questions

### 1. Daily Business Summary

How is the business performing today compared with the previous day and the same day last week?

[View SQL Query](queries/01_daily_business_summary.sql)

### 2. Monthly Signup Cohort Retention

How well do different customer signup cohorts retain over time?

[View SQL Query](queries/02_monthly_signup_cohort_retention.sql)

### 3. Funnel Conversion by Acquisition Channel

Which acquisition channels generate the strongest movement through the product funnel?

[View SQL Query](queries/03_funnel_conversion_by_acquisition.sql)

### 4. Top Products by Net Revenue

Which products generate the highest net revenue after accounting for refunds?

[View SQL Query](queries/04_top_products_by_net_revenue.sql)

### 5. Category Health: Purchases → Returns

Which categories generate the most revenue and which have relatively high return rates?

[View SQL Query](queries/05_category_health.sql)

### 6. Payment Failure Analysis

Which payment methods experience the highest failure rates and what are the major failure reasons?

[View SQL Query](queries/06_payment_failure_analysis.sql)

### 7. Delivery SLA Breach

Which carriers and shipping methods are failing to meet the 5-day delivery SLA?

[View SQL Query](queries/07_delivery_sla_breach.sql)

### 8. Customer LTV & Revenue Bucket Share

Which customer LTV segments contribute the largest share of total revenue?

[View SQL Query](queries/08_customer_ltv_bucket.sql)

### 9. Repeat Purchase Interval

How long do customers typically take to make their next purchase?

[View SQL Query](queries/09_repeat_purchase_interval.sql)

### 10. First-Touch vs Last-Touch Attribution

How does channel performance change when comparing first-touch and last-touch attribution?

[View SQL Query](queries/10_first_last_touch_attribution.sql)

---

## SQL Concepts Used

This project demonstrates practical SQL techniques used in business analytics:

- SELECT and filtering
- INNER JOIN
- LEFT JOIN
- CTEs
- GROUP BY
- HAVING
- Aggregate Functions
- CASE WHEN
- Conditional Aggregation
- Window Functions
- PARTITION BY
- ROW_NUMBER()
- RANK()
- LEAD()
- LAG()
- PERCENTILE_CONT()
- COALESCE()
- NULLIF()
- UNION ALL
- Date Arithmetic
- Revenue Calculations
- Rate and Percentage Calculations
- Top-N Analysis
- Customer Segmentation
- Cohort Analysis
- Funnel Analysis
- Marketing Attribution

---

## Business Thinking

The main objective of this project is not only to write SQL queries, but to understand the business problem behind the data.

For every analysis, the approach focuses on:

1. Understanding the business question
2. Identifying the correct data grain
3. Understanding table relationships
4. Choosing the correct metric definition
5. Avoiding duplicate counting caused by joins
6. Validating the analytical result
7. Converting SQL output into a business insight
8. Identifying the next question that should be investigated

---

## Data Quality & Validation

Data validation is an important part of the project.

Examples of validation performed include:

- Cross-checking revenue against source transaction data
- Validating percentage calculations
- Checking for duplicate counting caused by joins
- Handling NULL values using `COALESCE`
- Preventing division-by-zero using `NULLIF`
- Validating refund allocation against total refund amounts
- Checking whether calculated rates remain within expected ranges
- Using the correct payment-status field for paid-order analysis

For example, order-level refunds were proportionally allocated to products to avoid double-counting when an order contained multiple products.

---

## Key Analytical Learning

This project helped strengthen the ability to think beyond SQL syntax.

The key learning areas include:

- Understanding data grain
- Understanding primary and foreign-key relationships
- Identifying how joins can multiply rows
- Defining business metrics correctly
- Building reusable CTE-based analyses
- Using window functions for analytical problems
- Validating results before presenting them
- Translating SQL results into business recommendations

---

## Project Structure

```text
sql-business-insights/
│
├── notes/
│   └── ecom_schema.md
│
├── queries/
│   ├── 01_daily_business_summary.sql
│   ├── 02_monthly_signup_cohort_retention.sql
│   ├── 03_funnel_conversion_by_acquisition.sql
│   ├── 04_top_products_by_net_revenue.sql
│   ├── 05_category_health.sql
│   ├── 06_payment_failure_analysis.sql
│   ├── 07_delivery_sla_breach.sql
│   ├── 08_customer_ltv_bucket.sql
│   ├── 09_repeat_purchase_interval.sql
│   └── 10_first_last_touch_attribution.sql
│
└──README.md
``` 

## Documentation

### Schema Documentation

The `notes/ecom_schema.md` file documents the main e-commerce tables, relationships, important columns and data observations.

[View Schema Notes](notes/ecom_schema.md)

### Business Interpretations

The `INTERPRETATIONS.md` file explains the business purpose, key findings and next analytical questions for each SQL analysis.

[View Business Interpretations](INTERPRETATIONS.md)


## Tools & Technologies

- PostgreSQL
- SQL
- Metabase
- GitHub

---

## Author

**Aman Pandey**


