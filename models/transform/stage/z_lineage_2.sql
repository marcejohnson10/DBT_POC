{{ config(
    materialized ='incremental'
) }}



select * 
from {{ ref('z_lineage_1_stream_v') }}