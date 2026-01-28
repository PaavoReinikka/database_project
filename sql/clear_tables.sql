
BEGIN;


-- Run to empty tables 
TRUNCATE TABLE
  order_items,
  shipments,
  orders,
  products,
  suppliers,
  customers
RESTART IDENTITY
CASCADE;


-- Confirm tables are empty
SELECT 'customers' AS table, COUNT(*) FROM customers
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments;


ROLLBACK;
-- COMMIT;