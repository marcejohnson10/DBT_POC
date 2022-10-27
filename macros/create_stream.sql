{% macro create_stream(stream_name, source_table_name) -%}

    {% set query %}
        create stream if not exists {{ stream_name }} on table {{ source_table_name }};
    {% endset %}

    {% do run_query(query) %}
{%- endmacro %}


