# Overview
This project aims to empower our retail client with data-driven insights and decision-making capabilities by providing a robust data infrastructure and actionable analytics. It involves integrating, cleaning, and structuring data, creating analytical models, and presenting the results in a user-friendly format through data visualizations and dashboards.

It comprises two distinct **Business Processes**, each with its own end-to-end analysis, design, and development.

## Process 1: [Sales Analysis]

- Description: The project aimed to create an ETL (Extract, Transform, Load) pipeline for data extraction, transformation, and loading into SQL Server Databases from the OLEDB source. It included data analysis using SQL Server Analysis Services (SSAS) to build cubes for multi-dimensional and Tabular analysis for business users. These cubes supported interactive dashboards and data visualizations for informed decision-making.
  ### Process 1: [Sales Analysis]
  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Sales.PNG)
*Figure 1: Sales Analysis Star Schema*

  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Product.PNG)
 *Figure 2: Sales ETL Pipeline for Product dimension*
  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesETL.PNG)
*Figure 3: Incremental load of ETL Pipeline for Factsales*
 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesM.PNG)
*Figure 4: Sales Cube for Multidimensional Analysis*
 ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/SalesTab.PNG)
*Figure 5: Sales Cube for Tabular Analysis*
- End-to-End Solution: Describe the complete solution for this process.

### Process 2: [Purchase Analysis]

- Description: The project also aimed to create an ETL (Extract, Transform, Load) pipeline for data extraction, transformation, and loading into SQL Server Databases from the OLEDB source. It included data analysis using SQL Server Analysis Services (SSAS) to build cubes for multi-dimensional and Tabular analysis for business users. These cubes supported interactive dashboards and data visualizations for informed decision-making.
  ![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Purchase.PNG)
*Figure 1: Purchase Analysis Star Schema*
- End-to-End Solution: Describe the complete solution for this process.

### Process 3: [Misconduct Analysis]

- Description: Provide a brief description of the third Business Process.
- End-to-End Solution: Describe the complete solution for this process.

### Process 4: [Overtime Analysis]

- Description: Provide a brief description of the fourth Business Process.
- End-to-End Solution: Describe the complete solution for this process.

### Process 5: [Absent Analysis]

- Description: Provide a brief description of the fifth Business Process.
- End-to-End Solution: Describe the complete solution for this process.

## Installation

Include any instructions or prerequisites required for setting up and running the project.

## Usage

Provide information on how to use the project or the Business Processes within it.

## Contributing

Explain how others can contribute to the project if it's open-source or if you're accepting contributions.

## License

Specify the project's license if applicable.

## Contact

Provide contact information or links for questions or support related to the project.

# Galaxy Schema:
- Enterprise Data Warehouse was built based on a dimensional modelling technique pioneered by Ralph Kimball
![Alt Text](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Galaxy%20Schema.PNG?raw=true "Galaxy Schema")

# Bus  Matrix: 
This project contains 5 Business Processes and every one have their own end-to-end solutions. 
### Business Process: 
#### 1. Sales Analysis
#### 2. Purchase Analysis
#### 3. Misconduct Analysis
#### 4. Overtime Analysis
#### 5. Absent Analysis
#### 1. Sales Analysis
![Sales Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Sales.PNG)
#### 2. Purchase Analysis
![Purchase Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Purchase.PNG)
#### 3. Misconduct Analysis
![Misconduct Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Misconduct.PNG)
#### 4. Overtime Analysis
![Overtime Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/overtime.PNG)
#### 5. Absent Analysis
![Absent Analysis](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Absent.PNG)

# Data collection strategy
- Data are collected from 57 locations from all over the world
- We have divided the locations into 5 categories where the locations in each category have thesimilar density of 65+ aged population.   
- Distribution of population density over 65+ aged people: 
![TrainConvg](/Figures/Galaxy Schema.png?raw=true "Title")
![TrainConvg](/Figures/Galaxy Schema.png?raw=true "Galaxy Schema")

# Input dataset:
- We have total 22 input features in the dataset.
- Input features are chosen based on environmental, biological, pollution, and demographical factors.
- Some input parameters influence CFR, some of them influence CSR and some have an impact on both CFR and CSR. 

# Input features dictate CFR:
- Population density of 65 or older people 
- Vitamin A deficiency 
- Vitamin D deficiency 
- Health care quality and access index
- Pollutant PM2.5 particle 
- Anemia 
- AB+ 
- AB-
- A+
- A- 
- B+ 
- B- 
- O+ 
- O- 

# Input features dictate CSR:
- Solar radiation
- Daily Temperature 
- Precipitation
- Population density
- Average Wind speed
- Relative humidity
- Stringency index
- UV index

# Input features dictate both CFR and CSR:
- Pollutant PM2.5 particle 

# Methodology:
- To train the input dataset, Artificial Neural Netwrok is used for regression.
- GridSearch technique is used to choose the hyperparameters, activation function, solver, and number and the size of hidden layers. 
- Four hidden layers are used to train the model with the sizes of 22, 20, 10, 5. 
- A regularization parameter alpha is used to prevent the trained model from overfitting. 
- Non-linear activation function (Relu) is used to fit the non-linear dataset.
- Solver Adam is used to handle the noisy dataset. 

# Results:
- For CFR:
- Training Error (MAE): 0.0350
- Testing Error (MAE): 0.0377

- For CSR:
- Training Error (MAE): 0.0184
- Testing Error (MAE): 0.0187

# Figures:
# Training Convergence [CFR]: 
![TrainConvg](/Figures/dw_architecture.png?raw=true "Title")
# Training Convergence [CSR]: 
![TrainConvgCSR](Sohel/1542844586079.jpg?raw=true "Title")
# Parameter correlation: 
![Corr](Results/Figures/CorrCoefficient.png?raw=true "Title")

# Validation of the trained model
# Arizona, USA
![TrainConvg](Results/Validation/ArizonaCFR.png?raw=true "Title")
![TrainConvg](Results/Validation/ArizonaCSR.png?raw=true "Title")
# Japan
![TrainConvg](Results/Validation/JapanCFR.png?raw=true "Title")
![TrainConvg](Results/Validation/JapanCSR.png?raw=true "Title")
# BC, Canada
![TrainConvg](Results/Validation/BCCanadaCFR.png?raw=true "Title")
![TrainConvg](Results/Validation/BCCanadaCSR.png?raw=true "Title")
