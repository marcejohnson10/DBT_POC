{% macro create_stream(streamname=none) -%}

{% if execute %}

{% set query %}    

    {%- if streamname == none or streamname is not defined -%}

       create stream if not exists {{ this }}_stream on table {{ this }};
       

    {%- else -%}

        create stream if not exists {{ streamname }}_stream on table {{ this }};

    {%- endif -%}

{% endset %} 


{% do run_query(query) %}

{%- endif -%}

{%- endmacro %}

