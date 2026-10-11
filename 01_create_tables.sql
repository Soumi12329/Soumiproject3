create table customers(
    customer_id INTEGER Primary Key,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_date DATE
);



create table loans(
    loan_id INTEGER Primary Key,
    customer_id INTEGER REFERENCES customers(customer_id),
    loan_type VARCHAR(20),
    loan_amount NUMERIC(12,2),
    outstanding_amount NUMERIC(12,2),
    status VARCHAR(20) CHECK (status IN ('ACTIVE', 'CLOSE'))
);



