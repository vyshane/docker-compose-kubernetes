#!/bin/bash

set -e

require_command_exists() {
    command -v "$1" >/dev/null 2>&1 || { echo "$1 is required but is not installed. Aborting." >&2; exit 1; }
}

require_command_exists kubectl
require_command_exists docker
require_command_exists docker-compose

this_dir=$(cd -P "$(dirname "$0")" && pwd)

docker info > /dev/null
if [ $? != 0 ]; then
    echo "A running Docker engine is required. Is your Docker host up?"
    exit 1
fi

cd "$this_dir/kubernetes"
docker-compose up -d
docker cp master.json kubernetes_master_1:etc/kubernetes/manifests
docker commit kubernetes_master_1
docker stop kubernetes_master_1
docker start kubernetes_master_1
cd "$this_dir/scripts"

source docker-machine-port-forwarding.sh
forward_port_if_not_forwarded $KUBERNETES_API_PORT

./wait-for-kubernetes.sh
./create-kube-system-namespace.sh
./activate-dns.sh
./activate-kube-ui.sh
