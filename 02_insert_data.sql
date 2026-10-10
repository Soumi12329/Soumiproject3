INSERT INTO Customers
    (customer_id, customer_name, email, phone, created_date)
VALUES
    (11, 'Michael Clark', 'michael.clark@gmail.com', '9876500011', '2026-01-08'),
    (12, 'Emma Davis', 'emma.davis@gmail.com', '9876500012', '2026-02-14'),
    (13, 'Daniel Wilson', 'daniel.wilson@gmail.com', '9876500013', '2026-03-19'),
    (14, 'Olivia Martin', 'olivia.martin@gmail.com', '9876500014', '2026-04-07'),
    (15, 'James Anderson', 'james.anderson@gmail.com', '9876500015', '2026-05-16');


INSERT INTO Loans
    (loan_id,customer_id,loan_type,loan_amount,outstanding_amount,status)
VALUES
    (201, 11, 'HOME',      500000, 450000, 'ACTIVE'),
    (202, 11, 'CAR',       200000, 150000, 'ACTIVE'),
    (203, 12, 'PERSONAL',  100000,  75000, 'ACTIVE'),
    (204, 13, 'HOME',      800000, 650000, 'ACTIVE'),
    (205, 13, 'EDUCATION', 300000, 220000, 'ACTIVE'),
    (206, 14, 'CAR',       400000, 300000, 'ACTIVE'),
    (207, 15, 'PERSONAL',  150000, 100000, 'ACTIVE');
    