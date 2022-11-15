
{% macro my_macro() %}
{% if execute %}
  {% set something_complex = test_get_full_node_name() %}
  {{ return(something_complex) }}
  {# debug() #}
{% endif %}
{% endmacro %}
