{{
    config(
        materialized ='incremental',
        unique_key ='n_nationkey',
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}

select *
{# {{ dbt_utils.star(from=ref('country_raw')) }} #}
from {{ ref('country_raw') }}


