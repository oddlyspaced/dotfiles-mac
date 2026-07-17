---
description: Systematically debug issues through structured investigation, root cause analysis, and fix planning. Use when the user reports a bug, error, unexpected behavior, performance issue, or any codebase problem that needs diagnosis and resolution.
---

# Debug Plan

You are tasked with systematically diagnosing and resolving issues in a codebase through structured investigation, hypothesis-driven debugging, and collaborative root cause analysis. You produce a clear, actionable fix plan once the root cause is identified.

## Initial Response

When this command is invoked:

1. **Check if parameters were provided**:
   - If an error message, file path, log output, or ticket reference was provided, skip the default message
   - Immediately read any provided files FULLY
   - Begin the investigation process

2. **If no parameters provided**, respond with:
```
I'll help you debug this issue. Let me start by understanding the problem.

Please provide any of the following:
1. Error message or stack trace
2. Description of unexpected behavior (what happens vs. what should happen)
3. Steps to reproduce the issue
4. When the issue started (recent change, deploy, dependency update?)
5. Any relevant logs, screenshots, or file paths

The more context you give, the faster I can narrow it down.
```

Then wait for the user's input.

## Process Steps

### Step 1: Issue Intake & Classification

1. **Capture the raw issue signal**:
   - Error messages, stack traces, log output
   - Behavioral description (expected vs. actual)
   - Reproduction steps if known
   - Frequency (always, intermittent, once)
   - Environment (local, staging, production, specific browser/OS)
   - When it started (after a deploy, dependency update, code change, random)

2. **Classify the issue type** to guide investigation strategy:

   | Type | Signals | Investigation Approach |
   |------|---------|----------------------|
   | **Crash/Exception** | Stack trace, error message, process exit | Trace the stack, inspect throw site |
   | **Wrong Output** | Incorrect data, UI rendering wrong | Trace data flow, compare expected vs actual |
   | **Performance** | Slow response, high memory, timeout | Profile, find bottleneck, measure |
   | **Race Condition** | Intermittent, timing-dependent | Identify shared state, concurrency points |
   | **Regression** | "It used to work" | Git bisect, diff recent changes |
   | **Integration** | Works alone, fails with dependency | Check API contracts, versions, config |
   | **Environment** | Works locally, fails in CI/prod | Compare environments, config, secrets |
   | **Data** | Specific inputs cause failure | Identify bad data patterns, validate inputs |
   | **Build/Config** | Compilation errors, missing deps | Check configs, dependency trees, versions |
   | **Silent Failure** | No error but something doesn't work | Add instrumentation, trace execution path |

3. **Assess severity and scope**:
   - Is the application unusable (P0) or is this a minor annoyance (P3)?
   - How many users/codepaths are affected?
   - Is there a workaround?

### Step 2: Context Gathering & Codebase Investigation

**CRITICAL**: Before forming any hypotheses, gather thorough context. Premature conclusions are the enemy of good debugging.

1. **Read all provided files immediately and FULLY**:
   - Error logs, stack traces, issue descriptions
   - Any files the user mentions
   - **IMPORTANT**: Use the Read tool WITHOUT limit/offset parameters to read entire files
   - **CRITICAL**: DO NOT spawn sub-tasks before reading these files yourself in the main context
   - **NEVER** read files partially - if a file is mentioned, read it completely

2. **Extract investigation targets from the issue signal**:
   - Parse file paths and line numbers from stack traces
   - Identify function/class/module names mentioned in errors
   - Note any dependency names, API endpoints, or config keys

3. **Spawn parallel research tasks for codebase investigation**:

   Use specialized agents to build comprehensive understanding:

   - **codebase-locator**: Find all files related to the failing functionality
   - **codebase-analyzer**: Understand how the failing code path works end-to-end
   - **codebase-pattern-finder**: Find similar patterns elsewhere that work correctly (comparison debugging)

   Example prompts for agents:
   ```
   codebase-locator: "Find all files involved in [failing feature].
   Include: source files, config files, tests, type definitions,
   and any middleware or interceptors in the request path."

   codebase-analyzer: "Trace the complete execution path for [operation
   that fails]. Start from [entry point] and follow through to [where
   it breaks]. Report every function call, data transformation, and
   branching decision with file:line references."

   codebase-pattern-finder: "Find similar features to [broken feature]
   that work correctly. Compare their implementation patterns to identify
   what's different about the broken one."
   ```

