-- Establish foreign key relationships between the tables

-- Products table
ALTER TABLE products
ADD CONSTRAINT fk_supplier
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);

-- Suppliers table
-- No foreign keys to establish

-- Customers table
-- No foreign keys to establish

-- Orders table
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Order_Items table
ALTER TABLE order_items
ADD CONSTRAINT fk_order
FOREIGN KEY (order_id) REFERENCES orders(order_id),
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Shipments table
ALTER TABLE shipments
ADD CONSTRAINT fk_order_shipment
FOREIGN KEY (order_id) REFERENCES orders(order_id);