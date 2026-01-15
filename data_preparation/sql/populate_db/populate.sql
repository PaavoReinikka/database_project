-- C:\Users\paavo\Tiedostot\Skillio\ProjectWork\database_project\database_project\data\customers_final.csv

/*

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL
);

*/

COPY Customers (customer_id, name, location, email)
FROM 'C:/Users/paavo/Tiedostot/Skillio/ProjectWork/database_project/database_project/data/customers_final.csv'
DELIMITER ','
CSV HEADER;
