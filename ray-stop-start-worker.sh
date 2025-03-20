#!/bin/bash
clear
eval "$(conda shell.bash hook)"
conda activate vllm
# Set the below IP to whatever the IP is of your ray head node
ip=198.18.5.11
echo "Head node is set to $ip in this script. Change this if it is incorrect"
echo "Stopping cluster..."
ray stop

echo " Starting GPU cluster on worker node..."
ray start --address='198.18.5.11:6379'
sleep 3
ray status