

select 
a.*,
1 rwnum,
'{{ env_var("DBT_CLOUD_RUN_ID", "manual") }}' as _audit_run_id,
'{{ target.schema }}' as sch,
'{{ target.name }}' as nm,
'{{ generate_schema_name }}' as custom
{# getColumnnName('amount', 'average net balance') #} 
 from {{ ref('test_2') }} a

