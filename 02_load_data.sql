/*
===============================================================================
MTN PRICE HIKE ANALYTICS
02_load_data.sql
===============================================================================

Purpose:
    Load all CSV source files into the MTN Price Hike Analytics database.

Database:
    mtn_price_hike

Execution:
    Run this script using psql.

    Example:
    psql -U postgres -p 5433 -d mtn_price_hike -f 02_load_data.sql

Important:
    - \copy is a psql client-side command.
    - Tables must already exist before running this script.
    - Load order respects table dependencies.
    - The entire load runs inside one transaction.

===============================================================================
*/

BEGIN;


/*
===============================================================================
1. LOAD SERVICE TYPES
===============================================================================
*/

\copy dim_service_types FROM 'C:\Users\hp\Documents\Data Analysis Projects\MTN Analytics\mtn_price_hike_project V2 (15GB weekly revised)\mtn_price_hike_project V2 (15GB weekly revised)\data\dim_service_types.csv' WITH (FORMAT csv, HEADER true);


/*
===============================================================================
2. LOAD PLANS
===============================================================================
*/

\copy dim_plans FROM 'C:\Users\hp\Documents\Data Analysis Projects\MTN Analytics\mtn_price_hike_project V2 (15GB weekly revised)\mtn_price_hike_project V2 (15GB weekly revised)\data\dim_plans.csv' WITH (FORMAT csv, HEADER true);


/*
===============================================================================
3. LOAD CUSTOMERS
===============================================================================
*/

\copy dim_customers FROM 'C:\Users\hp\Documents\Data Analysis Projects\MTN Analytics\mtn_price_hike_project V2 (15GB weekly revised)\mtn_price_hike_project V2 (15GB weekly revised)\data\dim_customers.csv' WITH (FORMAT csv, HEADER true);


/*
===============================================================================
4. LOAD DATE DIMENSION
===============================================================================
*/

\copy dim_date FROM 'C:\Users\hp\Documents\Data Analysis Projects\MTN Analytics\mtn_price_hike_project V2 (15GB weekly revised)\mtn_price_hike_project V2 (15GB weekly revised)\data\dim_date.csv' WITH (FORMAT csv, HEADER true);


/*
===============================================================================
5. LOAD SUBSCRIPTIONS
===============================================================================
*/

\copy fact_subscriptions FROM 'C:\Users\hp\Documents\Data Analysis Projects\MTN Analytics\mtn_price_hike_project V2 (15GB weekly revised)\mtn_price_hike_project V2 (15GB weekly revised)\data\fact_subscriptions.csv' WITH (FORMAT csv, HEADER true);


/*
===============================================================================
6. LOAD TRANSACTIONS
===============================================================================
*/

\copy fact_transactions FROM 'C:\Users\hp\Documents\Data Analysis Projects\MTN Analytics\mtn_price_hike_project V2 (15GB weekly revised)\mtn_price_hike_project V2 (15GB weekly revised)\data\fact_transactions.csv' WITH (FORMAT csv, HEADER true);


/*
===============================================================================
7. COMMIT
===============================================================================
*/

COMMIT;


/*
===============================================================================
8. VERIFY ROW COUNTS
===============================================================================
*/

SELECT 'dim_service_types' AS table_name, COUNT(*) AS row_count
FROM dim_service_types

UNION ALL

SELECT 'dim_plans', COUNT(*)
FROM dim_plans

UNION ALL

SELECT 'dim_customers', COUNT(*)
FROM dim_customers

UNION ALL

SELECT 'dim_date', COUNT(*)
FROM dim_date

UNION ALL

SELECT 'fact_subscriptions', COUNT(*)
FROM fact_subscriptions

UNION ALL

SELECT 'fact_transactions', COUNT(*)
FROM fact_transactions

ORDER BY table_name;