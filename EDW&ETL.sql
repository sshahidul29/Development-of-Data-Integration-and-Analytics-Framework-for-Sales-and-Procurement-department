---------Create Staging DataBase-----------
IF NOT EXISTS (SELECT Name FROM sys.databases WHERE Name = 'ABCStaging')
	CREATE DATABASE ABCStaging
ELSE
	Print ('database already exist')


--------Create DataWarehouse DataBase----------

 IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ABCEDW')
	CREATE DATABASE ABCEDW
ELSE
	Print ('database already exist')

----------Create the Schemas-------------
USE ABCStagging
CREATE SCHEMA Stagging


USE [ABCEDW]
CREATE SCHEMA EDW

-----Product Dimesion from OLTP----
  use ABCOLTP
  
  Select p.ProductID,p.Product,p.ProductNumber,p.UnitPrice,d.Department from Product p
  inner join Department d  on p.DepartmentID=d.DepartmentID

  select count(*) as SourceCount from Product p
  inner join Department d  on p.DepartmentID=d.DepartmentID


  ---- Product Staging ---- 
  use ABCStaging

  create table staging.Product
  (
    productID int ,
	product nvarchar(50),
	ProductNumber nvarchar(50),
	Unitprice float,
	Department nvarchar(50),
	LoadDate  datetime default getdate(),
	constraint staging_product_pk   primary key(productid)
  )
  select count(*) as desCount from staging.Product
  Truncate table staging.product

  ------- product EDW 
  use ABCStaging
  select  productId, product,ProductNumber,Unitprice,Department from  staging.Product 
  -- Precount, currentcurrent, postcount, type1count, type2Count 

   use ABCEDW
   
   create table EDW.DimProduct
  (
    ProductSk int Identity(1,1),
    ProductID int ,
	Product nvarchar(50),
	ProductNumber nvarchar(50),
	Unitprice float,
	Department nvarchar(50),
	EffectiveStartDate  datetime,
	EffectiveEndDate datetime,
	constraint Edw_dimproduct_sk   primary key(productsk)
  )

  select count(*) as PreCount  from EDW.DimProduct
  select count(*) as PostCount  from EDW.DimProduct
  Select * from EDW.DimProduct


  ----- promotion OLTP
  use ABCOLTP

  select p.PromotionID,t.Promotion,p.StartDate,p.EndDate,p.DiscountPercent  from  Promotion  p 
  inner join PromotionType t on p.PromotionTypeID=t.PromotionTypeID

  select count(*)  from  Promotion  p 
  inner join PromotionType t on p.PromotionTypeID=t.PromotionTypeID

  ------ promotion Staging
  use ABCStaging
  
  Create Table Staging.Promotion
  (
    PromotionID int,
	Promotion nvarchar(50),
	StartDate date,
	EndDate date,
	DiscountPercent float,
	Loaddate datetime default getdate(),
	constraint  staging_promotion_pk  primary key(PromotionID)
  )

  select count(*) desCount  from staging.promotion

  -------Promotion EdW---
  select  PromotionID,Promotion,StartDate,EndDate,DiscountPercent from staging.Promotion

  select count(*) CurrentCount from staging.Promotion
  Truncate Table staging.Promotion
  -------------------------------
  use ABCEDW
   Create Table EDW.DimPromotion
  (
    PromotionSK int identity(1,1),
	PromotionID int,
	Promotion nvarchar(50),
	StartDate date,
	EndDate date,
	DiscountPercent float,
	EffectiveStartDate Datetime,	
	constraint  edw_promotion_sk  primary key(PromotionSk)
  )


  select count(*) as PreCount  from EDW.DimPromotion

  select count(*) as PostCount  from EDW.DimPromotion
  ------ Store OLTP---
  use ABCOLTP
  select s.StoreID,s.StoreName,s.StreetAddress,c.CityName,st.State  from Store s 
  inner join City c  on c.CityID=s.CityID
  inner join State st on c.StateID=st.StateID

  select count(*) as SourceCount from Store s 
  inner join City c  on c.CityID=s.CityID
  inner join State st on c.StateID=st.StateID


  ---- Store Staging
	
  use  ABCStaging
  create table Staging.Store
  (
   StoreID int,
   StoreName nvarchar(50),
   StreetAddress nvarchar(50),
   CityName nvarchar(50),
   State nvarchar(50),
   LoadDate datetime default getdate(),
   constraint staging_store_pk primary key(StoreId)  
  )

  select StoreID,StoreName,StreetAddress,CityName,State from Staging.Store
  select * from Staging.Store
  select count(*) as DesCount  from Staging.Store
  Truncate Table staging.Store

  ------ store EDW
  select count(*) as CurrentCount  from Staging.Store
  
  use ABCEDW

  create table EDW.DimStore
  (
   StoreSk int  identity(1,1),
   StoreID int,
   StoreName nvarchar(50),
   StreetAddress nvarchar(50),
   CityName nvarchar(50),
   State nvarchar(50),
   EffectiveStartDate datetime,
   constraint edw_dimstore_sk primary key(StoreSk)  
  )
  select count(*) as PreCount  from EDW.DimStore
  select count(*) as PostCount  from EDW.DimStore
  Select * from EDW.DimStore
  
  ------ Customer OLTP----
  use ABCOLTP
  Select c.CustomerID, CONCAT(Upper(c.LastName),',',c.FirstName) as Customer, c.CustomerAddress, ct.CityName as City, s.State, getdate() as LoadDate from Customer c 
  inner join City ct on c.CityID=ct.CityID
  inner join State s on ct.StateID=s.StateID
  
  Select  count(*) as SourceCount from Customer c 
  inner join City ct on c.CityID=ct.CityID
  inner join State s on ct.StateID=s.StateID

  ----Customer Staging 

  use ABCStaging
  Create Table staging.Customer
  (
    CustomerID int, 
	Customer nvarchar(250),
	CustomerAddress nvarchar(50),
	City nvarchar(50),
	State nvarchar(50),
	LoadDate datetime default getdate(),
	constraint staging_customer_pk primary key(CustomerID)    
  )

  select CustomerID,Customer,CustomerAddress,City, State from staging.Customer

  select count(*) as DesCount from staging.Customer
    
  select count(*) as CurrentCount from staging.Customer

  Truncate Table Staging.Customer

  ----- Customer EDW------
  use ABCEDW

  Create Table EDW.DimCustomer
  (
    CustomerSK int identity(1,1),
    CustomerID int, 
	Customer nvarchar(250),
	CustomerAddress nvarchar(50),
	City nvarchar(50),
	State nvarchar(50),
	EffectiveStartDate datetime,
	constraint EDW_dimcustomer_sk primary key(CustomerSk)    
  )
  Select  count(*) as PreCount from EDW.DimCustomer

  Select  count(*) as PostCount from EDW.DimCustomer

  ------ OLTP POSChannel----

  use ABCOLTP
  select  p.ChannelID,p.ChannelNo,p.DeviceModel,p.SerialNo,p.InstallationDate from POSChannel p

  select  Count(*) as SourceCount from POSChannel p

  --- primary key , foreign key, unique, null or not null, check
  
  ----Staging POSChannel
    use  ABCStaging

	create table Staging.POSChannel
	(
	   ChannelID int,
	   ChannelNo nvarchar(50),
	   DeviceModel nvarchar(50),
	   SerialNo nvarchar(50),
	   InstallationDate date,
	   LoadDate datetime default getdate(),
	   constraint staging_posChannel_pk primary key (ChannelID)
	)
	
	select  count(*) as DesCount from staging.POSChannel
	Truncate Table staging.POSChannel

	Select ChannelID, ChannelNo, DeviceModel, SerialNo, InstallationDate from Staging.POSChannel
	select  count(*) as CurrentCount from staging.POSChannel
	---------EDW POSChannel
	use ABCEDW
	create table EDW.DimPOSChannel
	(
	   ChannelSK int identity(1,1),
	   ChannelID int,
	   ChannelNo nvarchar(50),
	   DeviceModel nvarchar(50),
	   SerialNo nvarchar(50),
	   InstallationDate date,
	   EffectiveStartDate datetime,
	   EffectiveEndDate datetime,
	   constraint EDW_DimposChannel_sk primary key (ChannelSK)
	)

	select Count(*) as  PreCount from EDW.DimPOSChannel

	select Count(*) as  PostCount from EDW.DimPOSChannel


