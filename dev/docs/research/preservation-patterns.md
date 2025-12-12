# APM → Beads Preservation Patterns

**Document Purpose**: Guide Phase 2 agents on what to preserve vs. adapt when integrating Beads into APM methodology.

**Critical Principle**: APM's methodology is battle-tested. Our job is surgical replacement of state management (markdown → Beads), NOT redesigning the methodology.

---

## Table of Contents

1. [Critical Patterns to Preserve](#critical-patterns-to-preserve)
2. [Beads Integration Points](#beads-integration-points)
3. [Surgical Replacement Guidance](#surgical-replacement-guidance)
4. [What to Preserve vs Adapt](#what-to-preserve-vs-adapt)
5. [Agent-Specific Patterns](#agent-specific-patterns)
6. [Success Criteria](#success-criteria)

---

## Critical Patterns to Preserve

### 1. Question Round Iteration System

**PRESERVE COMPLETELY** - This is foundational to APM methodology.

**Pattern Structure**:
```
Question Round N (until complete):
1. Question: [specific question]
   Answer: [answer]

2. Question: [specific question]
   Answer: [answer]

Completion Check:
- [ ] All aspects covered?
- [ ] Ready to proceed?
```

**Why Critical**:
- Prevents premature convergence
- Forces thoroughness through iteration
- Creates natural checkpoints
- User maintains control via approval gates

**Beads Adaptation**:
- Question Rounds happen IN CHAT (not in Beads)
- Only FINAL outputs go into Beads
- Preserve the interleaving of chat (iteration) and file (commitment)

---

### 2. Chat-to-File Pattern Interleaving

**PRESERVE COMPLETELY** - Core to APM's pedagogical approach.

**Pattern**:
1. **Chat Phase**: Interactive Q&A, exploration, iteration
2. **File Phase**: Commit finalized decisions to persistent artifact
3. **Repeat**: Next phase starts in chat again

**Why Critical**:
- Chat = exploration space (low commitment)
- File = decision record (high commitment)
- Prevents "analysis paralysis" from over-documenting
- Allows course correction without losing work

**Beads Adaptation**:
- Chat → Beads Comment (for context/discussion)
- File → Beads Issue Fields + Attachments (for decisions)
- NEVER replace chat exploration with direct-to-Beads writes

---

### 3. Anti-Packing Guardrails

**PRESERVE COMPLETELY** - Prevents scope creep and complexity explosion.

**Pattern Examples**:
- "Each task MUST be achievable in 90 minutes or less"
- "If breakdown exceeds 15 tasks, STOP and challenge scope"
- "One clear outcome per task"
- "No 'miscellaneous' or 'utility' tasks"

**Why Critical**:
- Keeps work units manageable
- Forces prioritization
- Prevents waterfall-style upfront planning
- Maintains agility

**Beads Adaptation**:
- Checklist items become Beads validation commands
- Time estimates go in Beads `effort` field
- Scope challenges still happen in CHAT before creating issues

---

### 4. Analytical Challenge Framework

**PRESERVE COMPLETELY** - The "devil's advocate" quality gate.

**Pattern Structure**:
```
ANALYTICAL CHALLENGE:
For each [task/decision/breakdown]:

Challenge 1: Is this truly necessary?
- What happens if we skip it?
- What's the minimum viable version?

Challenge 2: Can this be combined/split?
- Are there hidden dependencies?
- Is this actually two tasks?

[Continue with framework-specific challenges]
```

**Why Critical**:
- Forces second-order thinking
- Catches hidden assumptions
- Prevents over-engineering
- Builds better mental models

**Beads Adaptation**:
- Challenges happen in CHAT (not Beads)
- Only validated outcomes go into Beads
- Challenge results can be logged as Beads comments for audit trail

---

### 5. User Approval Gates

**PRESERVE COMPLETELY** - User control is non-negotiable.

**Pattern**:
- Every phase transition requires explicit user approval
- No autonomous progression through workflow
- Clear "what I did / what I need" messaging

**Beads Adaptation**:
- Approval gates remain in CHAT
- Agent proposes next action, waits for approval
- Beads updates happen AFTER approval, not before

---

### 6. Agent Identity Registration

**PRESERVE COMPLETELY** - Critical for multi-agent coordination.

**Pattern**:
```yaml
---
agent: implementation-agent-X
task_ref: project-prefix-abc
session_start: 2024-01-15T10:30:00Z
---
```

**Why Critical**:
- Tracks which agent owns which work
- Prevents context collision
- Enables handover protocols
- Creates audit trail

**Beads Adaptation**:
- Agent ID → Beads custom field or label
- Task ref → Beads issue ID
- Session metadata → Beads comment or metadata
- Preserve exact validation protocol

---

### 7. Memory Log Structure

**PRESERVE EXACTLY** - This is the beating heart of APM's state management.

**Current Structure**:
```yaml
---
status: [in_progress|completed|blocked|delegated]
agent: [agent-id]
task_ref: [task-id]
has_compatibility_concerns: [true|false]
has_ad_hoc_delegation: [true|false]
has_important_findings: [true|false]
---

## Summary
[One-paragraph overview]

## Details
[Implementation specifics]

## Output
[Files created/modified with paths]

## Issues Encountered
[Problems and solutions]

## Next Steps
[What's next]

## Compatibility Concerns (if flag = true)
[Backward compatibility issues]

## Ad-Hoc Delegation (if flag = true)
[Delegated work details]

## Important Findings (if flag = true)
[Discoveries affecting project scope]
```

**Beads Mapping** (1:1 SURGICAL):
```
YAML Frontmatter → Beads Fields:
  status           → issue.status (in_progress, done, blocked)
  agent            → issue.labels or custom field
  task_ref         → issue.id (native)
  has_*_flags      → issue.labels (e.g., "has:compatibility-concerns")

Markdown Sections → Beads Comment Sections:
  Summary          → Comment section: ## Summary
  Details          → Comment section: ## Details
  Output           → Comment section: ## Output (or attachment references)
  Issues           → Comment section: ## Issues Encountered
  Next Steps       → Comment section: ## Next Steps
  [Conditional]    → Comment sections (only if flag = true)
```

**Critical Rules**:
- ✅ Preserve ALL 5 required sections
- ✅ Preserve ALL 3 optional sections (conditional on flags)
- ✅ Preserve section order exactly
- ✅ Preserve content guidelines for each section
- ✅ Map boolean flags to Beads labels/fields
- ❌ Do NOT merge sections
- ❌ Do NOT rename sections
- ❌ Do NOT change conditional logic

---

### 8. Three-Attempt Debug Limit

**PRESERVE COMPLETELY** - Prevents infinite debugging loops.

**Pattern**:
```
Attempt 1: [try solution]
Attempt 2: [try different approach]
Attempt 3: [final attempt]

If still failing → DELEGATE to Debug Agent
```

**Why Critical**:
- Prevents resource waste
- Forces escalation to specialists
- Maintains progress momentum

**Beads Adaptation**:
- Track attempts in Beads comments
- Delegation trigger creates new Beads issue
- Link delegated issue to parent issue

---

### 9. Same-Agent vs Cross-Agent Context

**PRESERVE DISTINCTION** - Critical for context efficiency.

**Pattern**:
- **Same-Agent**: Minimal context (agent has memory)
- **Cross-Agent**: Full context (new agent needs everything)

**Why Critical**:
- Reduces token waste
- Speeds up execution
- Prevents context window overflow

**Beads Adaptation**:
- Same-agent: Reference previous Beads comment IDs
- Cross-agent: Full context in new issue description
- Preserve context packaging patterns from guides

---

## Beads Integration Points

### Integration Point 1: Setup Phase → Beads Initialization

**Current State**: `/apm-setup` creates markdown files
**Beads State**: Initialize Beads project structure

**Surgical Changes**:
```diff
- Create .apm/state/context-synthesis.md
- Create .apm/state/project-breakdown.md
+ bd init (if not already initialized)
+ bd create --title="Context Synthesis" --status=todo
+ bd create --title="Project Breakdown" --status=todo
```

**Preserve**:
- Guide file content (no changes to `.apm/guides/`)
- Slash command workflow
- User approval at each step

---

### Integration Point 2: Manager Agent → Task Queue

**Current State**: Reads markdown task list from `task-queue.md`
**Beads State**: Query Beads for available work

**Surgical Changes**:
```diff
- Read .apm/state/task-queue.md
- Parse markdown checklist
+ bd ready (get tasks with status=ready)
+ bd list --status=in_progress (check active work)
```

**Preserve**:
- Task assignment logic
- Workload balancing
- Priority ordering
- Agent availability checks

---

### Integration Point 3: Implementation Agent → Memory Log

**Current State**: Creates `.apm/memory/task-abc-memory.md`
**Beads State**: Adds structured comment to Beads issue

**Surgical Changes**:
```diff
- Write markdown file with YAML frontmatter
+ bd comments add task-abc --comment="<structured content>"

Content mapping:
- YAML frontmatter → Beads labels/fields
- Markdown sections → Comment sections (preserve structure)
```

**Preserve**:
- Exact Memory Log structure (all 5+3 sections)
- Boolean flag logic
- Content guidelines per section
- Status transition rules

---

### Integration Point 4: Ad-Hoc Delegation → Sub-Task Creation

**Current State**: Manual tracking in Memory Log
**Beads State**: Create child issue with parent link

**Surgical Changes**:
```diff
- Document delegation in "Ad-Hoc Delegation" section
+ bd create --parent=task-abc --title="Debug: [issue]"
+ bd update task-abc --label="has:ad-hoc-delegation"
```

**Preserve**:
- 3-step delegation workflow
- User confirmation requirement
- Session isolation (still use Task tool)
- Findings integration pattern

---

### Integration Point 5: Handover Protocol → Context Transfer

**Current State**: Create handover markdown file
**Beads State**: Transfer via Beads comment + status change

**Surgical Changes**:
```diff
- Create .apm/handover/handover-123.md
+ bd comments add task-abc --comment="## Handover\n[context]"
+ bd update task-abc --status=blocked --label="needs:handover"
```

**Preserve**:
- Handover triggers (context window limits, blockers)
- Context packaging structure
- Next agent instructions
- Clear resumption point

---

## Surgical Replacement Guidance

### Principle: Minimal Viable Change

**Rule**: Change ONLY the state management layer. Everything else stays identical.

**Example**:

❌ **Bad** (redesigning methodology):
```markdown
# NEW APM Workflow with Beads

1. Create all tasks upfront in Beads
2. Use Beads API for everything
3. Remove Question Rounds (use Beads comments instead)
```

✅ **Good** (surgical replacement):
```markdown
# APM Workflow (Beads-Adapted)

1. Context Synthesis (unchanged)
   - Question Rounds in chat
   - Final synthesis → bd create "Context Synthesis"

2. Project Breakdown (unchanged)
   - Analytical challenges in chat
   - Final breakdown → bd create for each task
```

---

### Replacement Checklist

For each guide update:

**Before Making Changes**:
- [ ] Read original guide completely
- [ ] Identify ONLY state management sections
- [ ] Confirm methodology patterns are preserved
- [ ] Draft changes as additive (not replacements)

**During Changes**:
- [ ] Replace markdown operations with Beads commands
- [ ] Keep all methodology text identical
- [ ] Add Beads examples that mirror markdown examples
- [ ] Preserve all section structures

**After Changes**:
- [ ] Verify no methodology changes
- [ ] Check all examples still work
- [ ] Confirm approval gates remain
- [ ] Test complete workflow end-to-end

---

### Common Pitfalls to Avoid

#### Pitfall 1: Over-Integration
❌ "Since we have Beads, let's track Question Rounds as sub-issues"
✅ Question Rounds stay in chat; only final outputs go to Beads

#### Pitfall 2: Premature Optimization
❌ "Let's redesign Memory Log structure to fit Beads better"
✅ Map Memory Log 1:1 to Beads comment structure

#### Pitfall 3: Skipping User Control
❌ "Automate task creation since Beads makes it easy"
✅ Preserve approval gates; Beads executes AFTER approval

#### Pitfall 4: Methodology Drift
❌ "This anti-packing rule seems outdated with Beads"
✅ All methodology rules are sacred; adapt state only

---

## What to Preserve vs Adapt

### ✅ PRESERVE (Do NOT Change)

| Element | Why Sacred | Location |
|---------|-----------|----------|
| Question Round structure | Core iteration mechanism | All Setup guides |
| Anti-packing guardrails | Prevents scope creep | Project Breakdown |
| Analytical challenges | Quality gate | Project Breakdown Review |
| User approval gates | Maintains control | All guides |
| Memory Log sections (5+3) | State contract | Memory Log Guide |
| Chat-to-file interleaving | Pedagogical pattern | All guides |
| 3-attempt debug limit | Resource management | Implementation Agent |
| Agent identity protocol | Multi-agent coordination | All agent guides |
| Same-agent vs cross-agent context | Token efficiency | Memory System |
| Ad-hoc delegation workflow | Specialist escalation | Agent Workflow |

### 🔧 ADAPT (Surgical Changes Only)

| Element | What Changes | How to Adapt |
|---------|--------------|--------------|
| State file creation | markdown → Beads issue | `bd create` with same content |
| Status tracking | markdown checkbox → Beads status | `bd update --status=` |
| Task querying | file read → Beads query | `bd ready`, `bd list` |
| Memory logging | file write → Beads comment | `bd comments add` with structure |
| Context handover | markdown file → Beads comment | Same structure, different medium |
| Sub-task delegation | manual tracking → child issue | `bd create --parent=` |
| Agent assignment | markdown tag → Beads field | Label or custom field |
| Progress tracking | markdown update → status change | `bd update --status=` |

---

## Agent-Specific Patterns

### Setup Agent (Context Synthesis + Project Breakdown)

**Preserve**:
- 4-step workflow: Context → Breakdown → Review → Bootstrap
- Question Round iteration (N rounds until complete)
- Analytical Challenge framework
- User approval between each step
- Anti-packing validation (15-task limit)

**Adapt**:
- Final context → `bd create "Context Synthesis" --description="[synthesis]"`
- Each task → `bd create --title="[task]" --effort=[estimate]`
- No more `.apm/state/project-breakdown.md`

**Critical Success Factor**:
- Question Rounds MUST stay in chat
- Only validated, approved outputs go to Beads

---

### Manager Agent (Task Orchestration)

**Preserve**:
- Bootstrap handover protocol (from Setup)
- Task assignment algorithm (priority + effort + dependencies)
- Workload balancing (max 2 concurrent tasks/agent)
- Cross-agent context packaging
- Memory Log monitoring (flags, status)

**Adapt**:
- Task queue read → `bd ready` (get available tasks)
- Active work check → `bd list --status=in_progress`
- Assignment → `bd update task-abc --assign=agent-X --status=in_progress`
- Status monitoring → `bd list --label="has:compatibility-concerns"`

**Critical Success Factor**:
- Assignment logic MUST be identical
- No autonomous task progression

---

### Implementation Agent (Task Execution)

**Preserve**:
- Agent identity registration (exact validation)
- Memory Log structure (5 required + 3 optional sections)
- Boolean flag logic (compatibility, delegation, findings)
- 3-attempt debug limit
- Ad-hoc delegation protocol
- Task Report format (user-facing)

**Adapt**:
- Memory Log file → Beads comment (1:1 structure mapping)
- YAML frontmatter → Beads fields/labels
- Status updates → `bd update --status=`
- Flag activation → `bd update --label="has:*"`

**Critical Success Factor**:
- Memory Log structure CANNOT change
- All 8 sections must map exactly

**Detailed Mapping**:
```
Memory Log YAML → Beads:
  status: completed                     → bd update --status=done
  agent: impl-agent-3                   → bd update --label="agent:impl-agent-3"
  task_ref: proj-abc                    → (native issue ID)
  has_compatibility_concerns: true      → bd update --label="has:compatibility-concerns"
  has_ad_hoc_delegation: true           → bd update --label="has:ad-hoc-delegation"
  has_important_findings: false         → (no label)

Memory Log Sections → Beads Comment:
---
## Summary
[one-paragraph overview]

## Details
[implementation specifics]

## Output
- File: /path/to/file.ts (lines 10-50)
- Modified: /path/to/other.ts (lines 5-20)

## Issues Encountered
1. [Issue description]
   - Solution: [how resolved]

## Next Steps
- [ ] [next action]
- [ ] [next action]

## Compatibility Concerns (only if flag = true)
[backward compatibility details]

## Ad-Hoc Delegation (only if flag = true)
- Agent Type: Debug
- Reason: [why delegated]
- Outcome: [what was learned]

## Important Findings (only if flag = true)
[discoveries that affect project scope]
---

Command:
bd comments add proj-abc --comment="$(cat <<'EOF'
[paste exact structure above]
EOF
)"
```

---

### Ad-Hoc Agents (Debug + Research)

**Preserve**:
- 3-step workflow: Request → Confirm → Isolate
- User confirmation requirement (NEVER skip)
- Session isolation via Task tool
- Findings integration via markdown code blocks
- Re-delegation protocol (if complexity exceeds scope)

**Adapt**:
- Delegation request → New Beads issue with parent link
- Context provision → Issue description (YAML+markdown structure)
- Findings → Beads comment on parent issue
- Re-delegation → Create new child issue, update flags

**Critical Success Factor**:
- User confirmation MUST happen before Task tool spawn
- Session isolation via Task tool is NON-NEGOTIABLE
- Findings MUST transfer back to parent issue

---

## Success Criteria

### Phase 2 is Successful If:

1. ✅ **Zero Methodology Changes**
   - Every Question Round pattern preserved
   - Every anti-packing rule enforced
   - Every approval gate maintained
   - Every analytical challenge present

2. ✅ **1:1 State Mapping**
   - Memory Log structure identical (just different storage)
   - All YAML fields map to Beads fields/labels
   - All 8 sections (5+3) present in Beads comments
   - Boolean flag logic preserved exactly

3. ✅ **Workflow Continuity**
   - Setup → Manager → Implementation flow unchanged
   - Agent handover protocols work identically
   - Ad-hoc delegation triggers at same points
   - User experience feels identical (just different backend)

4. ✅ **Guide Quality**
   - Original guide text 90%+ preserved
   - Only state management sections modified
   - Examples updated to show Beads commands
   - Tone, structure, pedagogy unchanged

5. ✅ **Backward Compatibility Knowledge**
   - All agents know markdown-based v0.1.0 existed
   - Guides reference both versions where helpful
   - Migration path documented (if users have old projects)

---

### Validation Questions

Before declaring Phase 2 complete, answer:

1. **Can a user who learned v0.1.0 (markdown) understand v0.2.0 (Beads)?**
   - If no → methodology changed too much

2. **Does Memory Log comment structure match file structure exactly?**
   - If no → 1:1 mapping failed

3. **Do Question Rounds still happen in chat?**
   - If no → chat-to-file pattern broken

4. **Are there approval gates before every Beads state change?**
   - If no → user control compromised

5. **Can we export Beads data and recreate markdown files identically?**
   - If no → data fidelity lost

---

## Conclusion

**Guiding Principle**: APM methodology is a finely-tuned system. We're replacing the storage engine (markdown → Beads), not redesigning the car.

**For Phase 2 Agents**:
- Read this document before touching any guide
- When in doubt, preserve the original
- Beads is a tool, not a reason to change methodology
- Every change must pass the "why can't this stay the same?" test

**Success Looks Like**:
- User runs `/apm-setup` → Same experience, Beads backend
- Manager assigns tasks → Same logic, Beads queries
- Implementation agent logs work → Same structure, Beads comments
- Workflow feels identical, just more robust storage

---

**Document Version**: 1.0
**Created**: 2025-12-12
**Phase**: 1 → 2 Transition Guide
**Status**: Ready for Phase 2 Reference
