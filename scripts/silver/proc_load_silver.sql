/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; -- Capture the start time of the procedure execution
	
	BEGIN TRY
		SET @batch_start_time = GETDATE(); -- Record the start time of the entire data loading process

		-- 1. Clean and Standardize customer information from CRM system and insert it into the silver layer
		PRINT'==================================================================================================================================================';
		PRINT 'Loading Data Into Silver Tables...';
		PRINT'==================================================================================================================================================';

		PRINT'---------------------------------------------------------------------------------------------------------------------------------------------------';
		PRINT '1. Cleaning and Standardizing customer information from CRM system and inserting it into silver layer...';
		PRINT'---------------------------------------------------------------------------------------------------------------------------------------------------';

		-- Inser cleaned and standardized customer information from the bronze layer into the silver layer.

		SET @start_time = GETDATE(); -- Record the start time of the data loading process

		PRINT '>> Truncating silver.crm_cust_info...';
		TRUNCATE TABLE silver.crm_cust_info;  -- Clear the silver table before inserting cleaned data
		PRINT '>> Inserting cleaned and standardized customer information into silver.crm_cust_info...';

		INSERT INTO silver.crm_cust_info (
			cust_id, 
			cust_key, 
			cust_firstname, 
			cust_lastname, 
			cust_marital_status, 
			cust_gender, 
			cust_create_date
		)

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

		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------------------------------------------------------------------';



		-- Clean and standardize product information from the bronze layer and insert it into the silver layer.

		SET @start_time = GETDATE(); -- Record the start time of the data loading process

		PRINT '>> Truncating silver.crm_prd_info...';
		TRUNCATE TABLE silver.crm_prd_info;  -- Clear the silver table before inserting cleaned data
		PRINT '>> Inserting cleaned and standardized product information into silver.crm_prd_info...';

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

			SET @end_time = GETDATE(); -- Record the end time of the data loading process
			PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
			PRINT '--------------------------------------------------------------------------------------------------------';



		-- Clean and Standardize crm_sales_details and insert it into the silver layer

		SET @start_time = GETDATE(); -- Record the start time of the data loading process

		PRINT '>> Truncating silver.crm_sales_details...';
		TRUNCATE TABLE silver.crm_sales_details;  -- Clear the silver table before inserting cleaned data
		PRINT '>> Inserting cleaned and standardized crm_sales_details into silver.crm_sales_details...';

		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
				CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE 
				WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price) 
					THEN sls_quantity * ABS(sls_price)
				 ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE 
				WHEN sls_price IS NULL OR sls_price <=0 
					THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price
			END AS sls_price
		  FROM bronze.crm_sales_details;

		  SET @end_time = GETDATE(); -- Record the end time of the data loading process
		  PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		  PRINT '--------------------------------------------------------------------------------------------------------';


		-- 2. Clean and Standardize customer information from the ERP system and insert it into the silver layer
		PRINT'==================================================================================================================================================';
		PRINT '2. Cleaning and Standardizing customer information from ERP system and inserting it into silver layer...';
		PRINT'==================================================================================================================================================';
		
		SET @start_time = GETDATE(); -- Record the start time of the data loading process
		
		PRINT '>> Truncating silver.erp_cust_az12...';
		TRUNCATE TABLE silver.erp_cust_az12;  -- Clear the silver table before inserting cleaned data
		PRINT '>> Inserting cleaned and standardized customer information from ERP system into silver.erp_cust_az12...';
		
		INSERT INTO silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)
		SELECT
			CASE 
				WHEN cid LIKE 'NAS%' 
					THEN SUBSTRING (cid, 4, LEN(cid)) 
				ELSE cid 
			END AS cid,								-- Remove 'NAS' prefix from cid if it exists
			CASE 
				WHEN bdate > GETDATE()
					THEN NULL
				ELSE bdate
			END AS bdate,							-- set future birthdates to NULL
			CASE 
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'Unknown'
			END AS gen							    -- Standardize gender values
		FROM bronze.erp_cust_az12;

		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------------------------------------------------------------------';


		-- Clean and Standardize erp_loc_a101 and insert it into the silver layer

		SET @start_time = GETDATE(); -- Record the start time of the data loading process

		PRINT '>> Truncating silver.erp_loc_a101...';
		TRUNCATE TABLE silver.erp_loc_a101;  -- Clear the silver table before inserting cleaned data
		PRINT '>> Inserting cleaned and standardized location information from ERP system into silver.erp_loc_a101...';

		INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		)

		SELECT
			REPLACE(cid, '-', '') AS cid,  -- Remove dashes from cid
			CASE 
				WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(cntry) IN ('DE', 'DEU') THEN 'Germany'
				WHEN TRIM(cntry) = '' OR TRIM(cntry) IS NULL THEN 'Unknown'
				ELSE TRIM(cntry)  
			END AS cntry                         -- Standardize country values
		FROM bronze.erp_loc_a101;

		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------------------------------------------------------------------';


		-- Clean and Standardize erp_cust_az12 and insert it into the silver layer

		SET @start_time = GETDATE(); -- Record the start time of the data loading process

		PRINT '>> Truncating silver.erp_px_cat_g1v2...';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;  -- Clear the silver table before inserting cleaned data
		PRINT '>> Inserting cleaned and standardized product category information from ERP system into silver.erp_px_cat_g1v2...';

		INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT 
			id,
			cat,
			subcat,
			maintenance
		  FROM bronze.erp_px_cat_g1v2;

		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '--------------------------------------------------------------------------------------------------------';


	SET @batch_end_time = GETDATE(); -- Record the end time of the entire data loading process
	PRINT '=====================================================================================================================';
		PRINT 'Data loading process completed.';
				PRINT 'Silver layer total execution time: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds.';
	PRINT '=====================================================================================================================';


	END TRY

	BEGIN CATCH
		PRINT '=====================================================================================================================';
		PRINT 'An error occurred while loading data into silver tables.';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=====================================================================================================================';
	END CATCH
END
