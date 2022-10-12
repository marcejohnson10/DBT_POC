{{
    config(
        materialized = 'table'
    )
}}
with part as (

    select * from {{ref('part_rslt')}}

),

final as (
    select 
        part_key,
        manufacturer,
        name,
        brand,
        type,
        size,
        container,
        retail_price
    from
        part
)
select *
from final  
order by part_key