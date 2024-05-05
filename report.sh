#!/bin/bash

source ~/.bash_profile

version=$(cat ~/aethir/log/main-core-api.log | grep "\"ver\" : " | head -1 | awk '{print $3}' | sed 's/\"\|,//g')
service=$(sudo systemctl status aethird --no-pager | grep "active (running)" | wc -l)
pid=$(pidof AethirChecker)
chain="testnet"
id=aethir-$AETHIR_ID
bucket=node



#if [ $service -ne 1 ]
#then 
#  status="error";
#  message="service not running"
#else 
#  status="ok";
#fi

if [ -z $pid ]
then 
  status="error";
  message="process not running"
else 
  status="ok";
fi

cat << EOF
{
  "id":"$id",
  "machine":"$MACHINE",
  "chain":"$chain",
  "type":"node",
  "version":"$version",
  "status":"$status",
  "message":"$message",
  "service":$service,
  "pid":$pid,
  "updated":"$(date --utc +%FT%TZ)"
}
EOF

# send data to influxdb
if [ ! -z $INFLUX_HOST ]
then
 curl --request POST \
 "$INFLUX_HOST/api/v2/write?org=$INFLUX_ORG&bucket=$bucket&precision=ns" \
  --header "Authorization: Token $INFLUX_TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary "
    status,node=$id,machine=$MACHINE status=\"$status\",message=\"$message\",version=\"$version\",url=\"$url\",chain=\"$chain\" $(date +%s%N) 
    "
fi
