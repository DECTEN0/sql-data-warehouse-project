/*
=======================================================================================================================================================
This script creates the necessary tables in the 'silver' schema for a data warehouse. 
It checks if each table already exists and drops it before creating a new one with the specified columns and data types. 
The tables include 'crm_cust_info', 'crm_prd_info', 'crm_sales_details', 'erp_cust_az12', 'erp_loc_a101', and 'erp_px_cat_g1v2'. 
Each table is designed to store specific information related to customers, products, sales details, and other relevant data for the CRM and ERP systems.

Arguments:
- None

Warning: Dropping tables will result in the loss of all existing data in those tables.

=======================================================================================================================================================
*/


IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;	
CREATE TABLE silver.crm_cust_info(
	cust_id INT,
	cust_key NVARCHAR(50),
	cust_firstname NVARCHAR(50),
	cust_lastname NVARCHAR(50),
	cust_marital_status NVARCHAR(50),
	cust_gender NVARCHAR(50),
	cust_create_date DATE,
	dwh_create_dt DATETIME2 DEFAULT GETDATE()
);

GO

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
	prd_id       INT,
	cat_id       NVARCHAR(50),
	prd_key      NVARCHAR(50),
	prd_nm       NVARCHAR(50),
	prd_cost     INT,
	prd_line	 NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt   DATE,
	dwh_create_dt DATETIME2 DEFAULT GETDATE()
);

GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_dt DATETIME2 DEFAULT GETDATE()
);

GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12(
	cid   NVARCHAR(50),
	bdate DATE,
	gen   NVARCHAR(50),
	dwh_create_dt DATETIME2 DEFAULT GETDATE()
);

GO

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101(
	cid   NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_dt DATETIME2 DEFAULT GETDATE()
);

GO

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
	id          NVARCHAR(50),
	cat         NVARCHAR(50),
	subcat      NVARCHAR(50),
	maintenance NVARCHAR(50),
	dwh_create_dt DATETIME2 DEFAULT GETDATE()
);
