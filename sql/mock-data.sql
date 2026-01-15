BEGIN;

-- =========================
-- Customers
-- =========================
INSERT INTO customers (name, location, email) VALUES
('Alice Johnson', 'New York, USA', 'alice.johnson@email.com'),
('Bob Smith', 'London, UK', 'bob.smith@email.com'),
('Carla Gomez', 'Madrid, Spain', 'carla.gomez@email.com'),
('David Chen', 'Toronto, Canada', 'david.chen@email.com'),
('Emma Müller', 'Berlin, Germany', 'emma.muller@email.com');

-- =========================
-- Suppliers
-- =========================
INSERT INTO suppliers (name, contact_info, country) VALUES
('Global Tech Supplies', 'contact@globaltech.com', 'USA'),
('Euro Electronics', 'sales@euroelectronics.eu', 'Germany'),
('Asia Manufacturing Co', 'info@asiamfg.cn', 'China'),
('Nordic Wholesale', 'orders@nordicwholesale.se', 'Sweden'),
('UK Distribution Ltd', 'support@ukdist.co.uk', 'UK');

-- =========================
-- Products
-- =========================
INSERT INTO products (name, category, price, stock_quantity, supplier_id) VALUES
('Wireless Mouse', 'Electronics', 25.99, 50, 1),
('Mechanical Keyboard', 'Electronics', 89.99, 20, 1),
('USB-C Charger', 'Electronics', 19.99, 8, 2),
('Laptop Stand', 'Accessories', 39.99, 15, 2),
('Noise Cancelling Headphones', 'Electronics', 199.99, 5, 3),
('Webcam HD', 'Electronics', 59.99, 30, 3),
('Monitor 27-inch', 'Electronics', 299.99, 12, 4),
('Desk Lamp', 'Home Office', 29.99, 25, 5);

-- =========================
-- Orders
-- =========================
INSERT INTO orders (customer_id, order_date, order_status) VALUES
(1, '2024-01-05', 'Delivered'),
(2, '2024-01-07', 'Delivered'),
(3, '2024-01-10', 'Shipped'),
(4, '2024-01-12', 'Pending'),
(5, '2024-01-15', 'Delivered'),
(1, '2024-01-18', 'Shipped');

-- =========================
-- Order Items
-- =========================
INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
-- Order 1
(1, 1, 2, 25.99),
(1, 3, 1, 19.99),

-- Order 2
(2, 2, 1, 89.99),
(2, 4, 1, 39.99),

-- Order 3
(3, 5, 1, 199.99),
(3, 6, 2, 59.99),

-- Order 4
(4, 8, 1, 29.99),

-- Order 5
(5, 7, 1, 299.99),
(5, 1, 1, 25.99),

-- Order 6
(6, 3, 2, 19.99);

-- =========================
-- Shipments
-- (one-to-one with orders)
-- =========================
INSERT INTO shipments (order_id, shipped_date, delivery_date, shipping_cost) VALUES
(1, '2024-01-06', '2024-01-08', 9.99),
(2, '2024-01-08', '2024-01-10', 12.50),
(3, '2024-01-11', NULL, 15.00),
(4, NULL, NULL, 7.50),
(5, '2024-01-16', '2024-01-18', 10.00),
(6, '2024-01-19', NULL, 8.99);

ROLLBACK;
--COMMIT;