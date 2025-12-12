#!/bin/bash

# Sync Dev to Production
# Promotes changes from dev/ directory to production directories

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Sync Dev to Production                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Check if dev directory exists
if [ ! -d "dev" ]; then
    echo -e "${RED}Error: dev/ directory not found${NC}"
    exit 1
fi

echo -e "${YELLOW}This will copy files from dev/ to production directories:${NC}"
echo -e "  dev/.apm/guides/      → .apm/guides/"
echo -e "  dev/.claude/commands/ → .claude/commands/"
echo ""

# Show what would be synced
echo -e "${BLUE}Files that will be synced:${NC}"
echo ""
echo -e "${YELLOW}Guides:${NC}"
if [ -d "dev/.apm/guides" ]; then
    ls -1 dev/.apm/guides/ | sed 's/^/  /'
else
    echo "  (none)"
fi
echo ""

echo -e "${YELLOW}Commands:${NC}"
if [ -d "dev/.claude/commands" ]; then
    ls -1 dev/.claude/commands/ | sed 's/^/  /'
else
    echo "  (none)"
fi
echo ""

# Confirm
read -p "Proceed with sync? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Sync cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}Syncing files...${NC}"
echo ""

# Sync guides
if [ -d "dev/.apm/guides" ]; then
    echo -e "${YELLOW}Syncing guides...${NC}"
    mkdir -p .apm/guides
    cp -v dev/.apm/guides/* .apm/guides/
    echo -e "${GREEN}✓ Guides synced${NC}"
    echo ""
fi

# Sync commands (excluding dev-specific commands)
if [ -d "dev/.claude/commands" ]; then
    echo -e "${YELLOW}Syncing commands...${NC}"
    mkdir -p .claude/commands

    # Copy only production commands (not -dev versions)
    for file in dev/.claude/commands/*; do
        filename=$(basename "$file")
        # Skip any files with -dev in the name
        if [[ ! "$filename" =~ -dev ]]; then
            cp -v "$file" ".claude/commands/$filename"
        fi
    done
    echo -e "${GREEN}✓ Commands synced${NC}"
    echo ""
fi

# Sync metadata if exists
if [ -f "dev/.apm/metadata.json" ]; then
    echo -e "${YELLOW}Syncing metadata...${NC}"
    cp -v dev/.apm/metadata.json .apm/metadata.json
    echo -e "${GREEN}✓ Metadata synced${NC}"
    echo ""
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Sync Complete!                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Review changes: git diff"
echo -e "  2. Test the production commands"
echo -e "  3. Commit if satisfied: git add . && git commit -m \"Update guides/commands\""
echo ""