----- OLTP Employees-------------
	
 use  ABCOLTP
 
 select * from Employee
 select * from MaritalStatus


 select e.EmployeeID,e.EmployeeNo,concat(Upper(e.LastName),' ,',e.FirstName) as Employee,e.DoB,m.MaritalStatus from Employee e
 inner join MaritalStatus m on e.MaritalStatus=m.MaritalStatusID

 select count(*) as SourceCount from Employee e
 inner join MaritalStatus m on e.MaritalStatus=m.MaritalStatusID


 ---- Employee Staging---
 use ABCStaging

  create table Staging.Employee
  (
    Employeeid int,
	EmployeeNo nvarchar(50),
	Employee  nvarchar(255),
	DoB date,
	MaritalStatus nvarchar(50),
	LoadDate datetime default getdate(),
	Constraint Staging_Employee_pk primary key(EmployeeId)   
  )

  select e.Employeeid,e.EmployeeNo,e.Employee,e.DoB,e.MaritalStatus  from staging.Employee e
  select count(*) as CurrentCount  from staging.Employee e

  Truncate table Staging.employee

  ----------- Employeee EDW

  use ABCEDW

  create table EDW.DimEmployee
  (
    EmployeeSK int identity(1,1),
    Employeeid int,
	EmployeeNo nvarchar(50),
	Employee  nvarchar(255),
	DoB date,
	MaritalStatus nvarchar(50),
	EffectiveStartDate datetime ,
	EffectiveEndDate datetime ,
	constraint EdW_Dimemployee_SK primary key(EmployeeSK)   
  )

  select  count(*) as PreCount from EDW.dimEmployee
  select  count(*) as PostCount from EDW.dimEmployee

  ---------------------Oltp vendor
  use ABCOLTP

  select v.VendorID,v.VendorNo, concat_ws(', ',Upper(v.LastName), v.FirstName) as vendor, v.RegistrationNo,v.VendorAddress,
  c.CityName as City,s.State
  from Vendor v 
  inner join City c on v.CityID=c.CityID
  inner join state s on c.StateID=s.StateID


  select count(*) as SourceCount  from Vendor v 
  inner join City c on v.CityID=c.CityID
  inner join state s on c.StateID=s.StateID

  --------- staging vendor---

  use  ABCStaging

  create table staging.Vendor
  (
   VendorID int, 
   VendorNo nvarchar(50),
   Vendor nvarchar(255),
   RegistrationNo nvarchar(50),
   VendorAddress nvarchar(50),
   City nvarchar(50),
   State  nvarchar(50),
   LoadDate datetime default getdate(),
   constraint staging_vendor_pk primary key (VendorID)
   )

   Select   VendorID, VendorNo, Vendor , RegistrationNo, VendorAddress, City,State from  staging.Vendor

   select  Count(*) as descCount  from Staging.Vendor 
   	 
   select  Count(*) as CurrentCount  from Staging.Vendor 

   Truncate Table Staging.Vendor

   --- EDW Vendor----
   use ABCEDW
   Drop table EDW.DimVendor
   create table EDW.DimVendor
  (
   VendorSK int identity(1,1),
   VendorID int, 
   VendorNo nvarchar(50),
   Vendor nvarchar(255),
   RegistrationNo nvarchar(50),
   VendorAddress nvarchar(50),
   City nvarchar(50),
   State  nvarchar(50),
   EffectiveStartDate datetime,
   EffectiveEndDate datetime,
   Constraint EDW_Dimvendor_SK Primary key (VendorSK)
   )

   select  count(*) as PreCount from EDW.dimVendor

   select  count(*) as PostCount from EDW.dimVendor


 -----  Oltp Sales analysis
