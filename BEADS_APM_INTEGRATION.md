# Beads + APM Integration Design Document

## Overview

This document defines how to integrate **Beads** (issue tracking) with **APM** (Agentic Project Management) to solve key workflow problems.

---

## Problem Statement

### Current APM Pain Points

| Problem | Description |
|---------|-------------|
| **MD file sync** | Implementation_Plan.md, Memory Logs, and actual state can drift apart |
| **Copy-paste friction** | Task assignments, handovers, and delegations require manual copy-paste between sessions |
| **Manual state synthesis** | Agents must manually write long handover documents from memory |
| **No queryable state** | Cannot easily ask "what's blocked?" or "what's ready?" |

---

## Solution Architecture

### Separation of Concerns

```
┌─────────────────────────────────────────────────────────────┐
│                   BEADS (Data Layer)                        │
│                                                             │
│  • Single source of truth for tasks                         │
│  • Status, dependencies, comments                           │
│  • Persistent across sessions (git-tracked)                 │
│  • Queryable (bd ready, bd blocked, bd list)                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              TASK TOOL (Execution Layer)                    │
│                                                             │
│  • Spawn agents directly (no copy-paste)                    │
│  • Manager spawns Implementation Agents                     │
│  • Implementation spawns Ad-Hoc Agents                      │
│  • Results return directly to caller                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│               APM GUIDES (Methodology Layer)                │
│                                                             │
│  • Context Synthesis process                                │
│  • Task breakdown methodology                               │
│  • Agent role definitions                                   │
│  • Quality standards                                        │
└─────────────────────────────────────────────────────────────┘
```

### Core Principle

- **Beads** = Where data lives (tasks, status, history)
- **Task Tool** = How agents spawn other agents
- **APM Guides** = How to think about work (methodology only)

---

## Component Mapping

### What Replaces What

| APM Component | Beads Replacement | Notes |
|---------------|-------------------|-------|
| Implementation_Plan.md (task store) | Beads issues + epics + dependencies | Plan becomes queryable |
| Memory Logs | `bd comments` on tasks | Saved during work, not after |
| Task status tracking | `bd update --status=` | open, in_progress, blocked, closed |
| Handover documents | `bd` queries | No manual synthesis needed |
| Cross-agent dependencies | `bd dep add` | Automatic blocking detection |
| Phase tracking | Beads epics | `bd epic status` for progress |
| Manager coordination notes | Meta-issue with comments | `manager-notes` issue |

### What APM Keeps

| APM Component | Purpose | Status |
|---------------|---------|--------|
| Context_Synthesis_Guide | How to gather requirements | Keep |
| Project_Breakdown_Guide | How to decompose work | Keep |
| Task_Assignment_Guide | What makes good task specs | Keep (modify for Beads) |
| Memory_Log_Guide | How to document work | Replace with Beads conventions |
| Memory_System_Guide | How memory is organized | Replace with Beads conventions |
| Agent role definitions | Who does what | Keep |

---

## Beads Issue Structure

### Issue Types

| Type | APM Equivalent | Usage |
|------|----------------|-------|
| `epic` | Phase | Group of related tasks |
| `task` | Task | Single unit of work |
| `feature` | Feature task | New functionality |
| `bug` | Bug fix task | Defect repair |
| `chore` | Meta/admin | Coordination notes, cleanup |

### Labels for Agent Assignment

```bash
# Agent domain labels
Agent_Frontend
Agent_Backend
Agent_API
Agent_Testing
Agent_Dependencies

# Meta labels
manager-meta      # Manager coordination notes
ad-hoc-research   # Research delegation
ad-hoc-debug      # Debug delegation
has-findings      # Task has important discoveries
blocked-external  # Blocked by external factor
```

### Issue Description Format

For tasks that need detailed specs (like APM Task Assignment):

```markdown
## Objective
[One sentence goal]

## Requirements
- [Requirement 1]
- [Requirement 2]

## Acceptance Criteria
- [Criterion 1]
- [Criterion 2]

## Guidance
[Technical notes, constraints, approach suggestions]
```

### Dependencies

```bash
# Task B depends on Task A (A blocks B)
bd dep add <task-B> <task-A>

# View what blocks a task
bd show <task-id>

# View all blocked tasks
bd blocked
```

---

## Workflow: Setup Phase

### Current APM Setup
1. Context Synthesis (Q&A)
2. Project Breakdown (create Implementation_Plan.md)
3. Optional Review
4. Enhancement
5. Manager Bootstrap prompt

### New Setup with Beads

```
1. Context Synthesis (unchanged - Q&A)
        │
        ▼
2. Project Breakdown → Create Beads Structure
        │
        ├─ Create phase epics
        │    bd create --title="Phase 1: Setup" --type=epic
        │
        ├─ Create task issues
        │    bd create --title="Task 1.1 - Add BOM" --type=task \
        │      -l Agent_Dependencies \
        │      --description="[detailed spec]"
        │
        ├─ Add dependencies
        │    bd dep add task-1-2 task-1-1
        │
        └─ Create manager-notes issue
             bd create --title="Manager Coordination Notes" \
               --type=chore -l manager-meta
        │
        ▼
3. Validation
        │
        ├─ bd dep cycles     (check for circular deps)
        ├─ bd ready          (verify starting tasks exist)
        └─ bd stats          (review structure)
        │
        ▼
4. Manager Bootstrap (simplified)
        │
        └─ Short prompt: "Query Beads for state, use Task tool to assign"
```

