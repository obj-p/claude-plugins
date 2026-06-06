---
description: Load the latest handoff file, verify it against the repo, and continue the work
---

You are picking up work handed off from a previous session.

## 1. Find the handoff

Determine the repo name with
`basename "$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")"`
so all worktrees of a repo share one name.

If $ARGUMENTS names a handoff file, use it. Otherwise take the most recently
modified file in `~/.claude/handoffs/<repo>/` (ignore the `archive/`
subdirectory). If there is none, tell the user and stop.

## 2. Verify it against reality

The repo may have changed since the handoff was written. Before trusting it:

- Check `git status`, the current branch, and `git log` since around the
  handoff date
- Read the key files it names and confirm the referenced code is still there
  (line numbers may have drifted)
- Spot-check items listed as done

Tell the user about any drift you find and how you plan to adjust.

## 3. Archive it

Move the handoff file to `~/.claude/handoffs/<repo>/archive/`.

## 4. Continue the work

Summarize the goal, what is done, and what is outstanding in a few lines for
the user. Then start on the handoff's next step, honoring its gotchas.
