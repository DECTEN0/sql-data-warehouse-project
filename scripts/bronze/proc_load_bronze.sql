/*
============================================================================================================================================================================
STORED PROCEDURE: bronze.load_bronze
============================================================================================================================================================================
Script Description:
					This script creates or alters the stored procedure 'bronze.load_bronze' 
					which is responsible for loading data into the bronze tables from specified CSV files. 

Purpose:
					The purpose of this stored procedure is to automate the process of loading data into the bronze tables 
					by using the BULK INSERT command to read data from CSV files and insert it into the respective tables. 
					Before loading new data, it truncates the existing data in the tables to ensure that only fresh data is present.

Parameters: 
					None

Usage Example:
					To execute the stored procedure and load data into the bronze tables, you can run the following command:
					EXEC bronze.load_bronze;

Warning:
					- Ensure that the file paths specified in the BULK INSERT commands are correct and accessible by the SQL Server instance.
					- Truncating tables will result in the loss of all existing data in those tables. Make sure to back up any important data before running this procedure.
					- The CSV files should be properly formatted and should match the schema of the respective tables for successful data loading.

============================================================================================================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; -- Capture the start time of the procedure execution

	BEGIN TRY
		SET @batch_start_time = GETDATE(); -- Record the start time of the entire data loading process
		PRINT '=======================================';
		PRINT 'Loading Data Into Bronze Tables...';
		PRINT '=======================================';

		PRINT '---------------------------------------';
		PRINT 'Loading CRM Tables...';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE(); -- Record the start time of the data loading process
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info; -- Clear existing data from the table before loading new data
	
		PRINT '>> Inserting Data Into : bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,          --skip header row
			FIELDTERMINATOR = ',', --specify comma as field delimiter
			TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
		);
		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE(); -- Record the start time of the data loading process
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info; -- Clear existing data from the table before loading new data

		PRINT '>> Inserting Data Into : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,          --skip header row
			FIELDTERMINATOR = ',', --specify comma as field delimiter
			TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
		);
		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE(); -- Record the start time of the data loading process
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details; -- Clear existing data from the table before loading new data

		PRINT '>> Inserting Data Into : bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,          --skip header row
			FIELDTERMINATOR = ',', --specify comma as field delimiter
			TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
		);
		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------';


		PRINT '---------------------------------------';
		PRINT 'Loading ERP tables...';
		PRINT '---------------------------------------';


		SET @start_time = GETDATE(); -- Record the start time of the data loading process
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12; -- Clear existing data from the table before loading new data

		PRINT '>> Inserting Data Into : bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,          --skip header row
			FIELDTERMINATOR = ',', --specify comma as field delimiter
			TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
		);
		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------';


		SET @start_time = GETDATE(); -- Record the start time of the data loading process
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101; -- Clear existing data from the table before loading new data

		PRINT '>> Inserting Data Into : bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,          --skip header row
			FIELDTERMINATOR = ',', --specify comma as field delimiter
			TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
		);
		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------';

		SET @start_time = GETDATE(); -- Record the start time of the data loading process
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2; -- Clear existing data from the table before loading new data
	
		PRINT '>> Inserting Data Into : bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,          --skip header row
			FIELDTERMINATOR = ',', --specify comma as field delimiter
			TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
		);
		SET @end_time = GETDATE(); -- Record the end time of the data loading process
		PRINT '>> Data Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------';

		SET @batch_end_time = GETDATE(); -- Record the end time of the entire data loading process
		PRINT '=======================================';
		PRINT 'Bronze Layer Data Loading Completed Successfully!';
		PRINT 'Bronze Layer Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=======================================';
	END TRY
	BEGIN CATCH
		PRINT '=======================================';
		PRINT 'An error occurred while loading data into bronze tables.';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=======================================';

	END CATCH
END
