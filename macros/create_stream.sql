{% macro create_stream() -%}

    
    {% set query %}
        create stream if not exists {{ this }}_stream on table {{ this }};
    {% endset %}
 
  
    {% do run_query(query) %}

{%- endmacro %}