4. **Read all files identified by research tasks**:
   - After research tasks complete, read ALL files they identified as relevant
   - Read them FULLY into the main context
   - Pay special attention to: recent changes, error handling paths, configuration

5. **Check for recent changes** (if regression suspected):
   - Run `git log --oneline -20` to see recent commits
   - Run `git log --oneline --all -- <affected-files>` to see changes to specific files
   - Run `git diff HEAD~5 -- <affected-files>` to inspect recent diffs
   - Check for recent dependency updates in lock files

6. **Present initial findings**:
   ```
   Based on my investigation, here's what I've found:

   **Issue Summary:**
   [Clear 1-2 sentence description of the problem]

   **Affected Code Path:**
   - Entry point: `file:line` → [description]
   - Passes through: `file:line` → [description]
   - Fails at: `file:line` → [description]

   **Key Observations:**
   - [Observation with file:line reference]
   - [Relevant pattern or anomaly discovered]
   - [Configuration or environment detail]

   **What I still need to understand:**
   - [Specific gap in understanding]
   ```

### Step 3: Reproduction Strategy

Establishing reliable reproduction is critical. If you can't reproduce it, you can't verify a fix.

1. **Determine reproduction approach**:
   - Deterministic: run the exact steps, verify failure
   - Intermittent: identify conditions that increase probability
   - Environment-specific: compare configurations, find the delta
   - Data-dependent: isolate the specific input that triggers it
   - Performance: establish baseline, measure the degradation

2. **Simplify existing reproduction** to the minimal case. What is the smallest input/config that triggers it?

3. **If no reproduction steps exist**, ask the user: frequency, specific inputs, conditions where it does NOT happen, and exact steps from a clean state.

4. **Write a reproduction test if possible** - a failing test that demonstrates the bug becomes the verification that the fix works.

### Step 4: Hypothesis-Driven Investigation

**This is the core debugging methodology.** Do not shotgun debug. Be systematic.

1. **Form hypotheses** based on gathered context:

   For each hypothesis, define:
   ```
   Hypothesis [N]: [Clear statement of what might be wrong]
   Evidence for: [What supports this hypothesis]
   Evidence against: [What contradicts it]
   Test: [How to confirm or rule it out - be specific]
   Effort: [Low/Medium/High to test]
   Likelihood: [Low/Medium/High based on evidence]
   ```

   **Prioritize hypotheses by**: Likelihood × (1 / Effort to test)
   Test the cheapest-to-verify, most-likely hypotheses first.

2. **Apply issue-type-specific techniques** from [REFERENCE.md](REFERENCE.md):
   - Crash/Exception: trace the stack, inspect throw site, check inputs
   - Wrong Output: trace data flow, binary search the pipeline
   - Performance: profile, find bottleneck, measure baseline
   - Race Condition: identify shared state, map concurrency
   - Regression: git bisect to find introducing commit
   - Integration: check API contracts, versions, changelogs
   - Environment: diff configs, check env vars, resource limits

3. **Spawn targeted investigation tasks**:
   - Use **codebase-analyzer** for deep dives into specific code paths
   - Use **codebase-locator** to find related code you might have missed
   - Use **shell** agent for running diagnostic commands
   - Use **WebSearch** for known issues with specific libraries/versions

4. **After each hypothesis test, update your understanding**:
   ```
   Hypothesis [N]: [CONFIRMED / RULED OUT / PARTIALLY CONFIRMED]
   Result: [What the test revealed]
   Next step: [What to investigate next based on this result]
   ```

5. **Narrow down relentlessly**:
   - Each test should eliminate possibilities
   - If a hypothesis is ruled out, it's still valuable information
   - Update remaining hypotheses based on new evidence
   - Stop when you have strong evidence pointing to a single root cause

### Step 5: Root Cause Identification

Once you've converged on the root cause:

1. **State the root cause clearly**:
   ```
   **Root Cause Identified:**

   [Clear, precise statement of what's wrong and why]

   **Evidence:**
   - [Specific evidence point 1 with file:line reference]
   - [Specific evidence point 2]
   - [How the hypothesis was confirmed]

   **Why this causes the observed symptom:**
   [Causal chain from root cause → symptom the user sees]

   **Contributing factors** (if any):
   - [Factor that made this bug possible but isn't the direct cause]
   - [Missing safeguard that would have prevented this]
   ```

