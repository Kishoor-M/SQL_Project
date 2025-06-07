create  database  My_project
use My_project

select  * from [Amazon Sale Report]


alter  table [Amazon Sale Report] 
drop column Unnamed_22 

alter  table [Amazon Sale Report] 
drop column [index] , [promotion_ids]

alter  table [Amazon Sale Report]
drop column fulfilled_by
--SORT THE DATE 
select  * from [Amazon Sale Report]
ORDER BY Date DESC;

-- To  Get uniuqe value 
select DISTINCT
az.Style,
az.SKU,
az.Category
from [Amazon Sale Report] as az


-- Check null
select * from [Amazon Sale Report] as a
WHERE Order_ID IS NULL
	OR a.Order_ID IS NULL
	OR a.Date IS NULL
	OR a.Fulfilment IS NULL
	OR a.Style IS NULL
	OR a.SKU IS NULL
	OR a.category IS NULL
	OR a.Amount IS NULL
	OR a.ship_city IS NULL
	OR a.ship_state IS NULL
	OR a.ship_postal_code IS NULL
	OR a.ship_country IS NULL;
	

--UPDATE THE NULL 

UPDATE A 
SET 
	A.ship_city='Unknow',
	A.ship_state ='Unknow' ,
	--A.ship_postal_code='Unknow',
	A.ship_country='Unknow'

FROM [Amazon Sale Report] AS A
 WHERE A.ship_city IS NULL
	OR a.ship_state IS NULL
--	OR a.ship_postal_code IS NULL
	OR a.ship_country IS NULL ;

--update the null values( float)

UPDATE A
SET A.ship_postal_code = '000000'
FROM [Amazon Sale Report] AS A
WHERE A.ship_postal_code  IS NULL



-- To analyse only shipped data & sales channel
DROP TABLE IF EXISTS [Amazon Sale Report New];
GO
	
SELECT *
INTO [Amazon Sale Report New]
FROM [Amazon Sale Report] AS AZ
WHERE AZ.Status ='Shipped' 
	AND AZ.Sales_Channel ='Amazon.in'
	AND AZ.Courier_Status ='Shipped'
	AND AZ.ship_city != 'Unknow';

SELECT * 
FROM [Amazon Sale Report New]
ORDER BY Date ASC ;


-- to view the table 

select * from [Amazon Sale Report New] 
ORDER BY CAST([Date] AS DATE) ASC;

SELECT  COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Amazon Sale Report New';

--TOTALL SALE BY MONTHLY,YEARLY

SELECT 
	FORMAT(Date,'yyyy-MM') AS ORDER_DATE,
	SUM(Amount) AS TOTAL_SALE
FROM [Amazon Sale Report New]
GROUP BY FORMAT(Date,'yyyy-MM' )
ORDER BY ORDER_DATE;

SELECT 
	FORMAT(Date,'yyyy') AS ORDER_DATE,
	SUM(Amount) AS TOTAL_SALE
FROM [Amazon Sale Report New]
GROUP BY FORMAT(Date,'yyyy' )
ORDER BY ORDER_DATE;
 --  TOTAL SALE WITH CATEGORY
SELECT 
	FORMAT(Date,'yyyy-MM') AS ORDER_DATE,
	Category,
	SUM(Amount) AS TOTAL_SALE
	FROM [Amazon Sale Report New]
GROUP BY FORMAT(Date,'yyyy-MM' ),Category
ORDER BY ORDER_DATE;


SELECT 
	FORMAT(Date,'yyyy') AS ORDER_DATE,
	Category,
	SUM(Amount) AS TOTAL_SALE
	
FROM [Amazon Sale Report New]
GROUP BY FORMAT(Date,'yyyy' ),Category
ORDER BY ORDER_DATE, TOTAL_SALE DESC;

-- TOP SALE PRODUCT 

SELECT TOP 5 
	AZ.Category,
	COUNT(AZ.Qty) AS  TOTAL_QTY
FROM [Amazon Sale Report New] AS AZ
GROUP BY AZ.Category
ORDER BY COUNT(AZ.Qty) DESC;

