/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), AGE(), COUNT(), GROUP BY, ORDER BY
===============================================================================
*/
-- Determine the first and last transaction date
-- and the total duration of the transaction data
SELECT
    MIN(transaction_date) AS first_transaction_date,
    MAX(transaction_date) AS last_transaction_date,
    AGE(MAX(transaction_date), MIN(transaction_date)) AS transaction_duration
FROM 
	fact_transactions;



-- Determine the first and last date in the dim_date table
-- And pre and post tariff hike periods
SELECT
    hike_period_label,
    MIN(full_date) AS period_start,
    MAX(full_date) AS period_end,
    COUNT(*) AS number_of_days
FROM dim_date
GROUP BY hike_period_label
ORDER BY period_start;

