# Agent Workflow Guide

This guide defines how Manager and Implementation Agents work using Beads for state and Task tool for spawning.

## Core Principles

1. **Beads is the source of truth** - All task state lives in Beads, not in memory or files
2. **Save as you work** - Log progress continuously with `bd comments add`, not at handover
3. **Task tool for spawning** - No copy-paste prompts; spawn agents directly
4. **No handover documents** - New sessions query Beads for state

## Manager Agent Workflow

### Starting a Session

```bash
# Get project overview
bd stats

# Discover available agents (see Agent_Discovery_Guide.md)
find .claude/agents -name "*.md" -type f

# See what's active
bd list --status=in_progress

# See what's ready to work
bd ready

# See what's blocked
bd blocked
```

### Assigning Work

When a task is ready:

```bash
# Get task details (includes labels)
bd show <issue-id>
```

Check for `agent:*` label in the output. If present, use that agent type. Otherwise, apply the decision framework from Agent_Discovery_Guide.md to select an appropriate agent.

Spawn an Implementation Agent via Task tool:

```
Task(
  subagent_type="<agent-from-label>",  # e.g., "general-purpose", "explore", "plan", or custom agent name
  prompt="""
  You are an Implementation Agent. Complete this task:

  Task ID: <issue-id>
  Title: <from bd show>
  Description: <from bd show>

  Workflow:
  1. Run: bd update <issue-id> --status=in_progress
  2. Do the work
  3. Log progress: bd comments add <issue-id> "what you did"
  4. When done: bd close <issue-id> --reason="summary"

  Return a summary of what was accomplished.
  """
)
```

Results return directly - no copy-paste needed.

### Reviewing Completed Work

```bash
# Check task status
bd show <issue-id>

# View work history
bd comments <issue-id>

# See what's now ready (dependencies unblocked)
bd ready
```

### Logging Decisions

Use a coordination notes issue for high-level decisions:

```bash
bd comments add <coordination-notes-id> "Prioritizing auth over UI because..."
```

### Continuing in New Session

No handover needed. Just query Beads:

```bash
bd stats                      # Overview
bd list --status=in_progress  # What's active
bd ready                      # What's next
bd comments <issue-id>        # History on specific tasks
```

## Implementation Agent Workflow

### Receiving Assignment

When spawned by Manager, you receive task details in the prompt.

### Starting Work

```bash
bd update <issue-id> --status=in_progress
```

### Logging Progress

Log as you work, not at the end:

```bash
bd comments add <issue-id> "Added JWT middleware to auth routes"
bd comments add <issue-id> "Found existing validation to reuse"
bd comments add <issue-id> "Tests passing"
```

### Delegating Sub-tasks

If you need research or debugging help, select an appropriate agent type (see Agent_Discovery_Guide.md for complete decision framework).

**Check available agents if needed:**
```bash
find .claude/agents -name "*.md" -type f  # Discover custom agents
```

**Research/Exploration:**
```
Task(
  subagent_type="explore",  # Fast read-only analysis
  prompt="Research: [topic]. Search codebase for patterns and examples. Return findings in markdown."
)
```

**Planning/Strategic Analysis:**
```
Task(
  subagent_type="plan",  # Read-only with web search capability
  prompt="Research: [topic]. Analyze approach options and recommend best practices. Return findings in markdown."
)
```

**Debug/Implementation:**
```
Task(
  subagent_type="general-purpose",  # Full tool access for modifications
  prompt="Debug: [error]. Reproduce: [steps]. Find root cause and fix."
)
```

Results return directly. Log the outcome:
```bash
bd comments add <issue-id> "Research complete: using approach X"
```

### Completing Work

```bash
bd close <issue-id> --reason="Implemented with tests passing"
```

### Continuing in New Session

No handover needed. Query Beads:

```bash
bd list --status=in_progress  # Find active task
bd show <issue-id>            # Get details
bd comments <issue-id>        # See work history
```

Continue where the previous agent left off.

## State Queries Reference

| Need | Command |
|------|---------|
| Project overview | `bd stats` |
| All open issues | `bd list --status=open` |
| Active work | `bd list --status=in_progress` |
| Ready to start | `bd ready` |
| Blocked issues | `bd blocked` |
| Task details | `bd show <id>` |
| Task history | `bd comments <id>` |

## State Updates Reference

| Action | Command |
|--------|---------|
| Start task | `bd update <id> --status=in_progress` |
| Log progress | `bd comments add <id> "message"` |
| Complete task | `bd close <id> --reason="summary"` |
| Add dependency | `bd dep add <blocked> <blocker>` |

## Why This Works

| Before (APM) | After (Beads + Task) |
|--------------|----------------------|
| State in markdown files | State in Beads (queryable) |
| Manual handover documents | Query current state |
| Copy-paste prompts | Task tool returns directly |
| "What's blocked?" = read files | `bd blocked` |
| "What's next?" = parse markdown | `bd ready` |

**End of Guide**
