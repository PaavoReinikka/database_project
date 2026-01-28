-- BASICS
SELECT COUNT(*) AS total_orders
FROM orders;

SELECT
  COALESCE(SUM(price_at_purchase * quantity), 0) AS total_sales
FROM order_items;

SELECT COUNT(*) AS low_stock_products
FROM products
WHERE stock_quantity < 10;

--JOINS
-- Orders, costumers name and order value
SELECT
    o.order_id,
    o.order_date,
    c.name AS customer_name,
    COALESCE(SUM(oi.price_at_purchase * oi.quantity), 0) AS total_order_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.order_date,
    c.name
ORDER BY o.order_date DESC;

-- top 5 costumers order by total spending
SELECT
    c.customer_id,
    c.name AS customer_name,
    COALESCE(SUM(oi.price_at_purchase * oi.quantity), 0) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.name
ORDER BY
    total_spent DESC
LIMIT 5;

-- supplier list and no. products the supply

SELECT
    s.supplier_id,
    s.name AS supplier_name,
    COUNT(p.product_id) AS number_of_products
FROM suppliers s
LEFT JOIN products p
    ON s.supplier_id = p.supplier_id
GROUP BY
    s.supplier_id,
    s.name
ORDER BY
    number_of_products DESC;

--NESTED QUERIES
-- inner query which is all costumers who placed more than 5 orders
SELECT
    customer_id
FROM
    Orders
GROUP BY
    customer_id
HAVING
    COUNT(order_id) > 5;

-- outer query which is the names of the costumers
SELECT
    customer_name
FROM
    Customers
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            Orders
        GROUP BY
            customer_id
        HAVING
            COUNT(order_id) > 5
        );

--avr delivery time per month 

SELECT
    order_date
FROM
    Orders
GROUP BY
    customer_id
HAVING
    COUNT(order_id) > 5;

--avr delivery time per month

SELECT
    o.order_date,
    s.delivery_date
FROM
    orders AS o
LEFT JOIN
    shipments AS s ON o.order_id = s.order_id;

-- calculating delivery duration

SELECT
    o.order_date,
    s.delivery_date,
    s.delivery_date - o.order_date AS delivery_duration_days
FROM
    orders AS o
LEFT JOIN
    shipments AS s ON o.order_id = s.order_id;

--calculating avr delivery time
    AVG(s.delivery_date - o.order_date) AS average_delivery_duration_days
FROM
    orders AS o
LEFT JOIN
    shipments AS s ON o.order_id = s.order_id;

-- calculate the avr delivery time per month
SELECT
    TO_CHAR(o.order_date, 'YYYY-MM') AS order_month, --Extract year and month
    AVG(s.delivery_date - o.order_date) AS average_delivery_duration_days -- 2. Calculate average duration
FROM
    orders AS o
LEFT JOIN
    shipments AS s ON o.order_id = s.order_id
WHERE
    s.delivery_date IS NOT NULL --  Only average completed deliveries
GROUP BY
    order_month
ORDER BY
    order_month;

    