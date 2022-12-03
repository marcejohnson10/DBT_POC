{{
    config(
        materialized ='incremental',
        unique_key ='n_nationkey',
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}
--if the unique_key is actualy not unique for any given set of records the entire load will fail when incremental_strategy='merge'. When incremental_strategy='delete+insert', 
--the table is truncated and reloaded and the unique_key is no longer respected (i.e. multiple rows with the same unique_key are loaded).
--Consider useing the config "merge_update_columns = ['n_name_derived', 'new_fld'] if you ONLY want updates applie to specific fields other than the unique_key. If you don't 
--specify "merge_update_columns = ['n_name_derived', 'new_fld'], then all fields except the unique_key will be updated with the merge.
select 
n_nationkey,
n_name_derived,
n_name,
new_fld 
from {{ ref('country_raw') }}

where --n_regionkey = 1 or
 --n_regionkey = 2 
 n_regionkey = 4  and n_nationkey =10