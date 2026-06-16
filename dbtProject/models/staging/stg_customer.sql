{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='cust_id'
) }}
with source as (
    select * from {{ source('core_banking', 'customer') }}
    
{% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}    
)
select
    cust_id as customer_id,
    name as customer_name,
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
from source