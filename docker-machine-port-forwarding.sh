#!/bin/bash
# Port forwarding so that we can use kubectl locally
ssh -f -N -L 8080:localhost:8080 docker@$(docker-machine ip $(docker-machine active))