2. **Distinguish root cause from symptoms**:
   - The root cause is the deepest fixable defect
   - Symptoms are the observable effects
   - There may be multiple symptoms from one root cause
   - Fix the root cause, not just the symptoms

3. **Verify with the user**:
   ```
   Does this root cause match what you're seeing? Before I propose fixes,
   I want to make sure we're solving the right problem.
   ```

### Step 6: Deep Fix Interview

**CRITICAL**: Before proposing fixes, interview the user about constraints and preferences.

Use `AskQuestion` to gather fix requirements:

**Interview Categories:**

1. **Fix Scope & Urgency**
   - Is this a hotfix (patch now, refactor later) or a proper fix?
   - Is there a deadline or SLA pressure?
   - Can we make breaking changes or must we maintain backward compatibility?

2. **Risk Tolerance**
   - How risk-averse is this fix? (production system vs. development)
   - Should we fix narrowly (just this case) or broadly (prevent the class of bugs)?
   - Are there related areas we should harden while we're here?

3. **Testing Requirements**
   - What test coverage exists for this area?
   - Should the fix include regression tests?
   - Is there a QA process or can we ship with automated tests only?

4. **Rollback Strategy**
   - Is there a feature flag system?
   - Can the fix be deployed incrementally?
   - What's the rollback plan if the fix causes new issues?

5. **Side Effects & Dependencies**
   - Are other teams/services affected? Coordinated deployment needed?
   - Are there downstream consumers that depend on the current (broken) behavior?

**Interview Best Practices:**
- Use `AskQuestion` with 2-4 focused questions per round
- Provide meaningful options; allow "Other" for custom input
- If user says "you decide" - make the decision and document rationale
- Continue until all ambiguity about fix approach is resolved

### Step 7: Fix Strategy Development

After understanding constraints:

1. **Propose fix options** (always give at least 2):
   ```
   **Fix Option A: [Name] (Recommended)**
   Approach: [What to change]
   Pros: [Benefits]
   Cons: [Drawbacks]
   Risk: [Low/Medium/High]
   Effort: [Low/Medium/High]
   Files affected: [List]

   **Fix Option B: [Name]**
   Approach: [What to change]
   Pros: [Benefits]
   Cons: [Drawbacks]
   Risk: [Low/Medium/High]
   Effort: [Low/Medium/High]
   Files affected: [List]
   ```

2. **Consider fix categories**: surgical (fix the broken line), defensive (add validation + fix), structural (refactor the design flaw), or workaround (config change/feature flag while proper fix is developed).

3. **Get alignment on approach** before writing the plan

### Step 8: Fix Plan Writing

After approach approval:

1. **Ensure directory exists**: Run `mkdir -p thoughts/shared/plans`
2. **Write the plan** to `thoughts/shared/plans/YYYY-MM-DD-fix-description.md`
   - Format: `YYYY-MM-DD-fix-description.md`
   - Example: `2026-03-01-fix-auth-token-expiry.md`
3. **Use this template**:

````markdown
# Fix: [Issue Title]

## Issue Summary

**Symptom:** [What the user observes]
**Root Cause:** [The underlying defect]
**Severity:** [P0-P3]
**Affected Area:** [Component/feature/service]

## Root Cause Analysis

### What's Happening
[Detailed explanation of the bug mechanism]

### Why It's Happening
[The underlying cause - the actual defect in logic, data, config, etc.]

### Causal Chain
```
[Root cause] → [Intermediate effect] → [Observable symptom]
```

### Evidence
- [Evidence point 1 with file:line reference]
- [Evidence point 2]
- [How we confirmed this is the root cause]

## What We're NOT Doing

[Explicitly list out-of-scope items to prevent scope creep]

## Fix Strategy

**Approach:** [Name of chosen approach]
**Rationale:** [Why this approach over alternatives]

## Phase 1: [Fix Description]

### Overview
[What this phase accomplishes]

### Changes Required:

#### 1. [Component/File Group]
**File**: `path/to/file.ext`
**Changes**: [Summary of changes]

```[language]
// Specific code to add/modify
```

**Why this change:** [Brief rationale connecting change to root cause]

### Regression Prevention:

#### Tests to Add:
- [ ] Test that reproduces the original bug (should pass after fix)
- [ ] Test for edge cases discovered during investigation
- [ ] Test for related scenarios that could have the same class of bug

### Success Criteria:

