{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append',
    unique_key ='product_id'
) }}

WITH src AS (
    SELECT
        *
    FROM
        {{ ref('stg_product') }}
        
{% if is_incremental() %}

where modified_date > (select coalesce(max(modified_date),'1900-01-01') from {{ this }} )

{% endif %}        
)

SELECT
    product_id,
    schm_type,
    schm_code,
    product_desc,
    created_date,
    modified_date
FROM
    src
-- ❌ Removed the extra trailing parenthesis from here