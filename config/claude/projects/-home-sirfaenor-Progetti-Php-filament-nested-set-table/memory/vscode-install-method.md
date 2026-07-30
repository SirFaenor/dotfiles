---
name: vscode-install-method
description: "User runs VSCode from the apt/.deb (Microsoft repo), not Snap. Switched on 2026-05-26 because Snap broke lerd/podman by leaking XDG_DATA_HOME."
metadata: 
  node_type: memory
  type: project
  originSessionId: 33297906-d0b9-4efd-97d1-18b98627d76d
---

User installed VSCode via the Microsoft apt repo (.deb) on 2026-05-26, after the Snap version was found to break lerd/podman: the Snap forced `XDG_DATA_HOME=/home/sirfaenor/snap/code/238/.local/share`, so podman looked in the wrong storage root and reported "no containers running" even when containers were active. The snap was removed.

**Why:** to make lerd/podman work in the VSCode integrated terminal without a per-command `XDG_DATA_HOME=...` prefix. Settings and extensions migrated automatically because they were already in standard paths (`~/.config/Code/`, `~/.vscode/extensions/`).

**How to apply:** if you see lerd/podman complaining about containers not running while `systemctl --user status lerd-*` shows them active, first check `which code` and `echo $XDG_DATA_HOME`. If `code` resolves to `/snap/bin/code` or XDG_DATA_HOME points inside `~/snap/`, the Snap got reinstalled — that's the root cause, not the lerd containers.
