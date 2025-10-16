#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

case "$1" in
    "start")
        echo -e "${YELLOW}Starting services...${NC}"
        docker-compose up -d
        echo -e "${GREEN}✅ Services started${NC}"
        ;;
    "stop")
        echo -e "${YELLOW}Stopping services...${NC}"
        docker-compose down
        echo -e "${GREEN}✅ Services stopped${NC}"
        ;;
    "restart")
        echo -e "${YELLOW}Restarting services...${NC}"
        docker-compose restart
        echo -e "${GREEN}✅ Services restarted${NC}"
        ;;
    "logs")
        echo -e "${YELLOW}Showing logs...${NC}"
        docker-compose logs -f
        ;;
    "status")
        echo -e "${YELLOW}Service status:${NC}"
        docker-compose ps
        ;;
    "update")
        echo -e "${YELLOW}Updating services...${NC}"
        docker-compose pull
        docker-compose up -d
        echo -e "${GREEN}✅ Services updated${NC}"
        ;;
    "clean")
        echo -e "${YELLOW}Cleaning up unused Docker resources...${NC}"
        docker system prune -f
        echo -e "${GREEN}✅ Cleanup completed${NC}"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|logs|status|update|clean}"
        echo "  start   - Start all services"
        echo "  stop    - Stop all services"
        echo "  restart - Restart all services"
        echo "  logs    - Show service logs"
        echo "  status  - Show service status"
        echo "  update  - Update to latest versions"
        echo "  clean   - Clean up Docker resources"
        exit 1
        ;;
esac