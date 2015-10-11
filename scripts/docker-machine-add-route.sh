#!/bin/bash
#
# Set up routes for accessing services and DNS from MacOS

# assume 'docker-vm' as the default docker machine name
#machine=${DOCKER_MACHINE_VM_NAME:=docker-vm}
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

	if [[ $docker_machine_ip =~ ^$rx\.$rx\.$rx\.$rx$ ]]; then
		default_gateway=$(route -n get default | grep gateway | awk '{print $2}')
		existing_route_gateway=$(route -n get $docker_network | grep gateway | awk '{print $2}')
		if [ -z "$existing_route_gateway" ] || [ "$existing_route_gateway" == "$default_gateway" ]; then
			echo "Adding route for docker-machine '$machine_name' and IP '$docker_machine_ip' requires sudo, please enter password"
			sudo route -n add $docker_network $docker_machine_ip
		elif [ "$existing_route_gateway" == "$docker_machine_ip" ]; then
			echo "Route entry already exists"
		else
			echo "Error: Existing route for $docker_network: $existing_route_gateway"
		fi
	else
		echo "No valid IP address for docker machine $machine_name: $docker_machine_ip"
    fi
}

add_route $machine $docker_net
