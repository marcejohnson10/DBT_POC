 -- depends_on: {{ ref('customer_rslt') }}

{{ create_stream('test_stream','customer_rslt') }}
