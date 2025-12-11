# Beads + APM Integration Kit

Integrates [Beads](https://github.com/steveyegge/beads) issue tracking with [APM](https://github.com/sdi2200262/agentic-project-management) (Agentic Project Management) for Claude Code.

## Why

APM provides methodology for breaking down projects and coordinating AI agents. This integration replaces its markdown-based state management with Beads:

| Before | After |
|--------|-------|
| MD files drift from reality | Beads is source of truth |
| Copy-paste task handoff | Task tool spawns agents |
| Manual handover docs | Agents query Beads |
| No queryable state | `bd ready`, `bd blocked` |

## Installation

### Quick Install (Recommended)

```bash
# Install in current directory
curl -fsSL https://raw.githubusercontent.com/emulatalk1/beads-apm-integration/main/install.sh | bash

# Install in specific directory
curl -fsSL https://raw.githubusercontent.com/emulatalk1/beads-apm-integration/main/install.sh | bash -s /path/to/project
```

The installer automatically detects your setup and handles:
- **New projects** - Initializes git, Beads, and all APM files
- **Existing projects** - Adds only what's missing
- **Existing APM projects** - Migrates to Beads, upgrades guides (see Migration below)
- **Existing Beads projects** - Adds APM methodology

### Migration from Original APM

When migrating from original APM, the installer:
- Backs up your `.apm/` directory to `.backup/YYYYMMDDHHMMSS/.apm/`
- Backs up original APM command files to `.backup/YYYYMMDDHHMMSS/.claude/commands/`
- Removes the 8 original APM commands (`apm-1` through `apm-8`) after backup
- Installs new Beads-APM commands (`apm-setup` and `apm-start`)

Your original files are preserved in the unified `.backup/YYYYMMDDHHMMSS/` directory if you need to reference them.

### Manual Install

1. Initialize Beads: `npx beads-cli init`
2. Copy `.apm/` directory to your project
3. Copy `.claude/commands/` to your project
4. Copy or merge `CLAUDE.md`

## Prerequisites

- Claude Code CLI
- Node.js (for Beads CLI)

## Usage

### New Project Setup

```
/apm-setup
```

Runs Context Synthesis and Project Breakdown, creating Beads issues.

### Resume Work

```
/apm-start
```

Queries Beads for state and available work.

### Manual Commands

```bash
bd stats                    # Project overview
bd ready                    # Available work
bd update <id> --status=in_progress
bd comments add <id> "note"
bd close <id>
```

## Contents

```
.apm/guides/
  Context_Synthesis_Guide.md      # Gather requirements
  Project_Breakdown_Guide.md      # Decompose into Beads issues
  Project_Breakdown_Review_Guide.md
  Task_Assignment_Guide.md        # Task spec format
  Agent_Workflow_Guide.md         # How agents use Beads

.claude/commands/
  apm-setup.md                    # /apm-setup command
  apm-start.md                    # /apm-start command

install.sh                        # Installation script
```

## Documentation

See [BEADS_APM_INTEGRATION.md](./BEADS_APM_INTEGRATION.md) for full design details.
