#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Ollama Data Backup Script${NC}"

BACKUP_DIR="./backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

case "$1" in
    "create")
        echo -e "${YELLOW}Creating backup...${NC}"
        # Backup Ollama data
        kubectl exec -n ollama-system deployment/ollama -- tar czf - /root/.ollama > $BACKUP_DIR/ollama-data.tar.gz
        # Backup models
        kubectl exec -n ollama-system deployment/ollama -- tar czf - /models > $BACKUP_DIR/models.tar.gz
        echo -e "${GREEN}✅ Backup created in $BACKUP_DIR${NC}"
        ;;
    "restore")
        if [ -z "$2" ]; then
            echo -e "${RED}Please specify backup directory${NC}"
            exit 1
        fi
        echo -e "${YELLOW}Restoring from $2...${NC}"
        # Restore Ollama data
        cat $2/ollama-data.tar.gz | kubectl exec -n ollama-system -i deployment/ollama -- tar xzf - -C /
        # Restore models
        cat $2/models.tar.gz | kubectl exec -n ollama-system -i deployment/ollama -- tar xzf - -C /
        echo -e "${GREEN}✅ Restore completed${NC}"
        ;;
    "list")
        echo -e "${YELLOW}Available backups:${NC}"
        ls -la ./backups/
        ;;
    *)
        echo "Usage: $0 {create|restore <backup_dir>|list}"
        echo "  create  - Create a new backup"
        echo "  restore - Restore from backup directory"
        echo "  list    - List available backups"
        exit 1
        ;;
esac