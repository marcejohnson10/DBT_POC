-- depends_on: {{ ref('z_lineage_3a') }}


{%- call statement('PRE_CALL_Z_LINEAGE_3C', fetch_result=true) -%}
    select id_1 as id_1
    from {{ ref('z_lineage_3a') }}

{%- endcall -%}

{%- set precall = load_result('PRE_CALL_Z_LINEAGE_3C') -%}
{%- set precall_data = precall['data'] -%}
{%- set precall_table = precall['table'] -%}

{% if execute %}
  {% set results_list = precall.columns[0].values() %}
  {% else %}
  {% set results_list = [] %}
{% endif %}
{{ return(results_list) }}


select 
{{ precall_data }} as data,
{{ precall }} as result,
{{ precall_table }} as tbl,
{{ results_list }} as list
from {{ ref('z_lineage_3a') }}

/*
select "ID_1",
  "AMT_1",
  "UNIT_1",
  "TOTAL_3",
  "COLOR_1",
  $sv as "session_variable",
  '{{ var("dbt_project_yml_var") }}' as dbt_yml_var
from {{ ref('z_lineage_2') }}
*/