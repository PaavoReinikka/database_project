 /* Detta är vad jag hade i min pgadmin, då jag genererade alla tables och queries där! */

 -- Customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    email VARCHAR(100)
);

-- Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact_info VARCHAR(150),
    country VARCHAR(50)
);

-- Products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2),
    supplier_id INT REFERENCES suppliers(supplier_id),
    stock_quantity INT
);

-- Orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    order_status VARCHAR(50)
);

-- Order Items
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    price_at_purchase NUMERIC(10,2)
);

-- Shipments
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE REFERENCES orders(order_id),
    shipped_date DATE,
    delivery_date DATE,
    shipping_cost NUMERIC(10,2)
);


INSERT INTO suppliers (name, contact_info, country) VALUES
('TechSupplier', 'tech@email.com', 'Sweden'),
('FoodSupplier', 'food@email.com', 'Germany'),
('ClothesSupplier', 'clothes@email.com', 'Italy');

INSERT INTO customers (name, location, email) VALUES
('Anna Svensson', 'Stockholm', 'anna@mail.com'),
('Erik Johansson', 'Göteborg', 'erik@mail.com'),
('Maria Nilsson', 'Malmö', 'maria@mail.com'),
('Johan Karlsson', 'Uppsala', 'johan@mail.com');

INSERT INTO products (name, category, price, supplier_id, stock_quantity) VALUES
('Laptop', 'Electronics', 12000, 1, 15),
('Headphones', 'Electronics', 800, 1, 50),
('Smartphone', 'Electronics', 9000, 1, 20),
('Pasta', 'Food', 25, 2, 100),
('Coffee', 'Food', 60, 2, 40),
('Jacket', 'Clothing', 1500, 3, 8),
('T-Shirt', 'Clothing', 250, 3, 60);

INSERT INTO orders (customer_id, order_date, order_status) VALUES
(1, '2025-01-01', 'Delivered'),
(2, '2025-01-05', 'Shipped'),
(3, '2025-01-10', 'Processing'),
(4, '2025-01-12', 'Delivered'),
(1, '2025-01-15', 'Shipped');

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 12000),
(1, 2, 2, 800),
(2, 4, 5, 25),
(3, 6, 1, 1500),
(4, 3, 1, 9000),
(5, 7, 3, 250);

INSERT INTO shipments (order_id, shipped_date, delivery_date, shipping_cost) VALUES
(1, '2025-01-02', '2025-01-04', 99),
(2, '2025-01-06', '2025-01-09', 79),
(4, '2025-01-13', '2025-01-15', 89),
(5, '2025-01-16', '2025-01-18', 69);

SELECT * FROM public.customers
ORDER BY customer_id ASC 