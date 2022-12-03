
select distinct 
n_nationkey, 
case n_name 
when 'BRAZIL' then 'USA'
when 'ARGENTINA' then 'USA'
when 'EGYPT' then 'USA'
when 'IRAN' then 'USA'
when 'INDIA' then 'USA'
else n_name end as n_name_derived,
n_name,
n_regionkey as n_regionkey,
n_comment,
'x' as new_fld
from {{ source('raw', 'nation') }}
where n_name in ('ARGENTINA',
'BRAZIL',
'EGYPT',
'INDIA',
'IRAN')
UNION ALL
select distinct
 n_nationkey, 
n_name ,
n_name,
n_regionkey+1,
n_comment,
'x' as new_fld
from {{ source('raw', 'nation') }}
where n_name in ('ARGENTINA',
'BRAZIL',
'EGYPT',
'INDIA',
'IRAN')
