CREATE TABLE VT260501BE9A82__DWH.transactions (
    operation_id         UUID NOT NULL,
    account_number_from  INT NOT NULL,
    account_number_to    INT NOT NULL,
    currency_code        INT NOT NULL,
    country              VARCHAR(50),
    status               VARCHAR(20),
    transaction_type     VARCHAR(30),
    amount               BIGINT,
    transaction_dt       TIMESTAMP(3) NOT NULL
)
PARTITION BY (transaction_dt::DATE);

CREATE PROJECTION VT260501BE9A82__DWH.transactions_proj AS
SELECT * FROM VT260501BE9A82__DWH.transactions
ORDER BY transaction_dt, currency_code, status
SEGMENTED BY HASH(transaction_dt, operation_id) ALL NODES;

CREATE TABLE VT260501BE9A82__DWH.currencies (
    date_update        DATE NOT NULL,
    currency_code      INT NOT NULL,
    currency_code_with INT NOT NULL,
    currency_code_div  NUMERIC(18, 8) NOT NULL
)
PARTITION BY (date_update);

CREATE PROJECTION VT260501BE9A82__DWH.currencies_proj AS
SELECT * FROM VT260501BE9A82__DWH.currencies
ORDER BY date_update, currency_code
SEGMENTED BY HASH(date_update) ALL NODES;

