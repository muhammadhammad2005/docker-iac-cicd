#!/bin/bash
set -e
ENVIRONMENT=${1:-development}
CPU_THRESHOLD=${2:-80}
MEMORY_THRESHOLD=${3:-80}
MIN_REPLICAS=${4:-2}
MAX_REPLICAS=${5:-10}

echo "Starting monitoring for $ENVIRONMENT..."
while true; do
  echo "$(date): Checking container metrics..."
  current_replicas=$(docker ps --filter "name=web" --format "{{.Names}}" | wc -l)
  avg_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" | sed 's/%//g' | awk '{sum+=$1} END {if(NR>0) print sum/NR; else print 0}')
  avg_memory=$(docker stats --no-stream --format "{{.MemPerc}}" | sed 's/%//g' | awk '{sum+=$1} END {if(NR>0) print sum/NR; else print 0}')
  echo "Replicas: $current_replicas | CPU: ${avg_cpu}% | Memory: ${avg_memory}%"

  if (( $(echo "$avg_cpu > $CPU_THRESHOLD" | bc -l) )) && [ $current_replicas -lt $MAX_REPLICAS ]; then
    new_replicas=$((current_replicas + 1))
    echo "Scaling up to $new_replicas..."
    bash scale.sh web $new_replicas $ENVIRONMENT
  elif (( $(echo "$avg_cpu < 30" | bc -l) )) && [ $current_replicas -gt $MIN_REPLICAS ]; then
    new_replicas=$((current_replicas - 1))
    echo "Scaling down to $new_replicas..."
    bash scale.sh web $new_replicas $ENVIRONMENT
  fi
  sleep 60
done
