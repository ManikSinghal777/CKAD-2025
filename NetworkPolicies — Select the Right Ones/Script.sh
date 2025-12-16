#!/bin/bash
set -e

echo "[+] Creating Pods (initially MIS-LABELED)"

cat <<EOF > pods.yaml
apiVersion: v1
kind: Pod
metadata:
  name: db-pod
  labels:
    wrong: label
spec:
  containers:
  - name: db
    image: nginx
---
apiVersion: v1
kind: Pod
metadata:
  name: api-pod
  labels:
    wrong: label
spec:
  containers:
  - name: api
    image: nginx
---
apiVersion: v1
kind: Pod
metadata:
  name: monitor-pod
  labels:
    wrong: label
spec:
  containers:
  - name: monitor
    image: nginx
EOF

kubectl apply -f pods.yaml

echo "[+] Creating 4 NetworkPolicies (ALREADY DEPLOYED)"

cat <<EOF > netpols.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
spec:
  podSelector:
    matchLabels:
      app: db
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api
          tier: frontend
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-monitor-to-backend
spec:
  podSelector:
    matchLabels:
      app: db
      tier: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: monitor
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-backend
spec:
  podSelector:
    matchLabels:
      app: db
      tier: backend
  policyTypes:
  - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: unrelated-policy
spec:
  podSelector:
    matchLabels:
      app: other
  policyTypes:
  - Ingress
EOF

kubectl apply -f netpols.yaml

echo "======================================"
echo "[✓] Environment READY"
echo
echo "Tasks to perform:"
echo "1) kubectl get netpol"
echo "2) kubectl describe netpol"
echo "3) Identify the TWO policies that allow traffic to backend"
echo "4) Label Pods correctly to enable communication"
echo "======================================"
