#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Azure Ollama OpenWebUI - Complete Deployment${NC}"

# Step 1: Deploy Infrastructure with Terraform
echo -e "${YELLOW}Step 1: Deploying Azure Infrastructure...${NC}"
./scripts/terraform-apply.sh

# Step 2: Deploy to Kubernetes
echo -e "${YELLOW}Step 2: Deploying to Kubernetes...${NC}"
./scripts/k8s-deploy.sh

# Step 3: Display access information
echo -e "${YELLOW}Step 3: Deployment Summary${NC}"
echo -e "${GREEN}✅ All deployments completed successfully!${NC}"
echo -e "${YELLOW}Access Methods:${NC}"
echo -e "${GREEN}1. Port Forwarding: kubectl port-forward -n ollama-system svc/openwebui 8080:80${NC}"
echo -e "${GREEN}2. Then open: http://localhost:8080${NC}"
echo -e "${GREEN}3. Ollama API: kubectl port-forward -n ollama-system svc/ollama 11434:11434${NC}"
echo -e "${YELLOW}Monitoring:${NC}"
echo -e "${GREEN}Grafana: kubectl port-forward -n monitoring svc/grafana 3000:3000${NC}"
echo -e "${GREEN}Prometheus: kubectl port-forward -n monitoring svc/prometheus 9090:9090${NC}"