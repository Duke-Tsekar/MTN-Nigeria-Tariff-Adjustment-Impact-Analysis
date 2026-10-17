/*
===============================================================================
PROJECT: MTN NIGERIA TARIFF ADJUSTMENT IMPACT ANALYSIS
BUSINESS QUESTION 1: OVERALL IMPACT ANALYSIS
===============================================================================

BUSINESS QUESTION:
What was the overall impact of the MTN price hike on customer activity,
transaction volume, and revenue?

PURPOSE:
Compare business performance before and after the tariff adjustment
effective 11 February 2025.

ANALYSIS PERIODS:
Pre-Hike  : 01 December 2024 - 10 February 2025 (72 calendar days)
Post-Hike : 11 February 2025 - 30 April 2025 (79 calendar days)

METHODOLOGY:
1. Compare customer activity, transactions, and revenue.
2. Calculate daily, per-customer, and per-transaction metrics.
3. Calculate percentage changes between the two periods in Excel.

SQL DIALECT:
PostgreSQL

SQL FUNCTIONS USED:
Aggregate functions: COUNT(), SUM(), AVG()
Distinct counting: COUNT(DISTINCT)
Numeric Formatting: ROUND()
String functions: TO_CHAR()
Conditional logic: CASE 
Joins: Inner JOINS
Grouping and Sorting: GROUP BY, ORDER BY
Aliasing : AS
Arithmetic Operators: /
Type Casting ::NUMERIC, ::INT


KEY METRICS MEASURED:
1. Total Transactions: Total transactions recorded in each period.
2. Active Customers: Unique customers who made transactions in each period.
3. Total Revenue: Total revenue generated per period, expressed in NGN.
4. Average Transaction Value (ATV): Average revenue per transaction, expressed in NGN.
5. Revenue per Active Customer: Average revenue per active purchasing customer, expressed in NGN.
6. Average Daily Transactions: Average transactions per calendar day.
7. Average Daily Revenue: Average revenue per calendar day, expressed in NGN.

===============================================================================
*/

SELECT
    d.hike_period_label,

    -- Measure purchase activity and unique purchasing customers.
    COUNT(*) AS transaction_count,
    COUNT(DISTINCT t.customer_id) AS distinct_customers,

    -- Measure total revenue, average transaction value, and revenue per customer.
    ROUND(SUM(t.amount_ngn), 2) AS total_revenue_ngn,
    ROUND(AVG(t.amount_ngn), 2) AS avg_transaction_value_ngn,
    ROUND(
        SUM(t.amount_ngn) / COUNT(DISTINCT t.customer_id), 2
    ) AS revenue_per_active_customer_ngn,

    -- Compare daily performance across the unequal observation periods.
    ROUND(
        COUNT(*)::NUMERIC /
        CASE WHEN d.hike_period_label = 'Pre-Hike' THEN 72 ELSE 79 END,
        2
    ) AS transactions_per_day,

    ROUND(
        SUM(t.amount_ngn) /
        CASE WHEN d.hike_period_label = 'Pre-Hike' THEN 72 ELSE 79 END,
        2
    ) AS revenue_per_day_ngn

FROM fact_transactions t
-- Join the date dimension to classify transactions by tariff period (Pre and post hike)
JOIN dim_date d
    ON d.date_id = TO_CHAR(t.transaction_date, 'YYYYMMDD')::INT

-- Summarize performance separately for each tariff period.
GROUP BY d.hike_period_label
ORDER BY d.hike_period_label DESC;

/*
===============================================================================
END OF BQ1: OVERALL IMPACT ANALYSIS
===============================================================================
*/