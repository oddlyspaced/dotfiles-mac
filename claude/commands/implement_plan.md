---
description: Implement technical plans from thoughts/shared/plans with verification
---

# Implement Plan

You are tasked with implementing an approved technical plan from `thoughts/shared/plans/`. These plans contain phases with specific changes and success criteria.

## Execution Modes

You have two execution modes:

### Mode 1: Direct Implementation (Default)
For small plans (3 or fewer tasks) or when user requests direct implementation.
- You implement each phase yourself
- Context accumulates in main conversation
- Use this for quick, focused implementations

### Mode 2: Agent Orchestration (Recommended for larger plans)
For plans with 4+ tasks or when context preservation is critical.
- You act as a thin orchestrator
- Agents execute each task and create handoffs
- Compaction-resistant: handoffs persist even if context compacts
- Use this for multi-phase implementations

**To use agent orchestration mode**, say: "I'll use agent orchestration for this plan" and follow the Agent Orchestration section below.

---

## Getting Started

When given a plan path:
1. Read the plan completely and check for any existing checkmarks (- [x])
2. Read the original ticket and all files mentioned in the plan
3. **Read files fully** - never use limit/offset parameters, you need complete context
4. Think deeply about how the pieces fit together
5. **Auto-create ledger if missing** (see below)
6. Create a todo list to track your progress
7. Start implementing if you understand what needs to be done

If no plan path provided, ask for one.

### Auto-Create Ledger If Missing

Before starting implementation, check for an existing ledger:

```bash
ls thoughts/ledgers/*.md 2>/dev/null
```

**If no ledger exists**, create one from the plan:

1. Extract session name from plan filename (e.g., `PLAN-add-auth.md` → `add-auth`)
2. Extract phases/tasks from the plan
3. Create ledger with phases as checkboxes:

```bash
mkdir -p thoughts/ledgers
```

Use this template:

```markdown
# Session: <session-name-from-plan>
Updated: <ISO timestamp>

## Goal
<Extract from plan's objective/summary section>

## Constraints
<Extract from plan's constraints or assumptions>

## Key Decisions
<Extract from plan's design decisions, or leave empty>

## State
- Done:
  - (none yet)
- Now: [→] Phase 1: <first phase from plan>
- Next: Phase 2: <second phase from plan>
- Remaining:
  - [ ] Phase 3: <third phase>
  - [ ] Phase 4: <fourth phase>
  ... (all phases from plan)

## Open Questions
<Extract any open questions from plan, or leave empty>

## Working Set
- Branch: <current branch>
- Plan: thoughts/shared/plans/<plan-file>.md
- Test cmd: <from plan if specified>
```

**Announce ledger creation:**
```
Created continuity ledger: thoughts/ledgers/<name>.md
This will persist across /clear and auto-load on session resume.
```

**If ledger exists**, read it and verify it matches the plan you're implementing.

## Implementation Philosophy

Plans are carefully designed, but reality can be messy. Your job is to:
- Follow the plan's intent while adapting to what you find
- Implement each phase fully before moving to the next
- Verify your work makes sense in the broader codebase context
- Update checkboxes in the plan as you complete sections
- **Update ledger checkboxes** as you complete phases (move from Now → Done)

When things don't match the plan exactly, think about why and communicate clearly. The plan is your guide, but your judgment matters too.

If you encounter a mismatch:
- STOP and think deeply about why the plan can't be followed
- Present the issue clearly:
  ```
  Issue in Phase [N]:
  Expected: [what the plan says]
  Found: [actual situation]
  Why this matters: [explanation]

  How should I proceed?
  ```

## Verification Approach

After implementing a phase:
- Run the success criteria checks (usually `make check test` covers everything)
- Fix any issues before proceeding
- Update your progress in both the plan and your todos
- Check off completed items in the plan file itself using Edit
- **Pause for human verification**: After completing all automated verification for a phase, pause and inform the human that the phase is ready for manual testing. Use this format:
  ```
  Phase [N] Complete - Ready for Manual Verification

  Automated verification passed:
  - [List automated checks that passed]

  Please perform the manual verification steps listed in the plan:
  - [List manual verification items from the plan]

  Let me know when manual testing is complete so I can proceed to Phase [N+1].
  ```

