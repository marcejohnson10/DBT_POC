{{
    config(
        materialized ='incremental',
        unique_key ='n_nationkey',
        on_schema_change='append_new_columns',
        merge_update_columns = ['new_fld']        
    )
}}

select 
n_nationkey,
n_name_derived,
n_name
{% if is_incremental() %}
, new_fld
{% endif %}
from {{ ref('nation_incr_test_rslt31') }}