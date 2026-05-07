#!/bin/bash
set -e
IMAGE_TAG=${1:-latest}
ENVIRONMENT=${2:-development}
echo "Updating containers to $IMAGE_TAG in $ENVIRONMENT..."
cd ~/docker-iac-lab
docker-compose pull
docker-compose up -d --no-deps web
echo "Update completed!"
