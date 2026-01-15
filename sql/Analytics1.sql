import psycopg2
from psycopg2.extras import RealDictCursor

DB_CONFIG = {
    "host": "localhost",
    "database": "skillio",
    "user": "postgres",
    "password": "YOUR_PASSWORD",
    "port": 5432
}

def get_conn():
    return psycopg2.connect(**DB_CONFIG)

# -------------------------
# BASICS
# -------------------------

def total_orders():
    sql = "SELECT COUNT(*) AS total_orders FROM orders;"
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(sql)
        return cur.fetchone()  # {"total_orders": ...}

def total_sales():
    sql = """
    SELECT COALESCE(SUM(price_at_purchase * quantity), 0) AS total_sales
    FROM order_items;
    """
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(sql)
        return cur.fetchone()

def low_stock_products(threshold=10):
    sql = """
    SELECT COUNT(*) AS low_stock_products
    FROM products
    WHERE stock_quantity < %s;
    """
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(sql, (threshold,))
        return cur.fetchone()

# -------------------------
# JOINS
# -------------------------

def orders_with_customer_and_value():
    sql = """
    SELECT
        o.order_id,
        o.order_date,
        c.name AS customer_name,
        COALESCE(SUM(oi.price_at_purchase * oi.quantity), 0) AS total_order_value
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        o.order_id,
        o.order_date,
        c.name
    ORDER BY o.order_date DESC;
    """
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(sql)
        return cur.fetchall()

def top_5_customers_by_spend(limit=5):
    sql = """
    SELECT
        c.customer_id,
        c.name AS customer_name,
        COALESCE(SUM(oi.price_at_purchase * oi.quantity), 0) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_id,
        c.name
    ORDER BY
        total_spent DESC
    LIMIT %s;
    """
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(sql, (limit,))
        return cur.fetchall()

def suppliers_with_product_count():
    sql = """
    SELECT
        s.supplier_id,
        s.name AS supplier_name,
        COUNT(p.product_id) AS number_of_products
    FROM suppliers s
    LEFT JOIN products p
        ON s.supplier_id = p.supplier_id
    GROUP BY
        s.supplier_id,
        s.name
    ORDER BY
        number_of_products DESC;
    """
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(sql)
        return cur.fetchall()

# -------------------------
# NESTED QUERIES
# -------------------------

def customers_with_more_than_n_orders(n=5):
    # Fix: your outer query used "customer_name" column, but table has "name".
    sql = """
    SELECT
        c.customer_id,
        c.name AS customer_name
    FROM customers c
WHERE c.customer_id IN (
        SELECT
            o.customer_id
        FROM orders o
        GROUP BY o.customer_id
        HAVING COUNT(o.order_id) > %s
    )
    ORDER BY c.customer_id;
    """
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(sql, (n,))
        return cur.fetchall()

# -------------------------
# AVG DELIVERY TIME PER MONTH
# -------------------------

def avg_delivery_time_per_month():
    # Fixes:
    # - Your earlier "avg delivery time per month" query was wrong (it selected order_date and grouped by customer_id).
    # - The "calculating avg delivery time" snippet was missing SELECT.
    # - Using AVG(delivery_date - order_date) returns an interval; we can convert to days.
    sql = """
    SELECT
        TO_CHAR(o.order_date, 'YYYY-MM') AS order_month,
        AVG(EXTRACT(EPOCH FROM (s.delivery_date - o.order_date)) / 86400.0) AS avg_delivery_days
    FROM orders o
    LEFT JOIN shipments s
        ON o.order_id = s.order_id
    WHERE s.delivery_date IS NOT NULL
    GROUP BY order_month
    ORDER BY order_month;
    """
    with get_conn() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
        cur.execute(sql)
        return cur.fetchall()

# -------------------------
# Quick test runner
# -------------------------
if __name__ == "__main__":
    print(total_orders())
    print(total_sales())
    print(low_stock_products(10))

    print("\nOrders with customer + value:")
    for r in orders_with_customer_and_value()[:5]:
        print(r)

    print("\nTop customers:")
    for r in top_5_customers_by_spend():
        print(r)

    print("\nSuppliers with product count:")
    for r in suppliers_with_product_count():
        print(r)

    print("\nCustomers with >5 orders:")
    for r in customers_with_more_than_n_orders(5):
        print(r)

    print("\nAvg delivery time per month:")
    for r in avg_delivery_time_per_month():
        print(r)
