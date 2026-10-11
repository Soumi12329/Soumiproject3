CREATE OR REPLACE PROCEDURE make_loan_payment(IN p_loan_id INTEGER, IN p_payment_amount INTEGER)
LANGUAGE PLpgSQL
AS &&

DECLARED
     source_loan BOOLEAN;
     status_check BOOLEAN;
     outstanding_amount INTEGER;
BEGIN
    source_loan = false;
    status_check = false;
    amount_flag = 0;
     SELECT EXISTS (select 1 from loans 
     WHERE loan_id = p_loan_id)
         INTO source_loan;
 
     IF source_loan = false THEN
         RAISE EXCEPTION 'Loan does not exist.';
     END IF;

    SELECT EXISTS (select 1 from loans 
     WHERE loan_id = p_loan_id
     and lower(status) = 'active')
         INTO status_check;

     IF status_check = false THEN
         RAISE EXCEPTION 'Invalid payment amount';
     END IF;

     IF p_payment_amount <= 0  THEN
        RAISE EXCEPTION 'Payment amount must be greater than zero';
     END IF;

     select outstanding_amount from loans
        WHERE outstanding_amount = p_payment_amount -- fix  this wrong
        ;

    IF outstanding_flag < p_payment_amount THEN
       RAISE EXCEPTION 'Payment exceeds outstanding amount';
    END IF;

    UPDATE Loans
     SET outstanding_amount = (outstanding_amount - p_payment_amount)
     WHERE loan_id = p_loan_id;

     IF (outstanding_amount - p_payment_amount) = 0 THEN
        UPDATE Loans
          SET status = 'CLOSED'
          WHERE loan_id = p_loan_id;
    ELSE RAISE EXCEPTION 'Loan is already closed';
    END IF;

    RAISE NOTICE 'Successful payment: p_payment_amount';

    EXCEPTION
         WHEN OTHERS THEN
         RAISE NOTICE 'Unexpected error...Testing the Procedure';

    END;
    $$;














