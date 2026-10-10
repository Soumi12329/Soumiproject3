PostgreSQL / PL/pgSQL Developer Task — Customer Loan Management
Scenario

You are working as a PostgreSQL Developer for a banking application.

Create a small Customer Loan Management module.

You need to:

Create tables
Insert customer and loan data
Create a PL/pgSQL procedure for loan payments
Create a PL/pgSQL function to retrieve outstanding balance
Execute all SQL files using a Linux shell script
Test the functionality
Push the complete project to GitHub
Project Structure
loan-management/
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_create_procedure.sql
│   └── 04_create_function.sql
│
├── run.sh
└── README.md
Data to Insert

Customers
stomer_id	customer_name	email						phone	created_date
	11		Michael Clark	michael.clark@gmail.com	9876500011	2026-01-08
	12		Emma Davis		emma.davis@gmail.com	9876500012	2026-02-14
	13		Daniel Wilson	daniel.wilson@gmail.com	9876500013	2026-03-19
	14		Olivia Martin	olivia.martin@gmail.com	9876500014	2026-04-07
	15		James Anderson	james.anderson@gmail.com	9876500015	2026-05-16

Loans
| loan_id | customer_id | loan_type | loan_amount | outstanding_amount | status |
| ------: | ----------: | --------- | ----------: | -----------------: | ------ |
|     201 |          11 | HOME      |      500000 |             450000 | ACTIVE |
|     202 |          11 | CAR       |      200000 |             150000 | ACTIVE |
|     203 |          12 | PERSONAL  |      100000 |              75000 | ACTIVE |
|     204 |          13 | HOME      |      800000 |             650000 | ACTIVE |
|     205 |          13 | EDUCATION |      300000 |             220000 | ACTIVE |
|     206 |          14 | CAR       |      400000 |             300000 | ACTIVE |
|     207 |          15 | PERSONAL  |      150000 |             100000 | ACTIVE |

File 1 — 01_create_tables.sql

Create two tables.

customers

| Column        | PostgreSQL Type | Requirement |
| ------------- | --------------- | ----------- |
| customer_id   | INTEGER         | Primary Key |
| customer_name | VARCHAR(100)    | NOT NULL    |
| email         | VARCHAR(100)    | UNIQUE      |
| phone         | VARCHAR(15)     |             |
| created_date  | DATE            |             |

loans

| Column             | PostgreSQL Type | Requirement |
| ------------------ | --------------- | ----------- |
| loan_id            | INTEGER         | Primary Key |
| customer_id        | INTEGER         | Foreign Key |
| loan_type          | VARCHAR(20)     |             |
| loan_amount        | NUMERIC(12,2)   |             |
| outstanding_amount | NUMERIC(12,2)   |             |
| status             | VARCHAR(20)     |             |

Relationship:

customers
    |
    | customer_id
    |
  loans

One customer can have multiple loans.

Use:

CREATE TABLE
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
File 2 — 02_insert_data.sql

Insert the provided:

5 customers
7 loans

Use:

INSERT INTO customers ...
INSERT INTO loans ...

COMMIT;

Then verify:
SELECT * FROM customers;
SELECT * FROM loans;

File 3 — 03_create_procedure.sql

Create a PostgreSQL procedure:

make_loan_payment
Parameters
p_loan_id
p_payment_amount

Example:

Loan 201
Payment = 10000

The procedure must:

Check whether the loan exists.
Check whether the loan is ACTIVE.
Check whether the payment amount is greater than zero.
Check whether the payment is greater than the outstanding amount.
Deduct the payment from outstanding_amount.
If the outstanding amount becomes 0, change status to CLOSED.
Display a success message.
Handle exceptions properly.

Use PostgreSQL:

CREATE OR REPLACE PROCEDURE

and:

LANGUAGE plpgsql

You can use:

SELECT ... INTO ...

For custom errors:

RAISE EXCEPTION 'Payment amount must be greater than zero';

You can also use PostgreSQL error codes if you want.

Handle:

Loan does not exist
Invalid payment amount
Payment exceeds outstanding amount
Loan is already closed
Unexpected error
Testing the Procedure

Successful payment:

CALL make_loan_payment(201, 10000);

Expected:
Loan 201
Before = 450000
Payment = 10000
After = 440000

Verify:

SELECT loan_id, outstanding_amount, status
FROM loans
ORDER BY loan_id;
Test another payment
CALL make_loan_payment(203, 25000);

Expected:

Loan 203
Before = 75000
Payment = 25000
After = 50000
Invalid loan
CALL make_loan_payment(999, 5000);

Should produce a loan does not exist error.

Invalid payment
CALL make_loan_payment(201, -5000);

Should produce an invalid payment amount error.

Excessive payment
CALL make_loan_payment(201, 999999999);

Should produce an amount exceeds outstanding balance error.

File 4 — 04_create_function.sql

Create a PostgreSQL function:

get_outstanding_amount

It should accept:
p_loan_id

and return the current outstanding amount.

Use:

CREATE OR REPLACE FUNCTION

with:

RETURNS NUMERIC

Inside the function, use:

SELECT outstanding_amount
INTO v_outstanding_amount
FROM loans
WHERE loan_id = p_loan_id;

Handle the situation where the loan doesn't exist.

Test
SELECT get_outstanding_amount(201);

After a 10000 payment, expected:
440000

File 5 — run.sh
Because this is PostgreSQL, use psql, not sqlplus.

Basic structure:

#!/bin/bash

psql -U username -d database_name <<EOF

\i sql/01_create_tables.sql
\i sql/02_insert_data.sql
\i sql/03_create_procedure.sql
\i sql/04_create_function.sql

