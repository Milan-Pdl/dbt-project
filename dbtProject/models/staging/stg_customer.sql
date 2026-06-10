with source as (
    select * from {{ source('core_banking', 'customer') }}
)
select
    cust_id as customer_id,
    name as customer_name,
    address,
    phone_number,
    postal_code,
    country,
    email,
    father_name,
    mother_name,
    occupation,
    education,
    nationality,
    created_date,
    modified_date
from source