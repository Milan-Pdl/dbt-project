{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='product_id'
) }}
with source as (
    select * from {{ source('core_banking', 'product') }}
)
select
    product_id,
    schm_type,
    schm_code,
    product_desc,
    created_date,
    modified_date
from source
