#Task 1

#!/bin/bash

# Ensure directory exists
mkdir -p /opt/ckadnov2025

# Create winter.yaml with required YAML content
cat <<EOF > /opt/ckadnov2025/winter.yaml
apiVersion: v1
kind: Pod
metadata:
  name: winter
spec:
  containers:
  - name: winter
    image: busybox
    command: ["sh", "-c", "echo Hello from winter pod && sleep 3600"]
EOF

# Create empty log_Output.txt (or overwrite if already exists)
echo "" > /opt/ckadnov2025/log_Output.txt

echo "Files created:"
echo " - /opt/ckadnov2025/winter.yaml"
echo " - /opt/ckadnov2025/log_Output.txt"

-------

#Task2

#!/bin/bash

# Make sure directory exists
mkdir -p /opt/ckadnov2025
echo "[+] Created /opt/ckadnov2025/pod.txt"

echo "[+] Creating namespace cpu-stress..."
kubectl create namespace cpu-stress --dry-run=client -o yaml | kubectl apply -f -

echo "[+] Creating stress pods..."
cat <<EOF | kubectl apply -n cpu-stress -f -
apiVersion: v1
kind: Pod
metadata:
  name: stress-1
spec:
  containers:
  - name: c1
    image: busybox
    command: ["sh", "-c", "while true; do :; done"]

---
apiVersion: v1
kind: Pod
metadata:
  name: stress-2
spec:
  containers:
  - name: c1
    image: busybox
    command: ["sh", "-c", "while true; do usleep 50000; done"]
EOF

echo "[+] Installing Metrics Server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "[+] Patching Metrics Server with required flags..."
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"},
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"},
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--metric-resolution=15s"}
  ]'

echo "[+] Waiting for Metrics Server rollout..."
kubectl rollout status deployment metrics-server -n kube-system
sleep 10

echo "[+] Checking if Metrics API is available..."
if kubectl top nodes >/dev/null 2>&1; then
    echo "[✓] Metrics API is now working!"
else
    echo "[!] Metrics API still unavailable."
    echo "    Your cluster might require RBAC patching."
    echo "    To fix manually, run:"
    echo ""
    echo "kubectl edit clusterrole system:aggregated-metrics-reader"
    echo ""
    echo "Add the following under rules:"
    echo ""
    echo "- apiGroups: [\"\"]"
    echo "  resources: [\"nodes/stats\", \"pods\", \"nodes\"]"
    echo "  verbs: [\"get\", \"list\", \"watch\"]"
fi

echo "done"
