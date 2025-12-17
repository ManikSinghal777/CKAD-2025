#!/bin/bash

set -e

echo "[+] Creating namespace meta"
kubectl create namespace meta

echo "[+] Setting current context namespace to meta"
kubectl config set-context --current --namespace=meta

echo "[+] Creating dev-deployment manifest"
cat <<EOF > /dev-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dev-deployment
  namespace: meta
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dev-app
  template:
    metadata:
      labels:
        app: dev-app
    spec:
      serviceAccountName: default
      containers:
      - name: dev-container
        image: bitnami/kubectl:latest
        command: ["sh", "-c", "while true; do kubectl get deployments -n meta; sleep 10; done"]
EOF

echo "[+] Applying deployment"
kubectl apply -f /dev-deployment.yaml

echo "[✓] Setup completed successfully"
