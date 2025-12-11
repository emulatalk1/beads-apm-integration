#!/bin/bash

# Beads + APM Integration Installer
# Installs APM methodology with Beads issue tracking into your project
# Fetches templates from GitHub

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub repository for templates
GITHUB_REPO="emulatalk1/beads-apm-integration"
GITHUB_BRANCH="main"
GITHUB_RAW_BASE="https://raw.githubusercontent.com/${GITHUB_REPO}/${GITHUB_BRANCH}"

# Target directory (default to current directory)
TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || TARGET_DIR="$1"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           Beads + APM Integration Installer                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# Utility Functions
# ============================================================================

download_file() {
    local remote_path="$1"
    local local_path="$2"
    local url="${GITHUB_RAW_BASE}/${remote_path}"

    mkdir -p "$(dirname "$local_path")"

    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$local_path"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$local_path"
    else
        echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
        exit 1
    fi
}

# ============================================================================
# Detection Functions
# ============================================================================

detect_git() {
    if [ -d "$TARGET_DIR/.git" ]; then
        return 0
    fi
    return 1
}

detect_beads() {
    if [ -d "$TARGET_DIR/.beads" ]; then
        return 0
    fi
    return 1
}

detect_apm() {
    if [ -d "$TARGET_DIR/.apm" ]; then
        return 0
    fi
    return 1
}

detect_claude_commands() {
    if [ -d "$TARGET_DIR/.claude/commands" ]; then
        return 0
    fi
    return 1
}

detect_claude_md() {
    if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
        return 0
    fi
    return 1
}

# ============================================================================
# Installation Functions
# ============================================================================

install_beads() {
    echo -e "${YELLOW}Installing Beads...${NC}"
    cd "$TARGET_DIR"

    # Check if bd is already installed globally
    if command -v bd &> /dev/null; then
        echo -e "  Using existing bd installation"
        bd init
    else
        echo -e "  Installing @beads/bd globally..."
        npm install -g @beads/bd
        bd init
    fi

    echo -e "${GREEN}✓ Beads initialized${NC}"
}

install_apm_guides() {
    echo -e "${YELLOW}Installing APM guides from GitHub...${NC}"
    mkdir -p "$TARGET_DIR/.apm/guides"

    # Download all guide files
    local guides=(
        "Context_Synthesis_Guide.md"
        "Project_Breakdown_Guide.md"
        "Project_Breakdown_Review_Guide.md"
        "Task_Assignment_Guide.md"
        "Agent_Workflow_Guide.md"
    )

    for guide in "${guides[@]}"; do
        echo -e "  Downloading ${guide}..."
        download_file ".apm/guides/${guide}" "$TARGET_DIR/.apm/guides/${guide}"
    done

    # Download metadata
    echo -e "  Downloading metadata.json..."
    download_file ".apm/metadata.json" "$TARGET_DIR/.apm/metadata.json"

    echo -e "${GREEN}✓ APM guides installed${NC}"
}

install_claude_commands() {
    echo -e "${YELLOW}Installing Claude commands from GitHub...${NC}"
    mkdir -p "$TARGET_DIR/.claude/commands"

    # Download command files
    echo -e "  Downloading apm-setup.md..."
    download_file ".claude/commands/apm-setup.md" "$TARGET_DIR/.claude/commands/apm-setup.md"

    echo -e "  Downloading apm-start.md..."
    download_file ".claude/commands/apm-start.md" "$TARGET_DIR/.claude/commands/apm-start.md"

    echo -e "${GREEN}✓ Claude commands installed${NC}"
}

install_claude_md() {
    echo -e "${YELLOW}Installing CLAUDE.md from GitHub...${NC}"
    download_file "CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    echo -e "${GREEN}✓ CLAUDE.md installed${NC}"
}

