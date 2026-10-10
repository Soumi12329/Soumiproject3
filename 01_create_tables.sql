create table Customers(
    customer_id INTEGER Primary Key,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    created_date DATE
);

create table Loans(
    loan_id INTEGER Primary Key,
    customer_id INTEGER REFERENCES Customers(customer_id),
    loan_type VARCHAR(20),
    loan_amount NUMERIC(12,2),
    outstanding_amount NUMERIC(12,2),
    status VARCHAR(20)
);



