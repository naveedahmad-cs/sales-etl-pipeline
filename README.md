# Sales ETL Pipeline

A small, honest end-to-end ETL project in Python and SQL. It takes a clean
sales-orders file, loads it into a SQLite warehouse with a star schema, and
runs analytics queries that answer real business questions.

This project does **not** clean messy data — the cleaning was already done
in the [sales-data-cleaning](https://github.com/naveedahmad-cs/sales-data-cleaning)
project. This one starts from that cleaned file (432 rows) and builds on it.

## Architecture

```
data/sales_orders_cleaned.csv
        |
        v  Extract + Load (pandas + sqlite3)
SQLite staging table: sales_staging
        |
        v  Transform (sql/warehouse.sql)
Star schema: fact_sales + dim_date + dim_product + dim_city
        |
        v  Analyse (sql/analytics.sql)
output/*.csv — monthly sales, by product, by city, top customers
```

## What it answers

- How much did we sell each month?
- Which product sells the most?
- Which city sells the most?
- Who are the top 5 customers?
- What is the average order value each month?

Real results: 432 orders, total quantity 1,279, total sales 794,568.73,
from 2026-01-01 to 2026-03-31. See `output/SUMMARY.md` for the full
counted results.

## Tools

- Python
- Pandas
- SQL
- SQLite (built into Python — no database server to install)

## How to run it

```bash
python3 etl_pipeline.py
```

It rebuilds the warehouse from scratch on every run, runs the 6 analytics
queries, and saves the results as CSV files in `output/`. It prints the
row counts as it goes, so you can check the warehouse matches the CSV.

## Files

- `etl_pipeline.py` — the pipeline: extract, load, transform, analyse, export
- `sql/warehouse.sql` — star schema: dim_date, dim_product, dim_city, fact_sales
- `sql/analytics.sql` — 6 analytics queries
- `data/sales_orders_cleaned.csv` — clean input (432 rows)
- `output/monthly_sales.csv` — sales total by month
- `output/sales_by_product.csv` — sales by product (10 products)
- `output/sales_by_city.csv` — sales by city (7 cities)
- `output/top_customers.csv` — top 5 customers by total spend
- `output/avg_order_value.csv` — average order value by month
- `output/overall_totals.csv` — overall totals, used to check the warehouse
- `output/SUMMARY.md` — before / after summary with real counted numbers

## Honest note

This is a **sample dataset created for learning**. It is not real client data,
and no real client, company, or sales result is claimed anywhere in this project.

## Author

Naveed Ahmad — Computer Science student, Government College University Faisalabad,
focused on data engineering.
LinkedIn: https://www.linkedin.com/in/naveedahmad-cs/
GitHub: https://github.com/naveedahmad-cs
