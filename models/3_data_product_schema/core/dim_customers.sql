

select 
customer_key
,nation_key
,name
,address
,phone_number
,market_segment
,sum(account_balance) as account_balance
FROM {{ ref('customer_rslt') }}
group by 
customer_key
,nation_key
,name
,address
,phone_number
,market_segment