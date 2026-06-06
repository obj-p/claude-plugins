---
description: Update memories and write a handoff file so a fresh session can pick up the work
---

You are ending or pausing a work session. Capture everything a fresh session
would need, while you still have full context. Treat $ARGUMENTS as an extra
note to fold into the handoff if provided.

## 1. Memory pass

Scan this conversation for durable facts worth keeping beyond the task:

- Feedback or corrections the user gave on how you should work
- Project decisions, goals, or constraints not derivable from the code or git
  history
- User preferences you learned

Save or update these using your persistent memory. Skip anything the repo,
git history, or CLAUDE.md already records. Skip anything that only matters to
this conversation.

## 2. Write the handoff file

Determine today's date with `date +%Y-%m-%d` and the repo name with
`basename "$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"`
so all worktrees of a repo share one name. Pick a short kebab-case slug for
the task and write `~/.claude/handoffs/<repo>/<date>-<slug>.md` with these
sections:

- **Goal**: the original ask, in one or two sentences
- **Done**: what is complete, and how each item was verified
- **Outstanding**: what remains, as a checklist
- **Next step**: the exact first action the next session should take
- **Key files**: paths with line numbers for the code that matters
- **Gotchas**: failed approaches and why they failed, surprising behavior,
  quirks of the codebase or tooling discovered along the way

Be specific. Exact file paths, exact command invocations, exact error
messages. The next session has none of your context. Gotchas are the most
valuable section because they are the most expensive to rediscover.

## 3. Tell the user

Confirm the file path and tell the user to run `/handoff:pickup` in a fresh
session to continue.
