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

The script will set up port forwarding so that you can use kubectl locally without having to ssh into boot2docker. The default password for the boot2docker docker user is `tcuser`.

## Controlling Addons (DNS, UI)
You can use the `.settings` file to tell the `kube-up.sh` script which additional services to start. The default is
to start all addons:

```
# startup settings
port_forward=true
add_route=true
start_registry=true
start_dns=true
start_ui=true
```

- `port_forward` will setup the SSH tunnel for accessing the API server via `kubectl`
- `add_route` will create a custom routing entry to enable local name resolution via the configured cluster DNS
- `start_registry` will start a private docker registry (can be used to make local images available to k8s)
- `start_dns` will start skydns and the kube2sky bridge
- `start_ui` will start the k8s UI

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

