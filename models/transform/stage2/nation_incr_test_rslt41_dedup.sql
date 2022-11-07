{# Partition By this is the list of fields that make a record unique. Format=> 'field_1, field_2, field_3' with single quotes around set of fields. #}

{{ dbt_utils.deduplicate(
    relation=ref('nation_incr_test_rslt41'),
    partition_by='n_name_derived',
    order_by="n_nationkey desc",
   )
}}