#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Kubernetes Cluster Monitoring${NC}"

# Cluster info
echo -e "${YELLOW}=== Cluster Nodes ===${NC}"
kubectl get nodes -o wide

echo -e "${YELLOW}=== Ollama System Namespace ===${NC}"
kubectl get all -n ollama-system

echo -e "${YELLOW}=== Pod Status ===${NC}"
kubectl get pods -n ollama-system -o wide

echo -e "${YELLOW}=== Services ===${NC}"
kubectl get svc -n ollama-system

echo -e "${YELLOW}=== Persistent Volumes ===${NC}"
kubectl get pvc -n ollama-system

echo -e "${YELLOW}=== Ingress ===${NC}"
kubectl get ingress -n ollama-system

echo -e "${YELLOW}=== Resource Usage ===${NC}"
kubectl top pods -n ollama-system --use-protocol-buffers 2>/dev/null || kubectl top pods -n ollama-system

echo -e "${YELLOW}=== Events ===${NC}"
kubectl get events -n ollama-system --sort-by=.metadata.creationTimestamp | tail -10

echo -e "${YELLOW}=== Monitoring Namespace ===${NC}"
kubectl get all -n monitoring