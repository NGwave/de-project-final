DELETE FROM VT260501BE9A82__DWH.global_metrics
WHERE date_update = '{{ ds }}'::DATE - '1 day'::INTERVAL;

INSERT INTO VT260501BE9A82__DWH.global_metrics
(date_update, currency_from, amount_total, cnt_transactions, avg_transactions_per_account, cnt_accounts_make_transactions)
WITH transactions_in_dollars AS(
	SELECT 
		t.account_number_from as account,
		t.transaction_dt as date_update,
		t.currency_code as currency_from,
		(t.amount::NUMERIC(18, 2) / 100 * COALESCE(c.currency_code_div, 0))::NUMERIC(18, 4) AS amount_in_dollars
	FROM VT260501BE9A82__DWH.transactions t LEFT JOIN VT260501BE9A82__DWH.currencies c
	ON t.currency_code  = c.currency_code 
	AND t.transaction_dt::DATE = c.date_update 
	AND c.currency_code_with = 430 --код доллара 
	WHERE t.account_number_from > 0 AND t.account_number_to > 0 AND t.status = 'done' AND t.transaction_dt::DATE = '{{ ds }}'::DATE - '1 day'::INTERVAL)	
SELECT date_update, currency_from,
SUM(amount_in_dollars) AS amount_total,
COUNT(1) AS cnt_transactions,
(COUNT(1) / COUNT(DISTINCT account))::NUMERIC(18, 4) as avg_transactions_per_account,
COUNT(DISTINCT account) as cnt_accounts_make_transactions
FROM transactions_in_dollars
GROUP BY date_update, currency_from;

COMMIT;