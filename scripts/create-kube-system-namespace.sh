#!/bin/bash

kubectl -s http://localhost:8080 create -f - << EOF
kind: Namespace
apiVersion: v1
metadata:
  name: kube-system
  labels:
    name: kube-system
EOF
