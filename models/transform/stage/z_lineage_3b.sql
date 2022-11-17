{{ config(
    materialized ='incremental',
    pre_hook="set sv = 'var color'",
    post_hook="unset sv"    
) }}



select "ID_1",
  "AMT_1",
  "UNIT_1",
  "TOTAL_3",
  "COLOR_1",
  $sv as "session_variable",
  '{{ var("dbt_project_yml_var") }}' as dbt_yml_var --,
/*{% if execute %}
  {{ my_macro() }} as get_full_node
 {% endif %}*/ 
from {{ ref('z_lineage_2') }}