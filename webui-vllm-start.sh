#!/bin/bash
echo "starting WebUI container on port 8081 configured to talk to vLLM API on port xxx"
docker compose -f docker-compose-webui.yml up -d
if [[ $? -eq 0 ]]; then
    echo "*****************************************************************"
    echo "WebUI container started at http://64.101.169.102:8081"
    echo "****************************************************************"
else
    echo "###### Error: WebUI failed to start ######"
fi

