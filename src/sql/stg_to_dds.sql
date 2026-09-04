DELETE FROM VT260501BE9A82__DWH.transactions 
WHERE transaction_dt::DATE IN (
    SELECT DISTINCT transaction_dt::TIMESTAMP(3)::DATE 
    FROM VT260501BE9A82__STAGING.transactions 
    WHERE transaction_dt IS NOT NULL
);

INSERT INTO VT260501BE9A82__DWH.transactions (
    operation_id, account_number_from, account_number_to, currency_code, country, status, transaction_type, amount, transaction_dt
)
SELECT 
    operation_id::UUID,
    account_number_from::INT,
    account_number_to::INT,
    currency_code::INT,
    country,
    status,
    transaction_type,
    amount::BIGINT,
    transaction_dt::TIMESTAMP(3)
    
FROM VT260501BE9A82__STAGING.transactions;


MERGE INTO VT260501BE9A82__DWH.currencies tgt
USING (
	  SELECT date_update::DATE as date_update,
      currency_code::INT as currency_code,
      currency_code_with::INT as currency_code_with,
      currency_code_div::NUMERIC(18,8) as currency_code_div
      FROM VT260501BE9A82__STAGING.currencies) src
ON (tgt.date_update = src.date_update AND tgt.currency_code = src.currency_code)
WHEN MATCHED
THEN UPDATE SET 
                currency_code_with = src.currency_code_with, 
                currency_code_div = src.currency_code_div 
WHEN NOT MATCHED
    THEN INSERT (
                date_update,
                currency_code, 
				currency_code_with,
                currency_code_div 
        )
    VALUES (
                src.date_update,
                src.currency_code, 
				src.currency_code_with,
                src.currency_code_div 
        )
;