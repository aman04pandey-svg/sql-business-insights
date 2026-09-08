# Business Interpretations

This document explains the business purpose, key findings, and next analytical questions for each SQL query in the project.

---

## Q1. Daily Business Summary

### What the query does
Compares today's business performance with the previous day and the same day in the previous week. It calculates revenue, orders, AOV, payment/order rates, refunds, and revenue changes.

### Key business finding
On June 14, 2026, revenue was ₹370,320 from 75 orders, with an AOV of ₹4,937.60. Revenue declined by approximately 74% compared with the previous day and 79% compared with the same day in the previous week, indicating a significant short-term drop in business performance.

### What I would investigate next
I would investigate the main drivers behind significant revenue changes, such as order volume, average order value, cancellations, refunds, or changes in customer behavior.

---

## Q2. Monthly Signup Cohort Retention

### What the query does
Groups customers by their signup month and measures how many customers remain active in subsequent months.

### Key business finding
The March 2026 cohort shows the strongest observed retention, with 51.74% of customers retained in Month 1, 44.29% in Month 2, and 20.07% in Month 3. Retention declines across subsequent months, indicating that customer engagement drops over time. The April and May cohorts also show a decline from Month 1 to Month 2, while the latest cohorts have not yet matured enough to evaluate later-month retention.

### What I would investigate next
I would investigate why retention drops after the first month by analyzing repeat purchase behavior, acquisition channels, product categories, customer segments, and the first-purchase experience. I would also compare retention across cohorts once the newer cohorts have enough time to mature.

---

## Q3. Funnel Conversion by Acquisition Channel

### What the query does
Measures the customer journey from website session to product view, add-to-cart, checkout, and purchase for each acquisition channel.

### Key business finding
Organic has the highest traffic volume with 19,539 sessions and 5,491 purchases, while Email has the strongest session-to-purchase conversion at 29%. Overall funnel performance is relatively consistent across channels, with view-to-cart conversion around 40–41%, cart-to-checkout around 81%, and checkout-to-purchase around 85–87%. This suggests that the major opportunity is not the lower funnel but improving the conversion of visitors into cart additions.

### What I would investigate next
Compare traffic quality, customer intent and campaign performance across channels to understand why Organic generates the most volume while Email converts slightly better.

---

## Q4. Top Products by Net Revenue

### What the query does
Calculates product-level gross revenue, orders, units sold, returns, refunds, and net revenue after allocating order-level refunds proportionally across products.

### Key business finding
Eastlight Clarity ANC Headphones is the top product by net revenue at ₹921,478.88 from ₹922,243 gross revenue. Marigold Home Craft Lite Wireless Earbuds generated ₹909,374.06 net revenue but had ₹10,388.94 in refunds and a 3.23% return rate. This shows that high gross revenue does not necessarily translate into the highest net revenue when refunds and returns are considered.

### What I would investigate next
Identify products with high revenue but disproportionately high refunds or return rates to find potential product-quality, pricing or customer-experience issues.

---

## Q5. Category Health

### What the query does
Compares product categories based on orders, units sold, revenue, returns, and return rate.

### Key business finding
Smartwatch generates the highest category revenue at ₹59.74M with 6,874 units sold and a relatively low return rate of 2.53%. Shoes have the highest return rate at 2.91%, while Headphones also show a relatively higher return rate of 2.68%. This suggests that return behavior should be investigated separately from revenue performance to identify categories with potential product or customer-experience issues.

### What I would investigate next
I would investigate return reasons by category, product, and customer segment to understand why some categories have higher return rates. I would also compare return rates with product ratings, order channels, and individual SKUs to identify specific products driving category-level returns.

---

## Q6. Payment Failure Analysis

### What the query does
Analyzes payment attempts and failures by payment method and failure reason.

### Key business finding
UPI recorded the highest number of payment attempts (12,835) and 711 failures, with a 5.5% failure rate. Card had the largest absolute number of failures at 592 and a 4.2% failure rate. The leading failure reasons include Gateway Timeout for UPI and Bank Decline for Wallet/Netbanking, while Card's top error was Fraud. The error categories account for different shares of total failures, indicating that payment reliability issues have multiple underlying causes.

### What I would investigate next
I would investigate payment failures by gateway, error code, time period, and transaction volume to identify whether failures are caused by technical issues, bank declines, fraud controls, or specific payment providers. I would also monitor UPI gateway timeouts and card fraud failures separately because they represent different operational problems.

---

## Q7. Delivery SLA Breach

### What the query does
Measures delivery performance by comparing shipped and delivered dates and identifies deliveries taking more than five days.

### Key business finding
EcomExpress has the highest late-delivery rates among the displayed carrier-method combinations: 21% for Express and 20% for Same Day. In comparison, EcomExpress Standard has a 10% late rate, while Delhivery Same Day has the lowest displayed late rate at 7.1%. EcomExpress Express also has the highest average delivery time at 4.14 days, indicating a significant delivery-performance gap for this service.

### What I would investigate next
Compare carrier performance by region, service type and order volume to determine whether the higher late rate is concentrated in specific locations or operational conditions.

---

## Q8. Customer LTV Buckets

### What the query does
Calculates customer lifetime value and groups customers into different LTV buckets.

### Key business finding
Customer revenue is highly concentrated among high-LTV customers. The ₹20,000+ LTV segment contains 3,349 customers, representing approximately 40% of the 8,438 customers, but contributes ₹249.99M, or 88.38% of total revenue. In contrast, customers with LTV below ₹5,000 represent around 30% of customers but contribute only about 2.09% of revenue.

### What I would investigate next
Investigate what drives customers into the ₹20,000+ LTV segment, including repeat purchase frequency, acquisition channel, product/category mix and customer tenure. These high-value customers should also be evaluated for retention risk because a small deterioration in this segment could have a significant impact on total revenue.

---

## Q9. Repeat Purchase Interval

### What the query does
Measures the time between consecutive purchases for customers who purchase more than once.

### Key business finding
The analysis shows that repeat customers place their next order after an average of 10.36 days, with a median interval of 6 days and a 90th-percentile interval of 27 days. The analysis identifies 3,443 customers with repeat orders, indicating that a substantial customer base returns for additional purchases.

### What I would investigate next
I would investigate whether repeat purchase frequency differs by product category, acquisition channel, or customer segment.

---

## Q10. First and Last Touch Attribution

### What the query does
Attributes customer revenue to marketing channels using first-touch and last-touch attribution models.

### Key business finding
Organic is the largest revenue-driving channel under both attribution models, contributing approximately 40% of revenue under first-touch and 39% under last-touch attribution. Paid contributes approximately 36% under both models, while email's contribution increases from 6.3% under first-touch to 7.2% under last-touch, suggesting a relatively stronger role closer to conversion.

### What I would investigate next
I would compare first-touch and last-touch results to identify channels that create initial awareness versus channels that are more effective at driving final conversion.

---

## Overall Analytical Learning

The main lesson from this project is that good SQL analysis is not only about writing syntactically correct queries.

A strong analyst must understand:

- The business question
- The grain of each table
- Relationships between tables
- How JOINs can multiply rows
- Which metric definition is appropriate
- How to validate the final result
- How to convert SQL output into a business decision

These principles were applied throughout the 10-query business analysis project.
