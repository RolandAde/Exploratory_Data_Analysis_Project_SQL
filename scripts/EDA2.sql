-- A report showing the key metrics of the business
SELECT
	'Total Sales' AS Measure_Name, SUM(sales_amount) As Measure_Value
FROM gold.fact_sales
UNION ALL
SELECT
	'Total Quantity', SUM(Quantity)
FROM gold.fact_sales
UNION ALL
SELECT
	'Average Price', AVG(price)
FROM gold.fact_sales
UNION ALL
SELECT
	'Total No. Orders', COUNT(DISTINCT order_number)
FROM gold.fact_sales
UNION ALL
SELECT
	'Total No. Products', COUNT(product_name) Total_Products_name
FROM gold.dim_products
UNION ALL
SELECT
	'Total no. Customers', COUNT(customer_key) Total_customers_key
FROM gold.dim_customers
UNION ALL
SELECT
	'Total Customers with Orders', COUNT(DISTINCT customer_key) customers_with_orders
FROM gold.fact_sales