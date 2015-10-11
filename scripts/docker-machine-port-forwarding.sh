#!/bin/bash
#
# Set up kubectl port forwarding to boot2docker VM if needed.

machine=$(docker-machine active)
keyfile="~/.docker/machine/machines/$machine/id_rsa"

function forward_port_if_not_forwarded {
    port=$1
    forward_port_command="ssh -i $keyfile -f -N -L $port:localhost:$port docker@$(docker-machine ip $machine)"
    existing_forward=$(ps ax | grep "$forward_port_command" | grep -v grep)
    
    if [ -z "$existing_forward" ]; then
        eval $forward_port_command
    fi
}

# Kubernetes API
forward_port_if_not_forwarded 8080

