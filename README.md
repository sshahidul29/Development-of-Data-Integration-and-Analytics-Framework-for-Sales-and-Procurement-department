# Deliverables:
- Building Enterprise Data Warehousing Solution that addresses the analytic requirements
- Building Data Mart Cubes for functional areas based on the analytic requirements using SQL Server Analysis Services
- Using Power BI to design Data Visualisations for business users and management to enable informed decisions

# Galaxy Schema:
- Enterprise Data Warehouse was built based on a dimensional modelling technique pioneered by Ralph Kimball
![Alt Text](https://github.com/sshahidul29/Sales-and-Procurement-Data-Integration-and-Analytics-Framework/blob/main/Figures/Galaxy%20Schema.PNG?raw=true "Galaxy Schema")

# Bus  Matrix: 
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
