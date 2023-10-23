## Overview
This project aims to empower our retail client with data-driven insights and decision-making capabilities by providing a robust data infrastructure and actionable analytics. It involves integrating, cleaning, and structuring data, creating analytical models, and presenting the results in a user-friendly format through data visualizations and dashboards.

It comprises two distinct **Business Processes**, each with its own end-to-end analysis, design, and development.
### Business Processes are 1. Sales Analysis and 2. Purchase Analysis

## Achievement:
- Development of a robust data warehouse to retrieve data for further analysis.
- The virtualizations and dashboards helped the Sales Manager monitor the movement of products and assess how promotional activities influence sales.
- The Sales manager benefitted greatly from data analysis. It helped them understand customer shopping habits, and the dashboard provided insights into product combinations, sales opportunities, and customer behaviour.
- The Sales Manager was also able to determine the most in-demand products during specific times of the day.
- The Purchasing Manager was able to find the best vendors based on how quickly they deliver orders after they're placed.

## Software requirements:
- MS SQL Server, SSMS, SSIS, SSAS, SSRS, Power BI, Tableau, Visual Studio and Dax Studio
- Windows OS

## Data Management and Processes
Data Management and Processes involved with
- Data Governance
- Data Quality and Validation
- Data Retention Policy
- Master Data Management

## System Development Life Cycle (SDLC)
- Agile Scrum Methodology

## Enterprise Data Warehouse was built in MS SQL Server using SSMS
- Led complete database lifecycle management including installation, upgrade, troubleshooting, migration, and security.
- Conducted in collaboration with Managers, Project Managers, Technical Product Managers, Clients, Subject-matter experts and Data Governance representatives to obtain requirements, objectives, and business rules for the project.
- Conducted data profiling.
- Created the opportunity/stakeholder Matrix (it helps identify which business groups should be invited to the collaborative design sessions for each process-centric row).
- Constructed a Bubble Chart for communicating data models to a non-technical audience. 
- Created Bus Matrix (composition of Business process, Granularity, Facts, Fact Tables, and Dimensions).
- Designed and implemented Enterprise Data Warehouse (EDW) using Ralph Kimball’s Dimensional Modelling Approach.
- Created and configured Staging, EDW, and Control Framework databases on MS SQL Server.
- Responsible for Database Backup and Recovery, Backup Strategies and Scheduling Backups.
- Responsible for Database performance tuning, problem diagnosis and resolution.
![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Galaxyschema.PNG)  
Figure 1: Sales and Purchase Galaxyschema Schema

## ETL Pipeline was built in Visual Studio using SSIS

- The project aimed to create an ETL (Extract, Transform, Load) pipeline for data extraction, transformation, and loading into SQL Server Databases from the OLE DB source.
- Produced ETL Mapping and Transformation Rules and data Quality documentation for the project.
- Developed and tested ETL processes/programs necessary to extract data from different data sources, Transformed and cleansed the data, and loaded it into a Staging database and Staging to Data Warehouse, using connection managers like OLE DB, Excel, Flat file, and ADO.NET.
- Created a metric table for an audit of Source Count, and Destination Count Staging database, and Pre, Current, Post, Type1, and Type2 Counts for EDW using the Control framework database.
- Design and Implement Ralph Kimball slowly changing dimension (SCD) Type 1 and 2.
- Troubleshooting and root cause analysis activities to fix bugs in the data integration process.
- Used the server agent to automate the ETL processes to ensure new data were loaded automatically into the Data Warehouse.

  
  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesCETL.PNG)

 Figure 2: Control-flow diagram for ETL Pipeline

  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Product.PNG)

 Figure 3: Data-flow diagram of ETL Pipeline for Product dimension

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesETL.PNG)

Figure 4: Data-flow diagram for Incremental load of ETL Pipeline for Factsales

![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Control.PNG)

Figure 5: Control-flow diagram for ETL Pipeline to automate the system through SQL Server Agent

## Datamart was built using SSAS for Business Users

- Cubes were built using SQL Server Analysis Services (SSAS) for multi-dimensional and Tabular analysis for business users. These cubes supported interactive dashboards and data visualizations for informed decision-making.

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesM.PNG)

Figure 6: Sales Cube for Multidimensional Analysis

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/salesTab.PNG)

Figure 7: Sales Cube for Tabular Analysis

![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/PurchaseM.PNG)

Figure 8: Purchase Cube for Multidimensional Analysis

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/PurchaseTab.PNG)

Figure 9: Purchase Cube for Tabular Analysis

## Reports were generated using SSRS

- Experienced in SQL querying and development spanning stored procedures, de-duplication, views, functions, and cursors for reports.
- Developed advanced dashboards and reports for informed decision-making.
  
 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/ReportS.PNG)

Figure 10: Sales Analysis

## Data Analysis in PowerBI

- Modeled data based on Star and Snowflake Schema to enhance data accessibility.
- Working with complex DAX formulas to create required Measures, Calculated Columns and KPIs for analysis and reporting purposes.
- Implemented visualization best practices by creating measures instead of calculated columns where necessary. This reduced the overall size and improved the performance of reports.
- Created interactive Power BI dashboard and reports for informed decision-making.
   
 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesPB1.PNG)

Figure 11: Sales Analysis

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesPB2.PNG)

Figure 12: Tooltip Net Pay by Days

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesPB4.PNG)

Figure 13: Customer Basket Analysis Sales

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/PurchaseModel.PNG)

Figure 14: Purchase Star Schema in PowerBI

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/PurchasePB.PNG)

Figure 15: Purchase Analysis
