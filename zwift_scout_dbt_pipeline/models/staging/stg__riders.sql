with source as (
    select * 
    from {{ source("raw", "riders") }}
)

select * from source