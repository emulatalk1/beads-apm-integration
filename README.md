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

## Prerequisites

- Claude Code CLI
- Beads CLI (`bd`)

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
```

## Documentation

See [BEADS_APM_INTEGRATION.md](./BEADS_APM_INTEGRATION.md) for full design details.