use ABCOLTP

select * from SalesTransaction where Year(TransDate)=2023 and MONTH(transDate)=3
order by transDate 


IF (select count(*) from  TescaEDW.EDW.fact_salesAnalysis)<=0 
	select s.TransactionID,s.TransactionNO, Convert(date,s.TransDate)TransDate,datepart(HOUR,TransDate) as TransHour,
	Convert(date,s.OrderDate) OrderDate,datepart(HOUR,OrderDate) as OrderHour,convert(date,s.DeliveryDate) DeliveryDate,
	s.ChannelID, s.CustomerID,s.EmployeeID,s.ProductID,
	s.StoreID,s.PromotionID,s.Quantity, s.TaxAmount,s.LineAmount,s.LineDiscountAmount, Getdate() as LoadDate
   From SalesTransaction s  Where convert(date,TransDate)<=DATEADD(day,-1,convert(date,getdate()))     --- begin to n-1
ELSE
	select s.TransactionID,s.TransactionNO, Convert(date,s.TransDate)TransDate,datepart(HOUR,TransDate) as TransHour,
	Convert(date,s.OrderDate) OrderDate,datepart(HOUR,OrderDate) as OrderHour, convert(date,s.DeliveryDate) DeliveryDate
	,s.ChannelID, s.CustomerID,s.EmployeeID,s.ProductID,
	s.StoreID,s.PromotionID,s.Quantity, s.TaxAmount,s.LineAmount,s.LineDiscountAmount, Getdate() as LoadDate
   From SalesTransaction s Where convert(date,TransDate)=DATEADD(day,-1,convert(date,getdate()))  --- n-1

