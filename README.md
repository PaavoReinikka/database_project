# AURA_Project (aura_db)

### Project group: Firat, Josefine, Nadja, Paavo

### Group roles:
 - Database design and relationships: Josefine
 - Data generation: Paavo
 - Analytical queries: Nadja and Firat
 - Presentation: Nadja

Everyone creates and works in their own branch - use your own name. 
Communicate in Slack before doing pull requests. Only commit to your own branch unless otherwise agreed :) 

_____________________________________________

## Database Design

Everyone creates own local database and empty tables in Postgres.

 - **Products**:
   *     product_id, name, category, price, supplier_id, stock_quantity
 - **Suppliers**:
   *     supplier_id, name, contact_info, country
 - **Orders**:
   *     order_id, customer_id, order_date, order_status
 - **Order_items**:
   *     order_item_id, order_id, product_id, quantity, price_at_purchase
 - **Customers**:
   *     customer_id, name, location, email
 - **Shipments**:
   *     shipment_id, order_id, shipped_date, delivery_date, shipping_cost

## Relationships

 - **Products to Order_items (one-to-many)**
 - **Orders to Order_Items (one-to-many)**
 - **Orders to Customers (many-to-one)**
 - **Orders to Shipments (one-to-one)**
 - **Suppliers to Products (one-to-many)**

## Data generation

### Instructions 
* Write scripts to populate each table with sample data. Key points to cover:
* Randomized data for realistic distribution (for example, price ranges, order dates, shipment dates).
* Data consistency (for example, order_date should be earlier than delivery_date).
* Populate with at least 100 ( 1,000) entries in the Orders, Order_Items, and Customers tables to make
the dataset interesting for analytical queries.
* Example tools for generating sample data: Python’s Faker library or SQL INSERT statements.

