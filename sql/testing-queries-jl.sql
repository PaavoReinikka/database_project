--TEST Queries for Aura project. Testing the validity of relationships in the schema and that everything functions


--Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

--Total sales (sum of price_at_purchase * quantity)
SELECT
  SUM(oi.price_at_purchase * oi.quantity) AS total_sales
FROM order_items oi;

--Count of products with low stock (stock_quantity < 10)
SELECT COUNT(*) AS low_stock_products
FROM products
WHERE stock_quantity < 10;


--Total sales per product category
SELECT
  p.category,
  SUM(oi.quantity * oi.price_at_purchase) AS total_sales
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;

--Average order value
SELECT
  AVG(order_total) AS average_order_value
FROM (
  SELECT
    o.order_id,
    SUM(oi.quantity * oi.price_at_purchase) AS order_total
  FROM orders o
  JOIN order_items oi
    ON o.order_id = oi.order_id
  GROUP BY o.order_id
) order_totals;

--Monthly breakdown of number of orders and total sales
SELECT
  DATE_TRUNC('month', o.order_date) AS month,
  COUNT(DISTINCT o.order_id) AS number_of_orders,
  SUM(oi.quantity * oi.price_at_purchase) AS total_sales
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

 - ((DROP ALL))