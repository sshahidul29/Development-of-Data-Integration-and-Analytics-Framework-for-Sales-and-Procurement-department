---------Create Staging DataBase-----------
IF NOT EXISTS (SELECT Name FROM sys.databases WHERE Name = 'TescaStaging')
	CREATE DATABASE TescaStaging
ELSE
	Print ('database already exist')


--------Create DataWarehouse DataBase----------

 IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'TescaEDW')
	CREATE DATABASE TescaEDW
ELSE
	Print ('database already exist')

-----------Create Control Database-----------
IF NOT EXISTS (SELECT Name FROM sys.databases WHERE Name = 'TescaControl')
	CREATE DATABASE TescaControl
ELSE
	Print ('database already exist')

----------Create the Schemas-------------
USE TescaStagging
CREATE SCHEMA Stagging


USE [TescaEDW]
CREATE SCHEMA EDW


------------ Creating the Date Dimesion Table-----------
CREATE TABLE EDW.DimDate
(
DateSK int,    
BusinessDate date,   
BusinessYear int,
BusinessMonth int,
BusinessQuarter nvarchar(2),
EnglishMonth nvarchar(50),
EnglishDayofWeek NVARCHAR(50),
SpanishMonth nvarchar(50),
SpanishDayofWeek nvarchar(50),
FrenchMonth nvarchar(50),
FrenchDayofWeek nvarchar(50),
LoadDate datetime default getdate(),
Constraint edw_dimdate_sk Primary key (DateSK)
)

-----Dynamically Insert Data  into the Date table using a stored Procedure-----

Create or Alter procedure EDW.DateGenerator(@endDate date)
AS
BEGIN
SET NOCOUNT ON
	declare @StartDate date =  (SELECT MIN(CONVERT(DATE, minDate)) FROM
		(SELECT MIN(TRANSDATE) AS minDate FROM TescaOLTP.dbo.SalesTransaction
		union ALL
		SELECT MIN(TRANSDATE) AS minDate FROM TescaOLTP.dbo.PurchaseTransaction
		)A
	)
	
	Declare @NofDays int = DATEDIFF(Day, @startDate,  @Enddate)
	Declare @CurrentDay int = 0
	Declare @CurrentDate DATE

	IF (SELECT OBJECT_ID('EDW.DIMDATE')) IS NOT NULL
		TRUNCATE TABLE EDW.DimDate

	WHILE @CurrentDay <= @NofDays
	BEGIN
		SELECT @currentdate = (DATEADD(day, @CurrentDay, @StartDate))
		
	
		INSERT INTO EDW.DimDate(DateSK, BusinessDate,BusinessYear,BusinessMonth, BusinessQuarter, EnglishMonth,
		EnglishDayofWeek,SpanishMonth,SpanishDayofWeek,FrenchMonth, FrenchDayofWeek,LoadDate)
		SELECT CONVERT(INT, CONVERT(NVARCHAR(8), @CurrentDate, 112)), @CurrentDate, Year(@CurrentDate),
		MONTH(@CurrentDate), 'Q' + CAST(DATEPART(Q, @currentDate) as nvarchar), DATENAME(month, @currentDate), 
		datepart(dw, @CurrentDate),
		CASE DATEPART(MONTH, @CurrentDate)
			WHEN 1 THEN 'Enero' when 2 THEN 'Febrero' when 3 then 'Marzo' WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo'
			WHEN 6 THEN 'Junio' WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre'
			WHEN 11 THEN 'Noviembre' when 12 then 'Diciembre' 
		END,
		CASE DATEPART(WEEKDAY, @CurrentDate)
			WHEN 1 THEN 'Domingo' when 2 then 'Lunes' when 3 then 'Martes' when 4 then 'Miercoles' when 5 then 'Jueves'
			when 6 then 'Viernes' when 7 then 'Sabado'
			END, 
		CASE DATEPART(MONTH, @CurrentDate)
			WHEN 1 THEN 'Janvier' when 2 THEN 'Février' when 3 then 'mars' WHEN 4 THEN 'Avril' WHEN 5 THEN 'Mai'
			WHEN 6 THEN 'JUIN' WHEN 7 THEN 'Juillet' WHEN 8 THEN 'Août' when 9 then 'Septembre' when 10 then 'Octobre'
			WHEN 11 THEN 'Novembre' when 12 then 'Décembre' 
		END,
		CASE DATEPART(WEEKDAY, @CurrentDate)
			WHEN 1 THEN 'Dimanche' when 2 then 'Lundi' when 3 then 'Mardi' when 4 then 'Mercredi' when 5 then 'Jeudi'
			when 6 then 'Vendredi' when 7 then 'Samedi'
			END,
			Getdate()
		SELECT @CurrentDay = @CurrentDay+1
	END
