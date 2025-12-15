#!/bin/bash

# Beads + APM Integration Installer v0.2.1
# Installs APM methodology with Beads issue tracking into your project
# Fetches templates from GitHub

set -e

VERSION="0.2.1"

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
echo -e "${BLUE}║      Beads + APM Integration Installer v${VERSION}            ║${NC}"
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

# Detect if APM is original (markdown-based) or our Beads variant
detect_beads_apm() {
    if [ -f "$TARGET_DIR/.apm/metadata.json" ]; then
        if grep -q '"variant":\s*"beads-apm"' "$TARGET_DIR/.apm/metadata.json" 2>/dev/null; then
            return 0
        fi
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

# Detect v0.1.0 installation
detect_v0_1_0() {
    if [ -f "$TARGET_DIR/.apm/metadata.json" ]; then
        if grep -q '"version":\s*"0\.1\.0"' "$TARGET_DIR/.apm/metadata.json" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# ============================================================================
# Installation Functions
# ============================================================================

# Backup and remove files/directories
backup_and_remove() {
    local item="$1"       # file or directory path (relative to TARGET_DIR)
    local category="$2"   # "apm.guides" or "claude.commands"

    if [ -e "$TARGET_DIR/$item" ]; then
        timestamp="$(date +%Y%m%d%H%M%S)"
        backup_path="$TARGET_DIR/.backup/${timestamp}/${category}"

        mkdir -p "$backup_path"
        cp -r "$TARGET_DIR/$item" "$backup_path/"
        rm -rf "$TARGET_DIR/$item"

        echo -e "${BLUE}  ✓ Backed up and removed: $item${NC}"
    fi
}

remove_v0_1_0() {
    echo -e "${YELLOW}Removing v0.1.0 installation...${NC}"

    # Backup and remove .apm directory
    backup_and_remove ".apm" "apm.guides"

    # Backup and remove command files
    backup_and_remove ".claude/commands/apm-setup.md" "claude.commands"
    backup_and_remove ".claude/commands/apm-start.md" "claude.commands"

    echo -e "${GREEN}✓ v0.1.0 removed${NC}"
}

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

    # Download all guide files from dev/
    local guides=(
        "Context_Synthesis_Guide.md"
        "Project_Breakdown_Guide.md"
        "Project_Breakdown_Review_Guide.md"
        "Task_Assignment_Guide.md"
        "Agent_Workflow_Guide.md"
    )

    for guide in "${guides[@]}"; do
        echo -e "  Downloading ${guide}..."
        download_file "dev/.apm/guides/${guide}" "$TARGET_DIR/.apm/guides/${guide}"
    done

    # Download metadata
    echo -e "  Downloading metadata.json..."
    download_file "dev/.apm/metadata.json" "$TARGET_DIR/.apm/metadata.json"

    echo -e "${GREEN}✓ APM guides installed${NC}"
}

install_claude_commands() {
    echo -e "${YELLOW}Installing Claude commands from GitHub...${NC}"
    mkdir -p "$TARGET_DIR/.claude/commands"

    # Download command files from dev/
    echo -e "  Downloading apm-setup.md..."
    download_file "dev/.claude/commands/apm-setup.md" "$TARGET_DIR/.claude/commands/apm-setup.md"

    echo -e "  Downloading apm-start.md..."
    download_file "dev/.claude/commands/apm-start.md" "$TARGET_DIR/.claude/commands/apm-start.md"

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

    # Backup and remove existing guides
    backup_and_remove ".apm/guides" "apm.guides"

    # Install fresh guides from GitHub
    install_apm_guides
}

upgrade_claude_commands() {
    echo -e "${YELLOW}Upgrading Claude commands...${NC}"

    # Backup existing command files
    backup_and_remove ".claude/commands/apm-setup.md" "claude.commands"
    backup_and_remove ".claude/commands/apm-start.md" "claude.commands"

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
HAS_BEADS_APM=false
HAS_CLAUDE_COMMANDS=false
HAS_CLAUDE_MD=false
HAS_V0_1_0=false

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
    if detect_beads_apm; then
        HAS_BEADS_APM=true
        echo -e "  ${GREEN}✓${NC} APM guides present (Beads variant)"
    else
        echo -e "  ${YELLOW}!${NC} APM guides present (original - will migrate)"
    fi
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

if detect_v0_1_0; then
    HAS_V0_1_0=true
    echo -e "  ${YELLOW}!${NC} v0.1.0 detected (will upgrade to v0.2.0)"
fi

echo ""

# Determine installation type
if $HAS_V0_1_0; then
    INSTALL_TYPE="upgrade_v0_1_0"
    echo -e "${BLUE}Installation type:${NC} Upgrade from v0.1.0 to v0.2.0"
elif ! $HAS_GIT && ! $HAS_BEADS && ! $HAS_APM; then
    INSTALL_TYPE="new"
    echo -e "${BLUE}Installation type:${NC} New project"
elif $HAS_APM && $HAS_BEADS_APM && $HAS_BEADS; then
    INSTALL_TYPE="upgrade"
    echo -e "${BLUE}Installation type:${NC} Upgrade existing Beads-APM setup"
elif $HAS_APM && ! $HAS_BEADS_APM; then
    INSTALL_TYPE="migrate_original_apm"
    echo -e "${BLUE}Installation type:${NC} Migrate original APM to Beads-APM"
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
    "upgrade_v0_1_0")
        echo -e "${BLUE}Upgrading from v0.1.0 to v0.2.0...${NC}"
        echo ""

        # Remove old v0.1.0 files
        remove_v0_1_0

        # Install v0.2.0 from dev/
        echo ""
        echo -e "${BLUE}Installing v0.2.0...${NC}"
        install_apm_guides
        install_claude_commands

        # Update CLAUDE.md if needed
        if ! grep -q "## APM Integration" "$TARGET_DIR/CLAUDE.md" 2>/dev/null; then
            if $HAS_CLAUDE_MD; then
                append_to_claude_md
            else
                install_claude_md
            fi
        fi

        echo ""
        echo -e "${GREEN}Upgrade complete!${NC}"
        echo -e "${BLUE}Upgraded from v0.1.0 to v0.2.0${NC}"
        ;;

    "new")
        echo -e "${BLUE}Setting up new project...${NC}"
        echo ""

        # Initialize git if not present
        if ! $HAS_GIT; then
            echo -e "${YELLOW}Initializing git repository...${NC}"
            cd "$TARGET_DIR"
            git init -b main
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

    "migrate_original_apm")
        echo -e "${BLUE}Migrating original APM to Beads-APM...${NC}"
        echo ""

        # Backup and remove original APM guides
        backup_and_remove ".apm" "apm.guides"

        # Backup and remove original APM command files
        # Original APM uses 8 command files (apm-1 through apm-8) which conflict with Beads-APM.
        echo -e "${YELLOW}Backing up and removing original APM command files...${NC}"
        original_commands=(
            "apm-1-initiate-setup.md"
            "apm-2-initiate-manager.md"
            "apm-3-initiate-implementation.md"
            "apm-4-initiate-adhoc.md"
            "apm-5-handover-manager.md"
            "apm-6-handover-implementation.md"
            "apm-7-delegate-research.md"
            "apm-8-delegate-debug.md"
        )

        for cmd_file in "${original_commands[@]}"; do
            backup_and_remove ".claude/commands/${cmd_file}" "claude.commands"
        done

        # Install Beads if not present
        if ! $HAS_BEADS; then
            install_beads
        fi

        # Install Beads-APM guides and commands
        install_apm_guides
        install_claude_commands

        # Update CLAUDE.md
        if $HAS_CLAUDE_MD; then
            append_to_claude_md
        else
            install_claude_md
        fi

        echo ""
        echo -e "${GREEN}Migration complete!${NC}"
        echo ""
        echo -e "${YELLOW}Important notes:${NC}"
        echo -e "  • Original APM backed up to: .backup/{timestamp}/apm.guides/"
        echo -e "  • Original APM commands backed up to: .backup/{timestamp}/claude.commands/"
        echo -e "  • Original APM used markdown files for state management"
        echo -e "  • Beads-APM uses 'bd' commands instead"
        echo ""
        echo -e "${YELLOW}If you have existing tasks in markdown files:${NC}"
        echo -e "  1. Find backups: ls -la .backup/"
        echo -e "  2. Create issues in Beads: bd create --title=\"Task name\" --type=task"
        echo -e "  3. Add dependencies: bd dep add <consumer> <producer>"
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
                git init -b main
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

# ============================================================================
# Post-Installation Health Check
# ============================================================================

echo ""
echo -e "${BLUE}Running health check...${NC}"
echo ""

cd "$TARGET_DIR"
if command -v bd &> /dev/null; then
    # Capture bd doctor output and exit code
    DOCTOR_OUTPUT=$(bd doctor 2>&1) || true
    DOCTOR_EXIT=$?

    echo "$DOCTOR_OUTPUT"
    echo ""

    # Check if there are issues (bd doctor returns non-zero or output contains warnings/errors)
    if [ $DOCTOR_EXIT -ne 0 ] || echo "$DOCTOR_OUTPUT" | grep -qiE "(error|warning|issue|missing|not found|failed)"; then
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}Some issues were detected. You can fix them by running:${NC}"
        echo -e "  ${GREEN}bd doctor --fix${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    else
        echo -e "${GREEN}✓ All health checks passed${NC}"
    fi
else
    echo -e "${YELLOW}Warning: bd command not found. Please ensure @beads/bd is installed.${NC}"
fi

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
