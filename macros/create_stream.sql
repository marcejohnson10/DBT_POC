{% macro create_stream(streamname) -%}

    
   {%- if streamname is none -%}

       {%- set stream_name = "{{ this.identifier }}" %} 

    {%- else -%}

        {%- set stream_name = "{{ streamname | trim }}" %}

    {%- endif -%}

    {% set query %}
        create stream if not exists {{ streamname }}_stream on table {{ this }};
    {% endset %}
 
  
    {% do run_query(query) %}

{%- endmacro %}


