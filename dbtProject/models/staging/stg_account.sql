{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='account_id'
) }}

with source as (
    select * from {{ source('core_banking', 'account') }}

{% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}

)
select
    account_id,
    customer_id,
    branch_id,
    account_balance,
    lien_amt,
    acct_cls_flg,
    product_id,
    schm_type,
    schm_code,
    acct_crncy_code,
    acct_opn_date,
    created_date,
    modified_date
from source
