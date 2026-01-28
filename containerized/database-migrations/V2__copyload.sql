-- loads csv files from ../data-preparation/data into corresponding tables
-- suppliers.csv -> Suppliers
-- products.csv -> Products
-- customers.csv -> Customers
-- orders.csv -> Orders
-- order_items.csv -> Order_Items
-- shipments.csv -> Shipments
BEGIN;
COPY Suppliers(supplier_id, name, contact_info, country) FROM '/data/suppliers.csv' DELIMITER ',' CSV HEADER;
COPY Products(product_id, name, category, price, supplier_id, stock_quantity) FROM '/data/products.csv' DELIMITER ',' CSV HEADER;
COPY Customers(customer_id, name, location, email) FROM '/data/customers.csv' DELIMITER ',' CSV HEADER;
COPY Orders(order_id, customer_id, order_date, order_status) FROM '/data/orders.csv' DELIMITER ',' CSV HEADER;
COPY Order_Items(order_item_id, order_id, product_id, quantity, price_at_purchase) FROM '/data/order_items.csv' DELIMITER ',' CSV HEADER;
COPY Shipments(shipment_id, order_id, shipped_date, delivery_date, shipping_cost) FROM '/data/shipments.csv' DELIMITER ',' CSV HEADER;


-- Verify row counts after loading
SELECT 'Suppliers' AS table_name, COUNT(*) AS row_count FROM Suppliers;
SELECT 'Products' AS table_name, COUNT(*) AS row_count FROM Products;
SELECT 'Customers' AS table_name, COUNT(*) AS row_count FROM Customers; 
SELECT 'Orders' AS table_name, COUNT(*) AS row_count FROM Orders;
SELECT 'Order_Items' AS table_name, COUNT(*) AS row_count FROM Order_Items;
SELECT 'Shipments' AS table_name, COUNT(*) AS row_count FROM Shipments;
-- End of V2__copyload.sql

COMMIT;

