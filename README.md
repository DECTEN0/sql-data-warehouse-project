<h1 align="center">Data Warehouse and Analytics Project</h1>

Welcome to my **Data Warehouse and Analytics Project** repository. This project demonstrates my comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---

## 🏗️ Data Architecture

The data architecture for this project follows **Medallion Architecture** with Bronze, Silver, and Gold layers:

| Layer | Description |
|-------|-------------|
| **Bronze** | Stores raw data as-is from source systems. Data is ingested from CSV files into SQL Server. |
| **Silver** | Includes data cleansing, standardization, and normalization to prepare data for analysis. |
| **Gold** | Houses business-ready data modeled into a star schema required for reporting and analytics. |

---

## 📖 Project Overview

This project involves:

- **Data Architecture**: Designing a Modern Data Warehouse using Medallion Architecture (Bronze, Silver, and Gold layers)
- **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse
- **Data Modeling**: Developing fact and dimension tables optimized for analytical queries
- **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights

---

## 🎯 Skills Showcased

This repository is my introduction to Data Engineering:

- SQL Development
- Data Architecture
- Data Engineering
- ETL Pipeline Development
- Data Modeling
- Data Analytics

---

## 🛠️ Tools & Resources

- **Datasets**: CSV files for the project dataset
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)**: Lightweight server for hosting your SQL database
- **[SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)**: GUI for managing and interacting with databases
- **[Git](https://github.com)**: Version control and collaboration
- **[DrawIO](https://www.drawio.com)**: Design data architecture, models, flows, and diagrams
- **[Notion](https://www.notion.so)**: Project template and task management

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**: Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

**Specifications**:
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis
- **Integration**: Combine both sources into a single, user-friendly data model for analytical queries
- **Scope**: Focus on the latest dataset only; historization of data is not required
- **Documentation**: Provide clear documentation of the data model for business stakeholders and analytics teams

### BI: Analytics & Reporting (Data Analysis)

**Objective**: Develop SQL-based analytics to deliver detailed insights into:

- Customer Behavior
- Product Performance
- Sales Trends

These insights empower stakeholders with key business metrics, enabling strategic decision-making.


---

## 📂 Repository Structure

```
data-warehouse-project/
│
├── datasets/                           # Raw datasets (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture
│   ├── etl.drawio                      # ETL techniques and methods diagram
│   ├── data_architecture.drawio        # Project architecture diagram
│   ├── data_catalog.md                 # Dataset catalog with field descriptions
│   ├── data_flow.drawio                # Data flow diagram
│   ├── data_models.drawio              # Data models (star schema)
│   └── naming-conventions.md          # Naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   └── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information
├── .gitignore                          # Git ignore rules
└── requirements.txt                    # Project dependencies
```

---

## ☕ Stay Connected

Let's stay in touch! Feel free to connect with me:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/derrick-nyongesa/)

---

## 🛡️ License

This project is licensed under the **MIT License**. You are free to use, modify, and share this project with proper attribution.
