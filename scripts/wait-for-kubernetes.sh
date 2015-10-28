#!/bin/bash
source ../common.sh

printf "${yellow}Waiting for Kubernetes cluster to become available${reset}"

until $(kubectl cluster-info &> /dev/null); do
    sleep 1
	printf "${yellow}.${reset}"
done

printf "\n\n${green}   ${checkmark} Kubernetes cluster is up.${reset}\n\n"