--TOP SELLING PRDUCT - STYLE

SELECT TOP 15
AZ.Style,
AZ.Category,
COUNT(AZ.Style) AS TOTAL_COUNT
FROM [Amazon Sale Report New] AS AZ
GROUP BY AZ.Style,AZ.Category
ORDER BY COUNT(AZ.Style) DESC;


SELECT *
FROM [Amazon Sale Report New]

SELECT 
	AZ.Category,
	AZ.Size,
	COUNT(AZ.Size) AS TOTAL_COUNT 
FROM [Amazon Sale Report New] AS AZ
GROUP BY  AZ.Size ,AZ.Category
ORDER BY AZ.Category,Size ;

SELECT 
	AZ.Category,
	AZ.Size,
	SUM(AZ.Qty) AS TOTAL_QTY 
FROM [Amazon Sale Report New] AS AZ
GROUP BY  AZ.Size ,AZ.Category
ORDER BY AZ.Category,Size ;

SELECT 
	AZ.ship_state,
	SUM(AZ.Amount) AS TOTAL_SALE
	
FROM [Amazon Sale Report New] AS AZ
GROUP BY AZ.ship_state
ORDER  BY TOTAL_SALE DESC;


SELECT 
	AZ.ship_state,
	AZ.Category,
	SUM(AZ.Amount) AS TOTAL_SALE
	
FROM [Amazon Sale Report New] AS AZ
GROUP BY AZ.ship_state, AZ.Category
ORDER  BY ship_state,Category

SELECT top 5 AZ.Order_ID,
AZ.Date,
AZ.Style,
AZ.SKU,
AZ.Category,
AZ.Size,
AZ.Qty,
AZ.Amount,
AZ.ship_state,
ISR.CUSTOMER,
ISR.GROSS_AMT
FROM [Amazon Sale Report New] AS AZ
LEFT  JOIN [International sale Report] AS ISR
ON AZ.Style = ISR.Style;

SELECT TOP 5 * FROM [International sale Report];
SELECT TOP 5 * FROM [Amazon Sale Report New];


	
SELECT *
INTO [Amazon Sale International]
FROM
(
SELECT  AZ.Order_ID,
AZ.Date,
AZ.Style,
AZ.SKU,
AZ.Category,
AZ.Size,
AZ.Qty,
AZ.Amount,
AZ.ship_state,
ISR.CUSTOMER,
ISR.GROSS_AMT
FROM [Amazon Sale Report New] AS AZ
LEFT  JOIN [International sale Report] AS ISR
ON AZ.Style = ISR.Style )  as new

SELECT TOP 5 *
FROM  [Amazon Sale International];

SELECT 
	FORMAT(DATE,'yyy-MM') AS ORDER_DATE,
	SUM(AI.GROSS_AMT) TOTAL_SALES
FROM [Amazon Sale International] AS AI
GROUP BY FORMAT(DATE,'yyy-MM')
ORDER BY ORDER_DATE;

SELECT 
	FORMAT(DATE,'yyyy') AS ORDER_YEAR,
	SUM(AI.Amount) AS TOTAL_SALES 
FROM [Amazon Sale International] AS AI
GROUP BY FORMAT(DATE,'yyyy') 
ORDER BY ORDER_YEAR;


SELECT  TOP 5
	AI.Category,
	COUNT(AI.Qty) AS TOTAL_QTY,
	RANK() OVER(ORDER BY COUNT(AI.Qty) DESC) AS   TOP_RANK
FROM [Amazon Sale International] AS AI
GROUP BY AI.Category
ORDER BY COUNT(AI.Qty) DESC;

SELECT  TOP 20
	AI.Style,
	AI.Category,
	COUNT(AI.Style) AS TOTAL_COUNT,
	RANK() OVER(ORDER BY COUNT(AI.Style) DESC ) AS RANK
FROM [Amazon Sale International] AS AI 
GROUP BY AI.Style, AI.Category
ORDER BY COUNT(AI.Style) DESC;




