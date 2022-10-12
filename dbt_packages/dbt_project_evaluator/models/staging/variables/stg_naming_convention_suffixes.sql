{% set var_model_types = var('model_types') %}
{% set suffix_model_type = '_suffixes' %}

{% set vars_suffix = [] %}

{% for model_type in var_model_types %}
  {% do vars_suffix.append(model_type ~ suffix_model_type) %}
{% endfor %}

with vars_suffix_table as (
    {{ dbt_project_evaluator.loop_vars(vars_suffix) }}
),

parsed as (

select
    var_name as suffix_name, 
    {{ dbt.split_part('var_name', "'_'", 1) }} as model_type,
    var_value as suffix_value
from vars_suffix_table

),

final as (

    select
        {{ dbt_utils.surrogate_key(['model_type', 'suffix_value']) }} as unique_id,
        *
    from parsed

)

select * from final