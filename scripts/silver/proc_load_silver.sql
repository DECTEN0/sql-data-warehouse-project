/*
===========================================================================================================================================================================
This SQL script performs data transformation and loading from the bronze layer to the silver layer in a data warehouse. 
It consists of two main parts:
1. The first part cleans and standardizes customer information from the 'bronze.crm_cust_info' table and inserts it into the 'silver.crm_cust_info' table. 
   - It removes duplicates and null values based on 'cust_id', keeping only the latest record for each customer.
   - It trims unwanted spaces from 'cust_firstname' and 'cust_lastname'.
   - It standardizes 'cust_marital_status'
   	 - 'M' is converted to 'Married'
	 - 'S' is converted to 'Single'
	 - Any other value is set to 'Unknown'

2. The second part cleans and standardizes product information from the 'bronze.crm_prd_info' table and inserts it into the 'silver.crm_prd_info' table.
   - It extracts 'cat_id' from the first 5 characters of 'prd_key' and replaces any '-' with '_'.
   - It standardizes 'prd_line' values:
	 - 'M' is converted to 'Mountain'
	 - 'R' is converted to 'Road'
	 - 'S' is converted to 'Other Sales'
	 - 'T' is converted to 'Touring'
	 - Any other value is set to 'Unknown'
   - It converts 'prd_start_dt' to DATE format and calculates 'prd_end_dt' as one day before the next 'prd_start_dt' for the same product key.

NOTE:
Further queries will be added to clean and standardize: 
sales details, 
customer information from the ERP system, 
location information,
product category information in a similar manner, ensuring that the data in the silver layer is consistent and ready for analysis.

It will then be converted to a stored procedure for automation and scheduled execution.
===========================================================================================================================================================================
*/

-- 1. Clean and Standardize customer information from CRM system and insert it into the silver layer

INSERT INTO silver.crm_cust_info (
	cust_id, 
	cust_key, 
	cust_firstname, 
	cust_lastname, 
	cust_marital_status, 
	cust_gender, 
	cust_create_date
)

-- Remove duplicate and nulls 
SELECT 
	cust_id, 
	cust_key, 
	TRIM(cust_firstname) AS cust_firstname,  -- Remove unwanted spaces from cust_firstname
	TRIM(cust_lastname) AS cust_lastname,    -- Remove unwanted spaces from cust_lastname

	-- Standardize marital status
	CASE 
		WHEN UPPER(TRIM(cust_marital_status)) = 'M' THEN 'Married'
		WHEN UPPER(TRIM(cust_marital_status)) = 'S' THEN 'Single'
		ELSE 'Unknown'
	END AS cust_marital_status,

	-- Standardize gender
	CASE 
		WHEN UPPER(TRIM(cust_gender)) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(cust_gender)) = 'F' THEN 'Female'
		ELSE 'Unknown'
	END AS cust_gender,

	cust_create_date
FROM 
	(
		SELECT *, ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_create_date DESC) AS rn
		FROM bronze.crm_cust_info
		WHERE cust_id IS NOT NULL
	) t  -- Alias for the subquery
WHERE rn = 1;  -- Keep only the latest record for each cust_id, removing duplicates and nulls 


-- Clean and standardize product information from the bronze layer and insert it into the silver layer.

INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)

SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,  -- Extract cat_id from prd_key and replace '-' with '_'
	SUBSTRING(prd_key, 1, LEN(prd_key)) AS prd_key,  -- Extract prd_key from the first 5 characters of prd_key
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,  -- Replace NULL prd_cost with 0
	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'Unkown'
	END AS prd_line,  -- Standardize prd_line values
	CAST(prd_start_dt AS DATE) AS prd_start_dt,  -- Convert prd_start_dt to DATE
	CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) AS prd_end_dt  -- Calculate prd_end_dt as one day before the next prd_start_dt for the same prd_key
	FROM bronze.crm_prd_info;

	-- Clean and Standardize crm_sales_details and insert it into the silver layer



	-- 2. Clean and Standardize customer information from the ERP system and insert it into the silver layer


	-- CLean and Standardize erp_cust_az12 and insert it into the silver layer


	-- Cleand and Standardize erp_loc_a101 and insert it into the silver layer


	-- Cleand and Standardize erp_px_cat_g1v2 and insert it into the silver layer
