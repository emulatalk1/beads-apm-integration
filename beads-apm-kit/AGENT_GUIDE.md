# Agent Guide for Beads Workflows

How agents should use Beads while working.

## Core Principle

**Save state as you work, not at the end.**

Beads is your persistent memory. A new session can pick up where you left off by querying Beads.

## Starting a Session

```bash
bd stats                      # Overview
bd list --status=in_progress  # Active work
bd ready                      # Available work
```

## Working on a Task

**Start:**
```bash
bd update <id> --status=in_progress
```

**Log progress** (as you go, not at end):
```bash
bd comments add <id> "Added auth middleware"
bd comments add <id> "Found existing validation to reuse"
```

**Finish:**
```bash
bd close <id> --reason="Implemented with tests passing"
```

## Spawning Sub-Agents

Use the Task tool for delegation. Sub-agents are temporary - their results return directly to you.

**Research:**
```
Task(
  subagent_type="general-purpose",
  prompt="Research: [topic]. Return findings."
)
```

**Debug:**
```
Task(
  subagent_type="general-purpose",
  prompt="Debug: [error]. Reproduce: [steps]. Find root cause."
)
```

Log delegations in parent task if useful:
```bash
bd comments add <id> "Delegated OAuth research, using approach X"
```

## Breaking Down Work

When given requirements, create Beads issues:

```bash
bd create --title="Implement auth" --type=feature
bd create --title="Add tests for auth" --type=task
bd dep add <tests-id> <auth-id>  # tests depend on auth
```

## Querying State

| Need | Command |
|------|---------|
| What's ready? | `bd ready` |
| What's blocked? | `bd blocked` |
| What's active? | `bd list --status=in_progress` |
| Task details | `bd show <id>` |
| Task history | `bd comments <id>` |
| Project overview | `bd stats` |

## Handover

No manual handover needed. State is already in Beads.

New session just queries:
```bash
bd list --status=in_progress  # Continue this
bd comments <id>              # See history
```
