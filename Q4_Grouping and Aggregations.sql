
/* Total sales per product category */

/* 
This query calculates the total sales for each product category.
It multiplies quantity by price_at_purchase and groups the result by category.
*/

SELECT 
    p.category,  /* Product category (Electronics, Food, etc.) */
    SUM(oi.quantity * oi.price_at_purchase) AS total_sales  /* Total sales per category */
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id  /* Link order items to products */
GROUP BY p.category;  /* Group results by category */



/* Average order value */
/* 
This query calculates the average order value.
First, it calculates the total value of each order.
Then, it calculates the average of all order totals.
*/

SELECT 
    AVG(order_total) AS average_order_value  /* Average value of all orders */
FROM (
    SELECT 
        o.order_id,  /* Order ID */
        SUM(oi.quantity * oi.price_at_purchase) AS order_total  /* Total value per order */
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id  /* Link orders to order items */
    GROUP BY o.order_id  /* One row per order */
) sub;



/* Monthly breakdown: antal orders + total sales */
/* 
This query shows a monthly breakdown of:
- Number of orders per month
- Total sales per month
*/

SELECT 
    DATE_TRUNC('month', o.order_date) AS month,  /* Convert order date to month */
    COUNT(DISTINCT o.order_id) AS number_of_orders,  /* Count orders per month */
    SUM(oi.quantity * oi.price_at_purchase) AS total_sales  /* Total sales per month */
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id  /* Link orders to order items */
GROUP BY month  /* Group results by month */
ORDER BY month;  /* Sort by month */
