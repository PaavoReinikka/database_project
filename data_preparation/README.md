# Data Generation Guide

This guide explains how synthetic data is generated for the transactional schema, and the key constraints to respect when producing random data that adheres to table relationships and column rules.

## Overview
- Goal: Populate a small retail-like database for demos/analytics.
- Tech: Python (pandas, numpy) for CSV generation; SQL for schema and loading.
- Outputs: Supplier and customer CSVs are generated; other tables can be generated similarly respecting constraints below.

## Schema And Relationships (At A Glance...)
- One Supplier has many Products (Suppliers.supplier_id → Products.supplier_id)
- One Customer has many Orders (Customers.customer_id → Orders.customer_id)
- One Order has many Order_Items (Orders.order_id → Order_Items.order_id)
- One Product can appear in many Order_Items (Products.product_id → Order_Items.product_id)
- One Order has zero or one Shipment (Orders.order_id → Shipments.order_id)

Shipments are optional: pending/cancelled orders typically have no shipment; shipped/delivered orders should have one.

See SQL DDL in `sql/schema.sql`.

Recommended load order to maintain referential integrity:
1) Suppliers → 2) Products → 3) Customers → 4) Orders → 5) Order_Items → 6) Shipments

## Source Data And Scripts (names expected to evolve, same for final directory structure)
- Suppliers
  - Script: `suppliers-table-final.py`
  - Inputs: `companies.csv`, `countries.csv`
  - Output: `suppliers-final.csv`
  - Approach: Samples company names and countries, builds deterministic emails from names, assigns `supplier_id` 1..N.
- Customers
  - Script: `customers-script.py`
  - Inputs: `male.txt`, `female.txt`, `common-surnames-by-country.csv`, `companies.csv` (for locations)
  - Output: `customers-final2.csv`
  - Approach: Samples first/last names, composes full name, samples location from company HQs, generates unique emails by appending row index, assigns `customer_id` 1..N.

Both scripts use `numpy.random.seed(42)` for reproducibility and include simple ASCII normalization (strips accents and non-ASCII characters) to avoid encoding issues in CSV/DB.

## Table-By-Table Generation Notes
- Suppliers
  - Required: `name` (<= 255), `contact_info` (email-ish), `country` (<= 100)
  - Keys: `supplier_id` is SERIAL/identity in DB; if loading with explicit IDs, reset sequence post-load (see below).
- Products
  - Required: `name` (<= 255), `category` (<= 100), `price` DECIMAL(10,2) >= 0, `supplier_id` FK, `stock_quantity` INT >= 0
  - Generation tips: Sample realistic categories; draw `price` from positive distribution; round to 2 decimals; ensure `supplier_id` exists; `stock_quantity` non-negative.
- Customers
  - Required: `name` (<= 255), `location` (<= 255), `email` UNIQUE (<= 255)
  - Generation tips: Guarantee email uniqueness (e.g., suffix with index or UUID); keep within length; normalize ASCII.
- Orders
  - Required: `customer_id` FK, `order_date` (timestamp), `order_status` (<= 50)
  - Generation tips: Sample `customer_id` from existing customers; choose statuses from a small set (e.g., Pending, Processing, Shipped, Delivered, Cancelled) to keep analytics tidy; ensure time window consistency with shipments.
- Order_Items
  - Required: `order_id` FK, `product_id` FK, `quantity` INT > 0, `price_at_purchase` DECIMAL(10,2) >= 0
  - Generation tips: Sample 1–5 items per order; draw `quantity` from small positive ints; set `price_at_purchase` near product `price` with small noise; round to 2 decimals.
- Shipments
  - Required: `order_id` FK, `shipping_cost` DECIMAL(10,2) >= 0; optional `shipped_date`, `delivery_date`
  - Temporal logic: If present, `order_date` ≤ `shipped_date` ≤ `delivery_date`; allow nulls for in-progress orders; keep `shipping_cost` non-negative.

## Random Data Guidelines (Consistency + Realism)
- Reproducibility: Fix RNG seeds (as in the scripts) for consistent results across runs.
- Referential integrity: Always generate FK parents before children; sample child FKs exclusively from existing IDs.
- Uniqueness: Respect `Customers.email` UNIQUE; de-duplicate names/emails if sampling with replacement.
- Types and ranges: Price and costs must be non-negative with 2 decimals; quantities positive integers; text lengths fit defined VARCHAR limits.
- Timestamps: Keep plausible intervals; avoid future dates unless desired.
- Nullability: Only leave columns null if schema allows it.

## Practical Generation Strategy (per table)
- Suppliers
  - Create N suppliers (e.g., 100). Optionally leave `contact_info` null or build deterministic emails from names. Countries sampled from a countries list.
  - If loading explicit IDs, plan to reset the `supplier_id` sequence after COPY.
