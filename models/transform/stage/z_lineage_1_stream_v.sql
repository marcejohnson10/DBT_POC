{{ config(
    materialized='view'
) }}

select  distinct id_1, amt_1, unit_1, amt_1*unit_1 as total_3, color_1 
from {{ source('raw', 'z_lineage_1') }} 
where hash({{ dbt_utils.star(from=source('raw', 'z_lineage_1')) }}) in 
(select hash({{ dbt_utils.star(from=source('raw', 'z_lineage_1')) }})
 from {{ source('raw', 'z_lineage_1') }}_stream)