{{ dbt_utils.deduplicate(
    relation={{ ref('nation_incr_test_rslt41') }},
    partition_by='n_name, n_name_derived',
    order_by="n_nationkey desc",
   )
}}