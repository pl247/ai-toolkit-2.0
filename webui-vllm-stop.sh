#!/bin/bash
echo "Stopping Open WebUI"
docker ps -q | xargs --no-run-if-empty docker stop
echo "** Done **"
# ---------------------------------------- #