#### Automated Verification:
- [ ] Bug reproduction test passes: `[specific test command]`
- [ ] All existing tests still pass: `[test command]`
- [ ] Type checking passes: `[typecheck command]`
- [ ] Linting passes: `[lint command]`

#### Manual Verification:
- [ ] Original reproduction steps no longer trigger the bug
- [ ] Related functionality still works correctly
- [ ] No new warnings or errors in logs
- [ ] Performance is not degraded

**Implementation Note**: After completing this phase and all automated verification passes, pause for manual confirmation before proceeding.

---

## Phase 2: [Hardening / Prevention] (if applicable)

### Overview
[Additional defensive measures to prevent recurrence]

### Changes Required:
[Similar structure to Phase 1]

---

## Monitoring & Validation

### Post-Fix Monitoring:
- [ ] [What to monitor after deploying the fix]
- [ ] [Metrics to watch]
- [ ] [How long to monitor before considering it resolved]

### Rollback Plan:
- [ ] [How to revert if the fix causes issues]
- [ ] [What to watch for that would trigger rollback]

## Investigation Log

### Hypotheses Tested:
| # | Hypothesis | Result | Evidence |
|---|-----------|--------|----------|
| 1 | [Hypothesis] | [Confirmed/Ruled Out] | [Brief evidence] |
| 2 | [Hypothesis] | [Confirmed/Ruled Out] | [Brief evidence] |

### Key Discoveries:
- [Important finding that informed the fix]
- [Pattern or convention to be aware of]
- [Constraint that shaped the solution]

## References

- Original issue: [link/description]
- Relevant commits: [git hashes if applicable]
- Related documentation: [links]
- Similar past issues: [links if applicable]
````

### Step 9: Review & Iteration

1. **Present the draft plan location**:
   ```
   I've created the fix plan at:
   `thoughts/shared/plans/YYYY-MM-DD-fix-description.md`

   Please review it and let me know:
   - Does the root cause analysis match your understanding?
   - Are the fix changes correct and complete?
   - Are the success criteria specific enough?
   - Any edge cases or side effects I'm missing?
   - Should we add more hardening/prevention measures?
   ```

2. **Iterate based on feedback** - be ready to:
   - Refine root cause analysis
   - Adjust fix approach
   - Add missing edge cases
   - Strengthen regression tests
   - Update scope

3. **Continue refining** until the user is satisfied

## Investigation Techniques Reference

For detailed investigation techniques (binary search, comparison, temporal/regression, minimal reproduction, trace walkthrough) and common anti-patterns, see [REFERENCE.md](REFERENCE.md).

## Important Guidelines

1. **Don't Jump to Solutions**:
   - Resist the urge to immediately propose a fix
   - Understand the problem fully before solving it
   - A misdiagnosed bug leads to a fix that introduces new bugs

2. **Be Systematic**:
   - Form hypotheses, test them, record results
   - Don't shotgun debug (changing things randomly hoping something works)
   - Each investigation step should narrow the possibility space

3. **Be Skeptical**:
   - Question assumptions ("are we sure this function is even called?")
   - Verify, don't assume ("let me check that the config value is what we think")
   - Consider that the bug might not be where the error appears

4. **Be Interactive**:
   - Don't disappear for 10 minutes of silent investigation
   - Share findings incrementally
   - Ask the user when you hit a fork - they often have intuition about their codebase
   - Get buy-in before writing the fix plan

5. **Be Thorough**:
   - Read all context files COMPLETELY
   - Research actual code paths using parallel sub-tasks
   - Include specific file paths and line numbers
   - Don't stop at the first plausible explanation - verify it

6. **Track Progress**:
   - Use TodoWrite to track investigation tasks
   - Update todos as hypotheses are confirmed or ruled out
   - Mark investigation complete when root cause is confirmed

7. **No Open Questions in Final Plan**:
   - If you encounter open questions during investigation, STOP
   - Research or ask for clarification immediately
   - The fix plan must be complete and actionable
   - Every decision must be made before finalizing

## Sub-task Spawning Best Practices

- **Spawn multiple tasks in parallel** for efficiency
- **Each task should be focused** on a specific investigation angle
- **Be EXTREMELY specific**: include error messages, function names, directory paths
- **Request specific file:line references** in responses
- **Wait for all tasks to complete** before synthesizing
- **Verify results**: cross-check findings, spawn follow-ups if results seem wrong

