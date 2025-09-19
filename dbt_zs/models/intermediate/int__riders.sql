with 
source as (
    select *
    from {{ ref("stg__riders") }}
)

select * from source