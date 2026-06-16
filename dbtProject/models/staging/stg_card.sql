{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='card_number'
) }}
with source as (
    select * from {{ source('core_banking', 'card') }}
    
{% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}

)
select
    card_number,
    account_id,
    balance,
    card_type,
    closing_balance,
    card_expiry_date,
    created_date,
    modified_date
from source
