# Walmart-Analytics---SQL   
**Objective** -    
To analyze Walmart's sales data to identify patterns, trends, and insights that can be leveraged to optimize revenue, enhance operational efficiency, and improve customer satisfaction.   
**Problem Statement** -    
How can Walmart optimize its revenue and improve customer satisfaction by analyzing sales data to understand purchasing behaviors, product performance, and operational efficiency across different branches, customer segments, and time periods?

# CODE

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

--- average of monthly cost of goods sold
WITH cte AS 
(SELECT month_name, SUM(cogs) AS average FROM sales GROUP BY month_name)
SELECT ROUND(AVG(average),2) FROM cte;

--- Revenue from various product lines 
SELECT product_line, ROUND(SUM(total),2) AS revenue FROM sales GROUP BY product_line;

--- city with most revenue
SELECT city,branch, ROUND(SUM(total),2) AS revenue FROM sales GROUP BY city,branch;

--- Amount of tax collection on various product lines
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

---  city wise VAT collection
SELECT city, ROUND(AVG(tax_pct),1) AS Tax FROM sales GROUP BY city;

--- customer type wise VAT collection
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

# Key Business Insights

* Revenue Analysis:   
  Total Monthly Revenue: Analyzed total monthly revenue with peaks observed in certain months, highlighting seasonality in sales.   
  Product Line Revenue: Identified that 'Food and Beverages' is the product line with the highest revenue generated a total of $56144.84   

* Customer and Sales Insights:   
  Customer Type Contribution: Found that member customers contributed to 60% of the total revenue, amounting to $163625.  
  Gender-Based Sales: Analyzed sales distribution, revealing that female customers accounted for 55% of total purchases, amounting to $166391.   

* Payment Methods:   
  Usage Frequency: Discovered that Cash payments were used in 35% of transactions, while E-wallets accounted for 34% and Credit Card Payments for 31%.   
  Revenue Contribution: Calculated that transactions made via credit cards contributed to 50% of the total revenue.   

* Product Line Performance:   
  Quantity Sold: Determined that the electronics accessories product line had the highest number of units sold, totaling 961 units.   
  Average Rating: Found that the Food & Beverages product line had the highest average customer rating of 7 out of 10.   

* Cost Analysis and Tax:     
  Monthly COGS: Analyzed the monthly cost of goods sold (COGS), identifying a consistent pattern with an average monthly COGS of $101868.
  Tax: 5% Tax applied on all products as VAT.
     
* Operational Insights:   
  Branch Performance: Identified the top-performing branch as 'C' Branch, which generated $110490.   
  Sales Distribution by Time of Day: Found that 40% of sales occurred in the afternoon, indicating peak shopping hours.   

* Customer Satisfaction:     
  Customer Ratings: Found that customer satisfaction was highest for 'C' Branch with an average rating of 7.06 on 10.



  # Recommendations

* Revenue Optimization:   

1. Focus on High-Revenue Product Lines:   

    Recommendation: Increase inventory and marketing efforts for high-revenue product lines such as 'Food and Beverages'.   
    Action: Develop targeted promotions and bundle offers for these product lines to boost sales further.   

2. Optimize Pricing Strategies:   

    Recommendation: Implement dynamic pricing strategies based on demand patterns identified in the monthly revenue analysis.   
    Action: Adjust prices during peak seasons to maximize revenue while offering discounts during off-peak periods to maintain steady sales.   

* Customer Satisfaction:   

1. Enhance Customer Experience for High-Value Segments:   

    Recommendation: Focus on member customers who contributed 60% of the total revenue.   
    Action: Offer loyalty programs, personalized services, and exclusive deals to retain member customers and attract normal customers.   

2. Improve Ratings for Low-Rated Product Lines:   

    Recommendation: Address issues in product lines with low customer ratings, such as by improving product quality or providing better customer support.   
    Action: Conduct surveys and gather feedback to identify specific areas for improvement.   


* Operational Efficiency:

1. Align Staffing with Peak Sales Periods:   

    Recommendation: Adjust staffing levels based on the sales distribution analysis, which shows most of sales occur in the evening.   
    Action: Increase staff during peak hours to ensure smooth operations and better customer service.   

2. Replicate Success of High-Performing Branches:   

    Recommendation: Analyze the practices of top-performing branch which is 'C' branch and understand what they are doing right.   
    Action: Implement best practices from these branches across other locations to improve overall performance.   

* Product Performance:   

1. Promote High-Rated Products:   

    Recommendation: Highlight and promote product lines with the highest average customer ratings, such as 'Food and Beverages' with a rating of 7 out of 10.   
    Action: Use these ratings in marketing campaigns to attract more customers and build trust in product quality.   

2. Address Underperforming Products:   

    Recommendation: Identify and analyze underperforming products to understand the reasons behind their low sales.   
    Action: Consider discontinuing low-performing products or rebranding and repositioning them in the market.   

* Payment Method Optimization:   

1. Encourage Preferred Payment Methods:   

    Recommendation: Promote the use of credit cards and E-Wallets to access faster payments, pushing incentives like rewards, discounts to attract customers ad driving sales.    
    Action: Offer discounts or cashback incentives for customers using preferred payment methods.      

2. Streamline Payment Processing:   

    Recommendation: Improve the efficiency of payment processing systems to handle the high volume of transactions through popular payment methods.   
    Action: Invest in technology and infrastructure to ensure a seamless payment experience for customers.   

* Cost Management:

1. Monitor and Optimize COGS:   

    Recommendation: Regularly review and manage the cost of goods sold (COGS) to maintain profitability.   
    Action: Negotiate better terms with suppliers and optimize inventory management to reduce costs.   

2. Optimize Tax Strategies:   

    Recommendation: Utilize insights from the average tax rate analysis to optimize pricing and tax strategies.   
    Action: Adjust prices to reflect tax implications and explore tax-saving opportunities where applicable.   

