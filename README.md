# Walmart-Analytics---SQL   
**Objective**: To analyze Walmart's sales data to identify patterns, trends, and insights that can be leveraged to optimize revenue, enhance operational efficiency, and improve customer satisfaction.   
**Problem Statement** - How can Walmart optimize its revenue and improve customer satisfaction by analyzing sales data to understand purchasing behaviors, product performance, and operational efficiency across different branches, customer segments, and time periods?

CREATE A DATABASE  
CREATE A TABLE WITH BELOW COLUMNS   
LOAD THE DATA  

```  SQL
--- Create Table 'walmart sales'
CREATE DATABASE IF NOT EXISTS walmartSales;  
USE walmartSales;  
CREATE TABLE IF NOT EXISTS sales( 
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,  
branch VARCHAR(5) NOT NULL,     
city VARCHAR(30) NOT NULL,    
customer_type VARCHAR(30) NOT NULL,   
gender VARCHAR(30) NOT NULL,    
product_line VARCHAR(100) NOT NULL,  
unit_price DECIMAL(10,2) NOT NULL,    
quantity INT NOT NULL,     
tax_pct FLOAT(6,4) NOT NULL,    
total DECIMAL(12, 4) NOT NULL,     
date DATETIME NOT NULL,     
time TIME NOT NULL,     
payment VARCHAR(15) NOT NULL,    
cogs DECIMAL(10,2) NOT NULL,    
gross_margin_pct FLOAT(11,9),    
gross_income DECIMAL(12, 4),      
rating FLOAT(2, 1)   
);  

SELECT * FROM walmartSales.sales;

--- Time Of Day
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

--- Name Of Day

SELECT
	date,
	DAYNAME(date)
FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name = DAYNAME(date);

--- Name of Month

SELECT
	date,
	MONTHNAME(date)
FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales SET month_name = MONTHNAME(date);

--- unique cities
SELECT DISTINCT city FROM sales;

--- unique products
SELECT DISTINCT product_line FROM sales;

--- number of times each payment was used
SELECT payment, COUNT(payment) AS times used FROM sales GROUP BY payment;

--- number of products sold in different product lines
SELECT product_line, SUM(Quantity) AS Number of products FROM sales GROUP BY product_line;

--- monthly revenue
SELECT month_name, SUM(total) AS revenue FROM sales GROUP BY month_name;

--- monthly cost of goods sold
SELECT month_name, SUM(cogs) AS cogs per month FROM sales GROUP BY month_name;

--- Revenue from various product lines 
SELECT product_line, ROUND(SUM(total),2) AS revenue FROM sales GROUP BY product_line;

--- city with most revenue
SELECT city,branch, ROUND(SUM(total),2) AS revenue FROM sales GROUP BY city,branch;

--- Amount of tax applied on various product lines
SELECT product_line, ROUND(AVG(tax_pct),2) AS tax FROM sales GROUP BY product_line;

--- branches selling more than the average number of products sold
SELECT branch, SUM(quantity) AS morethanavg FROM sales GROUP BY branch HAVING (SELECT SUM(quantity)>AVG(quantity) FROM sales);

--- Number of product line sold to each gender
SELECT gender, product_line, COUNT(gender) AS quantity FROM sales GROUP BY gender, product_line ORDER BY product_line;

--- average rating of each product line
SELECT product_line, ROUND(AVG(rating),1) AS Rating FROM sales GROUP BY product_line;

--- no of sales across the day, for each day
SELECT day_name, time_of_day, SUM(quantity) AS total FROM sales GROUP BY day_name,time_of_day ORDER BY day_name DESC;

--- most revenue by customer type
SELECT customer_type, ROUND(SUM(total)) AS revenue FROM sales GROUP BY customer_type;

---  city wise VAT 
SELECT city, ROUND(AVG(tax_pct),1) AS Tax FROM sales GROUP BY city;

--- customer type wise VAT
SELECT customer_type, ROUND(AVG(tax_pct),1) AS Tax FROM sales GROUP BY customer_type;

--- cutomer types
SELECT DISTINCT customer_type FROM sales;

--- payment methods
SELECT DISTINCT payment FROM sales;

--- customer type buying the most
SELECT customer_type, COUNT(customer_type) AS Quantity FROM sales GROUP BY customer_type;

--- gender buying most
SELECT gender, COUNT(gender) AS Quantity FROM sales GROUP BY gender;

--- each gender purchasing from a branch
SELECT branch,gender, COUNT(gender) AS Quantity FROM sales GROUP BY branch, gender ORDER BY branch;

--- Average rating at each time of day
SELECT time_of_day, ROUND(AVG(rating),2) AS Rating FROM sales GROUP BY time_of_day;

--- Average ratings each day
SELECT day_name, ROUND(AVG(rating),2) AS Rating FROM sales GROUP BY day_name;

--- Average rating of each day on every branch
SELECT day_name,branch, ROUND(AVG(rating),2) AS Rating FROM sales GROUP BY day_name,branch ORDER BY branch;

```

** THANK YOU **
