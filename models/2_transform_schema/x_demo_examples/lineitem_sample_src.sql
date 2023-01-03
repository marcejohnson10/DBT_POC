{{
    config(
        materialized ='incremental',
        unique_key =['l_orderkey','l_partkey','l_suppkey'],
        on_schema_change='sync_all_columns',
        incremental_strategy='merge',
        merge_update_columns=['l_quantity','l_discount']
    )
}}

select  * from {{ source('raw', 'lineitem') }}
sample (2)