{{ config(
    materialized ='incremental'
) }}



select * 
from {{ ref('z_lineage_2') }}