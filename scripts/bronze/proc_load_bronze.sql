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

	TRUNCATE TABLE bronze.crm_cust_info; -- Clear existing data from the table before loading new data

	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,          --skip header row
		FIELDTERMINATOR = ',', --specify comma as field delimiter
		TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
	);


	TRUNCATE TABLE bronze.crm_prd_info; -- Clear existing data from the table before loading new data

	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,          --skip header row
		FIELDTERMINATOR = ',', --specify comma as field delimiter
		TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
	);



	TRUNCATE TABLE bronze.crm_sales_details; -- Clear existing data from the table before loading new data

	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,          --skip header row
		FIELDTERMINATOR = ',', --specify comma as field delimiter
		TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
	);


	TRUNCATE TABLE bronze.erp_cust_az12; -- Clear existing data from the table before loading new data

	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIRSTROW = 2,          --skip header row
		FIELDTERMINATOR = ',', --specify comma as field delimiter
		TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
	);

	TRUNCATE TABLE bronze.erp_loc_a101; -- Clear existing data from the table before loading new data

	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH (
		FIRSTROW = 2,          --skip header row
		FIELDTERMINATOR = ',', --specify comma as field delimiter
		TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
	);


	TRUNCATE TABLE bronze.erp_px_cat_g1v2; -- Clear existing data from the table before loading new data
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\Users\Window\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
		FIRSTROW = 2,          --skip header row
		FIELDTERMINATOR = ',', --specify comma as field delimiter
		TABLOCK                --specify that the entire file should be treated as a single batch for improved performance
	);

END
