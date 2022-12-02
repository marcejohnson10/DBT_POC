 /*  
   {{ config(
    materialized="table",
    tags="hourly",
    unique_key='part_key'
) }}
   
 {%- set uni_key = config.get('unique_key') -%}
  {{ uni_key }}
*/

with my_cte as (
    select 
--{{ uni_key }},
--    part.part_key,
--    part.name as part_name,
    part.manufacturer as manufacturer,
    current_date as cur_dt,
--    part.brand,
--    part.type as part_type
    count(*) as cnt
from
 dbt_dev.transform.part_rslt part
 group by part.manufacturer, current_date )

 {{ dbt_utils.deduplicate(
    relation='my_cte',
    partition_by='manufacturer, cur_dt',
    order_by='manufacturer desc',
   )
}}

 --select 'x' from {{this}};
