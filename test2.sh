#!/bin/bash

# Load variables from .env file
source ./.env

# sxtcli="java -jar sxt8.jar"

# Define the full command instead of using an alias
SXTCLI_CMD="java -jar sxt8.jar"

CREATE_SQL=$(cat << EOM
Select 
  substr(time_stamp, 1, 7) as YrMth
, sum(case 
      when from_address = my_Wallet
      then value_/1e18 end) as Amt_Out
, sum(case 
      when to_address = my_Wallet
      then value_/1e18 end) as Amt_In
, count(*) as Txn_Count
from ETHEREUM.TRANSACTIONS
join (select lower('0x123abd...') as my_Wallet)
  on from_address = my_Wallet
  or to_address   = my_Wallet
where time_stamp between current_date-(5*365) and current_date-1
Group by 1 order by 1
EOM
)

$SXTCLI_CMD sql --url=$API_URL --accessToken=$ACCESS_TOKEN --sqlText="$CREATE_SQL" --biscuits=$ADMIN_BISCUIT
