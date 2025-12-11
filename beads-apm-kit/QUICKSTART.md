# Quickstart: Beads for Agentic Workflows

Use Beads to track work in multi-agent projects. No markdown files to sync, no manual handovers.

## Setup

1. **Install Beads** (if not already)
   ```bash
   # See beads installation docs
   ```

2. **Initialize in your project**
   ```bash
   cd your-project
   bd init
   ```

3. **Copy the guides** (optional)
   ```bash
   cp BEADS_CONVENTIONS.md your-project/
   cp AGENT_GUIDE.md your-project/
   ```

## Basic Workflow

**Create work:**
```bash
bd create --title="Implement feature X" --type=feature
bd create --title="Add tests for X" --type=task
bd dep add <tests-id> <feature-id>
```

**Find work:**
```bash
bd ready   # What's available
bd stats   # Overview
```

**Do work:**
```bash
bd update <id> --status=in_progress
bd comments add <id> "progress note"
bd close <id> --reason="done"
```

**Query state:**
```bash
bd list --status=in_progress
bd blocked
bd show <id>
```

## Why This Works

| Before (markdown) | After (Beads) |
|-------------------|---------------|
| State in files that drift | Single source of truth |
| Manual handover docs | Query current state |
| "What's blocked?" = read files | `bd blocked` |
| "What's next?" = parse markdown | `bd ready` |

## Adding to CLAUDE.md

Add to your project's CLAUDE.md:

```markdown
## Workflow

- Track work in Beads (not markdown TODOs)
- Use `bd create` to create tasks
- Use `bd update --status=in_progress` when starting
- Use `bd comments add` to log progress
- Use `bd close` when done
```

That's it. Start working.
