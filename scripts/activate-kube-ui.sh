#!/bin/bash

source ../common.sh

printf "${yellow}Activating Kube UI...${reset}\n"

kube_ui_cluster_ip=$(kubectl get services --namespace=kube-system kube-ui --template={{.spec.clusterIP}} 2> /dev/null)

if [ -n "$kube_ui_cluster_ip" ]; then
	printf "\n${yellow}   ${warning} Kube-UI service already exists. ClusterIP: $kube_ui_cluster_ip${reset}\n\n"
	exit 0
fi

kubectl --namespace=kube-system create -f - << EOF > /dev/null
apiVersion: v1
kind: ReplicationController
metadata:
  name: kube-ui-v3
  namespace: kube-system
  labels:
    k8s-app: kube-ui
    version: v3
    kubernetes.io/cluster-service: "true"
spec:
  replicas: 1
  selector:
    k8s-app: kube-ui
    version: v3
  template:
    metadata:
      labels:
        k8s-app: kube-ui
        version: v3
        kubernetes.io/cluster-service: "true"
    spec:
      containers:
      - name: kube-ui
        image: gcr.io/google_containers/kube-ui:v3
        resources:
          limits:
            cpu: 100m
            memory: 50Mi
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 30
          timeoutSeconds: 5
EOF

kubectl --namespace=kube-system create -f - << EOF > /dev/null
apiVersion: v1
kind: Service
metadata:
  name: kube-ui
  namespace: kube-system
  labels:
    k8s-app: kube-ui
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "KubeUI"
spec:
  selector:
    k8s-app: kube-ui
  ports:
  - port: 80
    targetPort: 8080
EOF

check_rc "Successfully started kube-ui" "Could not start kube-ui"
