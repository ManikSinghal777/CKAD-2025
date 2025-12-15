#!/bin/bash

# Create namespace
kubectl create namespace nov2025

echo "[+] Creating app deployment in nov2025..."

k create deploy app -n nov2025 --image nginx:1.12 --replicas 3

echo "[+] Creating web1 deployment in nov2025..."

k create deploy web1 -n nov2025 --image nginx:1.12 --replicas 2

echo ""
echo "Setup completed!"
