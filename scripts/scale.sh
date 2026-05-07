#!/bin/bash
set -e
SERVICE=${1:-web}
REPLICAS=${2:-3}
ENVIRONMENT=${3:-development}
echo "Scaling $SERVICE to $REPLICAS replicas in $ENVIRONMENT..."
case $ENVIRONMENT in
  "development")
    cd ~/docker-iac-lab && docker-compose up -d --scale $SERVICE=$REPLICAS ;;
  "production")
    cd ~/docker-iac-lab/infrastructure && terraform apply -var="web_replicas=$REPLICAS" -auto-approve ;;
esac
echo "Scaling completed!"
