# Project Breakdown Review Guide
This guide defines how Setup Agents conduct targeted, user-selected review of Beads issues to detect and fix critical task quality issues. Using fresh context from issue creation, agents propose specific areas for systematic review and let users choose which issues receive detailed analysis.

---

## 1. Review Protocol Overview

### Review Purpose
Conduct systematic review on user-selected Beads issues to identify and fix critical task quality issues:
- Task packing violations (multiple distinct activities in one task)
- Classification errors (wrong single-step vs multi-step designation)
- Template matching patterns (rigid formatting across tasks)
- User requirement compliance failures (Context Synthesis requirements missing)
- Task execution scope errors (external platform assumptions)

### Context-Driven Review Methodology
**Agent Proposal → User Selection → Targeted Systematic Review → Comprehensive Fixing**

**Review Workflow:**
1. **Intelligent Proposal**: Agent analyzes fresh Implementation Plan context to recommend review areas
2. **User Selection**: User chooses which tasks/phases receive systematic review
3. **Systematic Analysis**: Apply full testing methodology only to selected areas
4. **Comprehensive Fixing**: Fix all issues in selected areas, ensure strict adherence to the established format
5. **Final User Review**: Present complete updated plan for approval

**Efficiency**: Full systematic review power applied only where most valuable

---

## 2. Intelligent Review Area Proposal

### 2.1. Context Analysis for Proposal Generation
**Leverage fresh Beads issue creation context to identify high-value review targets:**

**Immediate Context Awareness:**
- **Complex Multi-Step Tasks**: Tasks with 6+ steps that might need splitting
- **Technology Span**: Tasks covering multiple domains or skill areas
- **Critical Path Items**: Tasks with multiple dependencies or cross-agent handoffs
- **User Requirement Areas**: Sections containing emphasized Context Synthesis elements
- **External Integration Points**: Tasks involving deployment, configuration, or platform coordination

### 2.2. Proposal Categories
**Recommend review areas based on detected patterns:**

**High-Complexity Areas:**
- Phases with multiple 6+ step tasks
- Tasks spanning different technology domains
- Sections with dense cross-agent dependencies

**Critical Path Areas:**
- Tasks that block multiple other tasks
- Cross-agent handoff points
- External platform integration tasks

**User Requirement Areas:**
- Sections implementing emphasized Context Synthesis requirements
- Tasks involving user-specific preferences or constraints

**Pattern Concern Areas:**
- Groups of tasks with identical formatting
- Sections that might have template matching issues

### 2.3. Proposal Presentation Format
**Present clear, actionable recommendations to user:**

**Format Structure:**
```markdown
## Systematic Review Recommendations

Based on the Beads issues I just created, I recommend systematic review for:

**High-Complexity Areas:**
- **[Phase/Task ID]** ([complexity indicators: multi-step count, domain span, etc.])
- **[Phase/Task ID]** ([specific complexity reasoning])

**Critical Path Areas:**
- **[Phase/Task ID]** ([dependency description and impact])
- **[Phase/Task ID]** ([external coordination requirements])

**User Requirement Integration:**
- **[Phase/Task ID]** ([specific Context Synthesis requirements implemented])

**Pattern Concerns:**
- **[Task Range]** ([template matching or formatting issues identified])

**Recommendation:** Focus systematic review on [highest-value selections] for maximum impact.

**Your Choice:** Select any combination of the above recommendations, or specify other tasks/phases you'd like reviewed. I'll apply full systematic analysis only to your selected areas.
```

**Proposal Guidelines:**
- Limit recommendations to 4-6 items maximum for clear decision-making
- Provide specific reasoning for each recommendation
- Highlight 1-2 top priorities for user guidance
- Always offer user flexibility to modify selections

---

## 3. User Selection Process

### 3.1. Selection Options
**Flexible selection allowing user control:**

**Selection Formats User Can Choose:**
- **Full Phase Selection**: "Review [Phase X]" (all tasks in specified phase)
- **Multiple Phases**: "Review [Phases X and Y]" (multiple complete phases)
- **Individual Tasks**: "Review [Task X.Y] and [Task Z.A]" (specific task selections)
- **Task Ranges**: "Review [Tasks X.Y-X.Z]" (sequential task groups)
- **Mixed Combinations**: "Review [Phase X] and [Task Y.Z]" (phases plus individual tasks)
- **Exclusion Approach**: "Review everything except [Phase/Task identifiers]" (comprehensive minus exclusions)

