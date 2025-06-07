/*
====================================================================================
Query: Yearly Cumulative Sales and Average Trends

Purpose:
    - Aggregates yearly total sales
    - Computes running (cumulative) total and average sales over time

Key Metrics:
    - Total_Sales:               Sum of sales in a given year
    - Cummulative_Total_Sales:  Running total of yearly sales
    - Cummulative_Average_Sales:Running average of yearly sales

Window Function:
    - ORDER BY year ensures cumulative metrics follow chronological order

Source:
    gold.fact_sales — fact table containing sales transactions
====================================================================================
*/

SELECT
    Order_Date,  -- Truncated to Year (e.g., '2023-01-01' for all of 2023)
    Total_Sales,
    
    -- Running total of Total_Sales by year
    SUM(Total_Sales) OVER(ORDER BY Order_Date) AS Cummulative_Total_Sales,
    
    -- Running average of Total_Sales by year
    AVG(Total_Sales) OVER(ORDER BY Order_Date) AS Cummulative_Average_Sales
FROM (
    SELECT
        DATETRUNC(YEAR, order_date) AS Order_Date,   -- Extracts year portion
        SUM(sales_amount) AS Total_Sales,            -- Total sales for the year
        AVG(sales_amount) AS AVG_Sales               -- (Not used in outer query but OK to retain)
    FROM 
        gold.fact_sales
    WHERE 
        order_date IS NOT NULL
    GROUP BY 
        DATETRUNC(YEAR, order_date)
) t;
