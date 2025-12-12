# Task Assignment Guide

This guide covers **Manager-specific** details for spawning Implementation Agents: dependency context handling, user explanations, and next action decisions.

For general workflow (spawning, reviewing, bd commands), see `Agent_Workflow_Guide.md`.

---

## 1. Dependency Context Integration

When consumer tasks depend on producer outputs (via `bd dep add`), Manager provides context based on domain labels.

### 1.1. Determine Context Approach

Before spawning an agent, check dependencies:

```bash
bd show <issue-id>  # Shows dependencies
```

- **Same domain label** → Use **Simple Contextual Reference** (Section 1.2)
- **Different domain labels** → Use **Comprehensive Integration Context** (Section 1.3)

### 1.2. Same-Domain Dependencies

When **same domain** worked on both producer and consumer tasks:

**Approach:**
- Provide specific output references and key implementation details
- Include relevant file locations and important artifacts
- Assume working familiarity but provide concrete guidance

**Simple Example:**
```markdown
## Context from Dependencies
Based on Task 2.1 work, use the authentication middleware in `src/middleware/auth.js` and the JWT validation functions for this frontend integration task.
```

**Complex Example:**
```markdown
## Context from Dependencies
Building on Task 2.3 API implementation:

**Key Outputs to Use:**
- Authentication endpoints in `src/api/auth.js` (POST /api/login, GET /api/verify)
- User validation middleware in `src/middleware/auth.js`
- Database schema updates in `migrations/003_add_user_roles.sql`

**Implementation Details:**
- JWT tokens include user role and permissions in payload
- Error handling returns standardized error objects with code/message format

**Integration Approach:**
Extend the existing role-based permissions system for the new admin dashboard requirements.
```

**Guidelines:**
- Simple dependencies: Reference key files with brief integration guidance
- Complex dependencies: Include key outputs list, implementation details, integration approach
- Always include specific file paths

### 1.3. Cross-Domain Dependencies

When **different domains** worked on producer and consumer tasks:

**Approach:**
- Always provide detailed integration steps with explicit file reading instructions
- Include comprehensive output summaries regardless of complexity
- Assume consumer agent has **zero familiarity** with producer work

**Template:**
```markdown
## Context from Dependencies
This task depends on [Task X.Y description] implemented by [domain]:

**Integration Steps (complete before main task):**
1. Read [specific file] at [path] to understand [aspect]
2. Study [implementation files] in [paths] to understand [patterns]
3. Examine [test files] at [paths] for [usage examples]

**Producer Output Summary:**
- [Key functionality]: [Description]
- [Important files/endpoints]: [Locations and purposes]
- [Data structures]: [Important formats or contracts]
- [Error handling]: [How errors are handled]

**Integration Requirements:**
- [Requirement 1]: [How to integrate]
- [Usage patterns]: [How to use the outputs]
- [Constraints]: [Limitations to consider]

**If Unclear:**
Ask user about [specific clarification areas].
```

**Guidelines:**
- Always comprehensive regardless of complexity
- Include explicit file paths and what to look for
- Document all relevant outputs, interfaces, usage patterns
- Always include clarification pathway for ambiguous points

### 1.4. Agent Selection and Validation

Before spawning an agent, determine the appropriate agent type from the issue's assignee field.

**Discovery process:**

1. **Check for agent assignee in issue:**
   ```bash
   bd show <issue-id>  # Look for "Assignee:" field
   ```

2. **Validate agent availability:**
   - If `general-purpose`, `explore`, or `plan` → Use directly (built-in agents)
   - If custom agent name → Verify custom agent exists:
     ```bash
     find .claude/agents -name "<custom-name>.md" -type f
     ```

3. **Fallback behavior:**
   - If assigned agent not found, **STOP** and ask user:
     ```
     ⚠️ Issue <issue-id> is assigned to "<name>", but this agent doesn't exist.

     Available agents:
     - general-purpose (built-in)
     - explore (built-in)
     - plan (built-in)
     [+ any discovered custom agents from .claude/agents/]

     Please update the issue assignee with: bd update <issue-id> -a <correct-name>
     ```

