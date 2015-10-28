#!/bin/bash
#
# starts a local Docker registry that can be used to make local images available to k8s

source ../common.sh

function start_docker_registry {
	action=$1
	run_new_registry_cmd="docker run -d -p 5000:5000 --restart=always --name registry registry:2"
	if [ $? -ne 0 ]; then
		printf "\n${red}  ${error}docker command failed. Make sure that docker is running and shell environment is sane${reset}\n"
		exit -1
	fi

	existing_registry=$(docker ps -a | grep registry:2 | awk '{print $1}')
	run_existing_registry_cmd="docker start $existing_registry"
	running_registry=$(docker ps | grep registry:2 | awk '{print $1}')
	stop_registry_cmd="docker stop $running_registry"
 	case "$action" in
		"start")
			printf "${yellow}Starting docker registry...${reset}\n"
			if [ -z "$running_registry" ]; then
				if [ -z "$existing_registry" ]; then
					eval $run_new_registry_command &> /dev/null
				else
					#printf "${yellow}Using existing container: $existing_registry${reset}\n"
					eval $run_existing_registry_cmd &> /dev/null
				fi

				check_rc "Docker registry started" "Docker registry startup failed"

			else
				printf "\n${yellow}   ${warning} Docker registry already running. Container ID: $running_registry${reset}\n\n"
			fi
			;;
		"stop")
			if [ -z "$running_registry" ]; then
				printf "\n${yellow}   ${warning} Docker registry not running.${reset}\n\n"
			else
				printf "${yellow}Shutting down docker registry. Container ID: $running_registry${reset}\n"
				eval $stop_registry_cmd &> /dev/null

				check_rc "Docker registry stopped" "Docker registry shutdown failed"
			fi
			;;
		"check")
			if [ -n "$running_registry" ]; then
				echo "Docker registry already running. Container ID: $running_registry"
			elif [ -n "$existing_registry" ]; then
				echo "Docker registry NOT running but container exists: $existing_registry"
			fi
			;;
		*)
			echo "Usage: docker_registry start|stop|check"
			;;
	esac
}

start_docker_registry $1
