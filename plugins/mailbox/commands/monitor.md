---
allowed-tools: Monitor, Bash(bash:*)
description: Watch the mailbox live and surface new messages between turns
---

Use the Monitor tool to run this watcher, then report each message as it appears:

`bash "${CLAUDE_PLUGIN_ROOT}/scripts/mail-watch.sh" $ARGUMENTS`

If the user gave a number of seconds, the watcher stops after that long. With no argument it runs until stopped.