- Products
  - For every supplier, generate multiple products (e.g., 5–20 per supplier) so every supplier has coverage.
  - Sample `name`/`category` from product seed lists. Draw `price` from a positive distribution and round to 2 decimals. Set `stock_quantity` via `randint(0, 10000)`; treat 0 as out-of-stock.
- Customers
  - Sample first/last names and compose full names. Locations derived from seed locations (e.g., company HQs). Emails formatted as `first.last@domain.tld` with a suffix to guarantee uniqueness.
- Orders
  - For each customer, create several orders within a time window. Choose `order_status` from a small set like `Pending`, `Processing`, `Shipped`, `Delivered`, `Cancelled`.
  - Ensure consistency with shipments: cancelled → no shipment; delivered → shipment with both dates; pending/processing → shipment may be null or only `shipped_date`.
- Order_Items
  - For each order, create 1–5 line items. Choose `product_id` from existing products; `quantity` from small positive ints; set `price_at_purchase` = product price ± small noise (rounded to 2 decimals).
- Shipments
  - For orders that should ship, create exactly one shipment. Pick `shipped_date` ≥ `order_date`; pick `delivery_date` ≥ `shipped_date` (or null if in transit). Sample `shipping_cost` as non-negative and optionally scale with total quantity/weight.

These steps mirror the intent in `data_prep.ipynb`: parents first, then children; per-parent fan-out for dependent rows (Products per Supplier, Orders per Customer, Order_Items per Order, and optional Shipments per Order).

## Loading CSVs And Sequences
When inserting with explicit IDs into SERIAL columns, align the sequence afterward so future inserts don’t collide.

Example Postgres steps (psql):

```sql
-- Create schema
\i sql/schema.sql;

-- Load suppliers
\copy Suppliers(supplier_id,name,contact_info,country) FROM 'suppliers-final.csv' WITH (FORMAT csv, HEADER true);
SELECT setval(pg_get_serial_sequence('Suppliers','supplier_id'), (SELECT max(supplier_id) FROM Suppliers));

-- Load customers
\copy Customers(customer_id,name,location,email) FROM 'customers-final2.csv' WITH (FORMAT csv, HEADER true);
SELECT setval(pg_get_serial_sequence('Customers','customer_id'), (SELECT max(customer_id) FROM Customers));
```

Adjust paths as needed; ensure the psql working directory can access the CSVs.

## Validation Checklist (Quick SQL)
- Orphan checks
```sql
-- Orders without customers
SELECT COUNT(*) FROM Orders o LEFT JOIN Customers c USING (customer_id) WHERE c.customer_id IS NULL;
-- Order items without products or orders
SELECT COUNT(*) FROM Order_Items i LEFT JOIN Products p USING (product_id) WHERE p.product_id IS NULL;
SELECT COUNT(*) FROM Order_Items i LEFT JOIN Orders o USING (order_id) WHERE o.order_id IS NULL;
```
- Email uniqueness
```sql
SELECT email, COUNT(*) FROM Customers GROUP BY email HAVING COUNT(*) > 1;
```
- Temporal sanity
```sql
SELECT COUNT(*) FROM Shipments s JOIN Orders o USING (order_id)
WHERE (s.shipped_date IS NOT NULL AND s.shipped_date < o.order_date)
   OR (s.delivery_date IS NOT NULL AND s.shipped_date IS NOT NULL AND s.delivery_date < s.shipped_date);
```

- Status/Shipment consistency
```sql
-- Cancelled orders should not have shipments
SELECT COUNT(*) FROM Orders o JOIN Shipments s USING (order_id) WHERE LOWER(o.order_status) = 'cancelled';
-- Delivered orders should have shipment with delivery_date
SELECT COUNT(*) FROM Orders o LEFT JOIN Shipments s USING (order_id)
WHERE LOWER(o.order_status) = 'delivered' AND (s.order_id IS NULL OR s.delivery_date IS NULL);
```

## Extending The Generators
- Row counts: Update `N_SUPPLIERS` in `suppliers-table-final.py` and `N_customers` in `customers-script.py`.
- More tables: Follow the table notes above to add generators for Products, Orders, Order_Items, and Shipments.
- Realism: Add category taxonomies, price distributions by category, and simple stock constraints if desired.

## Common Pitfalls
- Forgetting sequence resets after COPY with explicit IDs → future INSERT failures.
- Violating VARCHAR limits with long strings → truncation or errors.
- Non-ASCII characters in CSVs causing load issues → use ASCII normalization like in the scripts.
- Negative or zero monetary/quantity values where not allowed.

---
This guide complements the existing scripts and SQL in this folder. Use it as a checklist when adding new generators or scaling volumes.
