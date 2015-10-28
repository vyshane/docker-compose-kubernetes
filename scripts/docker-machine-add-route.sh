#!/bin/bash
#
# Set up routes for accessing services and DNS from MacOS
source ../common.sh

machine=$(docker-machine active)
docker_net=${DOCKER_MACHINE_NET:=10.0.0.0/16}

rx='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'

function add_route {
	machine_name=$1
	docker_network=$2
	docker_machine_ip=$(docker-machine ip $machine_name)
	if [ $? -ne 0 ]; then
		exit -1;
	fi

	printf "${yellow}Checking routing entries for ${docker_net}...${reset}\n"

	if [[ $docker_machine_ip =~ ^$rx\.$rx\.$rx\.$rx$ ]]; then
		default_gateway=$(route -n get default | grep gateway | awk '{print $2}')
		existing_route_gateway=$(route -n get $docker_network | grep gateway | awk '{print $2}')
		if [ -z "$existing_route_gateway" ] || [ "$existing_route_gateway" == "$default_gateway" ]; then
			printf "${yellow}Adding route for docker-machine '$machine_name' and IP '$docker_machine_ip' requires sudo, please enter password${reset}\n"
			sudo route -n add $docker_network $docker_machine_ip
			if [ $? -eq 0 ]; then
				printf "\n${green}   ${checkmark} Successfully added route '$docker_net' -> '${docker_machine_ip}' ${reset}\n\n"
			else
				printf "\n${error}   ${error} Cannot add route\n\n"
			fi
		elif [ "$existing_route_gateway" == "$docker_machine_ip" ]; then
			printf "\n${yellow}   ${warning} Route entry already exists\n\n${reset}"
		else
			printf "\n${red}    ${error} Existing route for $docker_network: $existing_route_gateway\n\n${reset}"
		fi
	else
		printf "\n${red}   ${error} No valid IP address for docker machine $machine_name: $docker_machine_ip\n\n${reset}"
    fi
}

add_route $machine $docker_net
