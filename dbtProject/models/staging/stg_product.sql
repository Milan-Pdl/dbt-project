{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='product_id'
) }}
with source as (
    select * from {{ source('core_banking', 'product') }}
    
{% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}
)
select
    product_id,
    schm_type,
    schm_code,
    product_desc,
    created_date,
    modified_date
from source
