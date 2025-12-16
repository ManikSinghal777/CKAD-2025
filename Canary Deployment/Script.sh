#!/bin/bash
set -e

echo "[+] Creating stable web deployment (initial state)"

cat <<EOF > web-stable.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-stable
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
      version: stable
  template:
    metadata:
      labels:
        app: web
        version: stable
    spec:
      containers:
      - name: nginx
        image: nginx:1.14
        ports:
        - containerPort: 80
EOF

kubectl apply -f web-stable.yaml

echo "[+] Creating Service selecting app=web (DO NOT MODIFY THIS)"

cat <<EOF > web-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: default
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl apply -f web-svc.yaml

echo "======================================"
echo "[✓] Environment READY"
echo
echo "Your task:"
echo "- Scale stable to 3 replicas"
echo "- Create canary deployment with:"
echo "    image: nginx:1.16"
echo "    replicas: 1"
echo "- Ensure BOTH have label: app=web"
echo "- DO NOT modify the Service"
echo "======================================"
