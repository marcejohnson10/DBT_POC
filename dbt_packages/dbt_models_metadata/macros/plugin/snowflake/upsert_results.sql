{% macro snowflake__model_result_exists(cfg, column_values) %}
    {%- set schema_name = dbt_models_metadata.config__get_schema_name(cfg) -%}
    {%- set table_name = dbt_models_metadata.config__get_table_name(cfg) -%}

    {%- set check_query -%}
        SELECT 1 FROM {{schema_name}}.{{table_name}} WHERE UNIQUE_ID={{adapter.dispatch('to_literal', 'dbt_models_metadata')(column_values["unique_id"]["value"])}};
    {%- endset -%}

    {{ return(run_query(check_query).rows|length == 0) }}
{% endmacro %}


{% macro snowflake__insert_model_result(cfg, column_values) %}
    {%- set schema_name = dbt_models_metadata.config__get_schema_name(cfg) -%}
    {%- set table_name = dbt_models_metadata.config__get_table_name(cfg) -%}
    {%- set query -%}
        INSERT INTO {{schema_name}}.{{table_name}} (
            {%- for cv in column_values.values() %}
                {{cv["column"].name}}{{ ',' if not loop.last }}
            {%- endfor %}
        ) SELECT
            {% for cv in column_values.values() %}
                {%- if cv["column"].data_type|upper == "VARIANT" -%}
                    PARSE_JSON(
                {%- endif -%}
                {%- if cv.get('additional', False) -%}
                    {{adapter.dispatch('to_literal', 'dbt_models_metadata')(render(cv["value"]))}}
                {%- else -%}
                    {{adapter.dispatch('to_literal', 'dbt_models_metadata')(cv["value"])}}
                {%- endif -%}
                {%- if cv["column"].data_type|upper == "VARIANT" -%}
                    )
                {%- endif -%}{{ ',' if not loop.last else ';'}}
            {% endfor -%}
    {%- endset -%}
    {{query}}
{% endmacro %}


{% macro snowflake__update_model_result(cfg, column_values) %}
    {%- set schema_name = dbt_models_metadata.config__get_schema_name(cfg) -%}
    {%- set table_name = dbt_models_metadata.config__get_table_name(cfg) -%}
    {%- set query -%}
        UPDATE {{schema_name}}.{{table_name}}
        SET
            {% for cv in column_values.values() -%}
                {{cv["column"].name}} = {% if cv["column"].data_type|upper == "VARIANT" -%}
                    PARSE_JSON(
                {%- endif -%}
                {%- if cv.get('additional', False) -%}
                    {{adapter.dispatch('to_literal', 'dbt_models_metadata')(render(cv["value"]))}}
                {%- else -%}
                    {{adapter.dispatch('to_literal', 'dbt_models_metadata')(cv["value"])}}
                {%- endif -%}
                {%- if cv["column"].data_type|upper == "VARIANT" -%}
                    )
                {%- endif -%}{{ ',' if not loop.last }}
            {% endfor -%}
        WHERE UNIQUE_ID = {{adapter.dispatch('to_literal', 'dbt_models_metadata')(column_values["unique_id"]["value"])}};
    {%- endset -%}
    {{query}}
{% endmacro %}
