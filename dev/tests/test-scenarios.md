# v0.2.0 Test Scenarios and Validation Checklists

**Purpose**: Comprehensive testing plan for Beads + APM integration commands before production release.

**Version**: 0.2.0

**Last Updated**: 2025-12-12

---

## Table of Contents

1. [Overview](#overview)
2. [Test Environment Setup](#test-environment-setup)
3. [Command Test Scenarios](#command-test-scenarios)
   - [/apm-setup Tests](#apm-setup-tests)
   - [/apm-start Tests](#apm-start-tests)
4. [Beads Integration Tests](#beads-integration-tests)
5. [Guide Preservation Tests](#guide-preservation-tests)
6. [Error Handling Tests](#error-handling-tests)
7. [Validation Checklists](#validation-checklists)
8. [Success Criteria](#success-criteria)

---

## Overview

### Testing Goals

1. **Functional Correctness**: Commands work as specified
2. **Beads Integration**: State tracking provides equivalent/better visibility than markdown logs
3. **Guide Preservation**: APM methodology remains intact
4. **Error Resilience**: Graceful handling of edge cases
5. **User Experience**: Clear, helpful, actionable

### Testing Approach

- **Happy Path**: Commands work in ideal conditions
- **Error Cases**: Commands handle failures gracefully
- **Edge Cases**: Boundary conditions and unusual inputs
- **Integration**: Beads tracking provides complete visibility
- **Regression**: Existing guides remain functional

---

## Test Environment Setup

### Prerequisites

```bash
# Verify Beads is installed
bd --version

# Verify Claude Code CLI is operational
claude --version

# Create clean test project directory
mkdir -p ~/test-apm-project
cd ~/test-apm-project

# Initialize git (if commands expect it)
git init
git config user.name "Test User"
git config user.email "test@example.com"

# Copy dev commands to test location
cp -r /path/to/beads-apm-integration/dev/.claude .
cp -r /path/to/beads-apm-integration/dev/.apm .
```

### Clean State Verification

```bash
# Ensure no existing Beads state
bd stats  # Should show "No issues found" or similar

# Ensure no APM state files
ls -la .apm/  # Should only contain guides/

# Verify commands are available
ls .claude/commands/  # Should show apm-setup.md, apm-start.md
```

---

## Command Test Scenarios

### /apm-setup Tests

#### Test 1.1: Happy Path - Complete Setup Flow

**Objective**: Verify full setup flow from start to finish with user providing good responses.

**Steps**:
1. Run `/apm-setup` in Claude Code
2. Respond to Context Synthesis Round 1 (existing material)
3. Respond to Context Synthesis Round 2 (targeted inquiry)
4. Respond to Context Synthesis Round 3 (requirements)
5. Respond to Context Synthesis Round 4 (validation)
6. Approve project breakdown
7. Skip systematic review
8. Approve final validation

**Expected Behavior**:
- Agent follows 4-round Context Synthesis flow
- Agent creates Beads issues with proper structure
- Agent verifies no circular dependencies
- Agent presents summary and gets approval
- User sees clear next step: `/apm-start`

**Beads Verification**:
```bash
# After setup completes
bd stats                  # Should show issue count
bd list                   # Should show all created issues
bd ready                  # Should show ready tasks
bd blocked                # Should show blocked tasks
bd dep cycles             # Should show "No cycles found"
```

**Success Criteria**:
- [ ] All 4 Context Synthesis rounds completed
- [ ] Issues created with title, description, type, labels
- [ ] Dependencies properly linked (blocker/blocked relationships)
- [ ] No circular dependencies detected
- [ ] Summary presented with clear metrics
- [ ] User received next step instruction

---

#### Test 1.2: Context Synthesis - Minimal Responses

**Objective**: Test behavior when user provides minimal/brief responses.

**Steps**:
1. Run `/apm-setup`
2. Provide very brief answers to all questions
3. Observe if agent probes deeper or accepts minimal input

**Expected Behavior**:
- Agent should probe for more detail when responses are too brief
- Agent should synthesize reasonable context from minimal input
- Agent should not get stuck in infinite questioning loop

**Success Criteria**:
- [ ] Agent requests elaboration on vague answers
- [ ] Agent makes reasonable inferences
- [ ] Agent proceeds to breakdown after sufficient context

---

#### Test 1.3: Project Breakdown - Complex Dependencies

**Objective**: Test dependency management with complex task graph.

**Steps**:
1. Complete Context Synthesis with requirements that create complex dependencies
2. Observe project breakdown structure
3. Verify dependency graph correctness

**Test Cases**:
- Linear dependencies (A → B → C)
- Parallel dependencies (A → B, A → C)
- Diamond dependencies (A → B, A → C, B → D, C → D)
- Multiple producers (A → C, B → C)

**Beads Verification**:
```bash
bd show <issue-id>        # Check "Depends on" section
bd blocked                # Verify blocked tasks show correct blockers
bd dep cycles             # Ensure no cycles introduced
```

**Success Criteria**:
- [ ] Dependencies correctly represent task relationships
- [ ] No circular dependencies created
- [ ] `bd ready` shows only tasks with no unmet dependencies
- [ ] `bd blocked` accurately identifies blockers

---

#### Test 1.4: Systematic Review - High-Value Selection

**Objective**: Test optional review flow when user opts in.

**Steps**:
1. Complete project breakdown
2. Choose "Systematic Review" option
3. Allow agent to propose high-value review areas
4. Select specific issues for review
5. Verify review analysis quality

**Expected Behavior**:
- Agent proposes review areas based on complexity, critical path, requirements
- Agent applies systematic analysis (per Project_Breakdown_Review_Guide.md)
- Agent updates issues based on findings
- Agent presents changes for user approval

**Success Criteria**:
- [ ] Agent identifies high-value review targets
- [ ] Agent performs thorough analysis
- [ ] Issues updated with refined requirements
- [ ] User approves changes before proceeding

---

#### Test 1.5: Error Case - Beads Not Available

**Objective**: Test graceful failure when Beads is not installed/accessible.

**Setup**:
```bash
# Temporarily make bd command unavailable
alias bd='echo "bd: command not found" && exit 127'
```

**Steps**:
1. Run `/apm-setup`
2. Observe agent response when `bd stats` fails

**Expected Behavior**:
- Agent detects Beads unavailability
- Agent provides clear error message
- Agent instructs user to install Beads
- Agent does not continue with broken state

**Success Criteria**:
- [ ] Clear error message displayed
- [ ] Installation instructions provided
- [ ] Agent halts setup gracefully

---

#### Test 1.6: Edge Case - Empty Project (No Existing Material)

**Objective**: Test setup with greenfield project (no existing code/docs).

**Steps**:
1. Run `/apm-setup` in completely empty directory
2. Answer Round 1 with "No existing material"
3. Provide vision and requirements in subsequent rounds

**Expected Behavior**:
- Agent adapts to greenfield scenario
- Agent asks more visioning questions
- Agent creates appropriate breakdown for new project

**Success Criteria**:
- [ ] Agent handles "no existing material" gracefully
- [ ] Context Synthesis completes successfully
- [ ] Project breakdown appropriate for greenfield project

---

### /apm-start Tests

#### Test 2.1: Happy Path - First Task Execution

**Objective**: Verify Manager Agent correctly queries Beads and spawns Implementation Agent.

**Prerequisite**: Complete `/apm-setup` successfully

**Steps**:
1. Run `/apm-start`
2. Observe Manager Agent assess project state
3. Observe task selection and agent spawning
4. Verify Implementation Agent completes work
5. Check Beads state updates

**Expected Behavior**:
- Manager runs `bd stats`, `bd ready`, `bd list --status=in_progress`
- Manager selects appropriate task from ready queue
- Manager spawns Implementation Agent with Task tool
- Implementation Agent marks task as in_progress
- Implementation Agent logs progress
- Implementation Agent closes task with summary
- Manager verifies completion

**Beads Verification**:
```bash
# During execution
bd list --status=in_progress  # Should show active task

# After completion
bd show <completed-task-id>   # Should show status=done
bd comments <completed-task-id>  # Should show structured Memory Log
bd ready                      # Should show newly unblocked tasks
```

**Success Criteria**:
- [ ] Manager queries Beads for state
- [ ] Manager selects ready task
- [ ] Implementation Agent spawned with correct context
- [ ] Task status updated: ready → in_progress → done
- [ ] Structured Memory Log written
- [ ] Dependencies unblocked correctly

---

#### Test 2.2: Task Selection - Multiple Ready Tasks

**Objective**: Test Manager's prioritization logic with multiple ready tasks.

**Prerequisite**: Setup project with multiple parallel tasks

**Steps**:
1. Run `/apm-start` with 3+ tasks in ready state
2. Observe Manager's selection criteria
3. Verify selection rationale

**Expected Behavior**:
- Manager considers priority, criticality, dependencies, domain
- Manager explains selection rationale
- Manager assigns appropriate agent type

**Success Criteria**:
- [ ] Manager evaluates all ready tasks
- [ ] Selection criteria clearly articulated
- [ ] Reasonable prioritization applied

---

#### Test 2.3: Agent Assignment - Assignee Field Usage

**Objective**: Test Manager's use of assignee field from Beads issues.

**Setup**:
```bash
# Create issue with assignee
bd create --title="Research task" --assignee=explore
bd create --title="Implementation task" --assignee=general-purpose
bd create --title="Planning task" --assignee=plan
```

**Steps**:
1. Run `/apm-start`
2. Observe Manager read assignee from `bd show` output
3. Verify Manager uses correct agent type for spawning

**Beads Verification**:
```bash
bd show <issue-id>  # Check "Assignee:" field
```

**Success Criteria**:
- [ ] Manager reads assignee field correctly
- [ ] Manager uses assignee value for `subagent_type`
- [ ] Appropriate agent spawned for task type

---

#### Test 2.4: Dependency Context - Cross-Domain Handover

**Objective**: Test context transfer between tasks with dependencies.

**Setup**:
- Create Task A (domain: backend) → completed
- Create Task B (domain: frontend) → depends on Task A

**Steps**:
1. Complete Task A with structured Memory Log
2. Run `/apm-start` to start Task B
3. Verify Manager provides cross-domain context

**Expected Context**:
- Comprehensive integration steps (per Task_Assignment_Guide.md Section 1.3)
- Explicit file reading instructions
- All outputs, interfaces, usage patterns from Task A
- No assumption of familiarity

**Success Criteria**:
- [ ] Manager detects cross-domain dependency
- [ ] Manager provides comprehensive context
- [ ] Implementation Agent receives full handover
- [ ] No context gaps requiring clarification

---

#### Test 2.5: Quality Flags - Compatibility Concerns Detection

**Objective**: Test Manager's response to `has:compatibility-concerns` flag.

**Setup**:
```bash
# Complete task with compatibility flag
bd update <issue-id> --label="has:compatibility-concerns"
bd comments add <issue-id> "## Compatibility Concerns\nBreaking change: API format modified"
```

**Steps**:
1. Run `/apm-start` after flagged task completion
2. Observe Manager's flag detection
3. Verify Manager escalates to user

**Expected Behavior**:
- Manager runs `bd list --label="has:compatibility-concerns"`
- Manager reviews compatibility section
- Manager reports to user with context
- Manager awaits user guidance on migration

**Success Criteria**:
- [ ] Flag detected automatically
- [ ] Compatibility concerns surfaced to user
- [ ] User provided decision options
- [ ] Work prioritization adjusted based on user input

---

#### Test 2.6: Memory Log Verification - Structured Format

**Objective**: Verify Implementation Agents write complete Memory Logs.

**Steps**:
1. Run `/apm-start` to complete a task
2. After completion, verify Memory Log structure

**Beads Verification**:
```bash
bd comments <task-id>  # Read final comment
```

**Required Sections**:
- [ ] ## Summary
- [ ] ## Details
- [ ] ## Output
- [ ] ## Issues Encountered
- [ ] ## Next Steps

**Optional Sections** (if flags set):
- [ ] ## Compatibility Concerns
- [ ] ## Ad-Hoc Delegation
- [ ] ## Important Findings

**Content Quality**:
- [ ] Summary is one clear paragraph
- [ ] Details include architecture decisions
- [ ] Output lists files with absolute paths
- [ ] Issues include solutions and impact
- [ ] Next Steps are specific and actionable

**Success Criteria**:
- [ ] All required sections present
- [ ] Section order correct
- [ ] Content is detailed and actionable
- [ ] Markdown formatting preserved

---

#### Test 2.7: Debugging Protocol - Three-Attempt Limit

**Objective**: Test enforcement of three-attempt debugging limit.

**Setup**: Create task that will encounter debugging challenge

**Steps**:
1. Run `/apm-start` to spawn Implementation Agent
2. Observe debugging attempts in progress logs
3. Verify delegation after 3 attempts

**Expected Behavior**:
- Agent attempts solution 1, logs result
- Agent attempts solution 2, logs result
- Agent attempts solution 3, logs result
- Agent delegates to Debug Agent (or creates sub-task)
- Agent sets `has:ad-hoc-delegation` flag

**Beads Verification**:
```bash
bd comments <task-id>  # Should show 3 debug attempts
bd list --label="has:ad-hoc-delegation"  # Should show flagged task
bd list --parent=<task-id>  # Check for debug sub-task
```

**Success Criteria**:
- [ ] Exactly 3 attempts logged
- [ ] Delegation triggered appropriately
- [ ] Flag set correctly
- [ ] Context preserved for specialist

---

#### Test 2.8: Session Continuity - Resume After Interruption

**Objective**: Test Manager's ability to resume work after session ends.

**Steps**:
1. Run `/apm-start`, start 2 tasks
2. Simulate session interruption (close CLI)
3. Restart CLI, run `/apm-start` again
4. Verify Manager recovers state correctly

**Expected Behavior**:
- Manager queries Beads for current state
- Manager sees tasks in progress
- Manager continues from where work left off
- No handover documents needed

**Beads Verification**:
```bash
bd stats                      # Overview
bd list --status=in_progress  # Active tasks
bd comments <task-id>         # Work history
```

**Success Criteria**:
- [ ] Manager recovers state from Beads
- [ ] Work resumes seamlessly
- [ ] No context loss
- [ ] No duplicate work

---

#### Test 2.9: Error Case - No Ready Tasks

**Objective**: Test Manager behavior when no tasks are ready.

**Setup**:
```bash
# Create tasks, all blocked by dependencies
bd create --title="Task A"
bd create --title="Task B"
bd dep add B A  # B depends on A
```

**Steps**:
1. Run `/apm-start`
2. Observe Manager response to empty ready queue

**Expected Behavior**:
- Manager runs `bd ready`, gets empty result
- Manager checks `bd blocked` to understand why
- Manager reports to user: "No ready tasks. Blocked by: [dependencies]"
- Manager suggests resolving blockers or creating new tasks

**Success Criteria**:
- [ ] Manager detects empty ready queue
- [ ] Manager explains blocking situation
- [ ] Manager provides actionable suggestions

---

#### Test 2.10: Error Case - Invalid Agent Assignee

**Objective**: Test Manager behavior when assignee doesn't exist.

**Setup**:
```bash
# Create task with non-existent agent
bd create --title="Task X" --assignee=nonexistent-agent
```

**Steps**:
1. Run `/apm-start`
2. Observe Manager response to invalid assignee

**Expected Behavior**:
- Manager reads assignee: "nonexistent-agent"
- Manager checks if agent exists: `find .claude/agents -name "nonexistent-agent.md"`
- Manager finds no match
- Manager reports error to user with available agents
- Manager requests user update assignee

**Success Criteria**:
- [ ] Manager detects invalid assignee
- [ ] Manager lists available agents
- [ ] Manager requests user fix
- [ ] Manager does not proceed with invalid agent

---

## Beads Integration Tests

### Test 3.1: State Visibility - Equivalent to Markdown Logs

**Objective**: Verify Beads tracking provides equal or better visibility than markdown-based APM.

**Comparison Scenarios**:

| Markdown APM | Beads APM | Test |
|-------------|-----------|------|
| `tasks/backlog.md` | `bd list --status=open` | Compare output completeness |
| `tasks/in-progress.md` | `bd list --status=in_progress` | Compare active task visibility |
| `memory/task-abc-memory.md` | `bd comments task-abc` | Compare detail richness |
| Grep for "has_compatibility_concerns: true" | `bd list --label="has:compatibility-concerns"` | Compare query speed |
| Parse markdown for next task | `bd ready` | Compare usability |

**Success Criteria**:
- [ ] Beads queries are faster or equal speed
- [ ] Beads output is equally or more readable
- [ ] Beads filtering is more powerful (labels vs grep)
- [ ] No information loss compared to markdown

---

### Test 3.2: Dependency Tracking - Accuracy

**Objective**: Verify dependency relationships maintained correctly.

**Test Cases**:

```bash
# Create complex dependency graph
bd create --title="Foundation"
bd create --title="Feature A"
bd create --title="Feature B"
bd create --title="Integration"

bd dep add feature-a foundation
bd dep add feature-b foundation
bd dep add integration feature-a
bd dep add integration feature-b
```

**Verification**:
```bash
bd show foundation   # Should show: "Blocks: Feature A, Feature B"
bd show integration  # Should show: "Depends on: Feature A, Feature B"
bd ready             # Should show only "Foundation"
bd blocked           # Should show Feature A, Feature B, Integration
```

**After completing Foundation**:
```bash
bd close foundation
bd ready             # Should show Feature A, Feature B
bd blocked           # Should show only Integration
```

**Success Criteria**:
- [ ] Dependency relationships accurate
- [ ] `bd ready` correctly identifies unblocked tasks
- [ ] `bd blocked` shows correct blockers
- [ ] Completing tasks unblocks dependents

---

### Test 3.3: Audit Trail - Completeness

**Objective**: Verify Beads provides complete audit trail.

**Test Scenario**: Complete one task with multiple progress updates

**Beads Operations**:
```bash
bd update task-abc --status=in_progress
bd comments add task-abc "Started work on authentication"
bd comments add task-abc "Completed token generation"
bd comments add task-abc "Debug attempt 1: key encoding issue"
bd comments add task-abc "Resolved: using UTF-8 encoding"
bd comments add task-abc "[Complete Memory Log]"
bd close task-abc --reason="Successfully implemented"
```

**Verification**:
```bash
bd comments task-abc  # Should show all comments with timestamps
```

**Success Criteria**:
- [ ] All progress logged chronologically
- [ ] Timestamps accurate
- [ ] No lost updates
- [ ] Comments immutable (no accidental edits)

---

### Test 3.4: Cross-Session State Recovery

**Objective**: Verify state persists across sessions without handover files.

**Steps**:
1. Session 1: Start task, log progress, close session
2. Session 2: Query Beads, resume work, close session
3. Session 3: Query Beads, complete work

**Beads Queries** (each session):
```bash
bd stats
bd list --status=in_progress
bd show <task-id>
bd comments <task-id>
```

**Success Criteria**:
- [ ] State fully recoverable in each session
- [ ] No information loss between sessions
- [ ] No manual handover files needed
- [ ] Context complete for new agent

---

## Guide Preservation Tests

### Test 4.1: Context Synthesis Guide - Adherence

**Objective**: Verify `/apm-setup` follows Context_Synthesis_Guide.md correctly.

**Verification Method**: Compare agent behavior to guide specifications

**Guide Sections to Verify**:
- [ ] Four Question Rounds executed in order
- [ ] Round 1: Existing Material and Vision questions asked
- [ ] Round 2: Targeted Inquiry based on Round 1 responses
- [ ] Round 3: Requirements and Process questions asked
- [ ] Round 4: Final Validation summary provided
- [ ] User approval requested before breakdown

**Success Criteria**:
- [ ] All guide requirements met
- [ ] Question quality appropriate for each round
- [ ] Synthesis quality sufficient for breakdown

---

### Test 4.2: Project Breakdown Guide - Adherence

**Objective**: Verify `/apm-setup` follows Project_Breakdown_Guide.md correctly.

**Verification Method**: Compare breakdown to guide specifications

**Guide Sections to Verify**:
- [ ] Issues created with proper structure (title, description, type, labels)
- [ ] Dependencies linked correctly
- [ ] No circular dependencies
- [ ] Domain labels applied
- [ ] Assignee specified
- [ ] Done-when criteria included

**Success Criteria**:
- [ ] Breakdown structure matches guide
- [ ] Issue quality sufficient for implementation
- [ ] Dependency graph correct

---

### Test 4.3: Task Assignment Guide - Adherence

**Objective**: Verify `/apm-start` follows Task_Assignment_Guide.md correctly.

**Verification Method**: Compare Manager behavior to guide specifications

**Guide Sections to Verify**:
- [ ] Section 1.2: Same-domain context provided correctly
- [ ] Section 1.3: Cross-domain context comprehensive
- [ ] Section 3: Beads queries used as specified
- [ ] Agent selection follows decision framework

**Success Criteria**:
- [ ] Context quality matches guide requirements
- [ ] Query patterns match guide examples
- [ ] Agent selection appropriate

---

### Test 4.4: Agent Workflow Guide - Adherence

**Objective**: Verify agents follow Agent_Workflow_Guide.md correctly.

**Verification Method**: Compare agent behavior to guide specifications

**Guide Sections to Verify**:
- [ ] Manager workflow (Section: Manager Agent Workflow)
- [ ] Implementation workflow (Section: Implementation Agent Workflow)
- [ ] Quality standards enforced
- [ ] Debugging protocol followed

**Success Criteria**:
- [ ] Workflows match guide exactly
- [ ] Quality standards met
- [ ] No deviations from prescribed behavior

---

### Test 4.5: Memory System Guide - Adherence

**Objective**: Verify Memory Logs match Memory_System_Guide.md structure.

**Verification Method**: Compare Memory Log structure to guide template

**Guide Template Sections**:
- [ ] Summary (required)
- [ ] Details (required)
- [ ] Output (required)
- [ ] Issues Encountered (required)
- [ ] Next Steps (required)
- [ ] Compatibility Concerns (conditional)
- [ ] Ad-Hoc Delegation (conditional)
- [ ] Important Findings (conditional)

**Success Criteria**:
- [ ] Section order preserved exactly
- [ ] Content quality matches guide examples
- [ ] Optional sections present only when flagged

---

## Error Handling Tests

### Test 5.1: Beads Command Failures

**Scenarios to Test**:

```bash
# Scenario A: bd stats fails
bd stats  # Returns error

# Scenario B: bd create fails
bd create --title="Task"  # Returns error

# Scenario C: bd update fails
bd update task-abc --status=done  # Returns error

# Scenario D: bd comments fails
bd comments task-abc  # Returns error
```

**Expected Behavior**:
- Agent detects command failure
- Agent reports error to user with context
- Agent suggests remediation steps
- Agent does not continue with corrupted state

**Success Criteria**:
- [ ] Errors caught and reported clearly
- [ ] User provided remediation guidance
- [ ] State not corrupted by failed operations

---

### Test 5.2: Git Unavailable

**Scenario**: Project directory not a git repository

**Steps**:
1. Remove `.git` directory
2. Run `/apm-setup`
3. Observe agent behavior

**Expected Behavior**:
- Agent detects non-git environment
- Agent either: (a) continues without git, or (b) requests git init
- Agent does not fail silently

**Success Criteria**:
- [ ] Agent handles gracefully
- [ ] User informed of git status
- [ ] Clear path forward provided

---

### Test 5.3: Insufficient Permissions

**Scenario**: User lacks write permissions in directory

**Steps**:
1. Set directory to read-only
2. Attempt to run `/apm-setup`
3. Observe agent behavior

**Expected Behavior**:
- Agent detects permission issue
- Agent reports specific error
- Agent suggests permission fix

**Success Criteria**:
- [ ] Permission errors caught
- [ ] Clear error message displayed
- [ ] User knows how to resolve

---

## Validation Checklists

### Pre-Release Validation Checklist

**Functional Testing**:
- [ ] All happy path scenarios pass
- [ ] All error case scenarios handled gracefully
- [ ] All edge case scenarios handled correctly

**Beads Integration**:
- [ ] State visibility equal or better than markdown
- [ ] Dependency tracking accurate
- [ ] Audit trail complete
- [ ] Cross-session recovery works

**Guide Preservation**:
- [ ] Context Synthesis Guide followed
- [ ] Project Breakdown Guide followed
- [ ] Task Assignment Guide followed
- [ ] Agent Workflow Guide followed
- [ ] Memory System Guide followed

**Error Handling**:
- [ ] Beads command failures handled
- [ ] Git unavailability handled
- [ ] Permission issues handled

**Documentation**:
- [ ] README updated with test results
- [ ] Known issues documented
- [ ] Limitations clearly stated

**User Experience**:
- [ ] Commands intuitive
- [ ] Error messages helpful
- [ ] Progress visibility clear
- [ ] Next steps always obvious

---

### Post-Test Review Checklist

**Test Coverage**:
- [ ] All scenarios executed
- [ ] All success criteria verified
- [ ] All failure cases documented

**Issues Found**:
- [ ] Issues logged in Beads
- [ ] Severity assigned
- [ ] Reproduction steps documented
- [ ] Fixes prioritized

**Regression Prevention**:
- [ ] Test cases added for found issues
- [ ] Validation updated to catch similar issues
- [ ] Documentation updated with lessons learned

**Release Decision**:
- [ ] Critical issues resolved
- [ ] Known issues acceptable for v0.2.0
- [ ] Documentation complete
- [ ] Ready for production use

---

## Success Criteria

### Overall Success Criteria

**Must Have** (Blocking):
1. All happy path scenarios pass
2. Beads integration provides complete visibility
3. Memory Logs match guide structure exactly
4. No data loss or state corruption
5. Error handling prevents broken states

**Should Have** (Non-blocking):
1. All edge cases handled gracefully
2. Performance acceptable (< 5s for most operations)
3. User experience intuitive
4. Documentation comprehensive

**Nice to Have** (Future):
1. Progress bars for long operations
2. Rollback capability for failed operations
3. Validation mode (dry-run before execution)

---

### Beads vs Markdown Comparison

**Verification**: Beads tracking must provide equal or better:

| Metric | Markdown | Beads | Test Result |
|--------|----------|-------|-------------|
| State query speed | grep files | `bd list` | [PASS/FAIL] |
| Dependency tracking | Manual links | Native deps | [PASS/FAIL] |
| Audit trail | File history | Comments | [PASS/FAIL] |
| Flag filtering | grep YAML | Label queries | [PASS/FAIL] |
| Context recovery | Read files | `bd show` | [PASS/FAIL] |

**Pass Threshold**: Beads must equal or exceed markdown in all metrics.

---

### Guide Fidelity

**Verification**: Commands must preserve APM methodology:

| Guide | Fidelity Test | Result |
|-------|---------------|--------|
| Context Synthesis | 4 rounds executed correctly | [PASS/FAIL] |
| Project Breakdown | Issues structured per guide | [PASS/FAIL] |
| Task Assignment | Context templates applied | [PASS/FAIL] |
| Agent Workflow | Quality standards enforced | [PASS/FAIL] |
| Memory System | Logs match template exactly | [PASS/FAIL] |

**Pass Threshold**: 100% fidelity required. No deviations accepted.

---

## Test Execution Log Template

**Test Session**: [Date and Time]
**Tester**: [Name]
**Environment**: [OS, Beads version, Claude Code version]

### Test Results

| Test ID | Test Name | Status | Notes |
|---------|-----------|--------|-------|
| 1.1 | Happy Path Setup | PASS/FAIL | [Notes] |
| 1.2 | Minimal Responses | PASS/FAIL | [Notes] |
| 1.3 | Complex Dependencies | PASS/FAIL | [Notes] |
| ... | ... | ... | ... |

### Issues Found

| Issue ID | Severity | Description | Reproduction | Status |
|----------|----------|-------------|--------------|--------|
| BUG-001 | Critical | [Description] | [Steps] | Open/Fixed |
| BUG-002 | High | [Description] | [Steps] | Open/Fixed |

### Overall Assessment

**Ready for Release**: YES / NO
**Blocking Issues**: [List]
**Recommendations**: [List]

---

**End of Test Scenarios Document**
