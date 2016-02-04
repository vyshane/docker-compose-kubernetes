#!/bin/bash

dns_host=$(echo $DOCKER_HOST | awk -F'[/:]' '{print $4}')
: ${dns_host:=$(ifconfig docker0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')}

kubectl --namespace=kube-system create -f - << EOF
apiVersion: v1
kind: Endpoints
metadata:
  name: kube-dns
  namespace: kube-system
subsets:
- addresses:
  - ip: $dns_host
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
