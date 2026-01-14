import pandas as pd
import numpy as np


# Config
#-------------------
N_customers=100
np.random.seed(42)

# Clean text

def clean_text(series: pd.Series) -> pd.Series:
    return (
        series.astype(str)
        .str.encode("ascii", "ignore")
        .str.decode("ascii")
    )

# LOAD DATA
#-------------------------
# Names
df_male=pd.read_csv('male.txt', header=None, names=["first_name"])
df_female=pd.read_csv('female.txt', header=None, names=["first_name"])
df_first_names=pd.concat([df_male,df_female],ignore_index=True)

df_surnames = (
    pd.read_csv('common-surnames-by-country.csv')["Romanized Name"]
    .dropna()
    .rename("last_name")
)

df_surnames = clean_text(df_surnames)


# Location
df_companies = pd.read_csv("companies.csv")

locations=(
    df_companies["Headquarters"]
    .dropna()
    .str.split("+")
    .str[0]
    .str.strip()
)

locations = clean_text(locations)

# Customer Dataframe

# Random select of name values
df_customers=pd.DataFrame({
    "first_name": df_first_names.sample(N_customers,replace=True)["first_name"].values,
    "last_name": df_surnames.sample(N_customers, replace=True)["last_name"].values
})

# Full name creation
df_customers["name"]=(
    df_customers["first_name"]+" "+df_customers["last_name"]
)

df_customers["location"]=np.random.choice(
    locations,
    size=len(df_customers),
    replace=True
)

# Generate customer email
#-------------------

df_customers["email"] = (
    df_customers["first_name"].str.lower().str.replace(" ", "", regex=False) + "." +
    df_customers["last_name"].str.lower().str.replace(" ", "", regex=False) +
    df_customers.index.astype(str) +
    "@gmail.com"
)

# Inserting customer ID
df_customers.insert(
    0,
    "customer_id",
    range(1, len(df_customers) + 1)
)


df_customers = df_customers[["customer_id", "name", "location", "email"]]


df_customers["name"] = clean_text(df_customers["name"])

#TEST
print(df_customers.head())

df_customers.to_csv(
    "customers-final2.csv",
    index=False
)