--- 

IF (select count(*) from  TescaEDW.EDW.fact_salesAnalysis)<=0 
	select count(*) as SourceCount   From SalesTransaction s  Where convert(date,TransDate)<=DATEADD(day,-1,convert(date,getdate()))     --- begin to n-1
ELSE
	select count(*) as SourceCount From SalesTransaction s Where convert(date,TransDate)=DATEADD(day,-1,convert(date,getdate()))  --- n-1



use ABCStaging

Create table staging.SalesAnalysis
(
  TransactionID int,
  TransactionNo nvarchar(50),
  TransDate Date, 
  TransHour int,
  OrderDate date,
  OrderHour int,
  DeliveryDate date,
  ChannelID int,
  CustomerID int,
  EmployeeId int,
  ProductId int,
  StoreID int,
  PromotionID int ,
  Quantity float,
  TaxAmount float,
  LineAmount float,
  LineDiscountAmount float,
  LoadDate datetime default getdate(),
  constraint staging_salesAnalysis_pk  primary key(TransactionID)
 )
 
select  count(*) as DesCount from staging.SalesAnalysis
select   TransactionID,TransactionNo,TransDate,TransHour,OrderDate,OrderHour,DeliveryDate,ChannelID,CustomerID,
  EmployeeId,ProductId,StoreID,PromotionID,Quantity,TaxAmount,LineAmount,LineDiscountAmount,getdate() as LoadDate  from staging.SalesAnalysis
Select * from staging.SalesAnalysis
Truncate Table staging.SalesAnalysis

----- EdW salesAnalysis ---

 select  count(*) as CurrentCount from staging.SalesAnalysis
 
 use ABCEDW

 select DateSK, BusinessDate from EdW.DimDate
 select TimeSK, TimeHour from EDW.DimTime
 select ChannelSK, ChannelID from EDW.DimPOSChannel
 select CustomerSK, CustomerID  from EDW.dimCustomer
 select EmployeeSK, EmployeeID from EdW.DimEmployee
 select CategorySK, CategoryID from EdW.DimAbsence
 select ProductSK, ProductID from EDW.DimProduct
 select StoreSK, StoreID from EDW.DimStore
 select PromotionSK, PromotionID from EDW.DimPromotion
 select DecisionSK, DecisionID from EDW.DimDecision
 select MisConductSK, MisConductID from EDW.dimMisconduct
 select VendorSK, VendorID from EDW.DimVendor
 select * from EDW.DimStore

 select count(*) as PreCount  from EDW.fact_salesAnalysis
 select count(*) as PostCount  from EDW.fact_salesAnalysis
 --------------------------------------------
