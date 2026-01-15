CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    supplier_id INT REFERENCES Suppliers(supplier_id),
    stock_quantity INT DEFAULT 0
);