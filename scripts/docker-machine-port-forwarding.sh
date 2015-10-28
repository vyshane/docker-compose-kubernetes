#!/bin/bash
#
# Set up kubectl port forwarding to boot2docker VM if needed.

source ../common.sh

function forward_port_if_not_forwarded {
    port=$1

    machine=$(docker-machine active)
    keyfile="$HOME/.docker/machine/machines/$machine/id_rsa"

	printf "${yellow}Checking forward for port '$port'${reset}\n"
    forward_port_command="ssh -i $keyfile -f -N -L $port:localhost:$port docker@$(docker-machine ip $machine)"
    existing_forward=$(ps ax | grep "$forward_port_command" | grep -v grep)

    if [ -z "$existing_forward" ]; then
		#printf "${yellow}Adding portforward for port '$port'${reset}\n"
        eval $forward_port_command &> /dev/null
		check_rc "Successfully added port forward" "Could not forward port"
	else
		printf "\n${yellow}   ${warning} Port forward for '$port' already exists${reset}\n\n"
    fi
}

# Kubernetes API
forward_port_if_not_forwarded 8080

