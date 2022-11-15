{{ config(
    materialized='view'
) }}

select  * 
from {{ ref('lineitem_sample_src') }} 
where hash({{ dbt_utils.star(from=ref('lineitem_sample_src')) }}) in 
(select hash({{ dbt_utils.star(from=ref('lineitem_sample_src')) }})
 from {{ ref('lineitem_sample_src') }}_stream)
