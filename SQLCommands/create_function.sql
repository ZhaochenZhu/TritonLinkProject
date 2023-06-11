CREATE FUNCTION IIF(
        condition boolean, true_result numeric, false_result numeric
    ) RETURNS numeric LANGUAGE plpgsql AS $$
    BEGIN
     IF condition THEN
        RETURN true_result;
     ELSE
        RETURN false_result;
     END IF;
    END
    $$;
