#!/bin/bash
source .settings

require_command_exists() {
    command -v "$1" >/dev/null 2>&1 || { printf "${red}$1 is required but is not installed. Aborting.\n${reset}" >&2; exit 1; }
}

require_command_exists kubectl
require_command_exists docker
require_command_exists docker-compose

docker info > /dev/null
if [ $? != 0 ]; then
    printf "${red}A running Docker engine is required. Is your Docker host up?${reset}\n"
    exit 1
fi

printf "${yellow}Composing k8s cluster...${reset}\n"
cd kubernetes
docker-compose up -d

cd ../scripts

echo

if [ $(command -v docker-machine) ] &&  [ ! -z "$(docker-machine active)" ]; then
    if [ ! -z ${port_forward} ]; then
		./docker-machine-port-forwarding.sh
	fi
    if [ ! -z ${add_route} ]; then
		./docker-machine-add-route.sh
	fi
fi

./wait-for-kubernetes.sh

if [ -n "$start_dns" ]; then 
	./activate-dns.sh
fi

if [ -n "$start_ui" ]; then
	./activate-kube-ui.sh
fi

if [ -n "$start_registry" ]; then
	./start-docker-registry.sh start
fi
