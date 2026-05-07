#!/bin/bash
set -e
PREVIOUS_TAG=${1:-previous}
ENVIRONMENT=${2:-development}
echo "Rolling back to $PREVIOUS_TAG in $ENVIRONMENT..."
cd ~/docker-iac-lab
sed -i "s/docker-iac-web:latest/docker-iac-web:$PREVIOUS_TAG/g" docker-compose.yml
docker-compose up -d --no-deps web
echo "Rollback completed!"
