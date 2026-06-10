{{ config(
    materialized='table'
) }}

WITH txn AS (
    SELECT
        tran_date,
        branch_id,
        tran_amount
    FROM {{ ref('intermediate_hist_transcations') }}
),
branch AS (
    SELECT
        branch_id,
        branch_name,
        province,
        city_name,
        cluster_name
    FROM {{ ref('intermediate_branch') }}
)

SELECT
    txn.tran_date::date AS summary_date,
    txn.branch_id,
    branch.branch_name,
    branch.province,
    branch.city_name,
    branch.cluster_name,
    COUNT(*) AS transaction_count,
    SUM(txn.tran_amount) AS total_transaction_amount,
    AVG(txn.tran_amount) AS avg_transaction_amount,
    MAX(txn.tran_amount) AS max_transaction_amount,
    MIN(txn.tran_amount) AS min_transaction_amount
FROM txn
LEFT JOIN branch ON txn.branch_id = branch.branch_id
GROUP BY
    1,
    txn.branch_id,
    branch.branch_name,
    branch.province,
    branch.city_name,
    branch.cluster_name
ORDER BY 1
