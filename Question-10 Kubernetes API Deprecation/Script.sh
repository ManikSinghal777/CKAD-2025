#!/bin/bash
set -e

echo "=== STEP 1: Creating working deployment 'web-app' ==="

cat <<'DEPLOY' > ~/web-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web
        image: nginx
        ports:
        - containerPort: 80
DEPLOY

kubectl apply -f ~/web-app.yaml

echo
echo "Deployment created:"
kubectl get deploy web-app -o wide


echo
echo "=== STEP 2: Creating WRONG HPA manifest (old API + deprecated fields) ==="

cat <<'HPA' > ~/ckad-hpa.yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: 70
HPA


echo "Wrong HPA manifest written at ~/ckad-hpa.yaml"
