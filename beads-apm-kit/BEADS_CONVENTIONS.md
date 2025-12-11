# Beads Conventions for Agentic Workflows

Lightweight conventions for using Beads in multi-agent projects.

## Issue Types

| Type | Use For |
|------|---------|
| `task` | Single unit of work |
| `feature` | New functionality |
| `bug` | Defect repair |
| `epic` | Group of related tasks |
| `chore` | Admin work |

## Labels

Use labels to group and filter tasks. Define labels that fit your project.

Examples:
- By domain: `auth`, `api`, `ui`, `database`
- By component: `payments`, `notifications`, `users`
- By skill: `research`, `testing`, `devops`

No predefined labels required.

## Descriptions

Simple tasks: one-liner is fine.

Complex tasks: include what's needed to start work.

```markdown
## Objective
[What needs to be done]

## Context
[Why, constraints, relevant info]

## Done When
[How to know it's complete]
```

## Dependencies

```bash
# B depends on A
bd dep add <B> <A>

# What's blocked?
bd blocked

# What's ready to work?
bd ready
```

## Status

```
open → in_progress → closed
```

- `open` - Not started
- `in_progress` - Being worked on
- `closed` - Done

## Coordination Notes (optional)

For multi-agent projects, a single issue for high-level decisions:

```bash
bd create --title="Coordination Notes" --type=chore
bd comments add <id> "Decision: prioritize X because..."
```
