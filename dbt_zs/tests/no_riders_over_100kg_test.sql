{{ config(severity = 'warn') }}

select id from {{ ref("obt__riders") }} where weight > 100 group by 1