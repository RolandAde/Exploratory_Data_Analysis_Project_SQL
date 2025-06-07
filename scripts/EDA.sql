-- Exploring objects in the database
SELECT 
	*
FROM INFORMATION_SCHEMA.TABLES;

-- Exploring columns in the database
SELECT 
	*
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('dim_customers', 'dim_products', 'fact_sales');

-- Exploring countries of customers
SELECT DISTINCT 
	country
FROM gold.dim_customers;

-- Exploring categories in detail
SELECT DISTINCT
	category, 
	subcategory,
	product_name
FROM gold.dim_products
ORDER BY 1,2,3

--Identifying the date boundaries (Earliest & Latest Dates)
SELECT
	MIN(order_date) earliest_order_date,
	MAX(order_date) latest_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) order_range_years
FROM gold.fact_sales

-- Youngest and oldest customer
SELECT
	MIN(birthdate) oldest_birthdate,
	MAX(birthdate) youngest_birthdate,
	DATEDIFF(year, MIN(birthdate), GETDATE()) oldest_age,
	DATEDIFF(year, MAX(birthdate), GETDATE()) youngest_age,
	DATEDIFF(year, MIN(birthdate), MAX(birthdate)) birthdate_range_years
FROM gold.dim_customers

-- Find the total sales
SELECT
	SUM(sales_amount) Total_Sales
FROM gold.fact_sales

-- Find how many items are sold
SELECT
	SUM(quantity) Total_Items_Sold
FROM gold.fact_sales

-- Find the average selling price
SELECT
	AVG(price) Avg_price
FROM gold.fact_sales

-- Find the total number of orders
SELECT
	COUNT(order_number) Total_Orders,
	COUNT(DISTINCT order_number) Total_Unique_Orders
FROM gold.fact_sales

-- Find the total number of products
SELECT
	COUNT(product_key) Total_Products,
	COUNT(product_name) Total_Products_name,
	COUNT(DISTINCT product_key) Total_Unique_Products
FROM gold.dim_products

-- Find the total number of customers
SELECT
	COUNT(customer_key) Total_customers_key,
	COUNT(customer_id) Total_customer_id,
	COUNT(DISTINCT customer_key) Total_Unique_customer_key
FROM gold.dim_customers

-- Find the total number of customers that has placed an order
SELECT
	COUNT(DISTINCT customer_key) customers_with_orders
FROM gold.fact_sales


-- Find total customers by country
SELECT
	country,
	COUNT(customer_key) As Total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY Total_customers DESC

-- Find total customers by gender
SELECT
	gender,
	COUNT(customer_key) As Total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY Total_customers DESC

-- Find total products by category
SELECT
	category,
	COUNT(product_key) As Total_products
FROM gold.dim_products
GROUP BY category
ORDER BY Total_products DESC

-- What is the average cost in each category?
SELECT
	category,
	AVG(cost) As Avg_Cost
FROM gold.dim_products
GROUP BY category
ORDER BY Avg_Cost DESC

-- What is the total revenue generated for each category?
SELECT
	p.category,
	SUM(f.sales_amount) As Total_Revenue
FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY Total_Revenue DESC

-- Find the total revenue generate by each customer
SELECT
	c.customer_key,
	c.first_name + ' ' + c.last_name AS Full_name,
	SUM(f.sales_amount) As Total_Revenue
FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name + ' ' + c.last_name
ORDER BY Total_Revenue DESC

-- What is the distribution of sold items across countries?
SELECT
	c.country,
	SUM(f.quantity) As Total_sold_items
FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY Total_sold_items DESC


-- Which 5 products generate the highest revenue?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) As Total_Revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
GROUP BY p.product_name

-- What are the 5 worst performing products in terms of sales?
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) As Total_Revenue
FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue ASC

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) As Total_Revenue
FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY Total_Revenue DESC


-- Find the top 3 customers who have the lowest revenue
SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) As Total_Revenue
FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY Total_Revenue