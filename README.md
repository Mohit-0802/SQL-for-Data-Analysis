# Task 4 – SQL for Data Analysis

**Internship:** Data Analyst Internship (DataX Labs)
**Objective:** Use SQL queries to extract and analyze data from a database.

## Tools Used
- MySQL Community Server 8.0 + MySQL Workbench

## Dataset
Custom-built **Ecommerce_SQL_Database** with 4 related tables:
- `customers` (30 rows)
- `products` (15 rows)
- `orders` (100 rows)
- `order_items` (252 rows)

Raw data is also provided as CSVs (`customers.csv`, `products.csv`, `orders.csv`, `order_items.csv`) for reference.

## What I Did
1. Designed a small relational e-commerce schema (customers → orders → order_items → products).
2. Wrote SQL queries covering:
   - `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`
   - `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`
   - Subqueries (in `WHERE`, in `FROM`, scalar subqueries)
   - Aggregate functions (`SUM`, `AVG`, `COUNT`)
   - A view (`customer_revenue_view`) summarizing revenue per customer
   - Indexes on foreign key columns to optimize joins/filters, verified with `EXPLAIN QUERY PLAN`
   - `NULL` handling using `IS NULL` and `COALESCE`
3. Took screenshots of query outputs (see `/screenshots` folder).

## Files in This Repo
| File | Description |
|---|---|
| `create_ecommerce_db.sql` | Creates the `ecommerce_db` database, tables, and inserts all sample data |
| `queries_mysql.sql` | All analysis queries for the task |
| `customers.csv`, `products.csv`, `orders.csv`, `order_items.csv` | Raw dataset (for reference) |
| `screenshots/` | Screenshots of query outputs |
| `README.md` | This file |

## How to Run
1. Open MySQL Workbench and connect to your local server.
2. Run `create_ecommerce_db.sql` first (builds the database + loads data).
3. Then run `queries_mysql.sql` (all the analysis queries).

## Key Learnings
- How to join multiple related tables to answer business questions.
- How subqueries and views simplify complex analysis.
- How indexes speed up filtering/joins, verified using query plans.
