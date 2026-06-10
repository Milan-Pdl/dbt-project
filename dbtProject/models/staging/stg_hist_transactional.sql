with source as (
    select * from {{ source('core_banking', 'hist_transactional') }}
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
