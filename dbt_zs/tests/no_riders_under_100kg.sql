with source as (
    select * from {{ ref("obt__riders") }}
)

select * from source where weight<100