---

## Workflow: Manager Agent

### Responsibilities

| Responsibility | How (with Beads) |
|----------------|------------------|
| Track project state | `bd stats`, `bd epic status` |
| See what's active | `bd list --status=in_progress` |
| See what's blocked | `bd blocked` |
| Find next task | `bd ready` |
| Assign task | Task tool (spawn Implementation Agent) |
| Log decisions | `bd comments add manager-notes "..."` |
| Handover | New manager queries Beads |

### Task Assignment Flow

```
1. Manager identifies next task
   $ bd ready

2. Manager gets task details
   $ bd show <task-id>

3. Manager spawns Implementation Agent
   Task(
     subagent_type="general-purpose",
     prompt="""
     You are Implementation Agent for [domain].

     Task: [from bd show]

     When working:
     - bd update <id> --status=in_progress
     - bd comments add <id> "progress notes"

     When done:
     - bd close <id> --reason="completion summary"
     """
   )

4. Agent completes, Manager reviews
   $ bd show <task-id>
   $ bd comments <task-id>
```

### Manager Handover

**Old agent (before context fills):**
- State already saved via `bd comments add manager-notes`

**New agent (fresh session):**
```bash
# Get project state
bd stats
bd list --status=in_progress
bd blocked
bd ready

# Get coordination context
bd show manager-notes
bd comments manager-notes
```

**Handover prompt (minimal):**
```markdown
# Manager Agent Handover

## Get State
Run: bd stats, bd list --status=in_progress, bd blocked, bd ready

## Get Context
Run: bd show manager-notes, bd comments manager-notes

## Your Role
Coordinate agents, assign tasks via Task tool, log decisions to manager-notes.
```

---

## Workflow: Implementation Agent

### Responsibilities

| Responsibility | How (with Beads) |
|----------------|------------------|
| Start task | `bd update <id> --status=in_progress` |
| Log progress | `bd comments add <id> "..."` |
| Complete task | `bd close <id> --reason="..."` |
| Delegate research | Task tool (spawn Ad-Hoc) |
| Delegate debug | Task tool (spawn Ad-Hoc) |
| Handover | New agent queries Beads |

### Work Flow

```
1. Receive assignment (from Manager via Task tool)

2. Start work
   $ bd update task-xxx --status=in_progress

3. Log progress (as you work)
   $ bd comments add task-xxx "Added dependency to pom.xml"
   $ bd comments add task-xxx "Found existing auth middleware to reuse"

4. If stuck - need research
   Task(
     subagent_type="general-purpose",
     prompt="Research: [topic]. Return findings in markdown."
   )
   # Results return directly

5. If stuck - need debug (after 2 attempts)
   Task(
     subagent_type="general-purpose",
     prompt="Debug: [error]. Reproduce: [steps]. Fix it."
   )
   # Solution returns directly

6. Complete
   $ bd close task-xxx --reason="Implemented with tests passing"
```

### Implementation Agent Handover

**Old agent (before context fills):**
- State already saved via `bd update` and `bd comments`

**New agent (fresh session):**
```bash
# Get active task
bd list --status=in_progress

# Get task details and history
bd show <task-id>
bd comments <task-id>
```

**Handover prompt (minimal):**
```markdown
# Implementation Agent Handover

## Get Active Work
Run: bd list --status=in_progress
Run: bd show <task-id>
Run: bd comments <task-id>

## Your Role
Continue the in-progress task. Log progress with bd comments. Close with bd close when done.
```

---

## Workflow: Ad-Hoc Agent

### Characteristics

- **Temporary**: Spawned for specific task, ends when done
- **No Beads needed**: Results return directly to caller
- **Types**: Research or Debug

### Research Delegation

```python
# Implementation Agent spawns research agent
Task(
    subagent_type="general-purpose",
    prompt="""
    Research: Spring Security OAuth2 setup

    Questions:
    1. Latest setup procedure for Spring Security 6.x?
    2. Token storage best practices?

    Sources to check:
    - spring.io/projects/spring-security
    - Spring Security GitHub

    Return findings in markdown format.
    """
)
# Results return directly to Implementation Agent
```

### Debug Delegation

```python
# Implementation Agent spawns debug agent (after 2 failed attempts)
Task(
    subagent_type="general-purpose",
    prompt="""
    Debug this failure:

    File: UserService.java:45
    Error: NullPointerException
    Reproduce: mvn test -Dtest=UserServiceTest

    Already tried:
    1. Added null check - didn't help
    2. Checked injection - looks correct

    Find root cause and fix it.
    """
)
# Solution returns directly to Implementation Agent
```

### Optional: Log Delegation in Parent Task

