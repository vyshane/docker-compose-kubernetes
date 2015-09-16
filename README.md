# Launch [Kubernetes](http://kubernetes.io) using Docker via [Docker Compose](https://www.docker.com/docker-compose)

The Kubernetes [DNS addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns) will also set up for you.

## Starting Kubernetes on Linux

On Linux we'll run Kubernetes using a local Docker Engine. You will also need a local installation of Docker Compose. To launch the cluster:

```sh
./kube-up.sh <docker_host_address>
```

For the docker host address, use your local IP address. The IP address is needed to set up DNS for the cluster.

## Starting Kubernetes on OS X

On OS X we'll launch Kubernetes inside a [boot2docker](http://boot2docker.io) VM via [Docker Machine](https://docs.docker.com/machine/). You will need to have Docker Machine and Docker Compose installed on your machine. First start your boot2docker VM:

```sh
docker-machine start <name>
eval "$(docker-machine env $(docker-machine active))"
```

Then, to launch a Kubernetes cluster in boot2docker via Docker Machine:

```sh
./kube-up-docker-machine.sh
```

The script will set up port forwarding so that you can use kubectl locally without having to ssh into boot2docker. The default password for the boot2docker docker user is `tcuser`.

You can then check if Kubernetes is running:

```sh
kubectl get nodes
NAME        LABELS                             STATUS
127.0.0.1   kubernetes.io/hostname=127.0.0.1   Ready
```

## To destroy the cluster

```sh
./kube-down.sh
```

This will also remove any services, replication controllers and pods that are running in the cluster.

