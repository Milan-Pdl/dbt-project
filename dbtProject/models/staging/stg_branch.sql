{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='branch_id'
) }}
with source as (
    select * from {{ source('core_banking', 'branch') }}

{% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}

)
select
    branch_id,
    province,  -- Fixing the typo cleanly at the entrance of your pipeline
    cluster_name,
    city_name,
    branch_name,
    created_date,
    modified_date
from source