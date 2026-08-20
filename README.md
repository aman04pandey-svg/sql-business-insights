# SQL Business Insights

A SQL-based e-commerce analytics project focused on answering real-world business questions using PostgreSQL.

The project analyzes business performance across revenue, customers, products, payments, deliveries, and marketing attribution.

## Business Objectives

The goal of this project is to convert raw e-commerce data into actionable business insights for different business stakeholders such as:

- Business & Finance Teams
- Product Teams
- Category Managers
- Payments Teams
- Operations Teams
- CRM & Marketing Teams

## Key Business Questions

### 1. Daily Business Summary
Analyzes daily business performance using key revenue and order metrics.

### 2. Monthly Signup Cohort Retention
Analyzes customer retention behavior across signup cohorts.

### 3. Funnel Conversion by Acquisition Channel
Measures customer movement through the funnel and compares conversion across acquisition channels.

### 4. Top Products by Net Revenue
Identifies products generating the highest net revenue after accounting for refunds and returns.

### 5. Category Health: Purchases → Returns
Compares category-level revenue, sales volume, and return rates to identify healthy and problematic categories.

### 6. Payment Failure Analysis
Analyzes payment attempts and failures by payment method and identifies the top error reason for each method.

### 7. Delivery SLA Breach
Measures delivery performance by carrier and shipping method against the 5-day SLA.

### 8. Customer LTV & Revenue Bucket Share
Segments customers into LTV buckets and measures each bucket's contribution to total revenue.

### 9. Repeat Purchase Interval
Analyzes how long customers take to make their next purchase using repeat-order intervals.

### 10. First-Touch vs Last-Touch Attribution
Compares first-touch and last-touch marketing attribution to understand how different channels contribute to revenue.

## SQL Concepts Used

- JOINs
- LEFT JOINs
- CTEs
- GROUP BY
- CASE WHEN
- Aggregate Functions
- Window Functions
- ROW_NUMBER()
- LEAD()
- PERCENTILE_CONT()
- NULLIF()
- COALESCE()
- UNION ALL
- Date Arithmetic
- Conditional Aggregation
- Revenue & Rate Calculations
- Top-N per Group Analysis
- Customer Segmentation
- Marketing Attribution

## Business Thinking

The queries are designed not only to retrieve data, but to answer business questions and support decision-making.

Examples:

- Which products generate the most net revenue?
- Which categories have high return rates?
- Which payment methods fail most frequently?
- What are the major payment failure reasons?
- Which carriers are missing the 5-day delivery SLA?
- Which customer segments contribute the most revenue?
- How frequently do customers make repeat purchases?
- Does first-touch or last-touch attribution give a different view of channel performance?

## Project Structure

```text
sql-business-insights/
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
└── README.md

## SQL Concepts Used

- CTEs (Common Table Expressions)
- JOINs and LEFT JOINs
- GROUP BY and aggregate functions
- CASE WHEN for business segmentation
- Window Functions
- ROW_NUMBER() for top-N analysis
- LEAD() for repeat purchase analysis
- PERCENTILE_CONT() for median and P90 analysis
- Conditional aggregation
- NULL handling with COALESCE and NULLIF
- Revenue and rate calculations

## Business Insights Covered

This project answers practical e-commerce business questions such as:

- What is the overall business performance?
- Which products generate the highest net revenue after refunds?
- Which product categories have the highest return rates?
- Which payment methods have the highest failure rates?
- Which carriers and shipping methods are missing the 5-day delivery SLA?
- Which customer segments contribute the most revenue?
- How long does it take customers to make a repeat purchase?
- How does first-touch vs last-touch attribution change channel performance?

## Validation & Data Quality Checks

Each analysis includes sanity checks where applicable, such as:

- Revenue totals are cross-checked against source transaction data.
- Rates and percentages are validated to remain within expected ranges.
- Duplicate counting is avoided by aggregating data before joining CTEs.
- NULL and zero-division cases are handled using COALESCE and NULLIF.
- Delivery analysis excludes shipments that are still in transit.

## Tools

- PostgreSQL
- SQL
- Metabase
- GitHub

## Author

Aman Pandey






