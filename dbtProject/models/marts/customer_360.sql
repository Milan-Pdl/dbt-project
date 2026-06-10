{{ config(
    materialized='table'
) }}

WITH cust AS (
    SELECT *
    FROM {{ ref('intermediate_customer') }}
),
accounts AS (
    SELECT *
    FROM {{ ref('intermediate_accounts') }}
),
trans AS (
    SELECT *
    FROM {{ ref('intermediate_hist_transcations') }}
)

SELECT
    cust.customer_id,
    cust.customer_name,
    cust.email,
    cust.phone_number,
    cust.country,
    cust.address,
    COUNT(DISTINCT accounts.account_id) AS account_count,
    SUM(accounts.account_balance) AS total_account_balance,
    COUNT(trans.tran_id) AS transaction_count,
    SUM(trans.tran_amount) AS total_transaction_amount,
    MAX(trans.tran_date) AS last_transaction_date
FROM cust
LEFT JOIN accounts ON accounts.customer_id = cust.customer_id
LEFT JOIN trans ON trans.account_id = accounts.account_id
GROUP BY
    cust.customer_id,
    cust.customer_name,
    cust.email,
    cust.phone_number,
    cust.country,
    cust.address
