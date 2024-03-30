create database  SalesDataWalmart;

USE SalesDataWalmart
GO


Create table WMsales (
	invoice_id  varchar(100) Not null primary Key,
	branch  varchar (100) not null,
    customer_type varchar (100) not null,
    gender  varchar(100) not null,
    product_line varchar (100) not null,
    unit_price  decimal(10,2) not null,
    quantity int not null,
    VAT  float not null,
    total decimal (12,4) not null,
    date datetime not null,
    time TIME not null,
    payment_method varchar (100)  not null, 
    cogs  decimal (10, 2) not null,
    gross_margin_pct float,
    gross_income decimal(12, 4) not null,
    rating float,
	
);

USE SalesDataWalmart
GO
Create table StoreName (
  city varchar (30) not null,
  branch varchar(100) not null primary key,
      );

Select *
From WMsales

Select *
From StoreName

-- Add the foreign key constraint
ALTER TABLE WMsales
ADD CONSTRAINT Branch
FOREIGN KEY (Branch)
REFERENCES StoreName(Branch);


-- Add the column
ALTER TABLE WMsales
ADD timeofday VARCHAR(30);

-- Update the values
UPDATE WMsales
SET timeofday = (
    CASE 
        WHEN [time] BETWEEN '00:00:00.0000000' AND '12:00:00.0000000' THEN 'Morning'
        WHEN [time] BETWEEN '12:00:01.0000000' AND '17:59:59.0000000' THEN 'Afternoon'
        ELSE 'Evening' 
    END
);

Select *
From WMsales

-- Add day_name column
ALTER TABLE WMsales
ADD day_name VARCHAR(10);

-- Update day_name column
UPDATE WMsales
SET day_name = DATENAME(dw, date);

-- Add month_name column
ALTER TABLE WMsales
ADD month_name VARCHAR(15);

-- Update month_name column
UPDATE WMsales
SET month_name = FORMAT(date, 'MMMM');

-- Select all columns from wmsales
SELECT * 
FROM WMsales as w
INNER JOIN StoreName as s ON s.branch=w.branch;


----------------------------------- Generic Question -----------------------------------

-- 1. How many unique cities does the data have?
SELECT DISTINCT city
FROM wmsales as w
INNER JOIN StoreName as s ON w.branch=s.branch ;

-- 2. In which city is each branch?
SELECT DISTINCT s.city, w.branch
FROM wmsales as w
INNER JOIN StoreName as s ON w.branch=s.branch ;

---------------------------------------------- Product ----------------------------------------------

-- 1. How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) as No_Of_Products
FROM wmsales;

-- 2. What is the most common payment method?
SELECT payment_method, COUNT(payment_method) AS cnt
FROM wmsales
GROUP BY payment_method
ORDER BY cnt DESC;

-- 3. What is the most selling product line?
SELECT product_line, COUNT(product_line) AS cnt
FROM wmsales
GROUP BY product_line
ORDER BY cnt DESC;

-- 4. What is the total revenue by month?
SELECT month_name AS Month, SUM(total) AS Total_Revenue 
FROM wmsales
GROUP BY month_name
ORDER BY Total_Revenue DESC;

-- 5. What month had the largest COGS?
SELECT month_name AS month, SUM(cogs) AS cogs
FROM wmsales
GROUP BY month_name
ORDER BY cogs DESC;

-- 6. What product line had the largest revenue?
SELECT product_line, SUM(total) AS Total_revenue 
FROM wmsales
GROUP BY product_line
ORDER BY Total_revenue DESC;

-- 7. What is the city with the largest revenue?
SELECT s.city, SUM(total) AS Total_revenue 
FROM wmsales as w
INNER JOIN StoreName as s ON w.branch=s.branch
GROUP BY city
ORDER BY Total_revenue DESC;

-- 8. What product line had the largest VAT?
SELECT product_line, SUM(VAT) AS Valueable_Tax
FROM wmsales
GROUP BY product_line
ORDER BY Valueable_Tax DESC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
-- (Assuming you want to add a column named 'Sales_Category' with values 'Good' or 'Bad')
SELECT product_line,
       CASE WHEN SUM(total) > (SELECT AVG(total) FROM wmsales) THEN 'Good' ELSE 'Bad' END AS Sales_Category
FROM wmsales
GROUP BY product_line;

-- 10. Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty
FROM wmsales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM wmsales);

-- 11. What is the most common product line by gender?
SELECT gender, product_line, COUNT(gender) AS total_count
FROM wmsales
GROUP BY gender, product_line
ORDER BY total_count DESC;

-- 12. What is the average rating of each product line?
SELECT ROUND(AVG(rating), 2) AS avg_rating, product_line
FROM wmsales
GROUP BY product_line
ORDER BY avg_rating DESC;

----------------------------------- Sales -----------------------------------
-- 1. Number of sales made in each time of the day per weekday
SELECT timeofday, COUNT(*) AS total_sales
FROM wmsales
WHERE day_name = 'Sunday'
GROUP BY timeofday
ORDER BY total_sales DESC;

-- 2. Which of the customer types brings the most revenue?
SELECT customer_type, ROUND(SUM(total), 2) AS total_revenue
FROM wmsales
GROUP BY customer_type
ORDER BY total_revenue;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT s.city, AVG(VAT) AS value_added_tax
FROM wmsales as w
INNER JOIN StoreName as s ON s.branch=w.branch
GROUP BY city
ORDER BY value_added_tax DESC;

-- 4. Which customer type pays the most in VAT?
SELECT customer_type, AVG(VAT) AS value_added_tax
FROM wmsales
GROUP BY customer_type
ORDER BY value_added_tax DESC;

----------------------------------- Customer -----------------------------------
-- 1. How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM wmsales;

-- 2. How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM wmsales;

-- 3. What is the most common customer type?
SELECT customer_type, COUNT(*) AS total_count
FROM wmsales
GROUP BY customer_type
ORDER BY total_count;

-- 4. Which customer type buys the most?
SELECT customer_type, COUNT(*) AS total_count
FROM wmsales
GROUP BY customer_type
ORDER BY total_count;

-- 5. What is the gender of most of the customers?
SELECT gender, COUNT(*) AS gender_count
FROM wmsales
GROUP BY gender
ORDER BY gender_count DESC;

-- 6. What is the gender distribution per branch?
SELECT gender, COUNT(*) AS gender_count
FROM wmsales
WHERE branch = 'C'
GROUP BY gender
ORDER BY gender_count DESC;

-- 7. Which time of the day do customers give most ratings?
SELECT timeofday, AVG(rating) AS avg_rating
FROM wmsales
GROUP BY timeofday
ORDER BY avg_rating DESC;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT timeofday, branch, AVG(rating) AS avg_rating
FROM wmsales
GROUP BY timeofday, branch
ORDER BY avg_rating;

-- 9. Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM wmsales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- 10. Which day of the week has the best average ratings per branch?
SELECT day_name, AVG(rating) AS avg_rating
FROM wmsales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_rating DESC;

----------------------------------- Revenue And Profit Calculation -----------------------------------
-- Total gross sales
SELECT SUM(VAT + cogs) AS total_grass_sales
FROM wmsales;

-- Gross profit
SELECT (SUM(VAT + cogs) - SUM(cogs)) AS gross_profit
FROM wmsales;

-- Another way to calculate gross profit
SELECT (SUM(ROUND(VAT, 2) + COGS) - SUM(COGS)) AS gross_profit
FROM wmsales;

delete from StoreName
delete from WMsales