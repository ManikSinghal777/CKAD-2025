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
