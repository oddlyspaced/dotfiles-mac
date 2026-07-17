---
description: Generate a detailed handoff file documenting the current Claude session so a fresh session can resume without context loss.
---

# /handoff

You are tasked with writing a **handoff document** that captures everything a fresh Claude session needs to continue this work without re-deriving context.

The output is a markdown file under `thoughts/handoffs/` in the current project. After writing, confirm the path back to the user. Do **NOT** commit the file. Do **NOT** push.

---

## Step 1 — Determine the topic + slug

- If the user passed an argument (`/handoff <topic>`), use that as the topic.
- Otherwise infer a short kebab-case slug from the session focus (e.g. `scanner-debug-flow`, `cancelled-slots-feature`, `pr-39-review-round-2`). If ambiguous, ask the user in a single sentence before proceeding.

The filename is `thoughts/handoffs/<YYYY-MM-DD>-<slug>.md` (date from the local clock).

## Step 2 — Survey the session (parallel where possible)

Run these in **parallel** Bash calls to keep the survey fast:

1. **Branch + commits**
   - `git rev-parse --abbrev-ref HEAD` — current branch
   - `git rev-parse --short HEAD` — last commit
   - Find the base branch: check CLAUDE.md for "default branch", then `git symbolic-ref refs/remotes/origin/HEAD` as a fallback. Default to `develop` if neither is conclusive.
   - `git log --oneline origin/<base>..HEAD` — local-only commits
   - `git log --oneline -10` — recent context
2. **Uncommitted state**
   - `git status --short`
   - `git diff --stat` (or `git diff --stat --staged` if there's a staged set)
3. **Harness task list**
   - If TaskList is available, list all `in_progress` and `pending` tasks. Copy verbatim.
4. **Review ledgers / scratch notes**
   - `ls thoughts/reviews/ thoughts/handoffs/ thoughts/shared/plans/ 2>/dev/null` — note any files that were created or referenced this session.
5. **Open PR**
   - `gh pr list --head $(git branch --show-current) --json number,title,url --jq '.[]'` — if a PR is open for the branch, include the link.
6. **Project rules**
   - Note the path to `CLAUDE.md` if present. Don't dump its contents into the handoff.

## Step 3 — Compose the handoff

Use this structure exactly. Skip any section that has nothing meaningful to say (don't include empty headers).

```markdown
# Handoff — <topic>

**Date**: <YYYY-MM-DD HH:MM tz>
**Branch**: <branch>
**Base**: <base-branch>
**HEAD**: <short-hash> — "<commit subject>"
**Local commits ahead of origin/<base>**: <n>
**Open PR**: <#num · title · url>  ← omit if none

## Session arc

3–7 sentences of prose. What did the session set out to do, what did we learn, what was achieved? Written so the reader can skim and immediately know whether they're in the right session. No bullet points here.

## Commits landed this session (oldest → newest)

For each commit local to this session (whether already pushed or not):

- `<short-hash>` <commit subject>
  - One-line plain-English summary of what actually changed. NOT a copy of the commit message — the *intent* in one line.

If there are no commits, write "None — all work uncommitted." and skip to the next section.

## Uncommitted work

For each file currently dirty in the working tree, explain what it does and *why it wasn't committed*. Group related files when it helps.

- `path/file.tsx` — <what's pending, in one line>
  Why not committed: <one-line reason>

If clean, write "Clean working tree." and omit.

## Active harness tasks

If the harness has live `in_progress` or `pending` tasks, list them verbatim:

- [in_progress] <subject>
- [pending] <subject>

Omit the section entirely if there are no tasks.

## Open decisions / waiting on user

Each item: the decision point, brief context, the options that were on the table, and your last recommendation. Format:

- **<short title>** — context: <one line>. Options were: (a) …, (b) …, (c) …. Recommended: <which>.

## Gotchas / things to watch

Anything a fresh Claude could trip over. Be concrete:

- Debug scaffolding still in the working tree (hardcoded tokens, ngrok URLs, commented-out auth transforms, etc.) — name the file and line.
- TS / lint errors that are pre-existing noise vs. newly introduced.
- Native prebuild / reinstall needed before next build (e.g. expo plugin added).
- Pending review-ledger findings under `thoughts/reviews/` that were NOT acted on.
- API contract changes pending on the backend.
- Anything that crossed a tool boundary mid-flow (interrupted background agents, timed-out builds, etc.).

## Next actions for a fresh Claude

A short numbered list. Each item must be concrete enough to execute without further clarification — include `file:line` refs, exact commands, query keys, etc., where helpful.

1. <Action>
2. <Action>
3. …

## Context links

- `CLAUDE.md` — project rules (always loaded into the session by the harness; do not paste contents).
- Review ledgers / plans referenced this session:
  - `thoughts/reviews/<file>.md` — <one-line on its role>
  - `thoughts/handoffs/<earlier>.md` — <one-line>
- Useful files this session touched heavily: `path/file.tsx`, `path/other.ts` (line ranges optional).

## Notes for the next session

A short tail of project-specific reminders worth surfacing each time:

- Never push or open PRs without explicit authorization (per CLAUDE.md).
- <Any other always-active rule worth surfacing for this project>.
```

## Step 4 — Write + confirm

- Ensure `thoughts/handoffs/` exists (`mkdir -p` if not).
- Write the file via the Write tool.
- Reply to the user with a one-line confirmation including the file path. Nothing else.

## Style rules

- Assume the reader is a Claude with **zero** prior conversation context. They have CLAUDE.md and the file tree, nothing else.
- Cite paths with line numbers when useful (`app/features/dispatcher/screens/BagScanScreen.tsx:82`).
- Quote real git/cli output verbatim when short (commit lists, `git status` output).
- Prose only in the "Session arc" section; bullets everywhere else.
- Keep the file tight — aim for under ~250 lines unless the session truly justifies more.
- Never invent commits/files/tasks. If unsure, omit.
- Never include secrets (tokens, JWTs, passwords) in the handoff, even when they appear in the working tree. If a debug-token file is in scope, mention "debug JWT scaffolding" generically — don't paste the value.
