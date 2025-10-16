#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Azure Ollama OpenWebUI - Lightweight Deployment${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Build the custom image
echo -e "${YELLOW}Building OpenWebUI image...${NC}"
docker build -t azure-ollama-openwebui:latest .

# Pull Ollama image
echo -e "${YELLOW}Pulling Ollama image...${NC}"
docker pull ollama/ollama:latest

# Create network if it doesn't exist
docker network create azure-ollama-network 2>/dev/null || true

# Start services
echo -e "${YELLOW}Starting services...${NC}"
docker-compose up -d

# Wait for services to be healthy
echo -e "${YELLOW}Waiting for services to be ready...${NC}"
sleep 10

# Check if services are running
if docker ps | grep -q "azure-ollama" && docker ps | grep -q "azure-openwebui"; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo -e "${GREEN}OpenWebUI is available at: http://localhost:3000${NC}"
    echo -e "${GREEN}Ollama API is available at: http://localhost:11434${NC}"
else
    echo -e "${RED}❌ Some services failed to start. Check logs with: docker-compose logs${NC}"
    exit 1
fi