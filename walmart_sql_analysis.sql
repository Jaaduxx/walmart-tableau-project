/* =========================================
   WALMART SALES ANALYSIS PROJECT
   Author: Arijit Debnath
   Description: Raw-to-insight SQL cleaning
   Tool: PostgreSQL
========================================= */

-- =========================================
-- SECTION 0: TABLE CREATION & DATA LOADING
-- =========================================

DROP TABLE IF EXISTS walmart_sales;

CREATE TABLE IF NOT EXISTS walmart_sales (
  invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
  branch VARCHAR(30) NOT NULL,
  city VARCHAR(30) NOT NULL,
  customer VARCHAR(30) NOT NULL,
  gender VARCHAR(30) NOT NULL,
  product_line VARCHAR(100) NOT NULL,
  unit_price NUMERIC(10,2) NOT NULL,
  quantity INTEGER NOT NULL,
  tax_pct NUMERIC(10,4) NOT NULL,
  total NUMERIC(10,4) NOT NULL,
  date DATE NOT NULL,
  time TIME NOT NULL,
  payment VARCHAR(40) NOT NULL,
  cogs NUMERIC(8,2) NOT NULL,
  gross_margin NUMERIC(8,2) NOT NULL,
  gross_income NUMERIC(8,2) NOT NULL,
  rating NUMERIC(3,1) NOT NULL
);

SELECT * FROM walmart_sales;

-- =========================================
-- SECTION 1: DATA QUALITY CHECKS & ENRICHMENT
-- =========================================

-- 1.1 Check for NULL values
SELECT *
FROM walmart_sales
WHERE 
    invoice_id IS NULL
	OR branch IS NULL
	OR city IS NULL 
	OR customer IS NULL 
	OR gender IS NULL 
	OR product_line IS NULL 
	OR
    unit_price IS NULL 
	OR quantity IS NULL 
	OR tax_pct IS NULL 
	OR total IS NULL 
	OR date IS NULL 
	OR time IS NULL 
	OR payment IS NULL 
	OR cogs IS NULL 
	OR gross_margin IS NULL 
	OR gross_income IS NULL 
	OR rating IS NULL;

-- 1.2 Add & update: time_of_day column
ALTER TABLE walmart_sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmart_sales
SET time_of_day = (
  CASE 
    WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
    WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'afternoon'
    ELSE 'evening'
  END
);

-- 1.3 Add & update: month_name column
ALTER TABLE walmart_sales ADD COLUMN month_name VARCHAR(20);

UPDATE walmart_sales
SET month_name = TRIM(TO_CHAR(date, 'Month'));

-- 1.4 Add & update: day_name column
ALTER TABLE walmart_sales ADD COLUMN day_name VARCHAR(20);

UPDATE walmart_sales
SET day_name = TRIM(TO_CHAR(date, 'Day'));

-- =========================================
-- SECTION 2: PRODUCT-BASED INSIGHTS
-- =========================================

-- 2.1 Unique product lines
SELECT COUNT(DISTINCT product_line) AS total_product_line FROM walmart_sales;

-- 2.2 Most selling product line
SELECT product_line, SUM(quantity) AS total_units_sold
FROM walmart_sales
GROUP BY product_line
ORDER BY total_units_sold DESC
LIMIT 1;

-- 2.3 Total revenue by month
SELECT month_name, SUM(total) AS total_sales
FROM walmart_sales
GROUP BY month_name;

-- 2.4 Month with largest COGS
SELECT month_name, SUM(cogs) AS total_cogs
FROM walmart_sales
GROUP BY month_name
ORDER BY total_cogs DESC
LIMIT 1;

-- 2.5 Product line with highest revenue
SELECT product_line, SUM(total) AS revenue
FROM walmart_sales
GROUP BY product_line
ORDER BY revenue DESC
LIMIT 1;

-- 2.6 City with highest revenue
SELECT city, SUM(total) AS total_revenue
FROM walmart_sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;

-- 2.7 Product line with highest VAT
SELECT product_line, SUM(tax_pct) AS vat
FROM walmart_sales
GROUP BY product_line
ORDER BY vat DESC
LIMIT 1;

