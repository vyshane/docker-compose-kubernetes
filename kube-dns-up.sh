#!/bin/bash

if [ "$#" -ne 1 ]
then
  echo "Usage: $0 <docker_host_ip_address>"
  exit 1
fi

kubectl --namespace=kube-system create -f - << EOF
apiVersion: v1
kind: Endpoints
metadata:
  name: kube-dns
  namespace: kube-system
subsets:
- addresses:
  - IP: $1
  ports:
  - port: 53
    protocol: UDP
    name: dns
EOF

kubectl --namespace=kube-system create -f - << EOF
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
