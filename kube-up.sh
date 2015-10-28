#!/bin/bash
source ./common.sh

# CLI arguments
port_forward=1
add_route=0
start_dns=0
start_ui=0
start_registry=0
silent=0

read -r -d '' HELP_TEXT <<'USAGE_TEXT'
Usage: kube-up.sh [-fndursh]
Available options are:
	-f  disable forward to port 8080 on docker machine (required for kubectl)
	-n  disable adding route to enable local name resolution via skyDNS
	-d  disable skyDNS
	-u  disable kube-ui
	-r  start local docker registry
	-s  silent mode
	-h  show this help text
USAGE_TEXT

function show_help {
	echo "$HELP_TEXT"
    exit 0
}

while getopts "fndush?:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    f)  port_forward=0
        ;;
    n)  add_route=0
        ;;
	d)  start_dns=0
		;;
	u)  start_ui=0
		;;
	r)  start_registry=0
		;;
	s)  silent=1
		;;
    esac
done

#echo "port_forward='$port_forward', add_route='$add_route', start_dns: '$start_dns'"


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
    if [ "$port_forward" -eq 1 ]; then
		./docker-machine-port-forwarding.sh
	fi
    if [ "$add_route" -eq 1 ]; then
		./docker-machine-add-route.sh
	fi
fi

./wait-for-kubernetes.sh

if [ "$start_dns" -eq 1 ]; then
	./activate-dns.sh
fi

if [ "$start_ui" -eq 1 ]; then
	./activate-kube-ui.sh
fi

if [ "$start_registry" -eq 1 ]; then
	./start-docker-registry.sh start
fi
