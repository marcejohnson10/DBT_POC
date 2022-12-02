-----------------------------------------------------------------------------------------------------------------
--This performs a merge 2-step merge. 
--Step 1 - update fields when unique_key matches. 
--Step 2 - Insert new recs when no match on unique_key
--NOTE: multi-conditional merge statements are not possible in DBT models without creating a custom macro 
-----------------------------------------------------------------------------------------------------------------

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