END



----------------- Creating the Time Dimesion Table------------
USE TescaEDW
Create Table EDW.DimTime
 (
   TimeSK int identity(1,1),
   TimeHour int,   ---- 0  to 23
   TimeInterval nvarchar(20) not null, 
   BusinessHour nvarchar(20) not null,
   PeriodofDay  nvarchar(20) not null,
   LoadDate datetime default getdate(),
   constraint Edw_dimTime_sk primary key(TimeSk)
 )


 ---------Insert Data dynamically into the Time dimension table using a stored Procedure----------
Create or Alter procedure EDW.dimTimeGenerator
AS
BEGIN
SET NOCOUNT ON
 declare  @currentHour int= 0
   IF OBJECT_ID('EDW.dimTime') is not null
    TRUNCATE TABLE EDW.dimTime

 WHILE @currentHour<=23
 BEGIN
	
	insert into  EDW.dimTime(TimeHour,TimeInterval,BusinessHour,PeriodofDay,LoadDate)
	select @currentHour, right(concat('0',@currentHour),2)+':00-'+right(concat('0',@currentHour),2)+':59',
		case 
			When (@currentHour>=0 and @currentHour<=7 )  or (@currentHour>=18 and @currentHour<=23 ) Then 'Closed'	
			Else 'Open'
		END, 
		case 
			When @currentHour =0 Then 'MidNight'
			When @currentHour>=1 and @currentHour<=4 Then 'Early Morning'
			When @currentHour>=5 and @currentHour<=11 Then 'Morning'
		    When @currentHour=12 Then 'Noon'
			When @currentHour>=13 and @currentHour<=17 Then 'Afternoon'
			When @currentHour>=18 and @currentHour<=21 Then 'Evening'
			ElSE  'Night'
		END, getdate()
			   
	select @currentHour=@currentHour+1
 END
END

exec EDW.dimTimeGenerator '20301231'



-----Product Dimesion from OLTP----
USE [TescaOLTP]
SELECT P.ProductID,P.Product, P.ProductNumber, p.UnitPrice, D.Department, getdate() as LoadDate
FROM PRODUCT P
INNER JOIN Department D ON P.DepartmentID = D.DepartmentID

SELECT Count(*) AS SourceCount
FROM PRODUCT P
INNER JOIN Department D ON P.DepartmentID = D.DepartmentID

---------Product Staging---------
USE TescaStaging

CREATE TABLE Staging.Product
	(
	ProductID int,
	Product nvarchar(50),
	ProductNumber nvarchar(50),
	UnitPrice float,
	Department nvarchar(50),
	loadDate datetime default GETDATE(),
	constraint Staging_product_pk Primary key(productid)
	)


SELECT ProductID, Product, ProductNumber, UnitPrice, Department, getdate() as LoadDate FROM Staging.Product

SELECT COUNT(*) AS DesCount FROM Staging.Product

Truncate Table Staging.Product


USE TescaEDW
CREATE TABLE EDW.DimProduct
	(
	ProductSk int identity(1,1),
	ProductID INT,
	Product nvarchar(50),
	ProductNumber nvarchar(50),
	UnitPrice float,
	Department nvarchar(50),
	EffectiveStartDate datetime,
	EffectiveEndDate datetime,
	constraint Staging_product_sk Primary key(productsk)
	)

SELECT COUNT(*) As PreCount FROM EDW.DimProduct

SELECT COUNT(*) As PostCount FROM EDW.DimProduct


