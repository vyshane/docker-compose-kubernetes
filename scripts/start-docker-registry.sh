#!/bin/bash
#
# starts a local Docker registry that can be used to make local images available to k8s

function start_docker_registry {
	action=$1
	run_new_registry_cmd="docker run -d -p 5000:5000 --restart=always --name registry registry:2"
	if [ $? -ne 0 ]; then
		echo "docker command failed. Make sure that docker is running and shell environment is sane"
		exit -1
	fi

	existing_registry=$(docker ps -a | grep registry:2 | awk '{print $1}')
	run_existing_registry_cmd="docker start $existing_registry"
	running_registry=$(docker ps | grep registry:2 | awk '{print $1}')
	stop_registry_cmd="docker stop $running_registry"
 	case "$action" in
		"start") 
			if [ -z "$running_registry" ]; then
				echo "Starting docker registry..."
				if [ -z "$existing_registry" ]; then
					eval $run_new_registry_command
				else
					echo "Using existing container: $existing_registry"
					eval $run_existing_registry_cmd
				fi
			else
				echo "Docker registry already running. Container ID: $running_registry"
			fi
			;;
		"stop")
			if [ -z "$existing_registry" ]; then
				echo "Docker registry not running. Doing nothing"
			else
				echo "Shutting down docker registry. Container ID: $running_registry"
				eval $stop_registry_cmd
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
