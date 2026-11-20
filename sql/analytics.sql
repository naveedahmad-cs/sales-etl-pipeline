-- Analytics queries on the sales warehouse (fact_sales + dimensions)
-- Run against sales.db after the pipeline has loaded the star schema.

-- 1. Monthly sales total
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(*) AS orders,
    SUM(f.quantity) AS total_quantity,
    ROUND(SUM(f.total_amount), 2) AS total_sales
FROM fact_sales f
JOIN dim_date d ON d.date_id = f.date_id
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- 2. Sales by product
SELECT
    p.product,
    COUNT(*) AS orders,
    SUM(f.quantity) AS total_quantity,
    ROUND(SUM(f.total_amount), 2) AS total_sales
FROM fact_sales f
JOIN dim_product p ON p.product_id = f.product_id
GROUP BY p.product
ORDER BY total_sales DESC;

-- 3. Sales by city
SELECT
    c.city,
    COUNT(*) AS orders,
    SUM(f.quantity) AS total_quantity,
    ROUND(SUM(f.total_amount), 2) AS total_sales
FROM fact_sales f
JOIN dim_city c ON c.city_id = f.city_id
GROUP BY c.city
ORDER BY total_sales DESC;

-- 4. Top 5 customers by total spend
SELECT
    f.customer_name,
    COUNT(*) AS orders,
    SUM(f.quantity) AS total_quantity,
    ROUND(SUM(f.total_amount), 2) AS total_spent
FROM fact_sales f
GROUP BY f.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- 5. Average order value by month
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(*) AS orders,
    ROUND(AVG(f.total_amount), 2) AS avg_order_value,
    ROUND(SUM(f.total_amount), 2) AS total_sales
FROM fact_sales f
JOIN dim_date d ON d.date_id = f.date_id
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

-- 6. Overall totals (used to check the warehouse against the cleaned CSV)
SELECT
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_amount), 2) AS total_sales,
    MIN(date_id) AS first_date,
    MAX(date_id) AS last_date
FROM fact_sales;