append_to_claude_md() {
    echo -e "${YELLOW}Appending APM instructions to existing CLAUDE.md...${NC}"

    # Check if APM section already exists
    if grep -q "## APM Integration" "$TARGET_DIR/CLAUDE.md" 2>/dev/null; then
        echo -e "${YELLOW}  APM section already exists in CLAUDE.md, skipping${NC}"
        return
    fi

    cat >> "$TARGET_DIR/CLAUDE.md" << 'EOF'

## APM Integration

This project uses APM (Agentic Project Management) with Beads issue tracking.

### Quick Start

1. **Setup a new project**: Run `/apm-setup`
2. **Start work**: Run `/apm-start`

### Beads Workflow

- Track ALL work in beads (no TodoWrite, no markdown TODOs)
- `bd create` - Create issues
- `bd update --status=in_progress` - Start work
- `bd comments add` - Log progress
- `bd close` - Complete work
- `bd ready` - Find available work
EOF

    echo -e "${GREEN}✓ APM instructions appended to CLAUDE.md${NC}"
}

upgrade_apm_guides() {
    echo -e "${YELLOW}Upgrading APM guides...${NC}"

    # Backup existing guides
    if [ -d "$TARGET_DIR/.apm/guides" ]; then
        backup_dir="$TARGET_DIR/.apm/guides.backup.$(date +%Y%m%d%H%M%S)"
        cp -r "$TARGET_DIR/.apm/guides" "$backup_dir"
        echo -e "${BLUE}  Backed up existing guides to ${backup_dir}${NC}"
    fi

    # Install fresh guides from GitHub
    install_apm_guides
}

upgrade_claude_commands() {
    echo -e "${YELLOW}Upgrading Claude commands...${NC}"
    install_claude_commands
}

# ============================================================================
# Main Installation Logic
# ============================================================================

echo -e "${BLUE}Target directory:${NC} $TARGET_DIR"
echo ""

# Create target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Creating target directory...${NC}"
    mkdir -p "$TARGET_DIR"
fi

# Detect current state
echo -e "${BLUE}Detecting current setup...${NC}"
echo ""

HAS_GIT=false
HAS_BEADS=false
HAS_APM=false
HAS_CLAUDE_COMMANDS=false
HAS_CLAUDE_MD=false

if detect_git; then
    HAS_GIT=true
    echo -e "  ${GREEN}✓${NC} Git repository"
else
    echo -e "  ${YELLOW}○${NC} No git repository"
fi

if detect_beads; then
    HAS_BEADS=true
    echo -e "  ${GREEN}✓${NC} Beads initialized"
else
    echo -e "  ${YELLOW}○${NC} No Beads setup"
fi

if detect_apm; then
    HAS_APM=true
    echo -e "  ${GREEN}✓${NC} APM guides present"
else
    echo -e "  ${YELLOW}○${NC} No APM guides"
fi

if detect_claude_commands; then
    HAS_CLAUDE_COMMANDS=true
    echo -e "  ${GREEN}✓${NC} Claude commands present"
else
    echo -e "  ${YELLOW}○${NC} No Claude commands"
fi

if detect_claude_md; then
    HAS_CLAUDE_MD=true
    echo -e "  ${GREEN}✓${NC} CLAUDE.md present"
else
    echo -e "  ${YELLOW}○${NC} No CLAUDE.md"
fi

echo ""

# Determine installation type
if ! $HAS_GIT && ! $HAS_BEADS && ! $HAS_APM; then
    INSTALL_TYPE="new"
    echo -e "${BLUE}Installation type:${NC} New project"
elif $HAS_APM && $HAS_BEADS; then
    INSTALL_TYPE="upgrade"
    echo -e "${BLUE}Installation type:${NC} Upgrade existing APM + Beads setup"
elif $HAS_APM && ! $HAS_BEADS; then
    INSTALL_TYPE="migrate"
    echo -e "${BLUE}Installation type:${NC} Migrate APM to Beads"
elif ! $HAS_APM && $HAS_BEADS; then
    INSTALL_TYPE="add_apm"
    echo -e "${BLUE}Installation type:${NC} Add APM to existing Beads project"
else
    INSTALL_TYPE="existing"
    echo -e "${BLUE}Installation type:${NC} Add to existing project"
fi

echo ""

# Confirm installation (skip if non-interactive / piped)
if [ -t 0 ]; then
    read -p "Proceed with installation? [Y/n] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        exit 0
    fi
