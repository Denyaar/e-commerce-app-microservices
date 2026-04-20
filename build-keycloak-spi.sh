#!/bin/bash

set -e

echo "🔨 Building EcoCash Keycloak OTP SPI..."
echo "=========================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
SPI_DIR="/Users/tendaimupezeni/Projects/ZEcocash-Projects/developer-portal/keycloak-otp-spi"
DOCKER_COMPOSE_DIR="/Users/tendaimupezeni/Projects/ZPractice-projects/e-commerce-app"

# Step 1: Check Java
echo -e "${BLUE}📋 Checking prerequisites...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java not found. Please install Java 25.${NC}"
    exit 1
fi

if ! command -v mvn &> /dev/null; then
    echo -e "${RED}❌ Maven not found. Please install Maven.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Java version: $(java -version 2>&1 | head -n 1)${NC}"
echo -e "${GREEN}✅ Maven version: $(mvn -version | head -n 1)${NC}"
echo ""

# Step 2: Build SPI
echo -e "${BLUE}🔨 Building OTP SPI...${NC}"
cd "$SPI_DIR"

if mvn clean package; then
    echo -e "${GREEN}✅ SPI built successfully!${NC}"
    echo -e "${GREEN}   JAR location: ${SPI_DIR}/target/keycloak-otp-spi.jar${NC}"
else
    echo -e "${RED}❌ Build failed. Check logs above.${NC}"
    exit 1
fi
echo ""

# Step 3: Check if Keycloak database exists
echo -e "${BLUE}🗄️  Checking Keycloak database...${NC}"
if docker exec ms_pd_sql psql -U root -lqt | cut -d \| -f 1 | grep -qw keycloak; then
    echo -e "${GREEN}✅ Keycloak database exists${NC}"
else
    echo -e "${YELLOW}⚠️  Keycloak database not found. Creating...${NC}"
    if docker exec ms_pd_sql psql -U root -d postgres -c "CREATE DATABASE keycloak;"; then
        echo -e "${GREEN}✅ Keycloak database created${NC}"
    else
        echo -e "${RED}❌ Failed to create database${NC}"
        exit 1
    fi
fi
echo ""

# Step 4: Check .env file
echo -e "${BLUE}📝 Checking environment configuration...${NC}"
cd "$DOCKER_COMPOSE_DIR"
if [ -f ".env" ]; then
    echo -e "${GREEN}✅ .env file exists${NC}"
else
    echo -e "${YELLOW}⚠️  .env file not found${NC}"
    echo -e "${YELLOW}   Creating .env from .env.example...${NC}"
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "${YELLOW}   ⚠️  Please edit .env with your Twilio and SMTP credentials${NC}"
    else
        echo -e "${RED}❌ .env.example not found${NC}"
    fi
fi
echo ""

# Step 5: Restart Keycloak
echo -e "${BLUE}🔄 Restarting Keycloak...${NC}"
cd "$DOCKER_COMPOSE_DIR"
if docker-compose restart keycloak; then
    echo -e "${GREEN}✅ Keycloak restarted${NC}"
else
    echo -e "${YELLOW}⚠️  Keycloak not running. Starting...${NC}"
    docker-compose up -d keycloak
fi
echo ""

# Step 6: Wait for Keycloak to be ready
echo -e "${BLUE}⏳ Waiting for Keycloak to start...${NC}"
echo -e "${YELLOW}   This may take 30-60 seconds...${NC}"
sleep 10

MAX_ATTEMPTS=30
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if docker logs ms_keycloak 2>&1 | grep -q "Listening on:"; then
        echo -e "${GREEN}✅ Keycloak is ready!${NC}"
        break
    fi
    ATTEMPT=$((ATTEMPT + 1))
    echo -n "."
    sleep 2
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo -e "${YELLOW}⚠️  Timeout waiting for Keycloak. Check logs: docker logs ms_keycloak${NC}"
fi
echo ""

# Summary
echo -e "${GREEN}=========================================="
echo -e "✅ Build Complete!"
echo -e "==========================================${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo ""
echo -e "1️⃣  ${GREEN}Access Keycloak Admin Console:${NC}"
echo -e "   🌐 http://localhost:8443"
echo -e "   👤 Username: mupezeni"
echo -e "   🔑 Password: Mupezeni0102?"
echo ""
echo -e "2️⃣  ${GREEN}Configure OTP Authentication Flow:${NC}"
echo -e "   - Go to: Authentication → Flows"
echo -e "   - Copy 'Browser' flow → Name: 'Browser with OTP'"
echo -e "   - Add execution: 'EcoCash OTP Authentication'"
echo -e "   - Set to REQUIRED"
echo -e "   - Bind as Browser Flow"
echo ""
echo -e "3️⃣  ${GREEN}Apply Custom Theme:${NC}"
echo -e "   - Go to: Realm Settings → Themes"
echo -e "   - Login theme: 'ecocash'"
echo -e "   - Save"
echo ""
echo -e "4️⃣  ${GREEN}Configure User Phone Number:${NC}"
echo -e "   - Go to: Users → Select user → Attributes"
echo -e "   - Add: phoneNumber = +263771234567"
echo -e "   - Save"
echo ""
echo -e "${YELLOW}📖 Full documentation: See KEYCLOAK_SETUP.md${NC}"
echo ""
echo -e "${BLUE}🔧 Useful Commands:${NC}"
echo -e "   View logs:    docker logs -f ms_keycloak"
echo -e "   Restart:      docker-compose restart keycloak"
echo -e "   Check theme:  docker exec ms_keycloak ls /opt/keycloak/themes/ecocash"
echo -e "   Check SPI:    docker exec ms_keycloak ls /opt/keycloak/providers/"
echo ""