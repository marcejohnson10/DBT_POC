{% macro test_get_full_node_name() -%}

{% if execute %}
{%- set source_relation = adapter.get_relation(
      database=this.database,
      schema=this.schema,
      identifier=this.identifier) -%}
{{ source_relation }}
{{ log("Source Relation: " ~ source_relation, info=true) }}
{% endif %}
{%- endmacro %}

{% macro test_get_database_name() -%}
{% if execute %}
{%- set source_relation = adapter.get_relation(
      database=this.database) -%}
{{ source_relation }}
{{ log("Source Relation: " ~ source_relation, info=true) }}
{% endif %}
{%- endmacro %}

{% macro test_get_schema_name() -%}
{% if execute %}
{%- set source_relation = adapter.get_relation(
      schema=this.schema) -%}
{{ source_relation }}
{{ log("Source Relation: " ~ source_relation, info=true) }}
{% endif %}
{%- endmacro %}

{% macro test_get_model_name() -%}

{% if execute %}
{%- set source_relation = adapter.get_relation(
      database=this.database,
      schema=this.schema,
      identifier=this.identifier) -%}
{{ this.identifier }}
{{ log("Source Relation: " ~ source_relation, info=true) }}
{% endif %}
{%- endmacro %}