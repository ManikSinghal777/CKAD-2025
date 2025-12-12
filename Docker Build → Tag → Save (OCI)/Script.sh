#!/usr/bin/env bash
set -euo pipefail

# Create the directory for the Dockerfile
mkdir -p "$HOME/home"

# Create an empty (or placeholder) Dockerfile at the expected path
cat <<'EOF' > "$HOME/home/Dockerfile"
# Placeholder Dockerfile for CKAD practice
# You can replace its contents when performing the actual task.
FROM alpine:3.18
CMD ["echo", "Sample placeholder Dockerfile"]
EOF

echo "Created Dockerfile at: $HOME/home/Dockerfile"

# Create the target directory for the OCI tar export
# NOTE: The question uses a path starting with '-' which is invalid.
# We will create a normal directory named 'human-stork'
# and allow the user to export to '/human-stork/devmac-3.0.tar'
sudo mkdir -p /human-stork
sudo chmod 777 /human-stork

echo "Prepared export directory: /human-stork"
echo "Expected output file during your task: /human-stork/devmac-3.0.tar"

echo ""
echo "Environment setup complete."
echo "You may now perform the CKAD tasks manually."
