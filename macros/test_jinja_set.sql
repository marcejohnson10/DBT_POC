{% macro test_jinja_set() -%}

{%- set source_relation = adapter.get_relation(
      database=this.database,
      schema=this.schema,
      identifier=this.identifier) -%}
{{ source_relation }}

{{ log("Source Relation: " ~ source_relation, info=true) }}

{%- endmacro %}