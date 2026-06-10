{{ config(
    materialized = 'incremental'
) }}

WITH src AS (

    SELECT
        *
    FROM
        {{ ref('stg_customer') }}
)
SELECT
    customer_id,
    customer_name,
    address,
    phone_number,
    postal_code,
    country,
    email,
    father_name,
    mother_name,
    occupation,
    education,
    nationality,
    created_date,
    modified_date
FROM
    src
