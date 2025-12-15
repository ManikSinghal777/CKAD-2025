#!/bin/bash
set -e

echo "[+] Creating store-deploy Deployment"

cat <<EOF > store-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: store-deploy
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: store
  template:
    metadata:
      labels:
        app: store
    spec:
      containers:
      - name: store
        image: nginx
        ports:
        - containerPort: 80
EOF

kubectl apply -f store-deploy.yaml

echo "[+] Creating store-svc Service on port 8080"

cat <<EOF > store-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: store-svc
  namespace: default
spec:
  selector:
    app: store
  ports:
  - port: 8080
    targetPort: 80
EOF

kubectl apply -f store-svc.yaml

echo "[+] Creating MISCONFIGURED store-ingress"

cat <<EOF > store-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: store-ingress
  namespace: default
spec:
  rules:
  - http:
      paths:
      - path: /wrong
        pathType: Exact
        backend:
          service:
            name: wrong-svc
            port:
              number: 80
EOF

kubectl apply -f store-ingress.yaml

echo "[✓] Environment ready with misconfigured Ingress"

