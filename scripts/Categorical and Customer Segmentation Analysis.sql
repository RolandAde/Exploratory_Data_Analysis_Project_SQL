/*
===============================================================================
Categorical Distribution Analysis
===============================================================================
Purpose:
    - To segment products based on their cost into defined price bands.
    - Helps in understanding pricing distribution across inventory.
    - Supports pricing strategy, discount planning, and inventory profiling.

SQL Functions Used:
    - CASE: Used to define custom cost ranges.
    - COUNT(): Aggregates total number of products per cost segment.
===============================================================================
*/

-- CTE to assign products into cost-based ranges
WITH product_segments AS (
    SELECT
        product_key,                                -- Unique product identifier
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range                           -- Grouping logic for cost bands
    FROM gold.dim_products
)

-- Count how many products fall into each cost range
SELECT 
    cost_range,                                      -- Defined price band
    COUNT(product_key) AS total_products             -- Number of products in this band
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;                        -- Most common price ranges first


/*
===============================================================================
Customer Segmentation Analysis
===============================================================================
Purpose:
    - To classify customers into 'VIP', 'Regular', or 'New' based on lifecycle and total spend.
    - Enables personalized marketing, retention strategies, and loyalty programs.
    - Supports customer lifetime value analysis.

SQL Functions Used:
    - SUM(), MIN(), MAX(): Aggregate spending and order dates.
    - DATEDIFF(): Calculates customer lifespan.
    - CASE: Categorizes customers based on business logic.
    - COUNT(): Counts customers in each segment.
===============================================================================
*/

-- CTE to calculate total spending and lifecycle duration for each customer
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,           -- Total customer spend
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan  -- Duration in months
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)

-- Final query: assign customers to segments and count them
SELECT 
    customer_segment,                                    -- Segment name
    COUNT(customer_key) AS total_customers               -- Number of customers in each
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;                          -- Segment with most customers first
