-- 1. Open the snapshot block at the very top
{% snapshot snap_customer %}

{{ config(
    target_schema='gold',
    unique_key='customer_id',
    strategy='timestamp',
    updated_at='modified_date'
) }}

select * from {{ ref('intermediate_customer') }}

-- 2. Close the snapshot block at the very bottom
{% endsnapshot %}