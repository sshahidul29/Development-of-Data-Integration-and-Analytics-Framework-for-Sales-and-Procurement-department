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
