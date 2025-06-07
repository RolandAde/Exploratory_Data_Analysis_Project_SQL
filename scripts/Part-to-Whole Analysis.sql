/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To identify which product categories contribute the most to total sales.
    - Supports strategic decisions on inventory, marketing, and resource allocation.
    - Helps highlight high-performing vs. underperforming product segments.

SQL Functions Used:
    - SUM(): Aggregates sales per category.
    - Window Function SUM() OVER (): Calculates overall sales across all categories.
    - ROUND(), CAST(): Used to compute and format percentage contributions.
===============================================================================
*/

-- CTE to calculate total sales per product category
WITH category_sales AS (
    SELECT
        p.category,                            -- Product category name
        SUM(f.sales_amount) AS total_sales     -- Total sales for each category
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key       -- Left Join to get category info
    GROUP BY p.category                        -- Group by category for aggregation
)

-- Final query to calculate share of each category in overall sales
SELECT
    category,                                   -- Product category
    total_sales,                                -- Sales amount for the category
    SUM(total_sales) OVER () AS overall_sales,  -- Total sales across all categories
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percentage_of_total -- Category share in %
FROM category_sales
ORDER BY total_sales DESC;                      -- Rank categories by contribution
