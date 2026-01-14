# Connecta python till databasen

import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

def connect_db():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD")
    )

def get_customers():
    conn = connect_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM customers;")
    rows = cur.fetchall()
    conn.close()
    return rows

def get_products():
    conn = connect_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM products;")
    rows = cur.fetchall()
    conn.close()
    return rows

def total_orders():
    conn = connect_db()
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM orders;")
    total = cur.fetchone()[0]
    conn.close()
    return total

if __name__ == "__main__":
    print("Customers:")
    for c in get_customers():
        print(c)

    print("\nProducts:")
    for p in get_products():
        print(p)

    print("\nTotal orders:", total_orders())


# bryggan mellan Python och databasen.

# Den gör så att alla dina Python-program kan:

# koppla upp sig mot PostgreSQL

# köra SQL-frågor

# hämta data

# skicka data