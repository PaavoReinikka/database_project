#AURA_Project

## Database Design

 - Products: product_id, name, category, price, supplier_id, stock_quantity
 - Suppliers: supplier_id, name, contact_info, country
 - Orders: order_id, customer_id, order_date, order_status
 - Order_items: order_item_id, order_id, product_id, wuantity, price_at_purchase
 - Customers_ customer_id, name, location, email
 - Shipments: shipment_id, order_id, shipped_date, delivery_date, shipping_cost


## Relationships

 - Products to Order_items (one-to-many)
 - Orders to ORder_Items (one-to-many)
 - Orders to Customers (many-to-one)
 - Orders to Shipments (one-to-one)
 - Suppliers to Products (one-to-many)



