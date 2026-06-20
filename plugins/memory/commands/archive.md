---
description: Move a cold memory out of the recall path to cut its token cost to zero
---

You are archiving one or more memories that are no longer worth recalling.
Treat $ARGUMENTS as the memory name(s) to archive, matched against the `name:`
slug in each file's frontmatter or its filename. If $ARGUMENTS is empty, ask
which memory to archive and stop.

## 1. Locate the memory directory

Your persistent memory lives in the directory that holds `MEMORY.md` (the
index loaded into context each session). Resolve that directory now. All paths
below are relative to it.

## 2. Confirm the target

For each requested name, find its `<name>.md` file. If a name matches no file,
say so and skip it. Before moving anything, read the file's first lines and
report the slug and one-line description back, so the user sees what is leaving
the recall path.

## 3. Archive the file

Archive into a sibling `memory-archive/` directory that sits next to the memory
directory, not inside it. If the memory directory is `<dir>/memory`, the archive
is `<dir>/memory-archive`. Create it if it does not exist, then move each target
with `mv <dir>/memory/<name>.md <dir>/memory-archive/<name>.md`. Keeping the
archive outside the memory directory guarantees the file leaves the scanned
path, so it can never be surfaced in a recall `system-reminder` again, while the
content is preserved and reversible.

## 4. Update the index

Remove the archived memory's pointer line from `MEMORY.md`. Then scan the
remaining memories for `[[<name>]]` links that now point at the archived file
and report them as dangling, but do not edit them unless the user asks. A
dangling link is a marker, not an error.

## 5. Tell the user

Confirm each file moved to `memory-archive/`, the `MEMORY.md` line removed, and
list any dangling links found. To restore, the reverse is `mv
<dir>/memory-archive/<name>.md <dir>/memory/<name>.md` plus re-adding the index
line.