4. **No assignee present:**
   - Apply Agent Discovery Guide decision framework (see `.apm/guides/Agent_Discovery_Guide.md`)
   - Default to `general-purpose` for implementation tasks
   - Ask user to confirm agent selection if task requirements are unclear

**Reference:** See `Agent_Discovery_Guide.md` for complete agent capabilities and selection criteria.

### 1.5. Adding Context to Task Prompt

Include dependency context in the Task tool prompt with dynamically selected agent:

```python
# Example: Using agent from issue assignee field
Task(
  subagent_type="<agent-from-assignee>",  # e.g., "general-purpose", "explore", "plan", or custom agent name
  prompt="""
  You are an Implementation Agent. Complete this task:

  **Task ID:** <issue-id>
  **Title:** <title>

  ## Context from Dependencies
  [Use Section 1.2 or 1.3 template based on domain]

  ## Objective
  [From issue description]

  ## Requirements
  [From issue description]

  ## Workflow
  1. Run: bd update <issue-id> --status=in_progress
  2. Do the work
  3. Log progress: bd comments add <issue-id> "progress"
  4. When done: bd close <issue-id> --reason="summary"

  Return a summary of what was accomplished.
  """
)
```

**Assignee to subagent_type mapping:**
- Assignee `general-purpose` → `subagent_type="general-purpose"`
- Assignee `explore` → `subagent_type="explore"`
- Assignee `plan` → `subagent_type="plan"`
- Assignee `database-specialist` → `subagent_type="database-specialist"`

**Note:** The `subagent_type` parameter uses the assignee value directly.

---

## 2. User Explanation Requests

When users request explanations for complex tasks:

**Timing Protocol:**
- **Single-Step Tasks**: Brief intro BEFORE, detailed explanation AFTER
- **Multi-Step Tasks**: Same pattern per step

**Include in Task Prompt:**
```markdown
## Explanation Requirements
- Explain [technical approach / decision rationale / architectural impact]
- Provide brief intro before starting, detailed explanation after completing
```

Only include when explicitly requested by user.

---

## 3. Beads Query Patterns for Manager

Manager uses these Beads queries for task coordination and workflow management:

### 3.1. Task Discovery Queries

**Find available work:**
```bash
bd ready  # Get tasks with status=ready
```

**Check active work:**
```bash
bd list --status=in_progress  # See all in-progress tasks
```

**Find blocked tasks:**
```bash
bd blocked  # Get tasks with blockers
```

**View specific task details:**
```bash
bd show <issue-id>  # See full task context including dependencies
```

### 3.2. Task Management Commands

**Assign task to agent:**
```bash
bd update <issue-id> --assign=<agent-name> --status=in_progress
```

**Create new tasks:**
```bash
bd create --title="Task title" --description="Details" --assignee=<agent-name>
```

**Check dependencies:**
```bash
bd show <issue-id>  # Dependencies shown in output
```

---

## 4. Next Action Framework

After Task tool returns results, determine next step:

### 4.1. Continue Workflow
- Task complete → Check `bd ready` for next available task
- Phase complete → Log to coordination notes, continue with next phase
- Active work → Check `bd list --status=in_progress` to monitor

### 4.2. Follow-Up Actions
- Task needs refinement → Spawn new agent to continue/fix
- New requirements discovered → Create new issues with `bd create`
- Blocked tasks → Check `bd blocked` to identify and resolve blockers

### 4.3. Decision Criteria

| Status | Indicators | Action |
|--------|------------|--------|
| **Complete** | Issue closed, deliverables produced | Next task via `bd ready` |
| **Partial** | Progress logged, issue still open | Continue or reassign |
| **Blocked** | Blocker documented in comments | Use `bd blocked` to review, resolve blocker first |

---

**End of Guide**
