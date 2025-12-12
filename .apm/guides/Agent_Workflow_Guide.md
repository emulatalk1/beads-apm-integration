# Agent Workflow Guide

This guide defines how Manager and Implementation Agents work using Beads for state management and the Task tool for agent spawning.

## Core Principles

1. **Beads is the source of truth** - All task state lives in Beads, not in memory or files
2. **Save as you work** - Log progress continuously with `bd comments add`, not just at handover
3. **Task tool for spawning** - Use Task tool for agent delegation; results return directly
4. **No handover documents** - New sessions query Beads for state
5. **Quality standards matter** - Follow structured logging, validation protocols, and debugging limits

---

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
# Get task details (includes assignee)
bd show <issue-id>
```

Check for the assignee field in the output. If present, use that agent type. Otherwise, apply the decision framework from Agent_Discovery_Guide.md to select an appropriate agent.

Spawn an Implementation Agent via Task tool:

```
Task(
  subagent_type="<agent-from-assignee>",  # e.g., "general-purpose", "explore", "plan", or custom agent name
  prompt="""
  You are an Implementation Agent. Complete this task:

  **Task ID:** <issue-id>
  **Title:** <from bd show>
  **Description:** <from bd show>

  ## Workflow
  1. Run: bd update <issue-id> --status=in_progress
  2. Do the work following quality standards
  3. Log progress: bd comments add <issue-id> "structured progress updates"
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

### Monitoring Quality Flags

Check for issues requiring attention:

```bash
# Find issues with compatibility concerns
bd list --label="has:compatibility-concerns"

# Find issues with ad-hoc delegation
bd list --label="has:ad-hoc-delegation"

# Find issues with important findings
bd list --label="has:important-findings"
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

---

## Implementation Agent Workflow

### Agent Identity Registration

**CRITICAL**: At the start of EVERY task, register your identity.

```bash
# Start work and register identity
bd update <issue-id> --status=in_progress --label="agent:<agent-type>"

# Example
bd update proj-abc --status=in_progress --label="agent:impl-agent-3"
```

**Why this matters**:
- Tracks which agent owns which work
- Prevents context collision across agents
- Enables handover protocols
- Creates audit trail

### Receiving Assignment

When spawned by Manager, you receive task details in the prompt.

### Starting Work

```bash
bd update <issue-id> --status=in_progress
```

### Logging Progress - Structured Format

**CRITICAL**: Use structured logging format. Log as you work, not at the end.

**Basic Progress Updates:**
```bash
bd comments add <issue-id> "Added JWT middleware to auth routes"
bd comments add <issue-id> "Found existing validation to reuse"
bd comments add <issue-id> "Tests passing"
```

**For Complex Work - Use Memory Log Structure:**

When completing significant work, use this structured format in your final comment:

```bash
bd comments add <issue-id> "$(cat <<'EOF'
## Summary
[One-paragraph overview of what was accomplished]

## Details
[Implementation specifics: approach taken, key decisions, patterns used]

## Output
- File: /absolute/path/to/file.ts (lines 10-50)
- Modified: /absolute/path/to/other.ts (lines 5-20)
- Created: /absolute/path/to/new-file.ts

## Issues Encountered
1. [Issue description]
   - Solution: [how it was resolved]
2. [Another issue]
   - Solution: [resolution approach]

## Next Steps
- [ ] [Next action item if work continues]
- [ ] [Another action item]
EOF
)"
```

**Conditional Sections** (only include if applicable):

If you have compatibility concerns:
```bash
# Set flag first
bd update <issue-id> --label="has:compatibility-concerns"

# Then add details in comment
bd comments add <issue-id> "$(cat <<'EOF'
## Compatibility Concerns
[Describe backward compatibility issues, breaking changes, migration requirements]
EOF
)"
```

If you delegated work ad-hoc:
```bash
# Set flag first
bd update <issue-id> --label="has:ad-hoc-delegation"

# Then add details
bd comments add <issue-id> "$(cat <<'EOF'
## Ad-Hoc Delegation
- Agent Type: Debug
- Reason: [why delegation was needed]
- Outcome: [what was learned/resolved]
EOF
)"
```

If you discovered important findings:
```bash
# Set flag first
bd update <issue-id> --label="has:important-findings"

# Then add details
bd comments add <issue-id> "$(cat <<'EOF'
## Important Findings
[Discoveries that affect project scope, architecture decisions, or future tasks]
EOF
)"
```

### Debugging Protocol - Three-Attempt Limit

**CRITICAL**: Do NOT get stuck in infinite debugging loops.

**Pattern:**
```
Attempt 1: [try initial solution]
  → Log: bd comments add <id> "Debug attempt 1: tried X, result Y"

Attempt 2: [try different approach]
  → Log: bd comments add <id> "Debug attempt 2: tried Z, result W"

Attempt 3: [final attempt with thorough analysis]
  → Log: bd comments add <id> "Debug attempt 3: analyzed Q, tried R"

If still failing → DELEGATE to specialized agent
```

**When to Delegate After 3 Attempts:**

```bash
# Create debug sub-task
bd create --parent=<issue-id> --title="Debug: [specific error]" --description="[context from 3 attempts]"

# Mark parent with delegation flag
bd update <issue-id> --label="has:ad-hoc-delegation"

# Log delegation
bd comments add <issue-id> "Delegating to debug specialist after 3 attempts. See child issue."
```

**Why this matters**:
- Prevents resource waste
- Forces escalation to specialists when needed
- Maintains project momentum
- Ensures fresh perspectives on hard problems

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

**Minimum Requirements Before Closing:**
- [ ] All code changes committed
- [ ] Tests passing (or documented why not applicable)
- [ ] Structured progress logged
- [ ] Quality flags set if applicable
- [ ] Dependencies updated if needed

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

**Context Efficiency**:
- **Same-Agent Resumption**: Minimal context needed (you have conversation history)
- **Cross-Agent Resumption**: Full context in Beads (new agent reads all comments)

---

## Quality Standards

### 1. Agent Identity Tracking

**ALWAYS** register your agent identity:
```bash
bd update <id> --label="agent:<agent-type>"
```

### 2. Structured Logging

**ALWAYS** use structured format for significant work:
- Summary (required)
- Details (required)
- Output (required)
- Issues Encountered (required)
- Next Steps (required)
- Compatibility Concerns (conditional)
- Ad-Hoc Delegation (conditional)
- Important Findings (conditional)

### 3. Quality Flags

**SET FLAGS** when applicable:
- `has:compatibility-concerns` - Breaking changes or migration needed
- `has:ad-hoc-delegation` - Work delegated to specialist
- `has:important-findings` - Discoveries affecting project scope

### 4. Debug Discipline

**ENFORCE** three-attempt limit:
- Attempt 1: Initial solution
- Attempt 2: Alternative approach
- Attempt 3: Deep analysis
- Still failing? → Delegate

### 5. Test Validation

**BEFORE CLOSING**:
- Run relevant tests
- Document test results
- If tests fail, keep task open or delegate

---

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
| Quality flags | `bd list --label="has:*"` |

## State Updates Reference

| Action | Command |
|--------|---------|
| Start task | `bd update <id> --status=in_progress` |
| Register agent | `bd update <id> --label="agent:<type>"` |
| Log progress | `bd comments add <id> "message"` |
| Set quality flag | `bd update <id> --label="has:*"` |
| Complete task | `bd close <id> --reason="summary"` |
| Add dependency | `bd dep add <blocked> <blocker>` |
| Create sub-task | `bd create --parent=<id> --title="..."` |

## Memory Log Structure - Complete Example

Here's a complete example of a structured Memory Log comment:

```bash
bd comments add proj-abc "$(cat <<'EOF'
## Summary
Implemented JWT-based authentication for API routes. Added middleware, token generation/validation, and integrated with existing user model. All tests passing.

## Details
- Created auth middleware in src/middleware/auth.ts using jsonwebtoken library
- Added token generation to login endpoint in src/routes/auth.ts
- Implemented token validation and user extraction from request headers
- Reused existing User model validation patterns for consistency
- Added refresh token support for better UX

## Output
- Created: /Users/project/src/middleware/auth.ts (lines 1-85)
- Modified: /Users/project/src/routes/auth.ts (lines 20-45, 60-80)
- Modified: /Users/project/src/routes/protected.ts (lines 1-5)
- Created: /Users/project/tests/auth.test.ts (lines 1-120)

## Issues Encountered
1. Initial token expiration too short (5 min)
   - Solution: Changed to 1 hour for access tokens, 7 days for refresh tokens
2. Middleware order caused validation to run before auth
   - Solution: Reordered middleware stack in app.ts
3. Tests failed due to missing JWT_SECRET in test env
   - Solution: Added test-specific secret to jest.setup.ts

## Next Steps
- [ ] Monitor token expiration in production
- [ ] Consider implementing token revocation if needed

## Compatibility Concerns
Breaking change: All protected routes now require Authorization header.

Migration required:
- Frontend clients must update to send JWT in Authorization header
- Existing session-based auth will be deprecated in v2.0
- Provide migration guide for API consumers

## Important Findings
Discovered that refresh token rotation is critical for security. Current implementation supports this, but we should add monitoring for unusual refresh patterns (potential token theft).
EOF
)"
```

After adding this comment, set the appropriate flags:
```bash
bd update proj-abc --label="has:compatibility-concerns"
bd update proj-abc --label="has:important-findings"
```

---

## Why This Works

| Before (APM with Markdown) | After (Beads + Task) |
|----------------------------|----------------------|
| State in markdown files | State in Beads (queryable) |
| Manual handover documents | Query current state |
| Copy-paste prompts | Task tool returns directly |
| "What's blocked?" = read files | `bd blocked` |
| "What's next?" = parse markdown | `bd ready` |
| Memory logs in separate files | Structured comments on issues |
| Manual flag tracking | Label-based filtering |
| Session isolation via files | Session isolation via Task tool |

**Key Advantages**:
1. **Queryable State**: `bd list --label="has:compatibility-concerns"` beats grepping files
2. **Atomic Updates**: Status changes are instant and consistent
3. **Natural Hierarchy**: Parent/child issues replace manual delegation tracking
4. **Audit Trail**: All comments timestamped and immutable
5. **Cross-Session**: New agents query Beads, no handover documents needed

---

## Same-Agent vs Cross-Agent Context

### Same-Agent Context (Resuming Your Own Work)

**Minimal context needed** - you have conversation history:
```bash
bd show <issue-id>        # Quick reminder
bd comments <issue-id>    # See your recent progress
# Continue working
```

### Cross-Agent Context (New Agent Taking Over)

**Full context required** - new agent needs everything:
```bash
bd show <issue-id>        # Get full task description
bd comments <issue-id>    # Read all progress logs
bd list --parent=<id>     # Check for sub-tasks
bd dep list <issue-id>    # Check dependencies
# Understand full context before starting
```

**Why this distinction matters**:
- Reduces token waste for same-agent resumption
- Ensures thorough understanding for cross-agent handover
- Maintains context efficiency while preserving completeness

---

## Validation Checklist

Before closing a task, verify:

**Code Quality**:
- [ ] Code follows project patterns
- [ ] No obvious bugs or issues
- [ ] Dependencies properly managed

**Testing**:
- [ ] Relevant tests passing
- [ ] New tests added if needed
- [ ] Test failures documented

**Documentation**:
- [ ] Structured progress logged
- [ ] Output files listed with paths
- [ ] Issues and solutions documented

**Quality Flags**:
- [ ] Compatibility concerns flagged if applicable
- [ ] Ad-hoc delegation documented if occurred
- [ ] Important findings captured if discovered

**State Management**:
- [ ] Status accurately reflects completion
- [ ] Dependencies updated if affected
- [ ] Next steps clear for future work

---

**End of Guide**
