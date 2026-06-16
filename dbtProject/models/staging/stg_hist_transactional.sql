{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='tran_id'
) }}
with source as (
    select * from {{ source('core_banking', 'hist_transactional') }}
    
{% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}    
)
select
    tran_id,
    account_id,
    tran_amount,
    tran_date,
    tran_crncy,
    branch_id,
    tran_particular,
    tran_remarks,
    created_date,
    modified_date
from source
