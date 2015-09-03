#!/bin/bash
cd kubernetes
docker-compose stop
docker-compose rm -f
echo "Removing k8s-started containers..."
docker rm -f `docker ps -a -f "name=k8s_" -q`
