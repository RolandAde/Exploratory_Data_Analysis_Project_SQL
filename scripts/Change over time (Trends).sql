/*
====================================================================================
Query: Monthly Sales Performance Summary

Purpose:
    Aggregates key sales metrics by year and month to provide insights into 
    monthly sales trends and customer engagement.

Metrics Computed:
    - Total_Sales:     Sum of all sales amounts
    - Total_Customers: Unique customers who placed orders
    - Total_Quantity:  Total units sold

Source:
    gold.fact_sales — the central sales fact table in the Gold Layer

Filters:
    - Excludes records with NULL order dates
====================================================================================
*/

SELECT
	YEAR(order_date) AS Order_Year,               -- Extracts the year from the order date
	MONTH(order_date) AS Order_Month,             -- Extracts the month from the order date
	SUM(sales_amount) AS Total_Sales,             -- Total sales amount for the month
	COUNT(DISTINCT customer_key) AS Total_Customers, -- Number of unique customers in the month
	SUM(quantity) AS Total_Quantity               -- Total quantity of items sold in the month
FROM 
	gold.fact_sales                                -- Source table containing transactional sales data
WHERE 
	order_date IS NOT NULL                         -- Filters out records with NULL order dates
GROUP BY 
	YEAR(order_date),                              -- Groups results by year
	MONTH(order_date)                              -- and by month
ORDER BY 
	YEAR(order_date),                              -- Orders the final result chronologically by year
	MONTH(order_date);                             -- and by month
