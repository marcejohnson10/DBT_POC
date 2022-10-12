    select 

    part.part_key,
    part.name as part_name,
    part.manufacturer,
    part.brand,
    part.type as part_type
 
from
 dbt_dev.transform.part_rslt part