select * from EDW.Fact_SalesAnalysis	
Truncate table EDW.Fact_SalesAnalysis
 Create table EDW.Fact_SalesAnalysis
 (
   SalesSK bigint identity(1,1),
   TransactionNo nvarchar(50),
   TransDateSK int,
   TransHourSK int,
   OrderDateSK int, 
   OrderHourSK int,
   DeliveryDateSK int,
   ChannelSK int, 
   CustomerSK int, 
   EmployeeSK int, 
   ProductSK int,
   StoreSK int,
   promotionSK int,    	  
   Quantity float,
  TaxAmount float,
  LineAmount float,
  LineDiscountAmount float,
  LoadDate datetime, 
constraint EDW_Salesanalysis_SalesSK primary key(SalesSK),
constraint EDW_sales_Transdatesk foreign key (TransDateSk) references EDW.DimDate(dateSk),
constraint EDW_sales_Transhoursk foreign key (TransHoursk) references EDW.DimTime(TimeSk),
constraint EDW_sales_Orderdatesk foreign key (OrderDateSk) references EDW.DimDate(dateSk),
constraint EDW_sales_Orderhoursk foreign key (OrderHoursk) references EDW.DimTime(TimeSk),
constraint EDW_sales_DeliveryDatesk foreign key (DeliveryDateSk) references EDW.DimDate(dateSk),
constraint EDW_sales_ChannelSk foreign key(ChannelSk) references  EDW.DimPOSChannel(ChannelSK),
constraint EDW_sales_CustomerSK  foreign key(CustomerSk) references EDW.DimCustomer(CustomerSk),
constraint EDW_sales_EmployeeSK foreign key (EmployeeSk) references EDW.DimEmployee(EmployeeSK),
constraint EDW_sales_ProductSk foreign key(ProductSK) references EDW.DimProduct(ProductSk),
constraint EDW_sales_StoreSk foreign key(StoreSK) references EDW.dimStore(StoreSk),
constraint EDW_sales_PromotionSk foreign key(PromotionSK) references EDW.dimPromotion(Promotionsk)
 )

