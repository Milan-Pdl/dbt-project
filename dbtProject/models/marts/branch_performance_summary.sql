{{ config(
    materialized='table'
) }}

WITH branch AS (
    SELECT *
    FROM {{ ref('intermediate_branch') }}
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
    branch.branch_id,
    branch.branch_name,
    branch.province,
    branch.city_name,
    branch.cluster_name,
    COUNT(DISTINCT accounts.account_id) AS account_count,
    COUNT(DISTINCT accounts.customer_id) AS customer_count,
    SUM(accounts.account_balance) AS total_account_balance,
    COUNT(trans.tran_id) AS total_transaction_count,
    SUM(trans.tran_amount) AS total_transaction_amount,
    AVG(trans.tran_amount) AS avg_transaction_amount,
    MAX(trans.tran_amount) AS max_transaction_amount,
    MAX(trans.tran_date) AS last_transaction_date
FROM branch
LEFT JOIN accounts ON accounts.branch_id = branch.branch_id
LEFT JOIN trans ON trans.branch_id = branch.branch_id
GROUP BY
    branch.branch_id,
    branch.branch_name,
    branch.province,
    branch.city_name,
    branch.cluster_name
