create or replace function get_outstanding_amount( p_loan_id INTEGER)
RETURNS INTEGER 
LANGUAGE plpgsql
AS $$
DECLARE
      v_outstanding_amount = NUMERIC;

BEGIN
    SELECT outstanding_amount
       INTO v_outstanding_amount
       FROM loans
    WHERE loan_id = p_loan_id;

   F NOT FOUND THEN 
        RAISE EXCEPTION 'Loan % not found', p_loan_id; 
    END IF;

    return v_outstanding_amount;

END;
$$;