Select * from EDW.Fact_SalesAnalysis

 ------ OLTP Purchase ----
 use ABCOLTP

 select * from PurchaseTransaction

  IF (Select count(*) from  TescaEDW.EDW.fact_PurchaseAnalysis) <=0
	select p.TransactionID, p.TransactionNO, convert(date,p.TransDate) TransDate, Convert(date,OrderDate) OrderDate, 
	convert(date,DeliveryDate) DeliveryDate, 
	p.VendorID,p.EmployeeID,p.ProductID,p.StoreID,datediff(day, p.OrderDate, p.DeliveryDate) +1 as Diffentialdays,
	p.Quantity,p.TaxAmount,p.LineAmount,getDate() as LoadDate
	from  PurchaseTransaction p
	where  convert(date,p.TransDate)<= dateadd(day,-1,convert(date,GETDATE()))
 ELSE
	select p.TransactionID, p.TransactionNO, convert(date,p.TransDate) TransDate, Convert(date,OrderDate) OrderDate, 
	convert(date,DeliveryDate) DeliveryDate, 
	p.VendorID,p.EmployeeID,p.ProductID,p.StoreID,datediff(day, p.OrderDate, p.DeliveryDate) +1 as Diffentialdays,	
	p.Quantity,p.TaxAmount,p.LineAmount,getDate() as LoadDate
	from  PurchaseTransaction p
	where  convert(date,p.TransDate) = dateadd(day,-1,convert(date,GETDATE()))


	---- Source Count
	
  IF (Select count(*) from  TescaEDW.EDW.fact_PurchaseAnalysis) <=0
	select Count(*) as SourceCount from  PurchaseTransaction p
	where  convert(date,p.TransDate)<= dateadd(day,-1,convert(date,GETDATE()))
 ELSE
	select Count(*) as SourceCount	from  PurchaseTransaction p
	where  convert(date,p.TransDate) = dateadd(day,-1,convert(date,GETDATE()))



	---- Staging PurchaseAnalysis

	use ABCStaging

	Select count(*) as DescCount from Staging.PurchaseAnalysis

	Create Table Staging.PurchaseAnalysis
	(
	 TransactionID int,
	 TransactionNo nvarchar(50),
	 TransDate Date, 
	 OrderDate Date,
	 DeliveryDate date,
	 VendorID int,
	 EmployeeID int,
	 ProductID int , 
	 StoreID int,
	 DifferentialDays int,
	 Quantity float, 
	 TaxAmount  float,
	 LineAmount float,
	 LoadDate datetime default getdate(),
	 constraint staging_purchaseanalysis_pk primary key(TransactionID)	 
	)
	

	Select * from Staging.PurchaseAnalysis

	Truncate Table Staging.PurchaseAnalysis

	Select TransactionID, TransactionNo, TransDate, OrderDate, DeliveryDate, VendorID, EmployeeID,
	ProductID, StoreID, DifferentialDays, Quantity, TaxAmount, LineAmount, Getdate() as LoadDate from Staging.PurchaseAnalysis
	
	select DateSK, BusinessDate from EdW.DimDate
 select TimeSK, TimeHour from EDW.DimTime
 select ChannelSK, ChannelID from EDW.DimPOSChannel
 select CustomerSK, CustomerID  from EDW.dimCustomer
 select EmployeeSK, EmployeeID from EdW.DimEmployee
 select CategorySK, CategoryID from EdW.DimAbsence
 select ProductSK, ProductID from EDW.DimProduct
 select StoreSK, StoreID from EDW.DimStore
 select PromotionSK, PromotionID from EDW.DimPromotion
 select DecisionSK, DecisionID from EDW.DimDecision
 select MisConductSK, MisConductID from EDW.dimMisconduct
 select VendorSK, VendorID from EDW.DimVendor
	
	
	
	---------------- EdW Purchase Analysis

	Use ABCEDW
	select * from EDW.Fact_PurchaseAnalysis	
Truncate table EDW.Fact_PurchaseAnalysis

	Create Table EDW.Fact_PurchaseAnalysis
	(
	   PurchaseAnalysisSK  bigint identity(1,1),
	   TransactionNo nvarchar(50),
	   TransDateSK int,
	   OrderDateSK int,
	   DeliveryDateSK int,
	   VendorSK int,
	   EmployeeSK int,
	   ProductSK int,
	   StoreSK int,
	   DifferentialDays int,
   	   Quantity float, 
	   TaxAmount  float,
	   LineAmount float,
	   LoadDate datetime default getdate(),
	   constraint EDW_Fact_PurchaseAnalysis_SK primary key(PurchaseAnalysisSK),
	   constraint EDW_Purchase_Transdatesk foreign key (TransDateSK) references EDW.DimDate(dateSK),		
	   constraint EDW_Purchase_Orderdatesk foreign key (OrderDateSk) references EDW.DimDate(dateSk),		
	   constraint EDW_Purchase_DeliveryDatesk foreign key (DeliveryDateSk) references EDW.DimDate(dateSk),
	   constraint EDW_Purchase_VendorSk foreign key (VendorSk) references EdW.DimVendor(VendorSk),
	   constraint EDW_Purchase_EmployeeSK foreign key (EmployeeSk) references EDW.DimEmployee(EmployeeSK),
	   constraint EDW_Purchase_ProductSk foreign key(ProductSK) references EDW.DimProduct(ProductSk),
	   constraint EDW_Purchase_StoreSk foreign key(StoreSK) references EDW.dimStore(StoreSk)		
	)
		select count(*) as PreCount from  EDW.fact_PurchaseAnalysis

		select count(*) as PostCount from  EDW.fact_PurchaseAnalysis
