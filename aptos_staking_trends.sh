# in the dashboard: select * from SXTTemp.aptos_staking_trends_aeither limit 10

# 

API_URL="https://api.spaceandtime.dev"
USERID="aeither"
USER_PUBLIC_KEY="sxtcli authenticate keypair"
USER_PRIVATE_KEY="sxtcli authenticate keypair"


  #

  java -jar sxt8.jar authenticate keychain \
--accessToken="get it form the dashboard" \
--url="https://api.spaceandtime.dev" \
add \
  --publicKey=$USER_PUBLIC_KEY \
  --privateKey=$USER_PRIVATE_KEY

  #

  java -jar sxt8.jar authenticate login \
  --url=$API_URL \
  --userId=$USERID \
  --publicKey=$USER_PUBLIC_KEY \
  --privateKey=$USER_PRIVATE_KEY


# ACCESS_TOKEN=$( \
#   java -jar sxt8.jar authenticate login \
#   --url=$API_URL \
#   --userId=$USERID \
#   --publicKey=$USER_PUBLIC_KEY \
#   --privateKey=$USER_PRIVATE_KEY
# | awk 'NR==2{ print $2 }' )

# 

SQL="Select cast(time_stamp as date) as Block_Date, count(*) as Block_Count from ZKSYNCERA.BLOCKS where time_stamp between current_date-3 and current_date group by 1 order by 1"

  java -jar sxt8.jar sql --url=$API_URL --accessToken=$ACCESS_TOKEN --sqlText="$SQL"


#

SQL_CREATE_VIEW=$(cat << EOM
CREATE VIEW SXTTemp.aptos_staking_trends_aeither
with "public_key=D0B36AA455A9D4BF1E2ABA737A4CB44544C40CA75BD1C6BCB662576F4843E557, access_type=public_read"
as
---
WITH daily_stats AS (
  SELECT 
    DATE_TRUNC('day', TIME_STAMP) as date,
    EVENT_TYPE,
    SUM(AMOUNT) as total_amount,
    COUNT(*) as transaction_count,
    COUNT(DISTINCT DELEGATOR_ADDRESS) as unique_delegators,
    COUNT(DISTINCT POOL_ADDRESS) as unique_pools
  FROM aptos.DELEGATED_STAKING_ACTIVITIES
  GROUP BY 
    DATE_TRUNC('day', TIME_STAMP),
    EVENT_TYPE
  ORDER BY date DESC
)
SELECT 
  date,
  EVENT_TYPE,
  total_amount,
  transaction_count,
  unique_delegators,
  unique_pools,
  total_amount / NULLIF(transaction_count, 0) as avg_transaction_size
FROM daily_stats
EOM
)

java -jar sxt8.jar sql \
  --url=$API_URL \
  --accessToken=$ACCESS_TOKEN \
  --sqlText="$SQL_CREATE_VIEW" \
  --biscuits=$ADMIN_BISCUIT

  # 
