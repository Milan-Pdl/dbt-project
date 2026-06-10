with source as (
    select * from {{ source('core_banking', 'card') }}
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
