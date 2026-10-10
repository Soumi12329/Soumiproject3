CREATE OR REPLACE PROCEDURE make_loan_payment (IN p_loan_id INTEGER, IN p_payment_amount INTEGER)
LANGUAGE PLpgSQL
AS &&

DECLARED
     source_loan BOOLEAN;
     status_check BOOLEAN;
     Amount_flag INTEGER;
BEGIN

     SELECT EXISTS (select 1 from Loans 
     WHERE loan_id = p_loan_id)
         INTO source_loan;
 
     IF source_loan = False THEN
         RAISE EXCEPTION 'Loan does not exist.';
     END IF;

      SELECT EXISTS (select 1 from Loans 
     WHERE loan_id = p_loan_id
     and status = 'Active')
         INTO status_check;

     IF status_check = False THEN
         RAISE EXCEPTION 'Invalid payment amount';
     END IF;

     SELECT EXISTS (SELECT 1 FROM Loans
        Where loan_amount = p_payment_amount)
          INTO Amount_flag;

     IF Amount_flag <= 0  THEN
        RAISE EXCEPTION 'Payment amount must be greater than zero';
     END IF;

     SELECT EXIST (select 1 from Loans
        WHERE outstanding_amount = p_payment_amount)
        INTO outstanding_flag;

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














