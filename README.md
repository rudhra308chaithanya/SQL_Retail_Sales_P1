# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql

-- START OF PROJECT

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
```
**-- Q1) Write a SQL QUery to retrive all the records for the sales made on 2022-11-05:**
```sql
select * from Retail_Sales where sale_date='2022-11-05'
```
**-- Q2) Write a SQL Queeery to retrive all the transactions where the category is 'Clothing' 
--and the quantity sold is more than 3 in the month of Nov-2022**
```sql

select * 
from Retail_Sales 
where category='Clothing'
and FORMAT(sale_date,'MM-yyyy')='11-2022' and quantity>3
```
**-- Q3) Write a SQL Query to calculate the total sales(total_sales) for each category**
```sql
select 
category
,SUM(total_sale) as total_sales
,COUNT(total_sale) as total_sales
from 
Retail_Sales
group by category
```
**-- Q4) Write a SQL Query to find the average age of customers who purchased items from the 'Beauty' category**
```sql
select AVG(age) as average_age from Retail_Sales
where category='Beauty'
```
**-- Q5) Write a SQL QUeery to find all transactions where total sales is greater than 1000**
```sql
select * from Retail_Sales
where total_sale>1000
```
**-- Q6) Write a SQL Query to find the total number of transactions (transaction_id) made by each gender 
--in each category**
```sql
select gender,category,COUNT(1) total_Transactions  from Retail_Sales
group by gender,category
order by gender,category
```
**-- Q7) Write a sQL query to calculate the average sale for each month. FInd out best selling month in each year**
```sql
select Month,Year,average_sale from (
select FORMAT(sale_date,'yyyy') as Year,FORMAT(sale_date,'MM') as Month,AVG(total_sale) as average_sale 
, RANK() OVER (Partition by FORMAT(sale_date,'yyyy') order by AVG(total_sale) desc) T_Rank
from Retail_Sales
group by FORMAT(sale_date,'yyyy'),FORMAT(sale_date,'MM')
) as table1
where T_Rank=1
```
**-- Q8) Write a SQL Query to find the top 5 customers based on the highest total sales**
```sql
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
```
**-- Q9) Write a SQL Query to find the number of unique customers who purchased items from each category**
```sql
select category,COUNT(distinct customer_id) as u_customer from Retail_Sales
group by category
```
**-- Q10) Write a SQL Query to create each shift and number of orders (Example Morning <=12, Afternoon between 12 and 17, Evening > 17)**
```sql

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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

Thank you for your support, and I look forward to connecting with you!



