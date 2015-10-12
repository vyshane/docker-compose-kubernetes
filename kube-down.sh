#!/bin/bash

source .settings

printf "${yellow}Stopping replication controllers, services and pods...${reset}\n"

kubectl stop replicationcontrollers,services,pods --all &> /dev/null
if [ $? != 0 ]; then
    printf "\n${yellow}   ${warning} Cannot contact API server. Kubernetes already down? ${reset}\n\n"
fi

cd kubernetes
if [ ! -z "$(docker-compose ps -q)" ]; then
    docker-compose stop
    docker-compose rm -f -v
fi

k8s_containers=`docker ps -a -f "name=k8s_" -q`

if [ ! -z "$k8s_containers" ]; then
    printf "${yellow}Stopping and removing all other containers that were started by Kubernetes...${reset}\n"
    docker stop $k8s_containers
    docker rm -f -v $k8s_containers
fi

cd ../scripts 
if [ -n "$start_registry" ]; then
	./start-docker-registry.sh stop
fi

