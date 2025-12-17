#!/usr/bin/env bash
set -euo pipefail

WORKDIR="$HOME/broker-deployment"
MANIFEST="$WORKDIR/hotfix-deployment.yaml"
NS="quetzal"

mkdir -p "$WORKDIR"

cat > "$MANIFEST" <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hotfix-deployment
  namespace: quetzal
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hotfix
  template:
    metadata:
      labels:
        app: hotfix
    spec:
      containers:
        - name: hotfix-container
          image: nginx:stable
          ports:
            - containerPort: 8080
YAML

# Ensure namespace exists then apply the EXERCISE manifest (initial state, no securityContext)
kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f "$MANIFEST"

echo "=== Environment created ==="

