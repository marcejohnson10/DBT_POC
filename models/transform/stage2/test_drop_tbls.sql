
select 
{{ drop_old_relations(True) }} as cd
from {{ ref('nation_rslt') }}
