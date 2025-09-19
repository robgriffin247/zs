with 
source as (
    select *
    from {{ ref("int__riders") }}
)

select * from source