If instructed to execute multiple phases consecutively, skip the pause until the last phase. Otherwise, assume you are just doing one phase.

do not check off items in the manual testing steps until confirmed by the user.


## If You Get Stuck

When something isn't working as expected:
- First, make sure you've read and understood all the relevant code
- Consider if the codebase has evolved since the plan was written
- Present the mismatch clearly and ask for guidance

Use sub-tasks sparingly - mainly for targeted debugging or exploring unfamiliar territory.

## Resumable Agents

If the plan was created by `plan-agent`, you may be able to resume it for clarification:

1. Check `.claude/cache/agents/agent-log.jsonl` for the plan-agent entry
2. Look for the `agentId` field
3. To clarify or update the plan:
   ```
   Task(
     resume="<agentId>",
     prompt="Phase 2 isn't matching the codebase. Can you clarify..."
   )
   ```

The resumed agent retains its full prior context (research, codebase analysis).

Available agents to resume:
- `plan-agent` - Created the implementation plan
- `research-agent` - Researched best practices
- `debug-agent` - Investigated issues

## Resuming Work

If the plan has existing checkmarks:
- Trust that completed work is done
- Pick up from the first unchecked item
- Verify previous work only if something seems off

Remember: You're implementing a solution, not just checking boxes. Keep the end goal in mind and maintain forward momentum.

---

## Agent Orchestration Mode

When implementing larger plans (4+ tasks), use agent orchestration to stay compaction-resistant.

### Why Agent Orchestration?

**The Problem:** During long implementations, context accumulates. If auto-compact triggers mid-task, you lose implementation context. Handoffs created at 80% context become stale.

**The Solution:** Delegate implementation to agents. Each agent:
- Starts with fresh context
- Implements one task
- Creates a handoff on completion
- Returns to orchestrator

Handoffs persist on disk. If compaction happens, you re-read handoffs and continue.

### Setup

1. **Ensure ledger exists** (auto-created if missing - see "Auto-Create Ledger If Missing" above)

2. **Create handoff directory:**
   ```bash
   mkdir -p thoughts/handoffs/<session-name>
   ```
   Use the session name from your continuity ledger.

3. **Read the implementation agent skill:**
   ```bash
   cat .claude/skills/implement_task/SKILL.md
   ```
   This defines how agents should behave.

### Pre-Requisite: Plan Validation

Before implementing, ensure the plan has been validated using the `validate-agent`. The validation step is separate and should have created a handoff with status VALIDATED.

**Check for validation handoff:**
```bash
ls thoughts/handoffs/<session>/validation-*.md
```

If no validation exists, suggest running validation first:
```
"This plan hasn't been validated yet. Would you like me to spawn validate-agent first?"
```

If validation exists but status is NEEDS REVIEW, present the issues before proceeding.

### Orchestration Loop (with Per-Task Review)

For each task in the plan, follow this loop that ensures quality before proceeding:

```
For each task:
  ┌──────────────────┐
  │ 1. Implement     │ ──→ task handoff created
  └────────┬─────────┘
           ↓
  ┌──────────────────┐
  │ 2. Review        │ ──→ APPROVED? ──→ Next task
  └────────┬─────────┘         │
           ↓ CHANGES_REQUESTED │
  ┌──────────────────┐         │
  │ 3. Fix           │ ←───────┘
  └────────┬─────────┘
           ↓
      (back to Review, max 3 iterations)
```

#### Step 1: Prepare Context

- Read continuity ledger (current state)
- Read the plan (overall context)
- Read previous handoff if exists (from thoughts/handoffs/<session>/)
- Identify the specific task and its testing tier

#### Step 2: Initial Implementation

```
Task(
  subagent_type="general-purpose",
  model="opus",
  prompt="""
  [Paste contents of .claude/skills/implement_task/SKILL.md here]

  ---

  ## Your Context

  ### Continuity Ledger:
  [Paste ledger content]

  ### Plan:
  [Paste relevant plan section or full plan]

  ### Your Task:
  Task [N] of [Total]: [Task description from plan]

  ### Testing Tier:
  [TIER_1 | TIER_2 | TIER_3] - [Reason for tier assignment]

  ### Previous Handoff:
  [Paste previous task's handoff content, or "This is the first task - no previous handoff"]

  ### Handoff Directory:
  thoughts/handoffs/<session-name>/

  ### Handoff Filename:
  task-[NN]-[short-description].md

  ---

  Implement your task and create your handoff.
  """
)
```

