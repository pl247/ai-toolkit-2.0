#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate vllm
ip=$(ifconfig eno5 | grep 'inet ' | awk '{print $2}')
echo "Starting ray on head node IP: $ip"
echo "Stopping cluster..."
ray stop
echo " Starting GPU cluster on head node..."
ray start --head   --node-ip-address $ip
sleep 3
ray status
echo " remember to stop and start GPU cluster on all worker nodes"