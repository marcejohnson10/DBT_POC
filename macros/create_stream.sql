{% macro create_stream(stream_name, source_table_name) -%}
create stream if not exists {{ stream_name }} on table {{ source_table_name }};
{%- endmacro %}


