#!/bin/bash

if [ "$#" -ne 1 ]
then
  echo "Usage: $0 <docker_host_ip_address>"
  exit 1
fi

cd kubernetes
docker-compose up -d

cd ../scripts
./wait-for-kubernetes.sh
./activate-dns.sh $1
./activate-kube-ui.sh
