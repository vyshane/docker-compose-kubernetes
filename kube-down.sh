#!/bin/bash

this_dir=$(cd -P "$(dirname "$0")" && pwd)

echo "Removing replication controllers, services, pods and secrets..."
kubectl delete replicationcontrollers,services,pods,secrets --all
if [ $? != 0 ]; then
    echo "Kubernetes already down?"
fi

source scripts/docker-machine-port-forwarding.sh
remove_port_if_forwarded $KUBERNETES_API_PORT

cd "$this_dir/kubernetes"

if [ ! -z "$(docker-compose ps -q)" ]; then
    docker-compose stop
    docker-compose rm -f -v
fi

k8s_containers=`docker ps -a -f "name=k8s_" -q`

if [ ! -z "$k8s_containers" ]; then
    echo "Stopping and removing all other containers that were started by Kubernetes..."
    docker stop $k8s_containers
    docker rm -f -v $k8s_containers
fi
