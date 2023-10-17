# Overview
This project aims to empower our retail client with data-driven insights and decision-making capabilities by providing a robust data infrastructure and actionable analytics. It involves integrating, cleaning, and structuring data, creating analytical models, and presenting the results in a user-friendly format through data visualizations and dashboards.

It comprises two distinct **Business Processes**, each with its own end-to-end analysis, design, and development.
## Business Process 1: [Sales Analysis]
## Business Process 2: [Purchase Analysis]

- Description: The project aimed to create an ETL (Extract, Transform, Load) pipeline for data extraction, transformation, and loading into SQL Server Databases from the OLEDB source. It included data analysis using SQL Server Analysis Services (SSAS) to build cubes for multi-dimensional and Tabular analysis for business users. These cubes supported interactive dashboards and data visualizations for informed decision-making.

## Enterprise Data Warehouse was built in MySQL Server using SSMS
  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Galaxyschema.PNG)  
*Figure 1: Sales and Purchase Galaxyschema Schema *

## ETL Pipeline was built in Visual Studio using SSIS
  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesCETL.PNG)

 *Figure 2: Control-flow diagram for ETL Pipeline *

  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Product.PNG)

 *Figure 3: Data-flow diagram of ETL Pipeline for Product dimension *

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesETL.PNG)

*Figure 4: Data-flow diagram for Incremental load of ETL Pipeline for Factsales *

![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Control.PNG)

*Figure 5: Control-flow diagram for ETL Pipeline to automate the system through SQL Server Agent *

## Datamart was built using SSAS for Business Users

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesM.PNG)

*Figure 6: Sales Cube for Multidimensional Analysis *

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/salesTab.PNG)

*Figure 7: Sales Cube for Tabular Analysis *

![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/PurchaseM.PNG)

*Figure 8: Purchase Cube for Multidimensional Analysis *

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/PurchaseTab.PNG)

*Figure 9: Purchase Cube for Tabular Analysis *

## Reports were generated using SSRS

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/ReportS.PNG)

*Figure 6: Sales Analysis *

## Data Analysis in PowerBI

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesPB1.PNG)

*Figure 7: Sales Analysis*

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesPB2.PNG)

*Figure 8: Tooltip Net Pay by Days *

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesPB4.PNG)

*Figure 9: Customer Basket Analysis Sales*

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/PurchaseModel.PNG)

*Figure 10: Purchase Star Schema in PowerBI *

 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/PurchasePB.PNG)

*Figure 11: Purchase Analysis *

- End-to-End Solution: Describe the complete solution for this process.
