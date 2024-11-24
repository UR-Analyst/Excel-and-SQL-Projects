USE PROJECT_3;
# for null values

SELECT * FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR 
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR 
    customer_id IS NULL
    OR 
    gender IS NULL
    OR
    age IS NULL
    OR 
    category IS NULL
    OR 
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR 
    cogs IS NULL 
    OR 
    total_sale IS NULL;
    
    DELETE FROM retail_sales
    WHERE 
    transactions_id IS NULL
    OR 
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR 
    customer_id IS NULL
    OR 
    gender IS NULL
    OR
    age IS NULL
    OR 
    category IS NULL
    OR 
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR 
    cogs IS NULL 
    OR 
    total_sale IS NULL;
    
    SELECT COUNT(*) 
    FROM retail_sales;
    # WE HAVE 1987 DATA'S AFTER DELETING NULL VALUES.
    
    -- DATA EXPLORATION 
    
    -- HOW MANY SALES WE HAVE?
    SELECT COUNT(*)
    FROM retail_sales;
    -- 1987 sales
    
    -- HOW MANY CUSTOMERS WE HAVE 
    SELECT COUNT(DISTINCT customer_id)
    FROM retail_sales;
    -- 155 CUSTOMERS 
    
    -- HOW MANY CATEGORIES WE HAVE 
    SELECT DISTINCT category
    FROM retail_sales;
    -- WE HAVE 3 CATEGORIES : CLOTHING, BEAUTY, ELECTRONICS
    
    -- DATA ANALYSIS FOR BUSINESS PROBLEM SOLVING
    
-- Q1: WRITE A SQL QUERY TO RETRIEVE ALL THE COLUMNS FOR SALES MADE ON "2022-11-05"
SELECT * ,
    ROW_NUMBER() OVER(ORDER BY transactions_id ASC) AS row_naumber
FROM retail_sales
WHERE sale_date = "2022-11-05";
     -- we had 11 sales on "2022-11-05"alter

-- Q2: WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS CLOTHING
-- AND THE QUANTITY SOLD IS MORE THAN 10 IN THE MONTH OF NOV-2022
SELECT * 
FROM retail_sales
WHERE category = "Clothing"
AND
quantity > 3
AND 
sale_date BETWEEN "2022-11-01" AND "2022-11-30";

-- HOW MANY CLOTHING CATEGORIES ITEM WAS SOLD IN 2022 NOV?
SELECT category,SUM(quantity)
FROM retail_sales
WHERE category = "Clothing"
AND sale_date BETWEEN "2022-11-01" AND "2022-11-30"
GROUP BY category;
-- 134 items was sold from clothing category in nov 2022

-- Q3: WRITE A SQL QUERY TO CALCULATE THE TOTAL SALES FOR EACH CATEGORY
SELECT category, SUM(total_sale)AS Total_Sales
FROM retail_sales
GROUP BY category
ORDER BY Total_Sales DESC;
-- ELECTRONICS: 311445. CLOTHING: 309995.  BEAUTY: 286790

-- Q4: WRITE A SQL QUERY TO FIND THE AVG AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE BEAUTY CATEGORY
SELECT category, ROUND(AVG(age))
FROM retail_sales
WHERE category = "Beauty";
-- 40 YEARS OLD

-- Q5: WRITE A SQL QUERY TO FIND ALL THE TRANSACTIONS WHERE THE TOTAL_SALE IS GREATER THAN 1000
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS MADE BY EACH GENDER IN EACH CATEGORY
SELECT category, gender, COUNT(transactions_id)AS num_tran
FROM retail_sales
GROUP BY category, gender
ORDER BY num_tran DESC ;
-- Clothing : F=347 , M=351
-- Electronics : F=335 , M=343
-- Beauty : F=330 , M=281

-- Q7: WRITE A SQL QUERY TO CALCULATE THE AVG SALE FOR EACH MONTH. FIND OUT THE BEST SELLING MONTH IN EACH YEAR
SELECT * 
FROM 
(SELECT 
YEAR(sale_date) AS YEAR, 
MONTH(sale_date) AS MONTH, 
AVG (total_sale) AS avg_sale,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) desc) AS RAN_K
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE RAN_K =1;


-- Q8: HIGHEST SALE MONTH EACH YEAR?
WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS year, 
        MONTH(sale_date) AS month, 
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT year, month, total_sales
FROM MonthlySales
WHERE (year, total_sales) IN (
    SELECT year, MAX(total_sales)
    FROM MonthlySales
    GROUP BY year
)
ORDER BY year DESC;
-- DECEMBER 

-- Q9: WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES
SELECT 
customer_id,
SUM(total_sale)
FROM retail_sales
GROUP BY customer_id
order by SUM(total_sale) DESC
limit 5;

-- Q10: WRITE A QUERY TO FIND THE NUMBER OF CUSTOMERS WHO PRCHASED ITEMS FROM EACH CATEGORY
SELECT category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category
ORDER BY COUNT(customer_id) DESC;

-- Q11: WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS
-- EXAMPLE MORNING <=12, AFTERNOON BETWEEN 12 & 17, EVENING >17)
SELECT 
CASE
WHEN HOUR(sale_time)<= 12 THEN "Morning"
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
ELSE "Evening"
END AS shift,
COUNT(transactions_id) AS number_of_orders
FROM retail_sales
GROUP BY shift
ORDER BY number_of_orders DESC;










    
    
    
    
    
    SELECT  year(sale_date) AS year, month(sale_date) AS month, AVG(total_sale) AS avg_sale FROM retail_sales GROUP BY year, month ORDER BY avg_sale LIMIT 0, 1000
