--Project Retail_Sales_Analysis

CREATE DATABASE Retail_Sales_Analysis

GO

use Retail_Sales_Analysis


DROP TABLE IF EXISTS Retail_Sales
create table Retail_Sales (
					transactions_id int PRIMARY KEY
					, sale_date date
					, sale_time time
					, customer_id int
					, gender varchar(15)
					, age int
					, category varchar(100)
					, quantity int
					, price_per_unit float
					, cogs float
					, total_sale float
)

--BULK INSERT Retail_Sales
--FROM 'C:\Users\rudhr\Downloads\SQL_Prac\Retail-Sales-Analysis-SQL-Project--P1\SQL - Retail Sales Analysis_utf.csv'
--WITH (
--    FIELDTERMINATOR = ',',  -- Separator
--    ROWTERMINATOR = '\n',   -- New line
--    FIRSTROW = 2            -- Skip header row
--);


select * from Retail_Sales
where 
transactions_id is null 
or sale_date is null 
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null

select * from Retail_Sales
where sale_date is null

-- Data Cleaning

delete from Retail_Sales
where 
transactions_id is null 
or sale_date is null 
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null

select COUNT(1) from Retail_Sales

-- Data Exploration

-- How many sales we have

select COUNT(1) total_sales from Retail_Sales

-- How many unique customers we have

select count(DISTINCT customer_id) total_customers from Retail_Sales

-- How many unique categories we have

select count(DISTINCT category) total_category from Retail_Sales


-- Data Analysis, Business Key Problems and Solutions

-- Q1) Write a SQL QUery to retrive all the records for the sales made on 2022-11-05

select * from Retail_Sales where sale_date='2022-11-05'

-- Q2) Write a SQL Queeery to retrive all the transactions where the category is 'Clothing' 
--and the quantity sold is more than 3 in the month of Nov-2022

select * 
from Retail_Sales 
where category='Clothing'
and FORMAT(sale_date,'MM-yyyy')='11-2022' and quantity>3

-- Q3) Write a SQL Query to calculate the total sales(total_sales) for each category

select 
category
,SUM(total_sale) as total_sales
,COUNT(total_sale) as total_sales
from 
Retail_Sales
group by category

-- Q4) Write a SQL Query to find the average age of customers who purchased items from the 'Beauty' category

select AVG(age) as average_age from Retail_Sales
where category='Beauty'

-- Q5) Write a SQL QUeery to find all transactions where total sales is greater than 1000

select * from Retail_Sales
where total_sale>1000

-- Q6) Write a SQL Query to find the total number of transactions (transaction_id) made by each gender 
--in each category

select gender,category,COUNT(1) total_Transactions  from Retail_Sales
group by gender,category
order by gender,category

-- Q7) Write a sQL query to calculate the average sale for each month. FInd out best selling month in each year

select Month,Year,average_sale from (
select FORMAT(sale_date,'yyyy') as Year,FORMAT(sale_date,'MM') as Month,AVG(total_sale) as average_sale 
, RANK() OVER (Partition by FORMAT(sale_date,'yyyy') order by AVG(total_sale) desc) T_Rank
from Retail_Sales
group by FORMAT(sale_date,'yyyy'),FORMAT(sale_date,'MM')
) as table1
where T_Rank=1

-- Q8) Write a SQL Query to find the top 5 customers based on the highest total sales

select TOP 5 customer_id,SUM(total_sale) as Tot_Sale from Retail_Sales
group by customer_id
order by Tot_Sale Desc

select * from (
select customer_id,SUM(total_sale) as Tot_Sale 
, ROW_NUMBER() over (ORDER by SUM(total_sale) desc) as T_Rank
from Retail_Sales
group by customer_id
--order by Tot_Sale Desc
) as Tab1
where T_Rank<=5

-- Q9) Write a SQL Query to find the number of unique customers who purchased items from each category

select category,COUNT(distinct customer_id) as u_customer from Retail_Sales
group by category

-- Q10) Write a SQL Query to create each shift and number of orders (Example Morning <=12, Afternoon between 12 and 17, Evening > 17)


;with shifts as (
select 
case 
	when DATEPART(hour,sale_time) between 0 and 11
	then 'Morning'
	when DATEPART(hour,sale_time) between 12 and 17
	then 'Afternoon'
	else 'Evening'
end as Shifts
from Retail_Sales
)

select Shifts,COUNT(1) as Total_Orders from shifts
group by Shifts

-- END OF PROJECT