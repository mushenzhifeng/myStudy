#!/bin/bash


VM_NAME="test_`date "+%y%m%d_%H%M%S"`"
PING_TIMEOUT_SECS=300
SSH_TIMEOUT_SECS=300

EIP_ID="49ad0d4b-9bdb-439d-9e48-e8e408a396ed"
EIP_ADDRESS="80.158.1.46"
SUBNET_ID_ID="75ffa773-d695-4d6e-b820-21d55ee3aea3"

token=""

ecs_api_ip="80.158.0.66"
ecs_url="ecs.eu-de.otc.t-systems.com"
start_create_time=`date "+%y%m%d_%H:%M:%S"`
date

echo `date "+%y%m%d_%H:%M:%S"` : [ will creat vm ]
res=`curl -X POST -H "Content-Type: application/json" -H "X-Auth-Token: $token" -H "Cache-Control: no-cache" -H "Postman-Token: f9eab811-892b-aeb0-0568-fa81cb42d7bc" -d '{ "server": { "flavorRef": "s2.large.4", "name": "$VM_NAME", "imageRef": "9df3cfae-d037-44ea-97db-356a2c43488d", "availability_zone": "eu-de-02", "vpcid": "02ce0027-75b9-40e4-94f5-d4222e184bd9", "root_volume": {  "volumetype": "SATA" }, "publicip": { "id": "${EIP_ID}" }, "key_name": "KeyPair-yly-10622", "nics": [ { "subnet_id": "${SUBNET_ID_ID}" } ], "networks": [{ "uuid": "75ffa773-d695-4d6e-b820-21d55ee3aea3" }] } }' "https://$ecs_url/v1/971641d72cb646479bd768b0e984ca6c/cloudservers"`

job_id=`echo ${res} | grep -o '"job_id":"[^"]*"' |cut -d'"' -f4`
echo `date "+%y%m%d_%H:%M:%S"` : [ job_id=$job_id ]

while [[ $status != "SUCCESS" ]]
do
  resAvailable=`curl -X GET -H "Content-Type: application/json" -H "X-Auth-Token: $token" -H "Cache-Control: no-cache"  "https://$ecs_url/v1/971641d72cb646479bd768b0e984ca6c/jobs/$job_id"`
  status=`echo ${resAvailable} | grep -o '"status":"[^"]*"' |cut -d'"' -f4`
  server_id=`echo ${resAvailable} | grep -o '"server_id":"[^"]*"' |cut -d'"' -f4`
 
  echo `date "+%y%m%d_%H:%M:%S"` : [ server_id=${server_id} status="${status}" ] 
  if [ "$status" == "SUCCESS" ]; then
      finish_create_time=`date "+%y%m%d_%H:%M:%S"`
      date
      break
  fi
  sleep 0.2
done


start_ping_time=`date "+%y%m%d_%H:%M:%S"`
echo ${start_ping_time} : [ start ping : ping -c 1 -w ${PING_TIMEOUT_SECS} ${EIP_ADDRESS}]
ping -c 1 -w ${PING_TIMEOUT_SECS} ${EIP_ADDRESS}
finish_ping_time=`date "+%y%m%d_%H:%M:%S"`
echo ${finish_ping_time} : [ finish ping : ping -c 1 -w ${PING_TIMEOUT_SECS} ${EIP_ADDRESS}]

start_ssh_time=`date "+%y%m%d_%H:%M:%S"`
echo ${start_ssh_time} : [ start ssh : ssh -o ConnectTimeout=${SSH_TIMEOUT_SECS} ${EIP_ADDRESS}]
ssh -o ConnectTimeout=${SSH_TIMEOUT_SECS} ${EIP_ADDRESS}
finish_ssh_time=`date "+%y%m%d_%H:%M:%S"`
echo ${finish_ssh_time} : [ finish ssh : ssh -o ConnectTimeout=${SSH_TIMEOUT_SECS} ${EIP_ADDRESS}]


echo  "createVMByImage  :  start_create_time = $start_create_time "
echo  "createVMByImage  :  finish_create_time = $finish_create_time "
echo  "createVMByImage  :  start_ping_time = $start_ping_time "
echo  "createVMByImage  :  finish_ping_time = $finish_ping_time "
echo  "createVMByImage  :  start_ssh_time = $start_ssh_time "
echo  "createVMByImage  :  finish_ssh_time = $finish_ssh_time "
  
