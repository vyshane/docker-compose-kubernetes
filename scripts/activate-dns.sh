#!/bin/bash

dns_host=$(echo $DOCKER_HOST | awk -F'[/:]' '{print $4}')

kubectl --namespace=kube-system create -f - << EOF
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
