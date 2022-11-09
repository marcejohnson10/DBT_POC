{{ config(
    materialized='view'
) }}

select  distinct id_1, amt_1, unit_1, amt_1*unit_1 as total_3, color_1 
 
from {{ source('raw', 'z_lineage_1') }} 
where TO_VARCHAR(SHA1_BINARY(UPPER(ARRAY_TO_STRING(ARRAY_CONSTRUCT( 
													  TRIM(id_1)
													, TRIM(amt_1)
													, TRIM(unit_1)  
													, TRIM(color_1)   
													), '^')))) in 
(select TO_VARCHAR(SHA1_BINARY(UPPER(ARRAY_TO_STRING(ARRAY_CONSTRUCT( 
													  TRIM(id_1)
													, TRIM(amt_1)
													, TRIM(unit_1)  
													, TRIM(color_1)   
													), '^'))))  AS surrogate
 from {{ source('raw', 'z_lineage_1') }}_stream)