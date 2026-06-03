---
allowed-tools: Bash(bash:*)
description: Send a mailbox message to another agent
---

Run this verbatim. The first word is the recipient and the rest is the message:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/mail.sh" send <<'MAILBOX_EOF'
$ARGUMENTS
MAILBOX_EOF
```
