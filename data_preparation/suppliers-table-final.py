import pandas as pd
import numpy as np


# Config
# -------------------
N_SUPPLIERS = 100
np.random.seed(42)


# Load data
# -------------------
df_companies = pd.read_csv("companies.csv")
df_countries = pd.read_csv("countries.csv")

company_names = (
    df_companies["Company Name"]
    .dropna()
    .unique()
)

countries = df_countries["country"].dropna()

# Generate suppliers
# -------------------
df_suppliers = pd.DataFrame({
    "name": np.random.choice(company_names, size=N_SUPPLIERS, replace=True),
    "country": np.random.choice(countries, size=N_SUPPLIERS, replace=True),
})

# Generate contact info (email)
df_suppliers["contact_info"] = (
    df_suppliers["name"]
    .str.lower()
    .str.replace(r"[^a-z0-9]", "", regex=True)
    + "@company.com"
)

# Add supplier_id
df_suppliers.insert(
    0,
    "supplier_id",
    range(1, len(df_suppliers) + 1)
)

# Reorder columns
df_suppliers = df_suppliers[
    ["supplier_id", "name", "contact_info", "country"]
]

# Save to CSV
df_suppliers.to_csv(
    "suppliers-final.csv",
    index=False
)

print(df_suppliers.head())