----------Promotion Dimesion From OLTP---------
USE TescaOLTP
SELECT P.PromotionID, T.Promotion, p.StartDate, p.EndDate, p.DiscountPercent, getdate() as LoadDate
FROM PROMOTION P 
INNER JOIN PromotionType T ON P.PromotionTypeID = T.PromotionTypeID

SELECT COUNT(*) as sourceCount
FROM PROMOTION P 
INNER JOIN PromotionType T ON P.PromotionTypeID = T.PromotionTypeID


-------Promotion Staging-----------
USE TescaStaging
CREATE TABLE Staging.Promotion
	(
	PromotionID INT,
	Promotion nvarchar(50),
	StartDate date,
	EndDate date,
	DiscountPercent float,
	LoadDate datetime,
	constraint staging_promotion_sk Primary key(PromotionID)
	)

SELECT PromotionID, Promotion, StartDate, EndDate, DiscountPercent, getdate() AS LoadDate
FROM Staging.Promotion

SELECT COUNT(*) AS DesCount FROM Staging.Promotion
truncate table staging.promotion

-----Promotion EDW-----
USE TescaEDW
CREATE TABLE EDW.DimPromotion
	(
	PromotionSK int identity(1,1),
	PromotionID INT,
	Promotion nvarchar(50),
	StartDate date,
	EndDate date,
	DiscountPercent float,
	EffectiveStartDate datetime,
	constraint EDW_Dimpromotion_sk Primary key(PromotionSK)
	)

SELECT COUNT(*) AS PreCount FROM edw.DimPromotion
SELECT COUNT(*) AS PostCount FROM edw.DimPromotion


----Store Dimesion from OLTP -----
USE TESCAOLTP
SELECT  S.StoreID, s.StoreName, s.StreetAddress, C.CityName, st.State
FROM Store AS S
INNER JOIN City C ON S.CityID = C.CityID
INNER JOIN State AS st ON S.StateID = st.StateID


SELECT  COUNT(*) AS sourceCount
FROM Store AS S
INNER JOIN City C ON S.CityID = C.CityID
INNER JOIN State AS st ON S.StateID = st.StateID


----Store Staging----
use TescaStaging
CREATE TABLE Staging.Store
(
StoreID int,
StoreName nvarchar(50),
StreetAddress nvarchar(50),
CityName nvarchar(50),
State nvarchar(50),
LoadDate datetime default getdate(),
Constraint staging_store_sk Primary key (storeID)
)

SELECT StoreID, StoreName, StreetAddress, CityName, State, getdate as LoadDate FROM staging.store
SELECT COUNT(*) AS DesCount FROM Staging.Store

Truncate Table Staging.Store

-----EDW Store----
use TescaEDW

CREATE TABLE EDW.DimStore
(
StoreSK int identity(1,1),
StoreID int,
StoreName nvarchar(50),
StreetAddress nvarchar(50),
CityName nvarchar(50),
State nvarchar(50),
EffectiveStartDate datetime,
Constraint staging_store_sk Primary key (storeSK)
)

SELECT COUNT(*) AS PreCount FROM EDW.DimStore
SELECT COUNT(*) AS PostCount FROM EDW.DimStore


----Customer Dimesion From OLTP
use TescaOLTP
SELECT c.CustomerID, concat(upper(c.LastName), ',', c.FirstName) AS Customer,  c.CustomerAddress, 
ct.CityName AS City, s.State
FROM Customer AS C
INNER JOIN City AS ct ON C.CityID = ct.CityID
INNER JOIN State AS S ON ct.StateID = s.StateID

SELECT COUNT(*) AS SourceCount
FROM Customer AS C
INNER JOIN City AS ct ON C.CityID = ct.CityID
INNER JOIN State AS S ON ct.StateID = s.StateID

-----Customer Staging-----
use TescaStaging
CREATE TABLE Staging.Customer
(
CustomerID int,
Customer nvarchar(250),
CustomerAddress nvarchar(50), 
City nvarchar(50),
State nvarchar(50),
LoadDate datetime default GETDATE(),
Constraint Staging_Customer_pk Primary key (CustomerID)
)

SELECT CustomerID, Customer, CustomerAddress, City, State, getdate() as LoadDate FROM Staging.Customer

