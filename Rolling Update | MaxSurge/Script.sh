#!/bin/bash

# Create namespace
kubectl create namespace nov2025

echo "[+] Creating app deployment in nov2025..."
cat <<EOF | kubectl apply -n nov2025 -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: repo/nginx:1.12   # initial version
EOF

echo "[+] Creating web1 deployment in nov2025..."
cat <<EOF | kubectl apply -n nov2025 -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web1
  template:
    metadata:
      labels:
        app: web1
    spec:
      containers:
      - name: web1
        image: repo/nginx:1.12   # initial version
EOF

echo ""
echo "Setup completed!"
echo "Next steps (you will do manually):"
echo "1) Patch app deployment with maxSurge:5% and maxUnavailable:2%"
echo "2) Rolling update web1 to repo/nginx:1.13"
echo "3) Rollback app deployment"
