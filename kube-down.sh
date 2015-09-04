#!/bin/bash
cd kubernetes
docker-compose stop
docker-compose rm -f

k8s_containers=`docker ps -a -f "name=k8s_" -q`

if [ ! -z $k8s_containers ]; then
    echo "Removing k8s-started containers..."
    docker rm -f $k8s_containers
fi
