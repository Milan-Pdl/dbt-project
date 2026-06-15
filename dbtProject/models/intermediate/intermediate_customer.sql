{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key ='customer_id'
) }}

with src as (
    select * from {{ ref('stg_customer') }}
    {% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}
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
