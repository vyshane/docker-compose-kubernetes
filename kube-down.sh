#!/bin/bash

echo "Stopping kubernetes"
echo "Stop kubelet"
docker rm -f kubelet >/dev/null 2>&1

k8s_containers=`docker ps -a -f "name=k8s_" -q`
if [ ! -z "$k8s_containers" ]; then
    echo "Stopping and removing all other containers that were started by Kubernetes..."
    docker stop $k8s_containers
    docker rm -f -v $k8s_containers
fi

echo "Stopping etcd"
docker rm -f etcd >/dev/null 2>&1
