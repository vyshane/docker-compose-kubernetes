# Launch [Kubernetes](http://kubernetes.io) using Docker

The following will also be set up for you:

 * The Kubernetes [DNS addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns)
 * [Kube UI](http://kubernetes.io/v1.0/docs/user-guide/ui.html)

## Starting Kubernetes on Linux

On Linux we'll run Kubernetes using a local Docker Engine. You will also need the kubectl tool. To launch the cluster:

```sh
./kube-up.sh
```

## Starting Kubernetes on OS X

On OS X we'll launch Kubernetes via [Docker Machine](https://docs.docker.com/machine/). You will need to have Docker Machine (v0.5.0 or newer), and the kubectl tool installed locally. First start your boot2docker VM:

```sh
docker-machine start <name>
eval "$(docker-machine env <name>)"
```

Then, launch the Kubernetes cluster in boot2docker via Docker Machine:

```sh
./kube-up.sh
```

The script will set up the kubectl contextso that you can use kubectl locally without having to ssh into boot2docker.

## Checking if Kubernetes Is Running

```sh
kubectl cluster-info
Kubernetes master is running at http://localhost:8080
```

## Accessing Kube UI

Not working at the moment: You can access Kube UI at http://localhost:8080/ui.

## To destroy the cluster

```sh
./kube-down.sh
```

This will also remove any services, replication controllers and pods that are running in the cluster.
