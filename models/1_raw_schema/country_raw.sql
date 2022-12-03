

select distinct
n_nationkey as nation_key, 
n_name as name
--'x' as new_fld
from dbt_dev.raw.nation
where n_name in 
('USA',
'ARGENTINA',
'BRAZIL',
'IRAN')
