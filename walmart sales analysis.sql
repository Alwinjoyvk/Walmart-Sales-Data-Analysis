
--- Walmart Sales Data Analysis ------


---- Data Wrangling ----------------------

----- Build a database -------------------

CREATE DATABASE WALMARTSALESDATA;

----- Create table and insert the data -----
----- we set NOT NULL for each field, hence null values are filtered out -----


USE  WALMARTSALESDATA;


CREATE TABLE  IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city Varchar(30) NOT NULL,
customr_type Varchar(30) NOT NULL,
gender Varchar(10) NOT NULL,
product_line Varchar(100) NOT NULL,
unit_price Decimal(10,2) NOT NULL,
quantity INT NOT NUll,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
Cogs DECIMAL (10,2)  NOT NULL,
gross_margin_pct FLOAT(11, 9),
gross_income DECIMAL(12, 4) NOT NULL,
rating FLOAT(2,1)
);

----- Feature Engineering --------------
----- Add a new column named time_of_day to give insight of sales in the Morning -----

ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);
SET SQL_SAFE_UPDATES=0;

UPDATE sales
SET time_of_day = (CASE
    WHEN TIME(time) BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
    ELSE 'Evening'
END);

----- Add a new column named day_name that contains the extracted days of the week -----

ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

----- Add a new column named month_name that contains the extracted months of the year -----

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = MONTHNAME(date);

-- Exploratory Data Analysis (EDA) --

-- Generic Question --

----- How many unique cities does the data have? ----

SELECT  COUNT(DISTINCT city) AS UNIQUE_CITIES
FROM SALES;

----- In which city is each branch? ----

SELECT  DISTINCT city,branch
FROM SALES;

----- Product ----
----- How many unique product lines does the data have? ----

SELECT COUNT(DISTINCT product_line) AS unique_product_lines
FROM SALES;

----- What is the most common payment method? ----

SELECT payment_method AS common_payment, COUNT(payment_method) as cnt
FROM SALES
GROUP BY payment_method
order by cnt desc
limit 1;

------ What is the most selling product line? -----

SELECT product_line AS  top_seller, count( quantity) as cnt
FROM SALES
GROUP BY  product_line
order by cnt desc
limit 1;

------ What is the total revenue by month? -----

SELECT product_line, SUM(quantity) AS total_quantity_sold
FROM sales
GROUP BY product_line
ORDER BY total_quantity_sold DESC
LIMIT 1;

------ What month had the largest COGS? -----

SELECT month_name,MAX(COGS) AS largest_COGS
FROM sales
GROUP BY month_name
ORDER BY largest_COGS DESC
LIMIT 1;

------ What is the most selling product line? -----

SELECT month_name AS month, SUM(COGS) AS COGS
FROM sales
GROUP BY month_name
ORDER BY COGS DESC
LIMIT 1;

------ What product line had the largest revenue? -----

SELECT product_line ,SUM(total) AS LARGEST_REVENUE
FROM SALES
GROUP BY  product_line
ORDER BY  LARGEST_REVENUE DESC
LIMIT 1;

------ What is the city with the largest revenue? -----

SELECT CITY ,SUM(total) AS LARGEST_REVENUE
FROM SALES
GROUP BY CITY
ORDER BY  LARGEST_REVENUE DESC
LIMIT 1;

------ What product line had the largest VAT?-----

SELECT product_line, AVG(VAT) AS total_VAT
FROM sales
GROUP BY product_line
ORDER BY total_VAT DESC
LIMIT 1;

------ Which branch sold more products than average product sold? -----

SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity)>(SELECT AVG(QUANTITY) FROM sales);


------ What is the most common product line by gender?-----

SELECT gender, product_line, COUNT(gender) AS count
FROM sales
GROUP BY gender, product_line
ORDER BY  count DESC;

------ What is the most selling product line? -----

SELECT product_line, AVG(rating) AS Avg_rating
FROM sales
GROUP BY product_line
ORDER BY Avg_rating DESC;


------ Sales ---

------ Number of sales made in each time of the day per weekday -----


SELECT  day_name,time_of_day,
    COUNT(*) AS sales_count
FROM 
    sales
GROUP BY 
    day_name, time_of_day
ORDER BY  sales_count DESC;

------ Which of the customer types brings the most revenue? -----
    
SELECT customr_type,SUM(total) AS total_revenue
from sales
GROUP BY customr_type
ORDER BY  total_revenue DESC
LIMIT 1;

------ Which city has the largest tax percent/ VAT (Value Added Tax)?-----

SELECT CITY ,AVG(VAT) AS LARGEST_VAT
FROM SALES
GROUP BY CITY
ORDER BY  LARGEST_VAT DESC
LIMIT 1;

------ Which customer type pays the most in VAT?-----


SELECT customr_type,AVG(VAT) AS VAT
from sales
GROUP BY customr_type
ORDER BY  VAT DESC
LIMIT 1;

------ Customer -----

------ How many unique customer types does the data have? -----

SELECT COUNT(DISTINCT customr_type) AS unique_customer
from sales;

------ WHow many unique payment methods does the data have? -----

SELECT COUNT(DISTINCT payment_method) AS payment_methods
from sales;

------ What is the most common customer type? -----

SELECT customr_type,COUNT( customr_type) AS count
from sales
GROUP BY customr_type
ORDER BY count DESC
Limit 1;

------ Which customer type buys the most? -----

SELECT gender,COUNT(gender) AS cnt
from sales
GROUP BY gender
ORDER BY cnt DESC
Limit 1;

------ What is the gender distribution per branch? -----


SELECT  branch,gender,
    COUNT(*) AS ditribution
FROM 
    sales
GROUP BY branch,gender
ORDER BY  branch ;

------ Which time of the day do customers give most ratings? -----

SELECT  time_of_day,AVG(rating)
FROM sales
GROUP BY  time_of_day
ORDER BY AVG(rating) desc
LIMIT 1;

------ Which time of the day do customers give most ratings per branch? -----

SELECT  branch,time_of_day,AVG(rating)
FROM sales
GROUP BY branch, time_of_day
ORDER BY AVG(rating) desc;

------ Which day fo the week has the best avg ratings? -----

SELECT day_name,AVG(rating) as avg_rating
FROM sales
GROUP BY day_name
ORDER BY AVG(rating) desc
limit 1;

------ Which day of the week has the best average ratings per branch?-----

SELECT branch,day_name,AVG(rating) as avg_rating
FROM sales
GROUP BY branch,day_name
ORDER BY branch ;



