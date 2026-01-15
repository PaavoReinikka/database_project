BEGIN;

-- ADD info on schemas

-- ONLY USE BELOW - if commiting changes to below tables
--DROP TABLE IF EXISTS
   -- order_items,
   -- shipments,
   -- orders,
   -- products,
   -- suppliers,
  --  customers
--CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info TEXT,
    country VARCHAR(100)
);


CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    supplier_id INT NOT NULL,
    FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
    ON DELETE CASCADE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    order_status VARCHAR(50),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
    ON DELETE CASCADE
);



CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
    ON DELETE CASCADE
);


CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,
    shipped_date DATE,
    delivery_date DATE,
    shipping_cost NUMERIC(10,2),
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
    ON DELETE CASCADE
);

ROLLBACK;

--COMMIT;