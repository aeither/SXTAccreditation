java -jar sxt8.jar authenticate keychain \
--accessToken="eyJ0eXBlIjoiYWNjZXNzIiwia2lkIjoiZTUxNDVkYmQtZGNmYi00ZjI4LTg3NzItZjVmNjNlMzcwM2JlIiwiYWxnIjoiRVMyNTYifQ.eyJpYXQiOjE3MzAxOTk1OTEsIm5iZiI6MTczMDE5OTU5MSwiZXhwIjoxNzMwMjAxMDkxLCJ0eXBlIjoiYWNjZXNzIiwidXNlciI6ImFlaXRoZXIiLCJzZXNzaW9uIjoiZjZmNGNhMWMwMzg2Y2YwYTI0ODgxYWVkIiwic3NuX2V4cCI6MTczMDI4NTU1MjgxMywiaXRlcmF0aW9uIjoiZmE5NzdiYmQxZTM5NGQzYmYwYTdlNzgwIiwidHJpYWwiOnRydWV9.0k9ELfrShnGecJzY86vv7xPsrBmLGvZKV6Q-diCfH96Q5B7k5noZ-fG819eqLsAzyTMEgz5TVARFCC8VPKss8g" \
--url="https://api.spaceandtime.dev" \
add \
--privateKey="DqrUXhWjQwDSE2vfs1Bskz1Xi09J6QdPR93KBfpuqVk=" \
--publicKey="z4C63FgEKchKI3Xj03JBf6Oom/a24A4ogzOV3LkUbVo="

source .env && curl --request POST \
--url "https://api.spaceandtime.app/v1/sql" \
--header "accept: application/json" \
--header "authorization: Bearer sxt_m7xsRu6FB0_oHREj2ReQhzv716GgAEv6LWp" \
--header "content-type: application/json" \
--data '{
    "sqlText": "Select count(*) as Blocks_Yesterday from Ethereum.Blocks where time_stamp between current_date-1 and current_date"
}'

java -jar sxt8.jar authenticate keypair

# 

API_URL="https://api.spaceandtime.dev"
USERID="aeither"
USER_PUBLIC_KEY="yAIBDZXWOgmDVbgNDXcjmYvpbfu5bx1+QRdEwjdKpIc="
USER_PRIVATE_KEY="Ke1spyTzdCclX8DNLyUb4xLp8CArAGTPFYXPsYEfrvc="


  #

  java -jar sxt8.jar authenticate keychain \
--accessToken="eyJ0eXBlIjoiYWNjZXNzIiwia2lkIjoiZTUxNDVkYmQtZGNmYi00ZjI4LTg3NzItZjVmNjNlMzcwM2JlIiwiYWxnIjoiRVMyNTYifQ.eyJpYXQiOjE3MzAyMDI3MjIsIm5iZiI6MTczMDIwMjcyMiwiZXhwIjoxNzMwMjA0MjIyLCJ0eXBlIjoiYWNjZXNzIiwidXNlciI6ImFlaXRoZXIiLCJzZXNzaW9uIjoiZjZmNGNhMWMwMzg2Y2YwYTI0ODgxYWVkIiwic3NuX2V4cCI6MTczMDI4NTU1MjgxMywiaXRlcmF0aW9uIjoiMTU3Y2M1OGJjNWEzNmFiZjgxYjI2MTI4IiwidHJpYWwiOnRydWV9.GnkJHhtIAjTI05dYTuR42Ag2uDVLDYnecnjO557tFoT85UA8gFIMtu8Xq2XbopEck35ghWPrm3RFrYLHtjdPpw" \
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
