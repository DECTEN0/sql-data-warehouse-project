/*
==========================================================================================
CREATE DATABASES AND SCHEMAS
==========================================================================================
Script Purpose:
    This script creates a Data Warehouse database and defines three schemas:
    bronze, silver, and gold (Medallion Architecture).

Warning:
    This will DROP the database if it already exists.
    All data will be permanently deleted.
==========================================================================================
*/

USE master;
GO

-- Drop and Recreate Database "DataWarehouse"
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the Database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas (Medallion Architecture)

-- Raw data layer
CREATE SCHEMA bronze; 
GO

-- Cleaned and transformed data
CREATE SCHEMA silver;  
GO

-- Business-ready data (analytics layer)
CREATE SCHEMA gold;    
GO
