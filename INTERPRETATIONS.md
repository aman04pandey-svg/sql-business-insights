# Business Interpretations

This document explains the business purpose, key findings, and next analytical questions for each SQL query in the project.

---

## Q1. Daily Business Summary

### What the query does
Compares today's business performance with the previous day and the same day in the previous week. It calculates revenue, orders, AOV, payment/order rates, refunds, and revenue changes.

### Key business finding
The query helps identify whether daily revenue and order performance is improving or declining compared with recent periods.

### What I would investigate next
I would investigate the main drivers behind significant revenue changes, such as order volume, average order value, cancellations, refunds, or changes in customer behavior.

---

## Q2. Monthly Signup Cohort Retention

### What the query does
Groups customers by their signup month and measures how many customers remain active in subsequent months.

### Key business finding
The cohort analysis shows how customer retention changes over time and allows comparison of customer quality across signup periods.

### What I would investigate next
I would investigate why some signup cohorts retain better than others and compare retention by acquisition channel, customer segment, or first-order behavior.

---

## Q3. Funnel Conversion by Acquisition Channel

### What the query does
Measures the customer journey from website session to product view, add-to-cart, checkout, and purchase for each acquisition channel.

### Key business finding
The analysis identifies which acquisition channels generate the strongest conversion performance and where users are dropping out of the funnel.

### What I would investigate next
I would investigate the largest conversion drop-off for each channel and determine whether the issue is related to traffic quality, product experience, checkout friction, or payment problems.

---

## Q4. Top Products by Net Revenue

### What the query does
Calculates product-level gross revenue, orders, units sold, returns, refunds, and net revenue after allocating order-level refunds proportionally across products.

### Key business finding
The analysis identifies products that generate the highest net revenue after considering refund impact rather than looking only at gross sales.

### What I would investigate next
I would investigate whether high-refund products have specific categories, variants, return reasons, or customer segments associated with them.

---

## Q5. Category Health

### What the query does
Compares product categories based on orders, units sold, revenue, returns, and return rate.

### Key business finding
The analysis highlights categories that generate strong revenue as well as categories where return rates may indicate product or customer-experience issues.

### What I would investigate next
I would investigate categories with unusually high return rates and identify the products and return reasons responsible for the problem.

---

## Q6. Payment Failure Analysis

### What the query does
Analyzes payment attempts and failures by payment method and failure reason.

### Key business finding
The analysis identifies payment methods and failure reasons that contribute most to unsuccessful transactions.

### What I would investigate next
I would investigate whether payment failures are concentrated among particular methods, error codes, customer segments, or time periods.

---

## Q7. Delivery SLA Breach

### What the query does
Measures delivery performance by comparing shipped and delivered dates and identifies deliveries taking more than five days.

### Key business finding
The analysis identifies late deliveries and helps compare delivery performance across shipping carriers and methods.

### What I would investigate next
I would investigate which carriers, shipping methods, or regions have the highest SLA breach rates and whether delays are concentrated during particular periods.

---

## Q8. Customer LTV Buckets

### What the query does
Calculates customer lifetime value and groups customers into different LTV buckets.

### Key business finding
The analysis identifies the customer segments contributing the most lifetime revenue and helps understand the distribution of customer value.

### What I would investigate next
I would investigate which acquisition channels and customer behaviors are associated with high-LTV customers.

---

## Q9. Repeat Purchase Interval

### What the query does
Measures the time between consecutive purchases for customers who purchase more than once.

### Key business finding
The analysis helps understand how frequently customers return and identifies typical repeat-purchase intervals.

### What I would investigate next
I would investigate whether repeat purchase frequency differs by product category, acquisition channel, or customer segment.

---

## Q10. First and Last Touch Attribution

### What the query does
Attributes customer revenue to marketing channels using first-touch and last-touch attribution models.

### Key business finding
The analysis shows how the perceived contribution of acquisition channels changes depending on the attribution model used.

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
