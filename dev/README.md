# Beads + APM Integration

Integrates [Beads](https://github.com/steveyegge/beads) issue tracking with [APM](https://github.com/sdi2200262/agentic-project-management) (Agentic Project Management) methodology for Claude Code.

## What This Is

A ready-to-use kit that replaces APM's markdown-based state management with Beads issue tracking, and uses Claude Code's Task tool for agent spawning.

## Installation

### Quick Install

```bash
# Install in current directory
curl -fsSL https://raw.githubusercontent.com/emulatalk1/beads-apm-integration/main/install.sh | bash

# Install in specific directory
curl -fsSL https://raw.githubusercontent.com/emulatalk1/beads-apm-integration/main/install.sh | bash -s /path/to/project
```

The installer handles:
- New projects - Initializes git, Beads, and APM files
- Existing projects - Adds only what's missing
- Existing APM projects - Migrates to Beads, backs up original files
- Existing Beads projects - Adds APM methodology

### Prerequisites

- Claude Code CLI
- Node.js (for Beads CLI)

## Quick Start

1. **Setup a new project**:
   ```
   /apm-setup
   ```
   Runs Context Synthesis and Project Breakdown, creating Beads issues.

2. **Start work**:
   ```
   /apm-start
   ```
   Queries Beads for available work and spawns agents.

## Learn More

- **APM Methodology**: See the [original APM repository](https://github.com/sdi2200262/agentic-project-management) for detailed methodology documentation
- **Beads**: Learn more at [Beads repository](https://github.com/steveyegge/beads)
- **Project Files**: APM guides are in `.apm/guides/`, commands are in `.claude/commands/`
