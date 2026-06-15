{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key ='card_number'
) }}

with src as (
    select * from {{ ref('stg_card') }}
    {% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}

)
SELECT
    card_number,
    account_id,
    balance,
    card_type,
    closing_balance,
    card_expiry_date,
    created_date,
    modified_date
FROM
    src
