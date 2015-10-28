# Launch [Kubernetes](http://kubernetes.io) using Docker via [Docker Compose](https://www.docker.com/docker-compose)

The following will also be set up for you:

 * The Kubernetes [DNS addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns)
 * [Kube UI](http://kubernetes.io/v1.0/docs/user-guide/ui.html)

## Starting Kubernetes on Linux

On Linux we'll run Kubernetes using a local Docker Engine. You will also need Docker Compose as well as the kubectl tool. To launch the cluster:

```sh
./kube-up.sh
```

## Starting Kubernetes on OS X

On OS X we'll launch Kubernetes inside a [boot2docker](http://boot2docker.io) VM via [Docker Machine](https://docs.docker.com/machine/). You will need to have Docker Machine, Docker Compose, and the kubectl tool installed locally. First start your boot2docker VM:

```sh
docker-machine start <name>
eval "$(docker-machine env $(docker-machine active))"
```

Then, launch the Kubernetes cluster in boot2docker via Docker Machine:

```sh
./kube-up.sh
```

The script will set up port forwarding so that you can use kubectl locally without having to ssh into boot2docker.

## Controlling Addons (DNS, UI)
You can use the the following options to disable specific additional services. The default is
to start all addons, __except__ the local Docker Registry:

```
Usage: kube-up.sh [-fndursh]
Available options are:
	-f  disable forward to port 8080 on docker machine (required for kubectl)
	-n  disable adding route to enable local name resolution via skyDNS
	-d  disable skyDNS
	-u  disable kube-ui
	-r  start local docker registry
	-h  show this help text
	-s  silent mode
```

## Checking if Kubernetes Is Running

```sh
kubectl cluster-info
Kubernetes master is running at http://localhost:8080
KubeUI is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui
```

## Accessing Kube UI

You can access Kube UI at http://localhost:8080/ui.

## To destroy the cluster

```sh
./kube-down.sh
```

This will also remove any services, replication controllers and pods that are running in the cluster.

