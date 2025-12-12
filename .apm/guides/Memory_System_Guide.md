# Memory System Guide (Beads-Adapted)

**Document Purpose**: Define the memory and state tracking system for APM agents using Beads issue tracking.

**Critical Principle**: Memory Logs are the beating heart of APM's state management. Every action, decision, finding, and handover MUST be captured with the same richness as the original markdown-based system.

---

## Table of Contents

1. [Overview](#overview)
2. [Memory Log Structure](#memory-log-structure)
3. [Core Sections (Required)](#core-sections-required)
4. [Optional Sections (Conditional)](#optional-sections-conditional)
5. [Beads Implementation](#beads-implementation)
6. [Writing Memory Logs](#writing-memory-logs)
7. [Reading Memory Logs](#reading-memory-logs)
8. [Memory Log Lifecycle](#memory-log-lifecycle)
9. [Context Management](#context-management)
10. [Handover Protocol](#handover-protocol)
11. [Best Practices](#best-practices)

---

## Overview

### What is the Memory System?

The Memory System provides:
- **State persistence** across agent sessions
- **Audit trail** of all work performed
- **Context transfer** between agents
- **Decision documentation** for future reference
- **Progress tracking** for Manager Agent
- **Issue discovery** mechanism (compatibility, delegation, findings)

### Why It's Critical

Without comprehensive Memory Logs:
- Agents lose context between sessions
- Manager cannot track progress accurately
- Handovers fail due to missing context
- Important findings get lost
- Debugging becomes impossible
- Audit trail is incomplete

### Beads Adaptation

**Original System**: Memory Logs were markdown files (`.apm/memory/task-abc-memory.md`)

**Beads System**: Memory Logs are structured comments on Beads issues

**Key Preservation**: The exact structure, sections, and richness of tracking remain unchanged. Only the storage mechanism differs.

---

## Memory Log Structure

### Complete Structure Template

Every Memory Log follows this **exact** structure:

```markdown
## Summary
[One-paragraph overview of what was accomplished and why]

## Details
[Implementation specifics: what was built, how it works, key decisions]

## Output
[Files created/modified with absolute paths and line numbers]
- File: /absolute/path/to/file.ts (lines 10-50)
- Modified: /absolute/path/to/other.ts (lines 5-20)
- Created: /absolute/path/to/new-file.ts (entire file)

## Issues Encountered
[Problems faced and how they were resolved]
1. [Issue description]
   - Solution: [How it was resolved]
   - Impact: [What changed as a result]

## Next Steps
[What should happen next, who should do it]
- [ ] [Next action item]
- [ ] [Next action item]

## Compatibility Concerns
[Only present if `has:compatibility-concerns` label is set]
[Backward compatibility issues, breaking changes, migration needs]

## Ad-Hoc Delegation
[Only present if `has:ad-hoc-delegation` label is set]
- Agent Type: [Debug|Research|Other]
- Reason: [Why delegation was needed]
- Outcome: [What was learned/fixed]
- Findings: [Key discoveries from delegated work]

## Important Findings
[Only present if `has:important-findings` label is set]
[Discoveries that affect project scope, architecture, or future work]
- Finding: [Description]
- Impact: [How this affects the project]
- Recommendation: [What should be done about it]
```

### Structural Rules

**REQUIRED** (5 sections):
1. Summary
2. Details
3. Output
4. Issues Encountered
5. Next Steps

**OPTIONAL** (3 sections, conditional on labels):
6. Compatibility Concerns (if `has:compatibility-concerns`)
7. Ad-Hoc Delegation (if `has:ad-hoc-delegation`)
8. Important Findings (if `has:important-findings`)

**CRITICAL**:
- Section order MUST be preserved exactly
- Section names CANNOT be changed
- Sections CANNOT be merged or split
- Optional sections appear ONLY if corresponding label is set

---

## Core Sections (Required)

### 1. Summary

**Purpose**: One-paragraph overview for quick scanning

**Content Guidelines**:
- **What** was accomplished (high-level)
- **Why** it was done (purpose/goal)
- **Outcome** (success/partial/blocked)
- **Key context** for future readers

**Good Example**:
```markdown
## Summary
Implemented user authentication middleware for Express API using JWT tokens. Created token generation, validation, and refresh logic to support stateless authentication. Successfully tested with unit tests and integration tests. System is production-ready and follows security best practices.
```

**Bad Example**:
```markdown
## Summary
Added auth stuff. Works now.
```

**Why Critical**: Manager Agent uses Summary to:
- Quickly assess completion status
- Identify blockers without reading details
- Detect compatibility concerns early
- Prioritize next work

---

### 2. Details

**Purpose**: Implementation specifics for future maintenance

**Content Guidelines**:
- **Architecture decisions** (why this approach?)
- **Key algorithms** (how does it work?)
- **Dependencies** (what does this rely on?)
- **Configuration** (what settings were chosen?)
- **Tradeoffs** (what was considered and rejected?)

**Good Example**:
```markdown
## Details
Implemented JWT-based authentication with the following design:

Architecture:
- Middleware intercepts all protected routes
- Token validation happens before route handlers execute
- Refresh tokens stored in httpOnly cookies for security
- Access tokens have 15-minute expiry, refresh tokens 7 days

Key Decisions:
- Chose RS256 over HS256 for better key rotation support
- Rejected session-based auth due to scalability concerns
- Added rate limiting on token endpoints to prevent abuse

Dependencies:
- jsonwebtoken@9.0.0 (token generation/validation)
- bcryptjs@2.4.3 (password hashing)
- express-rate-limit@6.7.0 (rate limiting)

Configuration:
- Public/private key pair generated with 2048-bit RSA
- Keys stored in environment variables
- Token payload includes: userId, role, issuedAt, expiresAt
```

**Bad Example**:
```markdown
## Details
Used JWT library. Added middleware.
```

**Why Critical**: Future agents (including yourself) need enough context to:
- Understand why decisions were made
- Modify the implementation safely
- Debug issues that arise later
- Maintain consistency across codebase

---

### 3. Output

**Purpose**: Precise record of what files changed

**Content Guidelines**:
- **Absolute paths** (never relative)
- **Line numbers** (for targeted changes)
- **Change type** (Created/Modified/Deleted)
- **File purpose** (brief description)

**Format**:
```markdown
## Output
- File: /absolute/path/to/file.ts (lines 10-50)
  Purpose: [What this file does]

- Modified: /absolute/path/to/existing.ts (lines 5-20, 45-60)
  Changes: [What was changed and why]

- Created: /absolute/path/to/new-file.ts (entire file)
  Purpose: [Why this new file was needed]

- Deleted: /absolute/path/to/old-file.ts
  Reason: [Why removal was necessary]
```

**Good Example**:
```markdown
## Output
- Created: /project/src/middleware/auth.ts (entire file)
  Purpose: JWT authentication middleware for protected routes

- Modified: /project/src/app.ts (lines 15-18)
  Changes: Registered auth middleware globally

- Created: /project/src/utils/token.ts (entire file)
  Purpose: Token generation and validation utilities

- Modified: /project/src/routes/api.ts (lines 8-12, 34-40)
  Changes: Applied auth middleware to protected endpoints

- Created: /project/tests/auth.test.ts (entire file)
  Purpose: Unit and integration tests for authentication
```

**Bad Example**:
```markdown
## Output
- Added some files
- Changed routes
```

**Why Critical**: Manager Agent uses Output to:
- Track file-level progress
- Detect merge conflicts before they happen
- Coordinate parallel work across agents
- Generate accurate status reports

---

### 4. Issues Encountered

**Purpose**: Document problems and solutions for learning

**Content Guidelines**:
- **Every problem** encountered (even if quickly solved)
- **Solution approach** (what was tried, what worked)
- **Impact** (how this affected the work)
- **Prevention** (how to avoid in future)

**Format**:
```markdown
## Issues Encountered
1. [Issue description]
   - Solution: [How it was resolved]
   - Impact: [What changed as a result]
   - Prevention: [How to avoid this in future]

2. [Next issue]
   ...
```

**Good Example**:
```markdown
## Issues Encountered
1. JWT library threw "secret must be a string" error
   - Solution: Discovered environment variable was being read as Buffer. Added `.toString('utf8')` when loading private key.
   - Impact: Delayed implementation by 15 minutes. Added key validation to startup sequence.
   - Prevention: Document environment variable format requirements in README.

2. Token validation failed for valid tokens in tests
   - Solution: Test environment was using different RSA key pair. Standardized test fixtures to use consistent keys.
   - Impact: Required refactoring test setup. Created shared test utilities.
   - Prevention: Added test environment validation on startup.

3. Rate limiting blocked legitimate requests during testing
   - Solution: Configured separate rate limits for test vs production environments. Test limits are 10x higher.
   - Impact: Tests now run reliably. Production limits unchanged.
   - Prevention: Document rate limit configuration in deployment guide.
```

**Bad Example**:
```markdown
## Issues Encountered
Had some problems but fixed them.
```

**Why Critical**: Issue tracking provides:
- **Knowledge base** for future debugging
- **Pattern recognition** across tasks
- **Prevention strategies** to avoid repeated mistakes
- **Delegation triggers** (3 attempts → escalate to Debug Agent)

---

### 5. Next Steps

**Purpose**: Clear handover instructions for next agent (or future self)

**Content Guidelines**:
- **Specific actions** (not vague intentions)
- **Priority order** (what should happen first)
- **Context needed** (what the next agent should know)
- **Blocking issues** (what must be resolved first)

**Format**:
```markdown
## Next Steps
- [ ] [Specific action item with context]
- [ ] [Next action item]
- [ ] [Next action item]

Blocking Issues:
- [What must be resolved before proceeding]

Context for Next Agent:
- [Important context that's not in other sections]
```

**Good Example**:
```markdown
## Next Steps
- [ ] Add password reset functionality (tokens expire after 1 hour)
- [ ] Implement email verification flow (use same token mechanism)
- [ ] Add OAuth integration for Google/GitHub (consider passport.js)
- [ ] Write API documentation for auth endpoints (OpenAPI spec)
- [ ] Add monitoring/alerting for failed auth attempts

Blocking Issues:
- Email service not yet configured (needed for reset/verification)

Context for Next Agent:
- Private key rotation strategy not yet implemented (placeholder in code)
- Consider adding 2FA in future iteration (defer for now)
- Rate limiting thresholds may need tuning based on production traffic
```

**Bad Example**:
```markdown
## Next Steps
- Do more stuff
- Make it better
```

**Why Critical**: Next Steps enable:
- **Seamless handovers** (no context loss)
- **Priority alignment** (everyone knows what's important)
- **Blocker visibility** (prevents wasted effort)
- **Progress continuity** (work flows smoothly)

---

## Optional Sections (Conditional)

### 6. Compatibility Concerns

**When to Include**: Set `has:compatibility-concerns` label when backward compatibility is affected

**Purpose**: Flag breaking changes for Manager Agent review

**Content Guidelines**:
- **What breaks** (specific APIs, behaviors, data formats)
- **Who's affected** (users, other systems, tests)
- **Migration path** (how to upgrade safely)
- **Rollback plan** (how to undo if needed)

**Format**:
```markdown
## Compatibility Concerns

Breaking Changes:
1. [What changed]
   - Old behavior: [How it worked before]
   - New behavior: [How it works now]
   - Affected: [Who/what is impacted]

Migration Path:
- Step 1: [First migration step]
- Step 2: [Next step]
- Rollback: [How to revert]

Risk Assessment:
- Probability: [High/Medium/Low]
- Impact: [High/Medium/Low]
- Mitigation: [What reduces risk]
```

**Good Example**:
```markdown
## Compatibility Concerns

Breaking Changes:
1. Authentication now required for all /api/* endpoints
   - Old behavior: Some endpoints were public (e.g., /api/status, /api/health)
   - New behavior: All endpoints require valid JWT token
   - Affected: Monitoring tools, health check scripts, public API consumers

2. Token format changed from HS256 to RS256
   - Old behavior: Symmetric key validation
   - New behavior: Asymmetric key validation
   - Affected: Any service that validates tokens directly (not recommended but possible)

Migration Path:
- Step 1: Deploy new auth service with backward compatibility mode (accepts both HS256 and RS256)
- Step 2: Update all clients to use new token format
- Step 3: Monitor for 7 days to ensure no HS256 tokens in use
- Step 4: Remove backward compatibility mode
- Rollback: Revert to previous deployment, re-enable HS256 tokens

Risk Assessment:
- Probability: Medium (some clients may not be updated immediately)
- Impact: High (clients will get 401 errors)
- Mitigation: Phased rollout, extensive monitoring, clear communication
```

**Bad Example**:
```markdown
## Compatibility Concerns
Changed auth. Might break stuff.
```

**Why Critical**: Compatibility tracking prevents:
- **Production outages** from surprise breakages
- **Data loss** from incompatible migrations
- **Integration failures** when APIs change
- **User disruption** from unannounced changes

---

### 7. Ad-Hoc Delegation

**When to Include**: Set `has:ad-hoc-delegation` label when work is delegated mid-task

**Purpose**: Track specialist involvement and findings integration

**Trigger**: After 3 failed debugging attempts OR when specialized expertise needed

**Content Guidelines**:
- **Why delegated** (what exceeded current agent's scope)
- **Agent type** (Debug Agent, Research Agent, etc.)
- **Context provided** (what the specialist received)
- **Findings** (what was learned)
- **Integration** (how findings were applied)

**Format**:
```markdown
## Ad-Hoc Delegation

Delegation 1:
- Agent Type: [Debug|Research|Specialist]
- Trigger: [Why delegation was needed]
- Context Provided: [What info was given to specialist]
- Findings: [What the specialist discovered]
- Integration: [How findings were applied]
- Time: [Timestamp of delegation]

Delegation 2:
[If multiple delegations occurred]
```

**Good Example**:
```markdown
## Ad-Hoc Delegation

Delegation 1:
- Agent Type: Debug Agent
- Trigger: Token validation consistently failed after 3 debugging attempts. Error message was cryptic: "invalid signature"
- Context Provided:
  - Code snippet of token generation logic
  - Sample token payload
  - Validation code
  - Error stack trace
  - Environment configuration
- Findings:
  - Private key was being read with wrong encoding (base64 vs PEM)
  - Key parsing silently failed, resulting in malformed key
  - Validation used correctly-parsed public key, hence mismatch
- Integration:
  - Added explicit encoding specification when reading keys
  - Added key validation on application startup
  - Created test fixtures with both valid and invalid keys
  - Documented key format requirements in configuration guide
- Time: 2024-01-15T14:30:00Z

Delegation 2:
- Agent Type: Research Agent
- Trigger: Needed to choose between JWT, PASETO, and Macaroons for token format
- Context Provided:
  - Security requirements (RS256 minimum)
  - Performance constraints (sub-millisecond validation)
  - Ecosystem compatibility (Express, PostgreSQL)
- Findings:
  - JWT is most widely supported, proven track record
  - PASETO has better security defaults but limited library support
  - Macaroons overkill for this use case
  - Recommendation: JWT with RS256, rotate keys quarterly
- Integration:
  - Chose JWT based on recommendation
  - Implemented key rotation placeholder (future work)
  - Documented security considerations in architecture decisions
- Time: 2024-01-15T10:15:00Z
```

**Bad Example**:
```markdown
## Ad-Hoc Delegation
Asked debug agent for help. Fixed now.
```

**Why Critical**: Delegation tracking:
- **Captures specialist knowledge** for future reference
- **Justifies time spent** on complex problems
- **Prevents re-delegation** of same issue
- **Builds institutional knowledge** base

---

### 8. Important Findings

**When to Include**: Set `has:important-findings` label when discoveries affect project scope

**Purpose**: Escalate findings that change project direction or assumptions

**Content Guidelines**:
- **Discovery** (what was found)
- **Impact** (how this changes the project)
- **Evidence** (why we believe this)
- **Recommendations** (what should be done)

**Format**:
```markdown
## Important Findings

Finding 1: [Discovery description]
- Impact: [How this affects project scope/architecture/timeline]
- Evidence: [What supports this finding]
- Recommendation: [What should be done about it]
- Urgency: [Critical|High|Medium|Low]

Finding 2:
[Next finding]
```

**Good Example**:
```markdown
## Important Findings

Finding 1: Current database schema cannot support JWT token blacklisting efficiently
- Impact: Logout functionality will require architectural changes. Cannot simply invalidate tokens server-side without performance degradation.
- Evidence:
  - Token table would require O(n) scan on every request validation
  - Redis would add operational complexity and cost
  - Stateless JWT design conflicts with revocation requirements
- Recommendation:
  - Option A: Accept short-lived tokens (15 min) with no server-side revocation
  - Option B: Implement hybrid approach with Redis for blacklist
  - Option C: Switch to session-based auth for revocation needs
  - Recommendation: Option A for MVP, revisit if security requirements change
- Urgency: High (affects MVP scope and timeline)

Finding 2: Third-party API rate limits are 10x lower than expected
- Impact: Planned integration will hit rate limits under normal load. Need caching layer or alternative provider.
- Evidence:
  - API documentation states 100 requests/hour (not 1000 as assumed)
  - Premium tier costs $500/month (outside budget)
  - Alternative providers have similar limits
- Recommendation:
  - Implement aggressive caching (24-hour TTL)
  - Add request batching where possible
  - Monitor usage and upgrade tier if needed
  - Document rate limit constraints for stakeholders
- Urgency: Medium (can mitigate with caching, but limits architecture)
```

**Bad Example**:
```markdown
## Important Findings
Found some issues. Need to rethink approach.
```

**Why Critical**: Important Findings enable:
- **Early course correction** before too much work invested
- **Stakeholder communication** about scope changes
- **Architectural pivots** based on new information
- **Risk mitigation** through proactive discovery

---

## Beads Implementation

### Metadata Mapping

**Original**: YAML frontmatter in markdown files

```yaml
---
status: in_progress
agent: implementation-agent-3
task_ref: project-abc
has_compatibility_concerns: true
has_ad_hoc_delegation: false
has_important_findings: false
---
```

**Beads Equivalent**: Issue status, labels, and comments

```bash
# Status field
bd update project-abc --status=in_progress

# Agent assignment
bd update project-abc --label="agent:implementation-agent-3"

# Boolean flags
bd update project-abc --label="has:compatibility-concerns"
# (only set labels for true values; absence = false)
```

### Writing Memory Logs

**Command**:
```bash
bd comments add <task-id> --comment="$(cat <<'EOF'
## Summary
[Your summary here]

## Details
[Your details here]

## Output
[Your output here]

## Issues Encountered
[Your issues here]

## Next Steps
[Your next steps here]

## Compatibility Concerns
[Only if has:compatibility-concerns label set]

## Ad-Hoc Delegation
[Only if has:ad-hoc-delegation label set]

## Important Findings
[Only if has:important-findings label set]
EOF
)"
```

**Critical Rules**:
1. Use HEREDOC (`<<'EOF' ... EOF`) to preserve formatting
2. Include ALL 5 required sections
3. Include optional sections ONLY if corresponding label is set
4. Maintain exact section order
5. Use markdown formatting within sections

### Reading Memory Logs

**View Issue Details**:
```bash
bd show <task-id>
```
Shows: title, status, labels, description

**View Memory Log Comments**:
```bash
bd comments <task-id>
```
Shows: all comments with full Memory Log structure

**Query by Flags**:
```bash
# Find tasks with compatibility concerns
bd list --label="has:compatibility-concerns"

# Find tasks with delegation
bd list --label="has:ad-hoc-delegation"

# Find tasks with important findings
bd list --label="has:important-findings"
```

### Updating Memory Logs

**Add New Comment** (preferred for new work):
```bash
bd comments add <task-id> --comment="[new Memory Log]"
```

**Update Status**:
```bash
bd update <task-id> --status=done
```

**Add/Remove Labels**:
```bash
# Set flag
bd update <task-id> --label="has:compatibility-concerns"

# Remove flag (if Beads supports label removal)
bd update <task-id> --remove-label="has:compatibility-concerns"
```

---

## Memory Log Lifecycle

### Phase 1: Task Start

**Agent Receives Task**:
```bash
# Manager assigns task
bd update task-abc --assign=implementation-agent-3 --status=in_progress
```

**Agent Registers Identity**:
```bash
# Add agent label
bd update task-abc --label="agent:implementation-agent-3"
```

**Agent Begins Work**:
- Work happens (code, tests, debugging)
- No Memory Log yet (work in progress)

### Phase 2: Progress Logging (Optional)

**For Long-Running Tasks**: Add interim progress comments

```bash
bd comments add task-abc --comment="## Progress Update

Working on authentication middleware. Completed token generation logic.
Currently debugging validation logic (attempt 2 of 3).

Issues so far:
- Environment variable encoding issue (resolved)
- Key parsing error (investigating)

Estimated 30% complete."
```

**When to Log Progress**:
- Task spans multiple sessions
- Handover may be needed mid-task
- Complex debugging requires note-taking
- Multiple agents may need visibility

### Phase 3: Task Completion

**Agent Completes Work**:
1. Write comprehensive Memory Log (all 5 required sections)
2. Add optional sections if flags apply
3. Update status to done
4. Set completion labels

```bash
# Write Memory Log
bd comments add task-abc --comment="[complete Memory Log structure]"

# Set flags if needed
bd update task-abc --label="has:compatibility-concerns"

# Mark complete
bd close task-abc --reason="Successfully implemented JWT authentication with tests"
```

### Phase 4: Handover (If Needed)

**Trigger Handover When**:
- Context window approaching limit
- Blocking issue discovered
- Specialized expertise needed

**Handover Process**:
```bash
# Add handover comment
bd comments add task-abc --comment="## Handover

Current State: Token generation complete, validation failing

Blocker: Unknown encoding issue with private key

Context for Next Agent:
- Code at /project/src/middleware/auth.ts (lines 45-80)
- Error: 'invalid signature' on valid tokens
- Attempted solutions: re-keying, format changes, library upgrade
- Debugging notes: Keys parse successfully, signature mismatch persists

Recommendation: Escalate to Debug Agent or continue investigation with fresh perspective"

# Update status
bd update task-abc --status=blocked --label="needs:handover"
```

---

## Context Management

### Same-Agent Context (Minimal)

**Scenario**: Agent resumes own work after brief interruption

**Context Strategy**: Reference previous comment by timestamp

```bash
# Agent reads latest comment
bd comments task-abc

# Agent adds new comment referencing previous work
bd comments add task-abc --comment="## Update

Continuing from previous session (2024-01-15 14:30).

Resolved validation issue (see previous comment for context).
Now implementing refresh token logic."
```

**Why Minimal**: Agent has memory of recent work, doesn't need full recap

### Cross-Agent Context (Full)

**Scenario**: New agent picks up work from different agent

**Context Strategy**: Provide complete context in task description or handover comment

```bash
# Manager prepares full context for new agent
bd comments add task-abc --comment="## Context for New Agent

Original Task: Implement JWT authentication
Previous Agent: implementation-agent-3
Current State: 70% complete

Completed:
- Token generation logic
- Basic validation middleware
- Unit tests for generation

Remaining:
- Refresh token implementation
- Integration tests
- API documentation

Key Decisions:
- Using RS256 (not HS256) for better key rotation
- 15-minute access tokens, 7-day refresh tokens
- Tokens in httpOnly cookies for security

Code Locations:
- /project/src/middleware/auth.ts (main logic)
- /project/src/utils/token.ts (utilities)
- /project/tests/auth.test.ts (tests)

Blockers Resolved:
- Key encoding issue (fixed, see comment from 2024-01-15 14:30)

Next Steps:
[See Next Steps in latest Memory Log]"
```

**Why Full**: New agent has no context, needs comprehensive briefing

### Manager Agent Context Monitoring

**Manager Queries for Status**:
```bash
# Check all in-progress tasks
bd list --status=in_progress

# Check for flags
bd list --label="has:compatibility-concerns"
bd list --label="has:important-findings"

# Read specific task
bd show task-abc
bd comments task-abc
```

**Manager Responds to Flags**:
- `has:compatibility-concerns` → Review breaking changes, coordinate migration
- `has:ad-hoc-delegation` → Track specialist work, ensure findings integrated
- `has:important-findings` → Escalate to user, reprioritize work

---

## Handover Protocol

### When to Handover

**Context Window Limit**: When token count approaches 80% of limit
- Proactively prepare handover before hitting limit
- Clean handover > emergency context truncation

**Blocking Issue**: When progress stopped by external dependency
- Database migration pending
- API access not granted
- Upstream bug blocking work

**Specialized Expertise**: When work exceeds current agent's capabilities
- Complex debugging (after 3 attempts)
- Domain-specific knowledge needed
- Performance optimization requiring profiling

**Scheduled Rotation**: When task duration exceeds reasonable session
- Task estimated 90 minutes but taking 3+ hours
- Agent fatigue risk (quality degradation)
- Prefer fresh perspective

### Handover Structure

```markdown
## Handover

**Current State**: [One-sentence summary of where work stands]

**Blocker**: [What's preventing progress]

**Context for Next Agent**:
- [Key decision 1 and rationale]
- [Key decision 2 and rationale]
- [Important code location 1]
- [Important code location 2]

**Work Completed**:
- [x] [Task 1]
- [x] [Task 2]
- [ ] [Task 3 - in progress]

**Work Remaining**:
- [ ] [Task 4]
- [ ] [Task 5]

**Attempted Solutions** (if debugging):
1. [Approach 1] - Result: [What happened]
2. [Approach 2] - Result: [What happened]
3. [Approach 3] - Result: [What happened]

**Recommendation**: [What next agent should try or who should handle this]

**References**:
- Previous Memory Log: [timestamp]
- Related tasks: [task IDs]
- Documentation: [links]
```

### Handover Execution

```bash
# Write handover comment
bd comments add task-abc --comment="[Handover structure above]"

# Update status and labels
bd update task-abc --status=blocked --label="needs:handover"

# Notify Manager (via status change)
# Manager will detect blocked status and reassign
```

---

## Best Practices

### 1. Write Immediately After Work

**Don't**: Wait until end of day to write all Memory Logs

**Do**: Write Memory Log immediately after completing each task

**Why**: Fresh memory = accurate details. Delayed writing = lost context.

### 2. Be Specific, Not Vague

**Don't**: "Fixed the bug"

**Do**: "Fixed null pointer exception in token validation by adding null check before key.verify() call"

**Why**: Specificity enables future debugging and knowledge transfer.

### 3. Include Evidence

**Don't**: "This approach is better"

**Do**: "RS256 provides better security because private key never leaves server, unlike HS256 where secret must be shared"

**Why**: Evidence justifies decisions and educates future readers.

### 4. Document Failures Too

**Don't**: Only document successful solutions

**Do**: Document all attempted solutions, including failures

**Why**: Prevents future agents from repeating failed approaches.

### 5. Use Absolute Paths

**Don't**: `src/auth.ts`

**Do**: `/Users/username/project/src/auth.ts`

**Why**: Absolute paths work regardless of current working directory.

### 6. Preserve Formatting

**Don't**: Dump raw text into comments

**Do**: Use markdown formatting (headers, lists, code blocks)

**Why**: Readable Memory Logs = usable Memory Logs.

### 7. Set Flags Proactively

**Don't**: Wait for Manager to discover issues

**Do**: Set `has:*` labels immediately when conditions arise

**Why**: Early visibility enables early intervention.

### 8. Link Related Work

**Don't**: Treat each task as isolated

**Do**: Reference related tasks, previous work, dependencies

**Why**: Context connections reveal patterns and dependencies.

### 9. Write for Future Self

**Don't**: Assume you'll remember details

**Do**: Write as if you'll read this 6 months later with no memory

**Why**: Future you is effectively a different agent.

### 10. Balance Detail and Brevity

**Don't**: Write novels (too long) or telegrams (too short)

**Do**: Include all necessary context, omit unnecessary details

**Why**: Over-documentation is wasteful, under-documentation is useless.

---

## Validation Checklist

Before finalizing a Memory Log, verify:

**Structure**:
- [ ] All 5 required sections present
- [ ] Optional sections match label flags
- [ ] Sections in correct order
- [ ] Markdown formatting correct

**Content Quality**:
- [ ] Summary is one clear paragraph
- [ ] Details include architecture, decisions, tradeoffs
- [ ] Output lists all files with absolute paths
- [ ] Issues include solutions and impact
- [ ] Next Steps are specific and actionable

**Metadata Accuracy**:
- [ ] Status updated (in_progress → done/blocked)
- [ ] Agent label set
- [ ] Flags set correctly (has:*)
- [ ] Task closed if complete

**Context Completeness**:
- [ ] Future agent could resume work from this log
- [ ] All key decisions documented
- [ ] All blockers identified
- [ ] All findings captured

**Handover Readiness** (if applicable):
- [ ] Current state clearly described
- [ ] Blocker explicitly stated
- [ ] Attempted solutions documented
- [ ] Recommendation provided

---

## Summary

The Memory System is the foundation of APM's state management. Every action, decision, finding, and handover MUST be captured with the same richness whether using markdown files or Beads comments.

**Core Principles**:
1. **Comprehensive tracking**: No lost context
2. **Structured format**: Predictable, parseable
3. **Rich content**: Architecture, decisions, tradeoffs
4. **Proactive flagging**: Early visibility of issues
5. **Seamless handovers**: Zero context loss

**Beads Adaptation**:
- Same structure, different storage
- Comments replace files
- Labels replace YAML fields
- Same richness, same rigor

**Success Metrics**:
- Future agents can resume work seamlessly
- Manager Agent has complete visibility
- Audit trail is comprehensive
- Knowledge base grows over time

---

**Document Version**: 1.0 (Beads-Adapted)
**Created**: 2025-12-12
**Status**: Ready for Implementation Agent Use
