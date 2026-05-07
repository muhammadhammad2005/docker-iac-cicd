#!/bin/bash
set -e
ENVIRONMENT=${1:-development}
echo "Deploying to $ENVIRONMENT environment..."
case $ENVIRONMENT in
  "development")
    docker-compose up -d ;;
  "staging")
    docker-compose -f docker-compose.staging.yml up -d ;;
  "production")
    cd ../infrastructure && terraform init && terraform apply -auto-approve ;;
  *)
    echo "Unknown environment: $ENVIRONMENT"; exit 1 ;;
esac
echo "Deployment completed!"
