# ETL Pipeline — Results Summary

All numbers below are the **real counted results** from running
`python3 etl_pipeline.py` on the cleaned sales data. Nothing here is guessed.
A second run produced identical output files (checked with md5).

## Warehouse check — totals match the cleaned CSV

| Measure | Count |
|---|---|
| Rows extracted from cleaned CSV | 432 |
| Rows in fact_sales | 432 |
| Total quantity | 1,279 |
| Total of total_amount | 794,568.73 |
| Date range | 2026-01-01 to 2026-03-31 |
| Distinct dates (dim_date) | 90 |
| Distinct products (dim_product) | 10 |
| Distinct cities (dim_city) | 7 |
| Distinct customers | 16 |
| Overall average order value | 1,839.28 |

## Monthly sales

| Month | Orders | Total quantity | Total sales |
|---|---|---|---|
| January 2026 | 167 | 505 | 327,087.71 |
| February 2026 | 122 | 369 | 233,611.95 |
| March 2026 | 143 | 405 | 233,869.07 |

Check: 327,087.71 + 233,611.95 + 233,869.07 = 794,568.73.

## Sales by product (top 3 of 10)

| Product | Orders | Total quantity | Total sales |
|---|---|---|---|
| Mouse Pad | 54 | 167 | 116,295.03 |
| Ssd 512Gb | 55 | 170 | 115,174.62 |
| Power Bank | 46 | 127 | 81,833.56 |

Full list: see `output/sales_by_product.csv`.

## Sales by city (top 3 of 7)

| City | Orders | Total quantity | Total sales |
|---|---|---|---|
| Multan | 74 | 209 | 145,473.24 |
| Faisalabad | 76 | 238 | 141,194.92 |
| Rawalpindi | 76 | 226 | 140,999.59 |

Full list: see `output/sales_by_city.csv`.

## Top 5 customers

| Customer | Orders | Total quantity | Total spent |
|---|---|---|---|
| Ahmed Raza | 37 | 116 | 77,582.39 |
| Zara Khan | 34 | 114 | 77,542.05 |
| Omar Farooq | 37 | 110 | 73,150.89 |
| Bilal Hussain | 31 | 96 | 60,983.62 |
| Bilal Ahmed | 32 | 91 | 59,542.53 |

## Average order value by month

| Month | Orders | Average order value |
|---|---|---|
| January 2026 | 167 | 1,958.61 |
| February 2026 | 122 | 1,914.85 |
| March 2026 | 143 | 1,635.45 |

## What the pipeline does NOT do

- It does not re-clean messy data — the input is already the cleaned file
  (432 rows) from the sales-data-cleaning project.
- It does not invent sales, customers, or dates. Every number above
  comes from the 432 cleaned rows.
