# Beads + APM Integration

Integration of Beads issue tracking with APM (Agentic Project Management) methodology.

## What This Is

A ready-to-use kit that replaces APM's markdown-based state management with Beads, and uses Claude Code's Task tool for agent spawning.

## Quick Start

1. **Setup a new project**: Run `/apm-setup`
2. **Start work**: Run `/apm-start`

## Project Structure

```
.apm/guides/           # APM methodology guides (adjusted for Beads)
  Context_Synthesis_Guide.md
  Project_Breakdown_Guide.md
  Project_Breakdown_Review_Guide.md
  Task_Assignment_Guide.md
  Agent_Workflow_Guide.md

.claude/commands/      # Slash commands
  apm-setup.md         # Initialize project with Beads
  apm-start.md         # Resume or start work
```

## Beads Workflow

- Track ALL work in beads (no TodoWrite, no markdown TODOs)
- `bd create` - Create issues
- `bd update --status=in_progress` - Start work
- `bd comments add` - Log progress
- `bd close` - Complete work
- `bd ready` - Find available work

## How It Works

APM guides in `.apm/guides/` provide detailed methodology for each phase.