**Additional Selection Capabilities:**
- User can add tasks not included in agent recommendations
- User can request focus on specific aspects (classification, packing, requirements integration)
- User can modify agent recommendations by adding or removing items

### 3.2. Selection Confirmation
**Clear confirmation of review scope before proceeding:**

**Confirmation Format:**
```markdown
**Selected for Systematic Review:**
- [Phase/Task selections with task counts]
- [Individual task selections]
- [Any special focus areas requested]

**Total:** [X] tasks receiving full systematic analysis
**Proceeding with systematic review of selected areas...**
```

**Confirmation Requirements:**
- List all selected phases and individual tasks
- Provide total task count for scope clarity
- Confirm any special focus areas or constraints
- Obtain explicit user approval before proceeding

---

## 4. Systematic Analysis (Selected Areas Only)

### 4.1. Critical Review Methodology
**Challenge previous decisions using analytical questioning to identify genuine improvements:**

**CRITICAL**: The Setup Agent just created these tasks using specific reasoning. The systematic review must analytically challenge that reasoning to find genuine improvement opportunities, not simply confirm previous decisions.

### 4.2. Analytical Testing Framework
**For each selected task, apply structured analytical questioning:**

**Task [X.Y]: [Task Name] - Systematic Review**

**Scope Analysis:**
- **Current Decision**: "For this task, I chose to [scope decision]. Why is this not [alternative scope approach]?"
- **Complexity Assessment**: "This task has [X] steps/components. Can I break it into 2 or more focused tasks? What would be the benefits/drawbacks?"
- **Domain Evaluation**: "I assigned this to [Agent]. Would [Alternative Agent] be better suited? What specific domain knowledge does this require?"

**Classification Analysis:**
- **Current Format**: "I chose [single-step/multi-step] format. What specific factors support/challenge this classification?"
- **Validation Points**: "Does this task need user confirmation points? Where could an Implementation Agent get stuck without guidance?"
- **Workflow Efficiency**: "Would this be more efficient as [alternative classification]? What validation is truly necessary?"

**Implementation Feasibility:**
- **Agent Capability**: "What specific assumptions am I making about Implementation Agent capabilities? Which assumptions might be incorrect?"
- **Context Requirements**: "If an Implementation Agent receives this task with minimal context, what would they need clarified?"
- **Execution Challenges**: "What are the most likely points of failure during task execution? How can the task specification address these?"
- **Meta-Fields**: "Do the 'Objective', 'Output', and 'Guidance' fields provide clear, concise direction for the Manager Agent?"

**Requirement Integration:**
- **Context Synthesis Alignment**: "Which Context Synthesis requirements apply to this task? Are they explicitly integrated or assumed?"
- **User Coordination**: "What external actions does this task require? Are user coordination steps clearly specified?"
- **Output Clarity**: "Are the task outputs specific enough for the next Implementation Agent to integrate? What could be ambiguous?"

**Alternative Approaches:**
- **Different Organization**: "Could this work be structured as [alternative approach]? What would be the advantages?"
- **Dependency Optimization**: "Are the dependencies for this task optimal? Could reorganization reduce coordination overhead?"

### 4.3. Systematic Analysis Execution
**Apply analytical framework to each selected task:**

**Task [X.Y]: [Task Name] - Analysis Results**

1. **Scope Analysis Results**:
   - Alternative Scope Consideration: [Analysis and decision]
   - Task Splitting Assessment: [Benefits/drawbacks evaluated, decision with reasoning]
   - Agent Assignment Review: [Domain fit analysis and confirmation/change]

2. **Classification Analysis Results**:
   - Format Justification: [Factors supporting current classification or change needed]
   - Validation Point Assessment: [User confirmation needs analyzed]
   - Efficiency Evaluation: [Workflow optimization opportunities identified/confirmed]

3. **Implementation Feasibility Results**:
   - Capability Assumptions Review: [Assumptions validated or corrections identified]
   - Context Requirements Analysis: [Clarifications needed or sufficiency confirmed]
   - Failure Point Mitigation: [Potential issues identified and addressed]

4. **Requirement Integration Results**:
   - Context Synthesis Integration: [Requirements explicitly added or integration confirmed]
   - User Coordination Clarity: [External action steps clarified or confirmed]
   - Output Specification Review: [Ambiguities resolved or clarity confirmed]

