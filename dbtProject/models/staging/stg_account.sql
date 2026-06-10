with source as (
    select * from {{ source('core_banking', 'account') }}
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
