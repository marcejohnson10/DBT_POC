{{
    config(
        materialized ='incremental',
        unique_key ='n_nationkey',
        on_schema_change='append_new_columns'
    )
}}
--The on_schema_change='append_new_columns'/'sync_all_columns'/'fail' only works if your model uses a "SELECT *", as shown below.
select 
*
from {{ ref('nation_incr_test_rslt2') }}