```bash
# Before delegation
bd comments add task-xxx "Delegating research: Spring OAuth2 docs"

# After delegation returns
bd comments add task-xxx "Research complete: Using SecurityFilterChain approach"
```

---

## Handover Comparison

### APM (Before)

```
┌─────────────────────────────────────────┐
│ Agent works                             │
│ (state in context memory)               │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│ Context fills up                        │
│                                         │
│ Agent WRITES handover document:         │
│ - Manually synthesize state             │
│ - 100+ lines                            │
│ - Can be wrong/incomplete               │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│ New agent READS handover document       │
│ (may not match reality)                 │
└─────────────────────────────────────────┘
```

### Beads (After)

```
┌─────────────────────────────────────────┐
│ Agent works                             │
│                                         │
│ SAVES state continuously:               │
│ - bd update (status)                    │
│ - bd comments (progress)                │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│ Context fills up                        │
│                                         │
│ Nothing to write                        │
│ (state already in Beads)                │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│ New agent QUERIES Beads:                │
│ - bd list (what's active)              │
│ - bd show (task details)                │
│ - bd comments (work history)            │
│ (always accurate)                       │
└─────────────────────────────────────────┘
```

### Key Difference

| Aspect | APM | Beads |
|--------|-----|-------|
| When state is saved | At handover (manual) | During work (continuous) |
| Handover document | 100+ lines, manual | ~10 lines + queries |
| Risk of drift | High | None |
| State accuracy | Depends on memory | Always current |

---

## Commands Reference

### Project Setup

```bash
# Create phase epic
bd create --title="Phase 1: Name" --type=epic

# Create task with details
bd create --title="Task 1.1 - Name" --type=task \
  -l Agent_Domain \
  --description="Objective and requirements"

# Add dependency (task-B depends on task-A)
bd dep add <task-B> <task-A>

# Create manager notes issue
bd create --title="Manager Coordination Notes" --type=chore -l manager-meta
```

### During Work

```bash
# Start task
bd update <id> --status=in_progress

# Log progress
bd comments add <id> "Progress note..."

# Complete task
bd close <id> --reason="Completion summary"

# Mark blocked
bd update <id> --status=blocked
bd comments add <id> "Blocked by: reason"
```

### Query State

```bash
# Project overview
bd stats

# Active work
bd list --status=in_progress

# Available tasks (no blockers)
bd ready

# Blocked tasks
bd blocked

# Task details
bd show <id>

# Task history
bd comments <id>

# Phase progress
bd epic status <epic-id>
```

### Manager-Specific

```bash
# Log coordination decision
bd comments add manager-notes "Decision: prioritize X over Y because..."

# View coordination history
bd comments manager-notes
```

---

## Implementation Plan

### Phase 1: Foundation

1. **Define Beads conventions**
   - Issue description format for tasks
   - Label scheme for agent assignments
   - Manager-notes issue convention

2. **Create helper commands** (optional)
   - `/assign-task <id>` - Spawn agent for task
   - `/project-status` - Summary view

### Phase 2: Modified APM Guides

3. **Update Setup flow**
   - Create Beads issues instead of Implementation_Plan.md
   - Validation via `bd dep cycles`, `bd ready`

4. **Update Manager workflow**
   - Query Beads for state
   - Use Task tool for assignments
   - Simplified handover prompt

5. **Update Implementation workflow**
   - Save progress via `bd comments`
   - Use Task tool for delegation
   - Simplified handover prompt

### Phase 3: Testing

6. **Test on small project**
   - Run through full workflow
   - Identify gaps

7. **Iterate and refine**
   - Adjust conventions
   - Update documentation

---

## Open Questions

1. **Implementation_Plan.md** - Keep as read-only reference, or eliminate entirely?

2. **Rich task specs** - Is Beads description field sufficient, or need structured format?

3. **Epic hierarchy** - Use Beads parent-child, or just dependencies?

4. **Agent labels** - Single label per task, or multiple allowed?

5. **History retention** - How much detail in comments? Guidelines needed?

---

## Appendix: Example Project Setup

```bash
# Create phase epics
bd create --title="Phase 1: Spring AI Setup" --type=epic
bd create --title="Phase 2: Provider Refactoring" --type=epic
bd dep add phase-2 phase-1

# Create tasks for Phase 1
bd create --title="Task 1.1 - Add Spring AI BOM" --type=task \
  -l Agent_Dependencies \
  --description="Add Spring AI BOM to pom.xml. Configure version properties."

bd create --title="Task 1.2 - Configure providers" --type=task \
  -l Agent_Dependencies \
  --description="Configure OpenAI and Anthropic in application.yml"

bd create --title="Task 1.3 - Integration tests" --type=task \
  -l Agent_Testing \
  --description="Create integration tests for LLM providers"

# Add dependencies
bd dep add task-1-2 task-1-1
bd dep add task-1-3 task-1-2

# Create manager notes
bd create --title="Manager Coordination Notes" --type=chore -l manager-meta

# Verify setup
bd stats
bd ready
bd dep cycles
```

---

## Document History

| Date | Author | Changes |
|------|--------|---------|
| 2025-12-11 | Claude + User | Initial draft from discussion |
