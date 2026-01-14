# PostgreSQL Database Schema Documentation

## Overview

This project defines a PostgreSQL database schema for managing a simple e-commerce system. The schema includes tables for Products, Suppliers, Orders, Order Items, Customers, and Shipments, along with their relationships.

## Tables

1. **Products**
   - `product_id` (Primary Key)
   - `name`
   - `category`
   - `price`
   - `supplier_id` (Foreign Key referencing Suppliers)
   - `stock_quantity`

2. **Suppliers**
   - `supplier_id` (Primary Key)
   - `name`
   - `contact_info`
   - `country`

3. **Customers**
   - `customer_id` (Primary Key)
   - `name`
   - `location`
   - `email`

4. **Orders**
   - `order_id` (Primary Key)
   - `customer_id` (Foreign Key referencing Customers)
   - `order_date`
   - `order_status`

5. **Order_Items**
   - `order_item_id` (Primary Key)
   - `order_id` (Foreign Key referencing Orders)
   - `product_id` (Foreign Key referencing Products)
   - `quantity`
   - `price_at_purchase`

6. **Shipments**
   - `shipment_id` (Primary Key)
   - `order_id` (Foreign Key referencing Orders)
   - `shipped_date`
   - `delivery_date`
   - `shipping_cost`

## Relationships

- Each Product is supplied by a Supplier.
- Each Order is placed by a Customer.
- Each Order can contain multiple Order Items.
- Each Order Item references a Product.
- Each Order can have one or more Shipments.

## Setup Instructions

1. Ensure you have PostgreSQL installed and running.
2. Clone this repository to your local machine.
3. Navigate to the `src/sql` directory.
4. Execute the `schema.sql` file to create the database schema.
5. Optionally, run the `seeds.sql` file to populate the tables with initial data.

## Diagrams

The ERD (Entity-Relationship Diagram) illustrating the tables and their relationships can be found in the `src/diagrams/erd.wsd` file. You can use PlantUML to visualize the diagram.

## Conclusion

This schema provides a foundational structure for an e-commerce application, allowing for the management of products, suppliers, customers, orders, and shipments.