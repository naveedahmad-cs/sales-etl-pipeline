-- Sales warehouse — star schema (SQLite)
-- Run after the cleaned CSV is loaded into a staging table called sales_staging.
-- Staging has the same columns as the cleaned CSV:
-- order_id, order_date, customer_name, product, quantity, unit_price, total_amount, city

-- 1. Date dimension: one row per date in the data
CREATE TABLE IF NOT EXISTS dim_date (
    date_id TEXT PRIMARY KEY,   -- YYYY-MM-DD
    year INTEGER,
    month INTEGER,
    month_name TEXT,
    day INTEGER
);

INSERT OR IGNORE INTO dim_date (date_id, year, month, month_name, day)
SELECT DISTINCT
    order_date,
    CAST(substr(order_date, 1, 4) AS INTEGER),
    CAST(substr(order_date, 6, 2) AS INTEGER),
    CASE CAST(substr(order_date, 6, 2) AS INTEGER)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
    END,
    CAST(substr(order_date, 9, 2) AS INTEGER)
FROM sales_staging;

-- 2. Product dimension: one row per product
CREATE TABLE IF NOT EXISTS dim_product (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product TEXT UNIQUE
);

INSERT OR IGNORE INTO dim_product (product)
SELECT DISTINCT product FROM sales_staging;

-- 3. City dimension: one row per city
CREATE TABLE IF NOT EXISTS dim_city (
    city_id INTEGER PRIMARY KEY AUTOINCREMENT,
    city TEXT UNIQUE
);

INSERT OR IGNORE INTO dim_city (city)
SELECT DISTINCT city FROM sales_staging;

-- 4. Fact table: one row per sale, linked to the dimensions
CREATE TABLE IF NOT EXISTS fact_sales (
    order_id TEXT PRIMARY KEY,
    date_id TEXT,
    product_id INTEGER,
    city_id INTEGER,
    customer_name TEXT,
    quantity INTEGER,
    unit_price REAL,
    total_amount REAL,
    FOREIGN KEY (date_id) REFERENCES dim_date (date_id),
    FOREIGN KEY (product_id) REFERENCES dim_product (product_id),
    FOREIGN KEY (city_id) REFERENCES dim_city (city_id)
);

INSERT OR REPLACE INTO fact_sales
    (order_id, date_id, product_id, city_id, customer_name, quantity, unit_price, total_amount)
SELECT
    s.order_id,
    s.order_date,
    p.product_id,
    c.city_id,
    s.customer_name,
    s.quantity,
    s.unit_price,
    s.total_amount
FROM sales_staging s
JOIN dim_product p ON p.product = s.product
JOIN dim_city c ON c.city = s.city;
