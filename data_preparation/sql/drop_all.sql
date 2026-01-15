-- Drop all tables in dependency-safe order
-- CASCADE ensures drops succeed regardless of existing foreign keys

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS shipments CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;
