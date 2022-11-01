{{ config(
    materialized ='incremental',
    on_schema_change='sync_all_columns',
    post_hook="{{ create_stream() }}"
) }}


select 
'{{ target_model }}' x_model,
'{{ target.type }}' x_type,
'{{ target.schema }}' x_schema,
'{{ target.name }}' x_name,
'{{ target.database }}' x_database,
'{{ target.profile_name }}' x_profile_name,
'{{ target.warehouse }}' x_warehouse,
'{{ target.user }}' x_user,
'{{ target.role }}' x_role,
'{{ target.account }}' x_account,
'{{ this }}' x_this,
'{{ this.schema }}' as x_this_schema,
'{{ this.identifier }}' as x_this_identifier,
trim('{{ test_get_model_name() }}') as x_test_get_model_name

from dual
