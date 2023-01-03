{% macro generate(results) -%}
    {#
         load configuration from var
    #}

{% if execute %}
    {%- set cfg = var('dbt_models_metadata', {}) -%}
    

    BEGIN;

    {#
         creating schema and table if not exists
    #}
    {{ dbt_models_metadata.create_table_if_not_exists(cfg) }}

    {#
        update columns
    #}
    {{ dbt_models_metadata.update_columns(cfg) }}

    {#
        upsert results
            NOTE: this package only focues on model results
    #}
     {{ dbt_models_metadata.upsert_results(cfg, results) }}
    
    COMMIT;
{% endif %}
{%- endmacro %}
