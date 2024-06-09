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
#-------
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

	
#----------
SELECT
	date,
	DAYNAME(date)
FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name = DAYNAME(date);
#------------
SELECT
	date,
	MONTHNAME(date)
FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales SET month_name = MONTHNAME(date);

#uniquecities #branch
SELECT DISTINCT city,branch FROM sales;

#distinctproducts
SELECT DISTINCT product_line FROM sales;

#maxpaymentmethods
SELECT payment, COUNT(payment) FROM sales GROUP BY payment;

#mostsellingproducts
SELECT SUM(Quantity), product_line FROM sales GROUP BY product_line;

#totalrevenuebymonth
SELECT month_name, SUM(total) FROM sales GROUP BY month_name;

#mostcogsbymonth
SELECT month_name, SUM(cogs) FROM sales GROUP BY month_name;

#mostsellingproduct
SELECT product_line, ROUND(SUM(total),2) FROM sales GROUP BY product_line;

#citywithmostrevenue
SELECT city,branch, ROUND(SUM(total),2) AS revenue FROM sales GROUP BY city,branch;

#mostVAT
SELECT product_line, ROUND(AVG(tax_pct),2) AS tax FROM sales GROUP BY product_line;

#branchwithmostavgproducts
SELECT branch, SUM(quantity) AS morethanavg FROM sales GROUP BY branch HAVING (SELECT SUM(quantity)>AVG(quantity) FROM sales);

#famousproductgender
SELECT gender, product_line, COUNT(gender) FROM sales GROUP BY gender, product_line;

#avgratingofproduct
SELECT product_line, ROUND(AVG(rating),1) FROM sales GROUP BY product_line;

#noofsalesacrossthedayperweekday
SELECT day_name, time_of_day, SUM(quantity) AS total FROM sales GROUP BY day_name,time_of_day ORDER BY day_name DESC;

#mostrevenuebbycustomertype
SELECT customer_type, ROUND(SUM(total)) FROM sales GROUP BY customer_type;

#citypayingmostVAT
SELECT city, ROUND(AVG(tax_pct),1) FROM sales GROUP BY city;

#customertypepayingmostVAT
SELECT customer_type, ROUND(AVG(tax_pct),1) FROM sales GROUP BY customer_type;

#uniquecustomers
SELECT DISTINCT customer_type FROM sales;

#uniquepayments
SELECT DISTINCT payment FROM sales;

#mostcommonpayment
SELECT payment, COUNT(payment) FROM sales GROUP BY payment;

#customertypebuyingmost
SELECT customer_type, COUNT(customer_type) FROM sales GROUP BY customer_type;

#genderbuyingmost
SELECT gender, COUNT(gender) FROM sales GROUP BY gender;

#genderbybranch
SELECT branch,gender, COUNT(gender) FROM sales GROUP BY branch, gender ORDER BY branch;

#timeofdaymostratings
SELECT time_of_day, ROUND(AVG(rating),2) FROM sales GROUP BY time_of_day;

#timeofdaymostratingsperbranch
SELECT time_of_day, branch, ROUND(AVG(rating),2) FROM sales GROUP BY time_of_day,branch;

#bestratingsonwhichday
SELECT day_name, ROUND(AVG(rating),2) FROM sales GROUP BY day_name;

#bestratingsonwhichdayperbranch
SELECT day_name,branch, ROUND(AVG(rating),2) FROM sales GROUP BY day_name,branch ORDER BY branch;