Read the task handoff created by the agent.

#### Step 3: Review Loop

```python
MAX_ITERATIONS = 3
iteration = 1

while iteration <= MAX_ITERATIONS:

  # 3a. Get task-specific git diff
  git_diff = bash("git diff HEAD -- {files_from_handoff}")

  # 3b. Spawn task-review-agent
  review = Task(
    subagent_type="task-review-agent",
    prompt="""
    Review task implementation.

    ## Task Description
    Task {N} of {Total}: {task_description}

    ## Testing Strategy
    Tier: {task_tier}
    Required: {test_requirements_for_tier}

    ## Files Modified
    {files_from_handoff}

    ## Git Diff
    {git_diff}

    ## Previous Review (if any)
    Iteration: {iteration}
    {previous_review_json if iteration > 1 else "First review"}
    """
  )

  # 3c. Read review output
  review_output = read(".claude/cache/agents/task-review-agent/latest-output.md")
  # Parse JSON from output

  # 3d. Check verdict
  if review.verdict == "APPROVED":
    log("Task {N} approved after {iteration} iteration(s)")
    break

  if review.verdict == "CHANGES_REQUESTED":
    if iteration >= MAX_ITERATIONS:
      break  # Will escalate below

    # 3e. Spawn implement_task in fix mode
    Task(
      subagent_type="general-purpose",
      model="opus",
      prompt="""
      [Paste contents of .claude/skills/implement_task/SKILL.md here]

      ---

      ## Fix Mode

      You are in FIX MODE. Address the review comments below.

      ### Review Comments to Fix:
      Iteration: {iteration + 1}

      Comments:
      {format_comments_as_markdown(review.comments)}

      ### Previous Handoff:
      {task_handoff_content}

      ### Handoff Directory:
      thoughts/handoffs/<session-name>/

      ---

      Apply the fixes and update your handoff.
      """
    )

    iteration += 1

# 3f. Handle max iterations exceeded
if iteration > MAX_ITERATIONS and review.verdict != "APPROVED":
  escalate_to_user("""
  Task {N} has unresolved comments after {MAX_ITERATIONS} iterations.

  Remaining issues:
  {format_remaining_must_fix_comments(review.comments)}

  Options:
  1. Continue with remaining issues (accept risk)
  2. I'll fix manually and tell you to resume
  3. Skip this task
  """)
  # Wait for user response before continuing
```

#### Step 4: Finalize Task

After task is APPROVED (or user accepts with issues):

```python
# Update task handoff with review history
append_to_handoff(task_handoff, """
## Review History
- Iterations: {iteration}
- Final verdict: {verdict}
- Comments addressed: {total_comments_fixed}
""")

# Update ledger (just checkbox)
# IMPORTANT: Only mark complete AFTER review approval
update_ledger_checkbox(task_N, completed=True)

# Continue to next task
```

#### Step 5: On Blocker

If agent returns status="blocked":
- Read the handoff to understand the blocker
- Present blocker to user
- Options: retry, skip, or ask user for guidance

### Comment Formatting Helper

When passing review comments to fix mode, format as:

```markdown
### Review Comments to Fix:
Iteration: 2

Comments:
1. [MUST_FIX] src/auth.ts:45 - Missing null check
   Suggestion: Add `if (!user) throw new Error('User required');`

2. [SHOULD_FIX] src/auth.ts:78 - Consider using optional chaining
   Suggestion: Change `user.profile.name` to `user?.profile?.name`

3. [NIT] src/auth.ts:123 - Add JSDoc
   Suggestion: Add documentation comment
```

### Recovery After Compaction

If auto-compact happens mid-orchestration:

1. Read continuity ledger (loaded by SessionStart hook)
2. List handoff directory:
   ```bash
   ls -la thoughts/handoffs/<session-name>/
   ```
