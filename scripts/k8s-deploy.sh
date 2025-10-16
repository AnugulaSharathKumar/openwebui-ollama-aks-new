#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Azure Ollama OpenWebUI - Kubernetes Deployment${NC}"

# Check if required variables are set
if [ -z "$ACR_NAME" ]; then
    echo -e "${YELLOW}ACR_NAME not set, trying to get from Terraform...${NC}"
    if [ -f "terraform/terraform.tfstate" ]; then
        ACR_NAME=$(cd terraform && terraform output -raw acr_name)
    else
        echo -e "${RED}ACR_NAME not set and no Terraform state found. Please set ACR_NAME environment variable.${NC}"
        exit 1
    fi
fi

# Build and push Docker image
echo -e "${YELLOW}Building and pushing Docker image...${NC}"
docker build -t $ACR_NAME.azurecr.io/ollamawebui/openwebui:latest .

# Login to ACR
echo -e "${YELLOW}Logging into Azure Container Registry...${NC}"
az acr login --name $ACR_NAME

# Push image
echo -e "${YELLOW}Pushing image to ACR...${NC}"
docker push $ACR_NAME.azurecr.io/ollamawebui/openwebui:latest

# Create namespaces
echo -e "${YELLOW}Creating Kubernetes namespaces...${NC}"
kubectl apply -f kubernetes/namespaces/

# Deploy storage
echo -e "${YELLOW}Deploying storage...${NC}"
kubectl apply -f kubernetes/ollama/storage.yaml

# Deploy Ollama
echo -e "${YELLOW}Deploying Ollama...${NC}"
kubectl apply -f kubernetes/ollama/statefulset.yaml

# Wait for Ollama to be ready
echo -e "${YELLOW}Waiting for Ollama to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app=ollama -n ollama-system --timeout=300s

# Update OpenWebUI deployment with actual ACR image
echo -e "${YELLOW}Updating OpenWebUI deployment with ACR image...${NC}"
sed "s|azurecr.io/ollamawebui/openwebui:latest|$ACR_NAME.azurecr.io/ollamawebui/openwebui:latest|g" kubernetes/openwebui/deployment.yaml | kubectl apply -f -

# Deploy monitoring
echo -e "${YELLOW}Deploying monitoring stack...${NC}"
kubectl apply -f kubernetes/monitoring/

# Deploy ingress (if you have a domain configured)
echo -e "${YELLOW}Deploying ingress...${NC}"
kubectl apply -f kubernetes/ingress/

# Check deployment status
echo -e "${YELLOW}Checking deployment status...${NC}"
kubectl get all -n ollama-system
kubectl get all -n monitoring

echo -e "${GREEN}✅ Kubernetes deployment completed!${NC}"
echo -e "${YELLOW}To access your application:${NC}"
echo -e "${GREEN}1. Port-forward OpenWebUI: kubectl port-forward -n ollama-system svc/openwebui 8080:80${NC}"
echo -e "${GREEN}2. Then visit: http://localhost:8080${NC}"
echo -e "${YELLOW}Or set up ingress with your domain in kubernetes/ingress/ingress.yaml${NC}"