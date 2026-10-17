/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
	- To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for all tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Retrieve a list of all tables in the database
SELECT
	TABLE_CATALOG,
	TABLE_SCHEMA,
	TABLE_NAME,
	TABLE_TYPE
FROM
	INFORMATION_SCHEMA.TABLES
WHERE
	TABLE_SCHEMA = 'public';


-- Retrieve all columns for a every table in the database
SELECT
	TABLE_NAME,
	COLUMN_NAME,
	DATA_TYPE,
	IS_NULLABLE
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_SCHEMA = 'public'
ORDER BY
	TABLE_NAME,
	ORDINAL_POSITION;



