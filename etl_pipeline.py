"""
Sales ETL Pipeline — clean CSV -> SQLite warehouse -> analytics.

What it does, in plain steps:
  1. Extract: read data/sales_orders_cleaned.csv (432 clean rows)
  2. Load: put the rows into a staging table in sales.db (SQLite)
  3. Transform: build a star schema from sql/warehouse.sql
       fact_sales + dim_date + dim_product + dim_city
  4. Analyse: run the queries in sql/analytics.sql
  5. Export: save each result as a CSV in output/

Run it with:  python3 etl_pipeline.py
Needs: pandas (sqlite3 is built into Python, no install needed)
The warehouse file sales.db is deleted and rebuilt on every run,
so the results are always the same.
"""

import os
import sqlite3

import pandas as pd

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_FILE = os.path.join(BASE_DIR, "data", "sales_orders_cleaned.csv")
DB_FILE = os.path.join(BASE_DIR, "sales.db")
WAREHOUSE_SQL = os.path.join(BASE_DIR, "sql", "warehouse.sql")
ANALYTICS_SQL = os.path.join(BASE_DIR, "sql", "analytics.sql")
OUTPUT_DIR = os.path.join(BASE_DIR, "output")

# The analytics queries, in order, and the file each one saves to.
QUERIES = [
    ("monthly_sales", "Monthly sales total"),
    ("sales_by_product", "Sales by product"),
    ("sales_by_city", "Sales by city"),
    ("top_customers", "Top 5 customers"),
    ("avg_order_value", "Average order value by month"),
    ("overall_totals", "Overall totals"),
]


def read_sql_file(path):
    """Read a .sql file and split it into single statements."""
    with open(path, "r", encoding="utf-8") as f:
        text = f.read()
    # Split on semicolons; skip empty pieces and comment-only pieces.
    statements = []
    for part in text.split(";"):
        lines = [line for line in part.splitlines()
                 if not line.strip().startswith("--")]
        clean = "\n".join(lines).strip()
        if clean:
            statements.append(clean)
    return statements


def main():
    # 1. Extract: read the cleaned CSV.
    df = pd.read_csv(INPUT_FILE)
    print(f"Rows extracted from cleaned CSV: {len(df)}")

    # Start with a fresh warehouse every run.
    if os.path.exists(DB_FILE):
        os.remove(DB_FILE)
    conn = sqlite3.connect(DB_FILE)

    # 2. Load: put the rows into a staging table.
    df.to_sql("sales_staging", conn, index=False, if_exists="replace")
    print("Loaded staging table: sales_staging")

    # 3. Transform: build the star schema.
    for statement in read_sql_file(WAREHOUSE_SQL):
        conn.execute(statement)
    conn.commit()
    print("Built star schema: fact_sales, dim_date, dim_product, dim_city")

    # Check the fact table matches the CSV.
    fact_rows = conn.execute("SELECT COUNT(*) FROM fact_sales").fetchone()[0]
    print(f"Rows in fact_sales: {fact_rows}")

    # 4 + 5. Analyse and export each query to output/.
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    statements = read_sql_file(ANALYTICS_SQL)
    for (name, label), statement in zip(QUERIES, statements):
        result = pd.read_sql_query(statement, conn)
        out_file = os.path.join(OUTPUT_DIR, f"{name}.csv")
        result.to_csv(out_file, index=False)
        print(f"{label}: {len(result)} rows -> output/{name}.csv")

    conn.close()
    # The warehouse file is not needed after the exports.
    os.remove(DB_FILE)
    print("Done. See the output/ folder for the results.")


if __name__ == "__main__":
    main()
