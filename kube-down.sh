#!/bin/bash
cd kubernetes
docker-compose stop
docker-compose rm -f

echo "Removing scheduler..."
docker rm -f `docker ps -a -f "name=k8s_scheduler." -q`

echo "Removing controller manager.."
docker rm -f `docker ps -a -f "name=k8s_controller-manager." -q`

echo "Removing API server..."
docker rm -f `docker ps -a -f "name=k8s_apiserver." -q`

echo "Removing pods..."
docker rm -f `docker ps -a -f "name=k8s_POD." -q`
