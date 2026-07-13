/* ============================================================
   TASK 4: SQL FOR DATA ANALYSIS (MySQL version)
   Run create_ecommerce_db.sql FIRST to build the database.
   Database : ecommerce_db
   Tables   : customers, products, orders, order_items
   Author   : Sandeep Verma
   ============================================================ */

USE ecommerce_db;


/* ------------------------------------------------------------
   a. SELECT, WHERE, ORDER BY, GROUP BY
   ------------------------------------------------------------ */

-- 1. List all customers from Uttar Pradesh, newest signups first
SELECT customer_id, customer_name, city, state, signup_date
FROM customers
WHERE state = 'Uttar Pradesh'
ORDER BY signup_date DESC;

-- 2. List all products priced above 1000, cheapest first
SELECT product_id, product_name, category, price
FROM products
WHERE price > 1000
ORDER BY price ASC;

-- 3. Count how many orders exist per status
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


/* ------------------------------------------------------------
   b. JOINS (INNER, LEFT, RIGHT)
   ------------------------------------------------------------ */

-- 4. INNER JOIN: orders with the customer who placed them
SELECT o.order_id, c.customer_name, o.order_date, o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

-- 5. LEFT JOIN: every customer, with their orders (customers with 0 orders still appear)
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- 6. RIGHT JOIN: every product, with any order_items referencing it
SELECT p.product_name, oi.order_item_id, oi.quantity
FROM order_items oi
RIGHT JOIN products p ON oi.product_id = p.product_id
ORDER BY p.product_name;


/* ------------------------------------------------------------
   c. Subqueries
   ------------------------------------------------------------ */

-- 7. Customers who have placed at least one order (subquery in WHERE)
SELECT customer_name, city
FROM customers
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

-- 8. Products priced above the overall average price (scalar subquery)
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- 9. Top 5 customers by total amount spent (subquery in FROM)
SELECT customer_name, total_spent
FROM (
    SELECT c.customer_name AS customer_name,
           SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
) AS customer_totals
ORDER BY total_spent DESC
LIMIT 5;


/* ------------------------------------------------------------
   d. Aggregate functions (SUM, AVG)
   ------------------------------------------------------------ */

-- 10. Total revenue generated (SUM), ignoring rows with NULL quantity
SELECT SUM(quantity * unit_price) AS total_revenue
FROM order_items
WHERE quantity IS NOT NULL;

-- 11. Average revenue per user (SUM per customer, then AVG across customers)
SELECT AVG(customer_revenue) AS avg_revenue_per_user
FROM (
    SELECT c.customer_id, SUM(oi.quantity * oi.unit_price) AS customer_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE oi.quantity IS NOT NULL
    GROUP BY c.customer_id
) AS per_customer;

-- 12. Average order-item value per category
SELECT p.category, AVG(oi.quantity * oi.unit_price) AS avg_item_value
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.quantity IS NOT NULL
GROUP BY p.category
ORDER BY avg_item_value DESC;


/* ------------------------------------------------------------
   e. Views
   ------------------------------------------------------------ */

-- 13. Create a view summarizing revenue per customer
DROP VIEW IF EXISTS customer_revenue_view;
CREATE VIEW customer_revenue_view AS
SELECT c.customer_id,
       c.customer_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.quantity IS NOT NULL
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC;

-- Query the view like a normal table
SELECT * FROM customer_revenue_view LIMIT 10;


/* ------------------------------------------------------------
   f. Optimize queries with indexes
   ------------------------------------------------------------ */

-- 14. Create indexes on foreign key / frequently filtered columns
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_customers_state ON customers(state);

-- 15. Check the query plan before/after indexing (take a screenshot of this output)
EXPLAIN SELECT * FROM orders WHERE customer_id = 5;


/* ------------------------------------------------------------
   BONUS: Handling NULL values
   ------------------------------------------------------------ */

-- 16. Find rows with NULL city or NULL quantity
SELECT * FROM customers WHERE city IS NULL;
SELECT * FROM order_items WHERE quantity IS NULL;

-- 17. Replace NULL city with 'Unknown' using COALESCE / IFNULL
SELECT customer_name, COALESCE(city, 'Unknown') AS city
FROM customers;
