# Beads + APM Integration Project

This project develops standalone tooling to integrate Beads issue tracking with APM (Agentic Project Management) framework.

## Goal

Replace APM's markdown-based state management with Beads, and use Claude Code's Task tool for agent spawning instead of copy-paste.

## Key Components to Build

1. **Beads conventions** - Issue structure, labels, description format for APM-style tasks
2. **Slash commands** - `/assign-task`, `/project-status` for streamlined workflow
3. **Modified APM guides** - Updated for Beads integration
4. **Example workflows** - Demonstrate the full lifecycle

## Reference

See `BEADS_APM_INTEGRATION.md` for the complete design document.

## Beads Workflow

- Track ALL work in beads (no TodoWrite, no markdown TODOs)
- Use `bd create` to create issues
- Use `bd update --status=in_progress` when starting work
- Use `bd comments add` to log progress
- Use `bd close` when done