5. **Alternative Approach Results**:
   - Structural Alternatives: [Alternative approaches considered, current justified or changed]
   - Dependency Optimization: [Coordination improvements identified or current confirmed]

**Overall Assessment**: [Improvements implemented / Current approach validated with specific reasoning]

### 4.4. Quality Enhancement Requirements
**Ensure constructive challenge of previous decisions:**

**Analytical Standards:**
- Each selected task must be examined from multiple analytical perspectives based on §4.2 and §4.3
- Current decisions must be explicitly justified when maintained
- Alternative approaches must be genuinely considered, not dismissed

**Evidence-Based Analysis:**
- "I initially chose approach X based on reasoning Y. Upon review, consideration Z suggests improvement A"
- "While the current structure appears sound, implementation feasibility analysis reveals optimization opportunity B"
- "Task specification review confirms adequacy but identifies enhancement C for Implementation Agent clarity"
- "Current choices are correct because of factors X, Y, and Z; analysis of alternatives indicates that no other approach would provide additional benefit in this context"

**Constructive Challenge Process:**
- Question each significant decision made during initial task creation
- Consider Implementation Agent perspective throughout analysis
- Identify specific improvement opportunities rather than general critique
- Maintain focus on task execution success and clarity

### 4.5. Issue Documentation
**Track all improvements identified in selected areas:**

**Documentation Format:**
```markdown
**Improvements Identified in Selected Areas:**
- [Task ID]: [Improvement type] ([enhancement applied])
- [Task ID]: [Optimization identified] ([modification made])
- [Task Range]: [Pattern improvement] ([systematic enhancement applied])
```

**Documentation Requirements:**
- List each task with improvements identified during systematic review
- Specify improvement type (scope optimization, classification refinement, requirement integration, etc.)
- Document specific enhancement applied
- Group similar improvements for clarity
- Note tasks where current approach was validated through analysis

---

## 5. Comprehensive Fixing & Pattern Application

### 5.1. Selected Area Fixes
**Apply all identified fixes to selected tasks via Beads updates:**

**Fix Types and Beads Operations:**

**Task Splitting (Packing Violations):**
```bash
# Create new split tasks
bd create --title="[Original Task] - Part 1: [Focused Scope]" \
  --type=task \
  --description="[First component details]" \
  --effort="[time estimate]"

bd create --title="[Original Task] - Part 2: [Focused Scope]" \
  --type=task \
  --description="[Second component details]" \
  --effort="[time estimate]"

# Update dependencies if needed
bd dep add <new-task-1> <predecessor-task>
bd dep add <new-task-2> <new-task-1>
bd dep add <successor-task> <new-task-2>

# Close original packed task
bd close <original-task-id> --reason="Split into focused tasks [new-task-1] and [new-task-2] to address packing violation"
```

**Classification Corrections:**
```bash
# Update task description to reflect correct classification
bd update <task-id> --description="[Updated description with correct format and validation points]"

# Add comments to document classification change reasoning
bd comments add <task-id> "REVIEW: Changed classification from [old] to [new] because [specific reasoning]"
```

**Requirement Integration:**
```bash
# Update task to include missing Context Synthesis requirements
bd update <task-id> --description="[Enhanced description with explicit user requirements]"

# Document requirement additions
bd comments add <task-id> "REVIEW: Added Context Synthesis requirements: [list of requirements integrated]"
```

**Template Matching Resolution:**
```bash
# Update task descriptions to vary formatting appropriately
bd update <task-id> --description="[Revised description with task-specific formatting]"

# Note pattern fix
bd comments add <task-id> "REVIEW: Revised formatting to match task-specific needs rather than template pattern"
```

**Execution Scope Clarification:**
```bash
# Clarify boundaries and external coordination
bd update <task-id> --description="[Enhanced description with clear scope boundaries and user coordination steps]"

# Document scope refinements
bd comments add <task-id> "REVIEW: Clarified execution scope - [specific boundary clarifications made]"
```

### 5.2. Pattern Application to Unreviewed Areas
**Apply learned patterns to improve entire plan:**

**If Pattern Found in Selected Areas:**
- **Packing patterns**: Scan unreviewed areas for similar packing indicators, apply `bd create` splits where applicable
- **Classification patterns**: Check unreviewed tasks with similar characteristics, apply `bd update` corrections
- **Template matching**: Vary formatting across unreviewed similar tasks via `bd update`
- **Missing requirements**: Add requirements to unreviewed tasks in similar domains using `bd update`

