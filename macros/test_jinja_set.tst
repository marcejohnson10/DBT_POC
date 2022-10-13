
    {% set my_list = [1, 2, 2, 3] %}
    {% set my_set = set(my_list) %}
    {% do log(my_set) %}  {# {1, 2, 3} #}


{# if execute #}
select {{ my_set }}
{{ my_list[0] }}
{{ my_list[1] }}
{{ my_list }}
{# endif #}