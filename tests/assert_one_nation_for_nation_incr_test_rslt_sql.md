with nations as
(
    select * from {{ ref('nation_incr_test_rslt') }}
    )

    select 
    n_name_derived as name,
    count(*) as cnt
    from nations
    group by name
    having cnt >1