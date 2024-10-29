SXTCLI_CMD="java -jar sxt8.jar"

$SXTCLI_CMD biscuit generate table \
  --privateKey=$RESOURCE_PRIVATE_KEY \
  --resources="mySchema.myTable" \
  --operations=SELECT,INSERT \
  --users="Alice" \
  --subscriptions="abc123456789def" \
  --expires="2024-12-31T23:59:59Z"

  # SELECT Biscuit:
$SXTCLI_CMD biscuit generate table \
  --privateKey=$RESOURCE_PRIVATE_KEY \
  --resources="SXTTemp.Test_$USERID" \
  --expires="2024-12-31T23:59:59Z" \
  --operations="SELECT" 

  # APPEND Biscuit:
$SXTCLI_CMD biscuit generate table \
  --privateKey=$RESOURCE_PRIVATE_KEY \
  --resources="SXTTemp.Test_$USERID" \
  --operations="INSERT" 

  # LOADER Biscuit:
$SXTCLI_CMD biscuit generate table \
  --privateKey=$RESOURCE_PRIVATE_KEY \
  --resources="SXTTemp.Test_$USERID" \
  --subscriptions="8cb60b4b-1f67-423c-aad1-e5df478a0c05" \
  --operations="SELECT,INSERT,UPDATE,DELETE,MERGE" 

  INSERT_SQL=$(cat << EOM
  INSERT INTO SXTLABS.LEARN_Biscuits (TABLENAME, USER_ID, Insert_Timestamp, BISCUIT_NAME, BISCUIT)
  VALUES
     ('SXTTemp.Test_$USERID', '$USERID', CURRENT_TIMESTAMP, 'SELECT', '$SELECT_BISCUIT' )
   , ('SXTTemp.Test_$USERID', '$USERID', CURRENT_TIMESTAMP, 'APPEND', '$APPEND_BISCUIT' )
   , ('SXTTemp.Test_$USERID', '$USERID', CURRENT_TIMESTAMP, 'LOADER', '$LOADER_BISCUIT' )
EOM
)

$SXTCLI_CMD sql \
  --url=$API_URL \
  --accessToken=$ACCESS_TOKEN \
  --sqlText=$INSERT_SQL \
  --biscuits=$INSERT_ONLY_BISCUIT

