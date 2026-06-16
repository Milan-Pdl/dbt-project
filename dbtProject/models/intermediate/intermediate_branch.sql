{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='product_id'
) }}
WITH src AS (

    SELECT
        *
    FROM
        {{ ref('stg_branch') }}

{% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}

)

SELECT
    branch_id,
    province,
    cluster_name,
    city_name,
    branch_name,
    created_date,
    modified_date       
FROM    src
