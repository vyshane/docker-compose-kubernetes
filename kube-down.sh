#!/bin/bash
echo "Stopping replaction controllers, services and pods..."
kubectl stop replicationcontrollers,services,pods --all

cd kubernetes
docker-compose stop
docker-compose rm -f

k8s_containers=`docker ps -a -f "name=k8s_" -q`

if [ ! -z "$k8s_containers" ]; then
    echo "Removing k8s-started containers..."
    docker rm -f -v $k8s_containers
fi
