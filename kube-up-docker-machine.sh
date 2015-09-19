#!/bin/bash

machine=$(docker-machine active)

if [[ $? != 0 ]]; then
  echo "You must first start boot2docker via docker-machine"
  exit 1
fi

cd kubernetes
docker-compose up -d

cd ../scripts
./docker-machine-port-forwarding.sh
./wait-for-kubernetes.sh
./activate-dns.sh $(docker-machine ip $machine)
./activate-kube-ui.sh
