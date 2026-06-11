--SQL Retail Sales Analysis--
CREATE DATABASE sql_project_p1;

--Create Table--
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
       (
			transactions_id INT PRIMARY KEY,
			sale_date Date,	
			sale_time Time,	
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category VARCHAR(15),
			quantiy	INT,
			price_per_unit	FLOAT,
			cogs FLOAT,
			total_sale FLOAT
       );


--DATA CLEANING--
SELECT COUNT(*) FROM retail_sales;
SELECT * FROM retail_sales
LIMIT 10

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE customer_id IS NULL

SELECT * FROM retail_sales
WHERE gender IS NULL

SELECT * FROM retail_sales
WHERE category IS NULL

SELECT * FROM retail_sales
WHERE 
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

--delete null
DELETE FROM retail_sales
WHERE
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL
	OR 
	age IS NULL;

--DATA EXPLORATION (EDA)--

--how many sales we have?
SELECT COUNT(*) total_sale FROM retail_sales

--how many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales 

--how many category and the name of category we have?
SELECT COUNT(DISTINCT category) as total_sale FROM retail_sales 
SELECT DISTINCT category FROM retail_sales 

--DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWER--
-- 1) write a SQL query to retrive all column from sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE 
sale_date = '2022-11-05';

--2) write a SQL query to retrive all transactions where the category is 'clothing' and the quantity sold is greater than or equal to 4 in the month of 'Nov-2022'

SELECT 
*
FROM retail_sales
WHERE category = 'Clothing' 
	AND quantiy >= 4
	AND EXTRACT(YEAR FROM sale_date) = 2022
	AND EXTRACT(MONTH FROM sale_date) = 11;

--3) Write a SQL query to calculate total sales from each category
SELECT
	Category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

--4) Write a SQL query to count the average age of customers who purchase items from 'Beauty' category 
SELECT
	ROUND(AVG(age), 2) AS Average_Age
FROM retail_Sales
WHERE category = 'Beauty';

--5)  Write a SQL query to find all transactions where total_sale is greater than 1000 
SELECT 
*
FROM retail_sales
WHERE total_sale > 1000;

--6)  Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category
SELECT 
	category,
	gender,
	COUNT (*) AS total_transactions
FROM retail_sales
GROUP BY category,
		gender
ORDER BY 1

--7) Write a SQL query to find the average sale for each month and find when the best selling month in each year
--order by month
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS average_sale
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 2;

--order by the highest avg sale 
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS average_sale
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

--order by all
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS average_sale,
	RANK () OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC)
FROM retail_sales
GROUP BY 1, 2

--8)Write a SQL query to find top 5 customers based in highest total scale
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
	
--9) Write a SQL query to find a unique number from customers who purchased item from each category
SELECT
	category,
	COUNT (DISTINCT customer_id) AS unique_number
FROM retail_sales 
GROUP BY category;

--10)Write a SQL query to create each shift and number of orders (example morning <=12, afternoon between 12 & 17, Evening >17)
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    -- (Catatan: Sesuaikan 'sale_time' dengan nama kolom jam di tabel Anda)
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift
ORDER BY number_of_orders DESC;
	