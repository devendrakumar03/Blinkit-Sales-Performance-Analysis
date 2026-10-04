use blinkitdb;
Select * from blinkit_data;

Select count(*) from blinkit_data;
-- DATA CLEANING
Update blinkit_data
SET Item_Fat_Content=
CASE 
WHEN Item_Fat_Content IN ('LF','low fat') then 'Low Fat'
When Item_Fat_Content ='reg' then 'Regular'
Else Item_Fat_Content
End;

Select distinct(Item_Fat_Content) from blinkit_data;

-- FRIST KPI (TOTAL SALES)
SELECT CAST(SUM(Sales)/1000000 as decimal(10,2)) as Total_Sales_Millions from blinkit_data;
-- SECOND KPI (AVERAGE SALES)
Select CAST(Avg(sales) AS DECIMAL (10,0)) as Avg_Sales from blinkit_data;
-- THIRD KPI( NO. OF ITEMS)
select sum(sales) from blinkit_data where Item_Fat_Content='Low Fat';
-- FOURTH KPI (AVERAGE RATING)
select cast(avg(rating) as decimal (10,0)) as avg_rating from blinkit_data;

-- EDA
select Item_Fat_Content, 
cast(Sum(sales) as decimal(10,0))as total_sales,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as no_of_items,
cast(avg(rating) as decimal(10,2))as avg_rating
from blinkit_data 
where Outlet_Establishment_Year=2022
group by Item_Fat_Content
ORDER BY total_sales DESC;

select top 5 Item_Type, 
cast(Sum(sales) as decimal(10,0))as total_sales,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as no_of_items,
cast(avg(rating) as decimal(10,2))as avg_rating
from blinkit_data 
where Outlet_Establishment_Year=2022
group by Item_Type
ORDER BY total_sales DESC;


select Item_Fat_Content,Outlet_Location_Type,
cast(Sum(sales) as decimal(10,0))as total_sales,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as no_of_items,
cast(avg(rating) as decimal(10,2))as avg_rating
from blinkit_data 
group by Item_Fat_Content,Outlet_Location_Type;

select Outlet_Location_Type,
isnull([Low Fat],0) as Low_Fat,
isnull([Regular],0) as Regular
from 
(select Outlet_Location_Type,Item_Fat_Content,
cast(sum(Sales) as decimal(10,2)) as total_sales
from blinkit_data
group by Outlet_Location_Type,Item_Fat_Content) 
as sourcetable
pivot 
(
sum(total_sales)
for Item_Fat_Content in ([Low Fat],[Regular])
) as pivottable
order by Outlet_Location_Type;

select Outlet_Establishment_Year,
cast(Sum(sales) as decimal(10,0))as total_sales,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as no_of_items,
cast(avg(rating) as decimal(10,2))as avg_rating
from blinkit_data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year asc;

SELECT
    Outlet_Size,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        (SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) 
        AS DECIMAL(10,2)
    ) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;
select Outlet_Location_Type, sum(sales)
from blinkit_data
group by Outlet_Location_Type;

select Outlet_Type,
cast(Sum(sales) as decimal(10,0))as total_sales,
cast(avg(sales) as decimal(10,2)) as avg_sales,
count(*) as no_of_items,
cast(avg(rating) as decimal(10,2))as avg_rating
from blinkit_data
GROUP BY Outlet_Type;
