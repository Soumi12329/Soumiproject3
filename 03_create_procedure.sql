CREATE OR REPLACE PROCEDURE make_loan_payment(IN p_loan_id INTEGER, IN p_payment_amount INTEGER)
LANGUAGE PLpgSQL
AS $$  -- fixed previously given && check end you give $$

DECLARE
     source_loan BOOLEAN;
     status_check BOOLEAN;
     outstanding_amount_balance NUMERIC(12,2);
BEGIN
    source_loan = false;
    status_check = false;
    

    -- check whether the loan exists
     SELECT EXISTS (select 1 from loans 
     WHERE loan_id = p_loan_id)
         INTO source_loan;
 
     IF source_loan = false THEN
         RAISE EXCEPTION 'Loan does not exist.';
     END IF;

    -- CHECKING LOAN IS ACTIVE IF CLOSED GIVE ERROR
    SELECT EXISTS (select 1 from loans 
     WHERE loan_id = p_loan_id
     and UPPER(status) = 'ACTIVE'
    )
    INTO status_check;

     IF status_check = false THEN
         RAISE EXCEPTION 'Loan is closed , provide a active loan';
     END IF;

    -- checking given amount not zeror or negative
    IF p_payment_amount IS NULL OR p_payment_amount <= 0 THEN
        RAISE EXCEPTION 'Payment amount must be greater than zero';
    END IF;

    --  checking  payment exceeds outstanding amount 
     select outstanding_amount into outstanding_amount_balance 
     from loans
     WHERE loan_id = p_loan_id ;

    IF p_payment_amount> outstanding_amount_balance THEN
       RAISE EXCEPTION 'Payment exceeds outstanding amount';
    END IF;

    UPDATE Loans
     SET outstanding_amount = (outstanding_amount_balance - p_payment_amount)
    WHERE loan_id = p_loan_id;

    -- Syntax wrong and 
    -- why give error for closed its already checked earlier
    -- IF (outstanding_amount_balance - p_payment_amount) = 0 THEN
    --     UPDATE Loans
    --       SET status = 'CLOSED'
    --       WHERE loan_id = p_loan_id;
    -- ELSE RAISE EXCEPTION 'Loan is already closed';
    -- END IF;
    -- fixed Sysntx
    IF (outstanding_amount_balance - p_payment_amount) = 0 THEN
    UPDATE loans
    SET status = 'CLOSED'
    WHERE loan_id = p_loan_id;
    END IF;


--   Better Approach
--   --  Deduct payment and close loan if fully paid
--     UPDATE loans
--     SET outstanding_amount =
--             outstanding_amount - p_payment_amount,
--         status = CASE
--             WHEN outstanding_amount - p_payment_amount = 0
--                 THEN 'CLOSED'
--             ELSE status
--         END
--     WHERE loan_id = p_loan_id;

    RAISE NOTICE
        'Payment of % processed successfully for loan %.',
        p_payment_amount,
        p_loan_id;
        
    EXCEPTION
         WHEN OTHERS THEN
         RAISE NOTICE 'Payment failed: %', SQLERRM;
         RAISE;
         -- RAISE is used to display messages, generate errors, and report exceptions.
END;
$$;














