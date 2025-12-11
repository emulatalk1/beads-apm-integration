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

### 1.4. Adding Context to Task Prompt

Include dependency context in the Task tool prompt:

```python
Task(
  subagent_type="general-purpose",
  prompt="""
  You are an Implementation Agent. Complete this task:

  Task ID: <issue-id>
  Title: <title>

  ## Context from Dependencies
  [Use Section 1.2 or 1.3 template based on domain]

  ## Objective
  [From issue description]

  ## Requirements
  [From issue description]

  ## Workflow
  1. bd update <issue-id> --status=in_progress
  2. Do the work
  3. bd comments add <issue-id> "progress"
  4. bd close <issue-id> --reason="summary"
  """
)
```

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

## 3. Next Action Framework

After Task tool returns results, determine next step:

### 3.1. Continue Workflow
- Task complete → Check `bd ready` for next available task
- Phase complete → Log to coordination notes, continue with next phase

### 3.2. Follow-Up Actions
- Task needs refinement → Spawn new agent to continue/fix
- New requirements discovered → Create new issues with `bd create`

### 3.3. Decision Criteria

| Status | Indicators | Action |
|--------|------------|--------|
| **Complete** | Issue closed, deliverables produced | Next task |
| **Partial** | Progress logged, issue still open | Continue or reassign |
| **Blocked** | Blocker documented in comments | Resolve blocker first |

---

**End of Guide**
