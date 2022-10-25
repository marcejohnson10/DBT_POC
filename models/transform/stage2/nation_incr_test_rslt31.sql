{{
    config(
        materialized ='incremental',
        unique_key ='n_nationkey',
        on_schema_change='sync_all_columns'
    )
}}

select 
*
from {{ ref('nation_incr_test_rslt2') }}
