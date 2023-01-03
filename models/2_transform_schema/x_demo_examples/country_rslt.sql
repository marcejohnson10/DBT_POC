{{
    config(
        materialized ='incremental',
        unique_key ='nation_key',
        on_schema_change='sync_all_columns',
        incremental_strategy='merge'
    )
}}

select *
{# {{ dbt_utils.star(from=ref('country_raw')) }} #}
from {{ ref('country_raw') }}


