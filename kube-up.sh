#!/bin/bash

set -e

this_dir=$(cd -P "$(dirname "$0")" && pwd)

require_command_exists() {
    command -v "$1" >/dev/null 2>&1 || { echo "$1 is required but is not installed. Aborting." >&2; exit 1; }
}

require_command_exists kubectl
require_command_exists docker

docker info > /dev/null
if [ $? != 0 ]; then
    echo "A running Docker engine is required. Is your Docker host up?"
    exit 1
fi

if [[ ! $(docker version --format {{.Server.Version}})  == "1.10.3" ]]; then 
    echo "Warning: You should be running docker 1.10.3"
fi

echo "Setting up kubectl context"
api_address="localhost"
if command -v docker-machine >/dev/null 2>&1; then
    api_address=$(docker-machine ip)
fi

kubectl config set-cluster local --server="http://$api_address:8080" >/dev/null 2>&1
kubectl config set-context local --cluster=local >/dev/null 2>&1
kubectl config use-context local >/dev/null 2>&1

if kubectl cluster-info &> /dev/null; then
    echo "Kubernetes is already running"
    exit 1
fi

echo "Cleaning up last kubernetes run (may ask for sudo)"
if command -v docker-machine >/dev/null 2>&1; then
    docker-machine ssh $DOCKER_MACHINE_NAME "mount | grep -o 'on /var/lib/kubelet.* type' | cut -c 4- | rev | cut -c 6- | rev | xargs --no-run-if-empty sudo umount"
    docker-machine ssh $DOCKER_MACHINE_NAME "sudo rm -Rf /var/lib/kubelet"
else
    mount | grep -o 'on /var/lib/kubelet.* type' | cut -c 4- | rev | cut -c 6- | rev | xargs --no-run-if-empty sudo umount
    sudo rm -Rf /var/lib/kubelet
fi

echo "Starting etcd"
docker run \
    --name=etcd \
    --net=host \
    -d \
    gcr.io/google_containers/etcd:2.2.1 \
    /usr/local/bin/etcd --listen-client-urls=http://127.0.0.1:4001 --advertise-client-urls=http://127.0.0.1:4001 >/dev/null 2>&1

echo "Starting kubelet"
docker run \
    --name=kubelet \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/run:/var/run:rw \
    --volume=/var/lib/kubelet:/var/lib/kubelet:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    -d \
    gcr.io/google_containers/hyperkube-amd64:v1.2.0 \
    /hyperkube kubelet \
        --containerized \
        --hostname-override="127.0.0.1" \
        --address="0.0.0.0" \
        --api-servers=http://localhost:8080 \
        --config=/etc/kubernetes/manifests-multi \
        --cluster-dns=10.0.0.10 \
        --cluster-domain=cluster.local \
        --allow-privileged=true --v=2 >/dev/null 2>&1

echo "Waiting for Kubernetes cluster to become available..."
until $(kubectl cluster-info &> /dev/null); do
    sleep 1
done
echo "Kubernetes cluster is up."

"$this_dir/activate-kube-system.sh"
"$this_dir/activate-dns.sh"
# The dashboard doesn't seem ready yet
# "$this_dir/activate-ui.sh"

