with source as (
    select * from {{ source('core_banking', 'branch') }}
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