SELECT COUNT(*) AS DesCount Staging.Customer

Truncate Table Staging.Customer


-----EDW Customer-------
USE TescaEDW
CREATE TABLE EDW.DimCustomer
(
CustomerSK int identity(1,1),
CustomerID int,
Customer nvarchar(250),
CustomerAddress nvarchar(50), 
City nvarchar(50),
State nvarchar(50),
EffectiveStartDate datetime,
Constraint EDW_Customer_Sk Primary key (CustomerSK)
)

SELECT COUNT(*) AS PreCount from EDW.DimCustomer
SELECT COUNT(*) AS PostCount from EDW.DimCustomer

select * from edw.DimEmployee
truncate table edw.dimEmployee
Truncate table edw.Fact_overtimeAnalysis


---POSChannel Dimension From OLTP -----
USE TescaOLTP
SELECT p.ChannelID, p.ChannelNo, p.DeviceModel, p.InstallationDate,  p.SerialNo  FROM POSChannel as p

SELECT COUNT(*) AS SourceCount FROM POSChannel as p


---Staging PoSChannel----
use TescaStaging
CREATE TABLE Staging.PoSChannel
(
ChannelID int,
ChannelNo nvarchar(50),
DeviceModel nvarchar(50),
SerialNo nvarchar(50),
InstallationDate date,
LoadDate datetime default getdate(),
Constraint staging_PoSChannel_pk primary key(ChannelID)
)

SELECT ChannelID, ChannelNo, DeviceModel, InstallationDate,  SerialNo, Getdate() AS LoadDate
FROM Staging.PoSChannel

SELECT Count(*) AS DesCount FROM Staging.PoSChannel

Truncate TABLE Staging.PoSChannel


-----EDW PoSChannel------
USE TescaEDW
CREATE TABLE EDW.DimPoSChannel
(
ChannelSK int identity(1,1),
ChannelID int,
ChannelNo nvarchar(50),
DeviceModel nvarchar(50),
SerialNo nvarchar(50),
InstallationDate date,
EffectiveDate datetime,
EffectiveEndDate datetime,
Constraint EDW_PoSChannel_sk primary key(ChannelSK)
)

SELECT COUNT(*) AS PreCount FROM edw.DimPoSChannel
SELECT COUNT(*) AS PostCount FROM edw.DimPoSChannel


---------Employee Dimension Table From OLTP---------- 
USE TescaOLTP
SELECT E.EmployeeID, E.EmployeeNo, CONCAT(UPPER(E.LastName), ',', E.FirstName) AS Employee,  E.DoB, M.MaritalStatus
FROM Employee E
INNER JOIN MaritalStatus M on E.MaritalStatus = M.MaritalStatusID

SELECT COUNT(*) AS SourceCount
FROM Employee E
INNER JOIN MaritalStatus M on E.MaritalStatus = M.MaritalStatusID


----------Staging Employee----------
USE TescaStaging
CREATE TABLE Staging.Employee
(
EmployeeID int,
EmployeeNO Nvarchar(50),
Employee nvarchar(255),
DOB Date,
MaritalStatus Nvarchar(50),
LoadDate datetime default getdate(),
Constraint staging_employee_sk primary key (EmployeeID)
)

SELECT EmployeeID, EmployeeNo, Employee, DOB, MaritalStatus, getdate() as LoadDate  FROM Staging.Employee


SELECT COUNT(*) AS DesCount  FROM Staging.Employee

TRUNCATE TABLE Staging.Employee


USE TescaEDW
CREATE TABLE EDW.DimEmployee
(
EmployeeSK int Identity(1,1),
EmployeeID int,
EmployeeNO Nvarchar(50),
Employee nvarchar(255),
DOB Date,
MaritalStatus Nvarchar(50),
EffectiveStartdate datetime,
EffectiveEndDate datetime,
Constraint EDW_Dimemployee_sk primary key (EmployeeSK)
)


SELECT COUNT(*) AS PreCount  FROM EDW.dimEmployee
SELECT COUNT(*) AS PostCount  FROM EDW.dimEmployee



