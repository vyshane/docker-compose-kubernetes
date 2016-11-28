#!/bin/bash
echo "Waiting for Kubernetes cluster to become available..."

until $(kubectl -s http://localhost:8080 cluster-info &> /dev/null); do
    sleep 1
done

echo "Kubernetes cluster is up."
