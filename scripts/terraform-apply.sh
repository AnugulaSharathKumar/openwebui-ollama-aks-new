#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Azure Ollama OpenWebUI - Terraform Deployment${NC}"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Azure CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}Terraform is not installed. Please install it first.${NC}"
    exit 1
fi

# Initialize Terraform
echo -e "${YELLOW}Initializing Terraform...${NC}"
cd terraform
terraform init

# Check if terraform.tfvars exists
if [ ! -f terraform.tfvars ]; then
    echo -e "${RED}terraform.tfvars not found. Please create it from terraform.tfvars.example${NC}"
    exit 1
fi

# Plan deployment
echo -e "${YELLOW}Creating execution plan...${NC}"
terraform plan -var-file=terraform.tfvars

# Apply configuration
echo -e "${YELLOW}Applying Terraform configuration...${NC}"
terraform apply -var-file=terraform.tfvars -auto-approve

# Get outputs
echo -e "${YELLOW}Getting deployment outputs...${NC}"
AKS_NAME=$(terraform output -raw aks_cluster_name)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
ACR_NAME=$(terraform output -raw acr_name)

# Configure kubectl
echo -e "${YELLOW}Configuring kubectl...${NC}"
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME --overwrite-existing

echo -e "${GREEN}✅ Terraform deployment completed!${NC}"
echo -e "${GREEN}AKS Cluster: $AKS_NAME${NC}"
echo -e "${GREEN}ACR: $ACR_NAME${NC}"
echo -e "${GREEN}Resource Group: $RESOURCE_GROUP${NC}"