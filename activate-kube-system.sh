#!/bin/bash

echo "Activating Kube System"
kubectl create -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: kube-system
EOF

