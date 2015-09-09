#!/bin/bash

# First remove any existing forwards
ps aux | grep 'ssh -f -N -L 8080:localhost:8080 docker@' | grep -v grep | awk '{print $2}' | xargs kill

# Set up port forwarding so that we can use kubectl locally
ssh -f -N -L 8080:localhost:8080 docker@$(docker-machine ip $(docker-machine active))