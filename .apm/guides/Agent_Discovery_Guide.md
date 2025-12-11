# Agent Discovery Guide

This guide defines how to discover and select appropriate Claude Code agents for task execution. Both Setup Agent (during project breakdown) and Manager Agent (during task assignment) reference this guide.

## Discovery Mechanism

### Built-in Agents

Claude Code provides three built-in agents that are always available:

**Discover using:** These agents are available by default in all Claude Code installations.

| Agent | Label | Model | Capabilities | Best For |
|-------|-------|-------|--------------|----------|
| **general-purpose** | `agent:general-purpose` | Sonnet 4.5 | Full tool access: read, write, edit, bash, search, debugging | Complex multi-step tasks, implementation work, debugging, system integration |
| **explore** | `agent:explore` | Haiku 4.0 | Read-only: read, glob, grep (no write/edit/bash) | Fast codebase exploration, pattern discovery, documentation search, read-only analysis |
| **plan** | `agent:plan` | Sonnet 4.5 | Read-only: read, glob, grep, web search (no write/edit/bash) | Strategic planning, research synthesis, architecture review, requirements analysis |

### Custom Agents

Projects may define custom specialized agents for domain-specific work.

**Discover using:**
```bash
find .claude/agents -name "*.md" -type f
```

**Parse agent definitions:**
Each custom agent file (`.claude/agents/<name>.md`) contains YAML frontmatter with:

```yaml
---
name: <agent-name>
description: <brief description of agent purpose>
tools: [list, of, allowed, tools]
model: <claude-model-id>
---
```

**Example custom agent structure:**
```yaml
---
name: database-specialist
description: Database schema design and SQL optimization
tools: [read, write, edit, bash, grep, glob]
model: claude-sonnet-4-5-20250929
---
```

**Label convention for custom agents:** `agent:<name>` (e.g., `agent:database-specialist`)

## Agent Selection Guidance

### Task Characteristics → Agent Matching

Use this framework to match task requirements with appropriate agent capabilities:

#### Implementation Tasks
**Characteristics:** Writing code, creating files, running tests, making system changes
**Agent:** `agent:general-purpose`
**Rationale:** Requires full tool access for read/write/execute operations

#### Research & Planning Tasks
**Characteristics:** Analyzing architecture, reviewing documentation, strategic planning, requirements synthesis
**Agent:** `agent:plan`
**Rationale:** Read-only access with web search for comprehensive research without accidental modifications

#### Quick Codebase Exploration
**Characteristics:** Finding patterns, locating files, checking conventions, reading documentation
**Agent:** `agent:explore`
**Rationale:** Fast Haiku model optimized for read-only analysis with rapid turnaround

#### Domain-Specific Tasks
**Characteristics:** Specialized work requiring specific tool sets or expertise
**Agent:** Custom agent (if available)
**Rationale:** Pre-configured with appropriate tools and model for domain requirements

### Decision Framework

When selecting an agent, ask:

1. **Does this task modify the system?**
   - Yes → `agent:general-purpose` or custom implementation agent
   - No → Continue to next question

2. **Does this task require planning or external research?**
   - Yes → `agent:plan`
   - No → Continue to next question

3. **Is this a quick read-only exploration?**
   - Yes → `agent:explore`
   - No → Check for custom agents

4. **Is there a custom agent matching this domain?**
   - Yes → Use custom agent (check via `find .claude/agents`)
   - No → Default to `agent:general-purpose`

### Common Patterns

| Task Type | Recommended Agent | Why |
|-----------|------------------|-----|
| Implement feature | `agent:general-purpose` | Needs write/edit/bash access |
| Debug error | `agent:general-purpose` | Needs full diagnostic and modification tools |
| Research API approach | `agent:plan` | Benefits from web search, no modifications needed |
| Find usage patterns | `agent:explore` | Fast read-only grep/glob operations |
| Review architecture | `agent:plan` | Strategic analysis without accidental changes |
| Quick file location | `agent:explore` | Speed matters, read-only sufficient |
| Database migration | Custom DB agent (if exists) or `agent:general-purpose` | Specialized work or full tool access |
| Run tests | `agent:general-purpose` | Requires bash execution |

## Label Convention

All agent assignments use the `agent:<name>` label prefix:

- Built-in agents: `agent:general-purpose`, `agent:explore`, `agent:plan`
- Custom agents: `agent:<custom-name>` (from YAML `name` field)

**Usage in Beads:**
```bash
# Label task for specific agent
bd create --title="Implement auth" -l agent:general-purpose

# Update agent assignment
bd update <issue-id> -l agent:explore

# Query tasks by agent
bd list -l agent:general-purpose
```

## Dual-Use Reference

This guide serves two distinct workflow phases:

### Setup Agent Use (Project Breakdown)

**Context:** During project breakdown (see `Project_Breakdown_Guide.md` §2.1)

**Purpose:** Assign domain labels that will later map to agent selections

**Workflow:**
1. Identify logical work domains using domain analysis criteria
2. Create domain-specific labels (e.g., `auth`, `api`, `ui`, `testing`)
3. During Final Review (§5.2), consider if specialized agent labels are needed
4. Use `agent:*` labels when domain work naturally aligns with agent specialization

**Note:** Most domain labels remain domain-focused (e.g., `auth`, `api`). The `agent:*` convention is reserved for when agent capabilities are the primary organizing principle.

### Manager Agent Use (Task Assignment)

**Context:** During task assignment (see `Agent_Workflow_Guide.md` "Assigning Work" section and `Task_Assignment_Guide.md` § 1.4)

**Purpose:** Validate agent capabilities match task requirements before spawning

**Workflow:**
1. Query ready tasks: `bd ready`
2. Check task details: `bd show <issue-id>` (includes labels)
3. Validate agent selection against this guide's decision framework
4. If `agent:*` label present, use specified agent type
5. If domain label present, apply decision framework to select appropriate agent
6. Spawn agent via Task tool with validated `subagent_type`

**Validation checks:**
- Does task require write access? (If yes, exclude `agent:explore` and `agent:plan`)
- Does task benefit from fast read-only analysis? (Consider `agent:explore`)
- Does task require research or planning? (Consider `agent:plan`)
- Is there a matching custom agent? (Check `.claude/agents/`)

## Custom Agent Discovery Example

**Scenario:** Manager needs to assign a database migration task.

**Discovery process:**
```bash
# 1. Check for custom agents
find .claude/agents -name "*.md" -type f

# Output: .claude/agents/database-specialist.md

# 2. Read agent definition
cat .claude/agents/database-specialist.md
```

**Agent definition:**
```yaml
---
name: database-specialist
description: Database schema design and SQL optimization
tools: [read, write, edit, bash, grep, glob]
model: claude-sonnet-4-5-20250929
---
```

**Decision:** Use `agent:database-specialist` for specialized database work with full tool access.

**Spawn command:**
```python
Task(
  subagent_type="database-specialist",
  prompt="[Task details...]"
)
```

---

**End of Guide**
