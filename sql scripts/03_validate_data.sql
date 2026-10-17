-- 1. How many customers?
SELECT
	COUNT(*) AS customer_count
FROM
	dim_customers;


-- 2. How many transactions?
SELECT
	COUNT(*) AS transaction_count
FROM
	fact_transactions;


-- 3. What plans exist?
SELECT
	plan_id,
	plan_code,
	plan_name,
	frequency AS validity,
	data_gb_pre,
	data_gb_post,
	price_pre,
	price_post
FROM
	dim_plans;
-- 4. What service types exist?
SELECT
	service_type_id,
	service_type_name,
	service_category
FROM
	dim_service_types
ORDER BY
	service_type_id;
