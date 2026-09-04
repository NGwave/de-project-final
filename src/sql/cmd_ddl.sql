DROP TABLE IF EXISTS VT260501BE9A82__DWH.global_metrics CASCADE;

CREATE TABLE VT260501BE9A82__DWH.global_metrics (
    date_update                    DATE NOT NULL,
    currency_from                  INT NOT NULL,
    amount_total                   NUMERIC(18, 2) NOT NULL,
    cnt_transactions               INT NOT NULL,
    avg_transactions_per_account   NUMERIC(10, 2) NOT NULL,
    cnt_accounts_make_transactions INT NOT NULL
)
PARTITION BY (date_update);

CREATE PROJECTION VT260501BE9A82__DWH.global_metrics_proj AS
SELECT * FROM VT260501BE9A82__DWH.global_metrics
ORDER BY date_update, currency_from
SEGMENTED BY HASH(date_update, currency_from) ALL NODES;