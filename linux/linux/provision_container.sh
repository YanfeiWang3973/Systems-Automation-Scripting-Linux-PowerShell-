#!/bin/bash
# LXD Container Provision Script

if ! command -v lxd &> /dev/null; then
  echo "Installing LXD..."
  sudo snap install lxd || { echo "Installation failed."; exit 1; }
fi

echo "Initializing LXD..."
lxd init --auto

CONTAINER="Fei-Lab"
echo "Launching Ubuntu 20.04 container: $CONTAINER"
lxc launch images:ubuntu/20.04 "$CONTAINER"

echo "Container list:"
lxc list
