#!/bin/bash
#
# Set up kubectl port forwarding to boot2docker VM if needed.

forward_port_command="ssh -f -N -L 8080:localhost:8080 docker@$(docker-machine ip $(docker-machine active))"
existing_forward=$(ps ax | grep "$forward_port_command" | grep -v grep)

if [ -z "$existing_forward" ]; then
    eval $forward_port_command
fi
