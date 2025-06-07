/*
=====================================================================================================
Query: Yearly Product Sales Analysis with Average Comparison and Year-over-Year (YoY) Changes

Purpose:
    - Summarizes yearly sales by product
    - Compares each year’s sales to the product's overall average
    - Calculates year-over-year changes in sales
    - Labels performance as 'Above Avg' or 'Increase', etc., for easy reporting/dashboard insights

Main Calculations:
    • avg_sales: Average annual sales per product
    • diff_avg / avg_change: Difference from average and corresponding label
    • py_sales / diff_py / py_change: Previous year sales, difference, and direction of change

Source Tables:
    • gold.fact_sales — transactional sales fact table
    • gold.dim_products — product dimension with product names
=====================================================================================================
*/

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,     -- Extract year from order date
        p.product_name,                       -- Product name from dimension table
        SUM(f.sales_amount) AS current_sales  -- Total sales per product per year
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        YEAR(f.order_date),
        p.product_name
)

SELECT
    order_year,
    product_name,
    current_sales,

    -- Average sales across all years for each product
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,

    -- Difference from average
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,

    -- Sales performance vs. average
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Previous year sales for same product (YoY)
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,

    -- Difference from previous year
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,

    -- YoY trend
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change



FROM yearly_product_sales
ORDER BY product_name, order_year;
