-- Seeds for Products table
INSERT INTO products (product_id, name, category, price, supplier_id, stock_quantity) VALUES
(1, 'Laptop', 'Electronics', 999.99, 1, 50),
(2, 'Smartphone', 'Electronics', 499.99, 1, 100),
(3, 'Desk Chair', 'Furniture', 89.99, 2, 200),
(4, 'Coffee Maker', 'Appliances', 29.99, 3, 150);

-- Seeds for Suppliers table
INSERT INTO suppliers (supplier_id, name, contact_info, country) VALUES
(1, 'Tech Supplies Co.', 'contact@techsupplies.com', 'USA'),
(2, 'Furniture World', 'info@furnitureworld.com', 'Canada'),
(3, 'Home Appliances Inc.', 'support@homeappliances.com', 'UK');

-- Seeds for Customers table
INSERT INTO customers (customer_id, name, location, email) VALUES
(1, 'Alice Johnson', 'New York, NY', 'alice.johnson@example.com'),
(2, 'Bob Smith', 'Los Angeles, CA', 'bob.smith@example.com'),
(3, 'Charlie Brown', 'Chicago, IL', 'charlie.brown@example.com');

-- Seeds for Orders table
INSERT INTO orders (order_id, customer_id, order_date, order_status) VALUES
(1, 1, '2023-10-01', 'Shipped'),
(2, 2, '2023-10-02', 'Processing'),
(3, 3, '2023-10-03', 'Delivered');

-- Seeds for Order_Items table
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 3, 2, 89.99),
(3, 2, 2, 1, 499.99),
(4, 3, 4, 1, 29.99);

-- Seeds for Shipments table
INSERT INTO shipments (shipment_id, order_id, shipped_date, delivery_date, shipping_cost) VALUES
(1, 1, '2023-10-02', '2023-10-05', 15.00),
(2, 2, '2023-10-03', NULL, 10.00),
(3, 3, '2023-10-04', '2023-10-06', 5.00);