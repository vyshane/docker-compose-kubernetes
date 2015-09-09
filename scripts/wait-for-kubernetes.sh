#!/bin/bash
echo "Waiting for Kubernetes cluster to become available..."

until $(kubectl get pods &> /dev/null); do
    sleep 1
done

echo "Kubernetes cluster is up."