else
    echo -e "${YELLOW}Non-interactive mode: proceeding with installation...${NC}"
fi

echo ""
echo -e "${BLUE}Starting installation...${NC}"
echo ""

# ============================================================================
# Execute Installation Based on Type
# ============================================================================

case $INSTALL_TYPE in
    "new")
        echo -e "${BLUE}Setting up new project...${NC}"
        echo ""

        # Initialize git if not present
        if ! $HAS_GIT; then
            echo -e "${YELLOW}Initializing git repository...${NC}"
            cd "$TARGET_DIR"
            git init
            echo -e "${GREEN}✓ Git initialized${NC}"
        fi

        # Install all components
        install_beads
        install_apm_guides
        install_claude_commands
        install_claude_md
        ;;

    "upgrade")
        echo -e "${BLUE}Upgrading existing setup...${NC}"
        echo ""

        upgrade_apm_guides
        upgrade_claude_commands

        # Update CLAUDE.md if needed
        if ! grep -q "## APM Integration" "$TARGET_DIR/CLAUDE.md" 2>/dev/null; then
            append_to_claude_md
        fi
        ;;

    "migrate")
        echo -e "${BLUE}Migrating APM to Beads...${NC}"
        echo ""

        # Install Beads
        install_beads

        # Upgrade APM guides to Beads-aware versions
        upgrade_apm_guides
        upgrade_claude_commands

        # Update CLAUDE.md
        if $HAS_CLAUDE_MD; then
            append_to_claude_md
        else
            install_claude_md
        fi

        echo ""
        echo -e "${YELLOW}Note: You may have existing APM state in markdown files.${NC}"
        echo -e "${YELLOW}Consider migrating tasks to Beads with 'bd create'.${NC}"
        ;;

    "add_apm")
        echo -e "${BLUE}Adding APM to Beads project...${NC}"
        echo ""

        install_apm_guides
        install_claude_commands

        if $HAS_CLAUDE_MD; then
            append_to_claude_md
        else
            install_claude_md
        fi
        ;;

    "existing")
        echo -e "${BLUE}Adding Beads + APM to existing project...${NC}"
        echo ""

        # Initialize git if not present
        if ! $HAS_GIT; then
            INIT_GIT=true
            if [ -t 0 ]; then
                read -p "Initialize git repository? [Y/n] " -n 1 -r
                echo ""
                if [[ $REPLY =~ ^[Nn]$ ]]; then
                    INIT_GIT=false
                fi
            fi
            if $INIT_GIT; then
                cd "$TARGET_DIR"
                git init
                echo -e "${GREEN}✓ Git initialized${NC}"
            fi
        fi

        # Install Beads if not present
        if ! $HAS_BEADS; then
            install_beads
        fi

        # Install APM if not present
        if ! $HAS_APM; then
            install_apm_guides
        fi

        # Install Claude commands if not present
        if ! $HAS_CLAUDE_COMMANDS; then
            install_claude_commands
        else
            # Check if our specific commands exist
            if [ ! -f "$TARGET_DIR/.claude/commands/apm-setup.md" ]; then
                install_claude_commands
            fi
        fi

        # Handle CLAUDE.md
        if $HAS_CLAUDE_MD; then
            append_to_claude_md
        else
            install_claude_md
        fi
        ;;
esac

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  Installation Complete!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}What was installed:${NC}"
echo -e "  .beads/              - Beads issue tracking"
echo -e "  .apm/guides/         - APM methodology guides"
echo -e "  .claude/commands/    - Slash commands (apm-setup, apm-start)"
echo -e "  CLAUDE.md            - Project instructions for Claude"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Open Claude Code in your project"
echo -e "  2. Run ${GREEN}/apm-setup${NC} to initialize your project"
echo -e "  3. Run ${GREEN}/apm-start${NC} to begin work"
echo ""
echo -e "${BLUE}Beads commands:${NC}"
echo -e "  bd stats   - Project overview"
echo -e "  bd ready   - See available work"
echo -e "  bd create  - Create new issues"
echo -e "  bd close   - Complete issues"
echo ""
