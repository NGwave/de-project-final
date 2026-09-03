CREATE TABLE VT260501BE9A82__STAGING.transactions (
    operation_id         VARCHAR(128),
    account_number_from  VARCHAR(128),
    account_number_to    VARCHAR(128),
    currency_code        VARCHAR(10),
    country              VARCHAR(100),
    status               VARCHAR(50),
    transaction_type     VARCHAR(100),
    amount               VARCHAR(50),
    transaction_dt       VARCHAR(50)
)
UNSEGMENTED ALL NODES;

CREATE TABLE VT260501BE9A82__STAGING.currencies (
    date_update        VARCHAR(50),
    currency_code      VARCHAR(10),
    currency_code_with VARCHAR(10),
    currency_code_div  VARCHAR(50)
)
UNSEGMENTED ALL NODES;
