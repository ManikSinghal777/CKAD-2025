#!/bin/bash
set -e

echo "[+] Creating failing startup-pod"

cat <<EOF > startup-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: startup-pod
  namespace: default
spec:
  containers:
  - name: app
    image: nginx
    command: ["/app/start.sh"]
EOF

kubectl apply -f startup-pod.yaml

echo "[✓] Environment created (pod will fail as expected)"
