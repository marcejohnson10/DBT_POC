 -- depends_on: {{ ref('supplier_rslt') }}

{{ create_stream('test_stream','supplier_rslt') }}
