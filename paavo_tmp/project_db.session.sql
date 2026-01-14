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