3. Read the last handoff to understand where you were
4. Continue spawning agents from next uncompleted task

### Example Orchestration Session (with Review)

```
User: /implement_plan thoughts/shared/plans/PLAN-add-auth.md

Claude: I'll use agent orchestration for this plan (6 tasks).

Checking for continuity ledger...
No ledger found. Creating from plan...
Created: thoughts/ledgers/add-auth.md

Setting up handoff directory...
[Creates thoughts/handoffs/add-auth/]

─────────────────────────────────────────────────────────────
Task 1 of 6: Create user model (TIER_2)
─────────────────────────────────────────────────────────────

📝 Implementing...
[Spawns implement_task agent with TIER_2]
[Agent completes, creates task-01-user-model.md]

🔍 Reviewing (iteration 1)...
[Spawns task-review-agent]
[Review: APPROVED - no issues]

✅ Task 1 approved. Handoff: thoughts/handoffs/add-auth/task-01-user-model.md

─────────────────────────────────────────────────────────────
Task 2 of 6: Add authentication middleware (TIER_1)
─────────────────────────────────────────────────────────────

📝 Implementing...
[Spawns implement_task agent with TIER_1]
[Agent completes, creates task-02-auth-middleware.md]

🔍 Reviewing (iteration 1)...
[Spawns task-review-agent]
[Review: CHANGES_REQUESTED - 2 MUST_FIX, 1 SHOULD_FIX]

🔧 Fixing (iteration 2)...
[Spawns implement_task in fix mode with comments]
[Agent applies fixes, updates handoff]

🔍 Reviewing (iteration 2)...
[Spawns task-review-agent]
[Review: APPROVED - all issues addressed]

✅ Task 2 approved after 2 iterations. Handoff: thoughts/handoffs/add-auth/task-02-auth-middleware.md

─────────────────────────────────────────────────────────────
Task 3 of 6: Create login endpoint (TIER_1)
─────────────────────────────────────────────────────────────

📝 Implementing...
[Spawns implement_task agent]

🔍 Reviewing (iteration 1)...
[Review: CHANGES_REQUESTED - SQL injection vulnerability]

🔧 Fixing (iteration 2)...
🔍 Reviewing (iteration 2)...
[Review: CHANGES_REQUESTED - still has issue]

🔧 Fixing (iteration 3)...
🔍 Reviewing (iteration 3)...
[Review: CHANGES_REQUESTED - different issue now]

⚠️ Max iterations reached. Escalating to user...

Task 3 has unresolved comments after 3 iterations.

Remaining issues:
- [MUST_FIX] src/auth.ts:78 - Password comparison using ==, should use timing-safe compare

Options:
1. Continue with remaining issues (accept risk)
2. I'll fix manually and tell you to resume
3. Skip this task

User: I'll fix manually, continue with task 4

[Marks task 3 with warning, continues...]
```

### Handoff Chain

Each agent reads previous handoff → does work → creates next handoff:

```
task-01-user-model.md
    ↓ (read by agent 2)
task-02-auth-middleware.md
    ↓ (read by agent 3)
task-03-login-endpoint.md
    ↓ (read by agent 4)
...
```

The chain preserves context even across compactions.

### When to Use Agent Orchestration

| Scenario | Mode |
|----------|------|
| 1-3 simple tasks | Direct implementation |
| 4+ tasks | Agent orchestration |
| Critical context to preserve | Agent orchestration |
| Quick bug fix | Direct implementation |
| Major feature implementation | Agent orchestration |
| User explicitly requests | Respect user preference |

### Tips

- **Keep orchestrator thin:** Don't do implementation work yourself. Just manage agents.
- **Trust the handoffs:** Agents create detailed handoffs. Use them for context.
- **One agent per task:** Don't batch multiple tasks into one agent.
- **Sequential execution:** Start with sequential. Parallel adds complexity.
- **Update ledger after approval:** Only mark tasks complete AFTER review approval.
- **Review loop:** Each task goes through implement → review → fix cycle before proceeding.
- **Max 3 iterations:** If review still fails after 3 rounds, escalate to user.
- **Tier-aware testing:** Pass testing tier to implement_task so it applies correct rigor.
