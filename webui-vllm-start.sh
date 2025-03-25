#!/bin/bash
ip=$(ifconfig eno5 | grep 'inet ' | awk '{print $2}')
echo "starting WebUI container on $ip port 8081 configured to talk to vLLM API on port 8000"
docker compose -f docker-compose-webui.yml up -d
if [[ $? -eq 0 ]]; then
    echo "*****************************************************************"
    echo "WebUI container started at http://$ip:8081"
    echo "****************************************************************"
else
    echo "###### Error: WebUI failed to start ######"
fi

