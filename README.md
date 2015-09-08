# Launch a local [Kubernetes](http://kubernetes.io) cluster via [Docker Compose](https://www.docker.com/docker-compose)

To launch the Kubernetes cluster:

```shell
./kube-up.sh
```

If you are on OS X and are using [boot2docker](http://boot2docker.io) via [Docker Machine](https://docs.docker.com/machine/), you can set up port forwarding so that you can use [kubectl](http://kubernetes.io/v1.0/docs/getting-started-guides/aws/kubectl.html) locally:

```shell
./docker-machine-port-forwarding.sh
```

The default password for the boot2docker docker user is `tcuser`.

You can then check if Kubernetes is running:

```shell
kubectl get nodes
NAME        LABELS                             STATUS
127.0.0.1   kubernetes.io/hostname=127.0.0.1   Ready
```

To activate [DNS](https://github.com/kubernetes/kubernetes/blob/v1.0.3/cluster/addons/dns/README.md):

```sh
./kube-dns-up.sh <docker_host_ip_address>
```

To destroy the cluster:

```shell
./kube-down.sh
```

This will also remove any pods that are running in the cluster.