-- 2.8 Good/Bad product line classification
SELECT product_line, SUM(total) AS total_sales,
  CASE 
    WHEN SUM(total) > (SELECT AVG(total) FROM walmart_sales) THEN 'good'
    ELSE 'bad'
  END AS sales_status
FROM walmart_sales
GROUP BY product_line;

-- 2.9 Branch sales classification
SELECT branch, SUM(quantity) AS total_units_sold,
  CASE 
    WHEN SUM(quantity) > (SELECT AVG(quantity) FROM walmart_sales) THEN 'more than average'
    ELSE 'less than average'
  END AS brand_status
FROM walmart_sales
GROUP BY branch;

-- 2.10 Most common product line by gender
SELECT gender, product_line, purchases
FROM (
  SELECT gender, product_line, COUNT(*) AS purchases,
         RANK() OVER (PARTITION BY gender ORDER BY COUNT(*) DESC) AS rnk
  FROM walmart_sales
  GROUP BY gender, product_line
) ranked
WHERE rnk = 1;

-- 2.11 Avg rating per product line
SELECT product_line, ROUND(AVG(rating),2) AS avg_rating
FROM walmart_sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- =========================================
-- SECTION 3: SALES-BASED INSIGHTS
-- =========================================

-- 3.1 Sales per weekday
SELECT day_name, SUM(quantity) AS sales_number_units
FROM walmart_sales
GROUP BY day_name
ORDER BY CASE
  WHEN day_name = 'Monday' THEN 1
  WHEN day_name = 'Tuesday' THEN 2
  WHEN day_name = 'Wednesday' THEN 3
  WHEN day_name = 'Thursday' THEN 4
  WHEN day_name = 'Friday' THEN 5
  WHEN day_name = 'Saturday' THEN 6
  WHEN day_name = 'Sunday' THEN 7
END;

-- 3.2 Top customer type by revenue
SELECT customer AS customer_type, SUM(total) AS total_revenue
FROM walmart_sales
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;

-- 3.3 City with highest average VAT
SELECT city, ROUND(AVG(tax_pct),2) AS vat
FROM walmart_sales
GROUP BY city
ORDER BY vat DESC;

-- 3.4 Customer type paying highest VAT
SELECT customer AS customer_type, SUM(tax_pct) AS tax_paid
FROM walmart_sales
GROUP BY customer_type;

-- =========================================
-- SECTION 4: CUSTOMER-BASED INSIGHTS
-- =========================================

-- 4.1 Unique customer types
SELECT COUNT(DISTINCT customer) FROM walmart_sales;

-- 4.2 Unique payment methods
SELECT COUNT(DISTINCT payment) FROM walmart_sales;

-- 4.3 Gender distribution per branch
SELECT branch, gender, COUNT(gender) AS total_count
FROM walmart_sales
GROUP BY branch, gender
ORDER BY branch ASC;

-- Pivoted gender view
SELECT branch,
  COUNT(CASE WHEN gender = 'Male' THEN 1 END) AS male_count,
  COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS female_count
FROM walmart_sales
GROUP BY branch;

-- 4.4 Peak time for customer ratings
SELECT time_of_day, COUNT(rating)
FROM walmart_sales
GROUP BY time_of_day
ORDER BY COUNT(rating) DESC
LIMIT 1;

-- 4.5 Avg rating per time per branch
SELECT branch, time_of_day, ROUND(AVG(rating),2) AS avg_rating
FROM walmart_sales
GROUP BY branch, time_of_day
ORDER BY branch ASC, avg_rating DESC;

-- 4.6 Best weekday by avg rating
SELECT day_name, ROUND(AVG(rating),2) AS avg_rating
FROM walmart_sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- 4.7 Best day per branch
SELECT branch, day_name, ROUND(AVG(rating),2) AS avg_rating
FROM walmart_sales
GROUP BY branch, day_name
ORDER BY branch ASC, avg_rating DESC;

-- =========================================
-- SECTION 5: CITY & BRANCH SNAPSHOTS
-- =========================================

-- 5.1 Unique cities
SELECT DISTINCT city FROM walmart_sales;

-- 5.2 Branch-city map
SELECT DISTINCT branch, city FROM walmart_sales;



