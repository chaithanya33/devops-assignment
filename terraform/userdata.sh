#!/bin/bash
set -e

# Update system
dnf update -y

# Install required packages
dnf install -y git docker

# Enable & start Docker
systemctl enable docker
systemctl start docker

# Install Docker Compose v2
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Add ec2-user to docker group
usermod -aG docker ec2-user
