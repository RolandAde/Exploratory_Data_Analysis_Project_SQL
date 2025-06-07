-- Change over time (Trends)
SELECT
	YEAR(order_date) AS Order_Year,
	MONTH(order_date) AS Order_Month,
	SUM(sales_amount) AS Total_Sales,
	COUNT(DISTINCT customer_key) AS Total_Customers,
	SUM(quantity) AS Total_Quantity
FROM 
	gold.fact_sales
WHERE 
	order_date IS NOT NULL 
GROUP BY 
	YEAR(order_date),
	MONTH(order_date)
ORDER BY 
	YEAR(order_date),
	MONTH(order_date);


--Cumulative Analysis
-- Total sales per month and the running total of sales over time.
SELECT
	Order_Date,
	Total_Sales,
	SUM(Total_Sales) OVER(ORDER BY Order_Date) AS Cummulative_Total_Sales,
	AVG(Total_Sales) OVER(ORDER BY Order_Date) AS Cummulative_Average_Sales
FROM
	(
	SELECT
		DATETRUNC(YEAR, order_date) AS Order_Date,
		SUM(sales_amount) AS Total_Sales,
		AVG(sales_amount) AS AVG_Sales
	FROM 
		gold.fact_sales
	WHERE 
		order_date IS NOT NULL 
	GROUP BY 
		DATETRUNC(YEAR, order_date) 
)t;

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales
*/
