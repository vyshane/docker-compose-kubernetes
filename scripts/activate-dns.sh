#!/bin/bash

source ../common.sh

dns_host=$(echo $DOCKER_HOST | awk -F'[/:]' '{print $4}')

printf "${yellow}Activating DNS...${reset}\n"

dns_cluster_ip=$(kubectl get services --namespace=kube-system kube-dns --template={{.spec.clusterIP}} 2> /dev/null)

if [ -n "$dns_cluster_ip" ]; then
	printf "\n${yellow}   ${warning} Kube DNS service already exists. ClusterIP: $dns_cluster_ip${reset}\n\n"
	exit 0;
fi

kubectl --namespace=kube-system create -f  - << EOF > /dev/null
apiVersion: v1
kind: Endpoints
metadata:
  name: kube-dns
  namespace: kube-system
subsets:
- addresses:
  - IP: $dns_host
  ports:
  - port: 53
    protocol: UDP
    name: dns
EOF

kubectl --namespace=kube-system create -f - << EOF > /dev/null
kind: Service
apiVersion: v1
metadata:
  name: kube-dns
  namespace: kube-system
spec:
  clusterIP: 10.0.0.10
  ports:
  - name: dns
    port: 53
    protocol: UDP
EOF

check_rc "Successfully started kube-dns" "Could not start kube-dns"