**Conservative Application:**
- Apply only clear, obvious patterns to unreviewed areas
- Avoid extensive changes to unreviewed sections
- Focus on applying lessons learned from systematic review
- Document pattern-based changes with `bd comments add`

**Pattern-Based Update Example:**
```bash
# Apply identified pattern to similar unreviewed task
bd update <unreviewed-task-id> --description="[Updated with pattern-based improvement]"

# Document pattern application
bd comments add <unreviewed-task-id> "PATTERN FIX: Applied [pattern type] improvement identified during systematic review of [reviewed-task-id]"
```

### 5.3. Comprehensive Update Summary
**Track all Beads modifications made during review:**

**Update Operations Applied:**
1. **Systematic review fixes** to selected issues via `bd update`, `bd create` (splits), `bd close`
2. **Pattern-based improvements** to unreviewed issues via `bd update`
3. **Dependency updates** via `bd dep add/remove` to maintain consistency
4. **Documentation comments** via `bd comments add` for audit trail

**Verification Steps:**
```bash
# Verify all updates applied
bd list --status=ready

# Check dependency integrity
bd deps <task-id>

# Review recent changes
bd activity --since="[review start time]"
```

---

## 6. Final User Review

### 6.1. Review Summary Presentation
**Clear summary of all changes made:**

**Summary Format:**
```markdown
## Review Complete - Summary of Changes

**Systematic Review Applied To:**
- [Phase/Task selections] - Found and fixed: [issue summary with counts]
- [Individual tasks] - Found and fixed: [specific issues]
- [Any areas with no issues found]

**Beads Operations Performed:**
- Created [X] new issues (task splits)
- Updated [X] issue descriptions (classification, requirements, scope)
- Closed [X] original issues (replaced by splits)
- Added [X] dependency updates
- Documented [X] review comments

**Pattern-Based Improvements Applied:**
- [Description of patterns found and applied to unreviewed areas]
- [Count and type of improvements made based on systematic review findings]

**Total Changes:**
- [X] tasks split ([original] → [new task breakdown])
- [X] tasks reclassified ([classification changes made])
- [X] tasks enhanced with [type of enhancements]
- [X] tasks reformatted for [formatting improvements]

**Ready for Enhancement Phase**
```

**Summary Requirements:**
- Clearly distinguish between systematic review fixes and pattern-based improvements
- List specific Beads operations performed (create, update, close, dep add, comments add)
- Provide specific counts and types of changes made
- List any task splits with before/after identification
- Confirm readiness for next phase

### 6.2. Final Approval Process
**User review and approval:**

**Approval Workflow:**
1. **Present updated Beads issues** using:
   ```bash
   bd list --status=ready
   bd stats
   bd activity --since="[review start]"
   ```

2. **Highlight major modifications** for user attention:
   - Show split task details: `bd show <new-task-ids>`
   - Display updated descriptions: `bd show <modified-task-ids>`
   - Review comments added: `bd comments list <task-ids>`

3. **Request explicit approval** to proceed

4. **Address any user concerns** or additional changes:
   - Apply further updates via `bd update` as needed
   - Make additional splits via `bd create` if requested
   - Refine dependencies via `bd dep add/remove`

5. **Confirm completion** when user approves

---

## 7. Next Step

After user approves the reviewed issues, they can start the Manager with `/apm-start`.

The Manager will:
1. Query Beads for ready tasks (`bd ready`)
2. Spawn Implementation Agents via Task tool
3. Track progress via Beads status updates and comments

---

## Beads Integration Summary

**Preservation**: This guide preserves the complete systematic review methodology from APM:
- Question-based analytical framework (§4.2) - UNCHANGED
- User selection and approval gates (§3) - UNCHANGED
- Pattern detection and application (§5.2) - UNCHANGED
- Quality enhancement standards (§4.4) - UNCHANGED

**Adaptation**: Only state management operations changed from markdown to Beads:
- Plan modifications → `bd update --description`
- Task splits → `bd create` + `bd close`
- Dependency updates → `bd dep add/remove`
- Review documentation → `bd comments add`

**User Experience**: Workflow remains identical - agents propose, user selects, systematic analysis runs, comprehensive fixes applied, user approves. Only the backend storage changed.

---

**End of Guide**