----------Extracting the Sales Analysis (Fact Table) From OLTP--------- 

USE TescaOLTP
IF (SELECT COUNT(*) FROM TescaEDW.EDW.Fact_SalesAnalysis)<=0
	SELECT S.TransactionID, S.TransactionNO, DATEPART(HOUR, TransDate) AS TransHour, CONVERT(DATE, S.TransDate) 
	AS TransDate, convert(date, s.OrderDate) as OrderDate, DATEPART(Hour, s.OrderDate) as OrderHour,
	convert(date, s.DeliveryDate) as DeliveryDate,
	s.channelID, s.CustomerID, S.EmployeeID, S.ProductID, s.StoreID, s.PromotionID, S.Quantity, S.TaxAmount, S.LineAmount,
	S.LineDiscountAmount, getdate() as LoadDate
	FROM SalesTransaction S WHERE convert(date, TransDate) <= dateadd(day, -1, convert(date, getdate())) 
ELSE
	SELECT S.TransactionID, S.TransactionNO, DATEPART(HOUR, TransDate) AS TransHour, CONVERT(DATE, S.TransDate) 
	AS TransDate, convert(date, s.OrderDate) as OrderDate, DATEPART(Hour, s.OrderDate) as OrderHour,
	convert(date, s.DeliveryDate) as DeliveryDate,
	s.channelID, s.CustomerID, S.EmployeeID, S.ProductID, s.StoreID, s.PromotionID, S.Quantity, S.TaxAmount, S.LineAmount,
	S.LineDiscountAmount, getdate() as LoadDate FROM SalesTransaction as S
	WHERE convert(date, TransDate) = dateadd(day, -1, convert(date, getdate())) 


-----Source Count
IF (SELECT COUNT(*) FROM TescaEDW.EDW.Fact_SalesAnalysis)>=0

	SELECT COUNT(*) AS SourceCount
	FROM SalesTransaction S WHERE convert(date, TransDate) <= dateadd(day, -1, convert(date, getdate())) 
ELSE

	SELECT COUNT(*) AS SourceCount FROM SalesTransaction 
	WHERE convert(date, TransDate) = dateadd(day, -1, convert(date, getdate()))

---------Staging SalesFact----------
USE TescaStaging
CREATE TABLE Staging.SalesAnalysis
(
TransactionID int,
TransactionNO nvarchar(50),
TransDate date,
TransHour int,
OrderDate date,
OrderHour int,
DeliveryDate date,
channelID int,
CustomerID int,
EmployeeID int,
ProductID int,
StoreID int,
PromotionID int,
Quantity float,
TaxAmount float,
LineAmount float,
LineDiscountAmount float,
LoadDate datetime default getdate(),
Constraint Staging_SalesAnalysis_pk primary key (TransactionID)
)
SELECT TransactionID, TransactionNO, TransHour, TransDate, OrderDate, OrderHour, DeliveryDate, channelID, CustomerID, 
EmployeeID, ProductID, StoreID, PromotionID, Quantity, TaxAmount, LineAmount, LineDiscountAmount, Getdate() AS LoadDate
FROM staging.SalesAnalysis

SELECT COUNT(*) AS Descount FROM Staging.SalesAnalysis 

Truncate TABLE Staging.SalesAnalysis


----EDW SalesAnalysis-----
USE TescaEDW
Create table EDW.fact_salesAnalysis
 (
   SalesSk bigint identity(1,1),
   TransactionNo nvarchar(50),
   TransDateSk int,
   TransHourSk int,
   OrderDateSK int, 
   OrderHourSk int,
   DeliveryDateSk int,
   ChannelSK int, 
   CustomerSK int, 
   EmployeeSK int, 
   ProductSK int,
   StoreSk int,
   promotionSk int,    	  
   Quantity float,
  TaxAmount float,
  LineAmount float,
  LineDiscountAmount float,
  LoadDate datetime, 
constraint EDW_Salesanalysis_salesSk primary key(SalesSk),
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

SELECT COUNT(*) AS PostCount From edw.Fact_SalesAnalysis
SELECT COUNT(*) AS PreCount FROM EDW.Fact_SalesAnalysis
