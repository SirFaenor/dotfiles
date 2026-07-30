---
name: trello-skill
description: Use when the user asks to create, manage, or query Trello boards, lists, cards, labels, members, checklists, or comments
---

# Trello Management

Manage Trello via `~/.trello/trello_utils.py`. Import `TrelloManager`, call methods, print results.

## Config Setup

Config lives at `~/.trello/config.json`:

```json
{
  "api_key": "YOUR_API_KEY",
  "token": "YOUR_TOKEN"
}
```

**Get credentials:**
1. API Key: https://trello.com/power-ups/admin
2. Token: Visit `https://trello.com/1/authorize?expiration=never&scope=read,write&response_type=token&key=YOUR_API_KEY`

User can add custom keys to the config — accessible via `tm.config`.

## First Run

If `~/.trello/config.json` is missing:
1. Create it with exactly these dummy values: `{"api_key": "YOUR_API_KEY", "token": "YOUR_TOKEN"}`
2. Tell user to populate using the credential URLs above. The keys MUST be `api_key` and `token` (not `api_token`, not `key`).
3. STOP — do NOT attempt any Trello API calls until config has real values.

## Usage Pattern

```python
import sys, os; sys.path.insert(0, os.path.expanduser("~/.trello"))
from trello_utils import TrelloManager
tm = TrelloManager()
```

Always activate the venv first if running as a script:

```bash
# macOS/Linux
source ~/.trello/.venv/bin/activate

# Windows (PowerShell)
~\.trello\.venv\Scripts\Activate.ps1
```

## Quick Reference

| Operation | Call |
|-----------|------|
| List boards | `tm.list_boards()` |
| Get board | `tm.get_board("Board Name")` |
| Create board | `tm.create_board("Name", desc="...")` |
| Update board | `tm.update_board("Name", name="New", desc="...")` |
| Close board | `tm.close_board("Name")` |
| List lists | `tm.list_lists("Board")` |
| Create list | `tm.create_list("Board", "List Name")` |
| Update list | `tm.update_list("Board", "Old Name", name="New Name")` |
| Archive list | `tm.archive_list("Board", "List Name")` |
| List cards | `tm.list_cards("Board", list_name="Optional")` |
| Get card | `tm.get_card("Board", "Card Name")` |
| Create card | `tm.create_card("Board", "List", "Title", desc="...", labels=["Bug"], due="2026-04-01")` |
| Move card | `tm.move_card("Board", "Card", dest_list="Done")` |
| Move to board | `tm.move_card_to_board("SrcBoard", "Card", "DestBoard", dest_list="List")` |
| Clone card | `tm.clone_card("SrcBoard", "Card", "DestBoard", "DestList", include_checklists=True)` |
| Search cards | `tm.search_cards("query", board_name_or_id="Optional")` |
| Update card | `tm.update_card("Board", "Card", name="...", desc="...", due="...")` |
| Archive card | `tm.archive_card("Board", "Card")` |
| Delete card | `tm.delete_card("Board", "Card")` |
| List labels | `tm.list_labels("Board")` |
| Create label | `tm.create_label("Board", "Name", "red")` |
| Add label | `tm.add_label_to_card("Board", "Card", "Label")` |
| Remove label | `tm.remove_label_from_card("Board", "Card", "Label")` |
| List members | `tm.list_members("Board")` |
| Assign member | `tm.assign_member("Board", "Card", "Alice")` |
| Remove member | `tm.remove_member("Board", "Card", "Alice")` |
| Create checklist | `tm.create_checklist("Board", "Card", "Steps", items=["A", "B"])` |
| Check item | `tm.check_item("Board", "Card", "Steps", "A")` |
| Delete checklist | `tm.delete_checklist("Board", "Card", "Steps")` |
| Add attachment | `tm.add_attachment("Board", "Card", url="https://...", name="Link")` |
| Add file | `tm.add_attachment("Board", "Card", file_path="/path/to/file")` |
| List attachments | `tm.list_attachments("Board", "Card")` |
| Remove attachment | `tm.remove_attachment("Board", "Card", "attachment_id")` |
| Add comment | `tm.add_comment("Board", "Card", "text")` |
| List comments | `tm.list_comments("Board", "Card")` |

All name parameters accept names (case-insensitive) or Trello IDs. Due dates use ISO 8601 format.

## Dependency

Requires `py-trello >= 0.19.0`. Installed in `~/.trello/.venv`. If missing:

```bash
# macOS/Linux
~/.trello/.venv/bin/python -m pip install py-trello

# Windows
~\.trello\.venv\Scripts\python.exe -m pip install py-trello
```

## Common Mistakes

- **Wrong token scope:** Token must have `read,write` scope. Re-authorize if operations fail with permission errors.
- **Board not found:** Check exact name with `tm.list_boards()`. Names are case-insensitive but must be exact.
- **Archived items missing:** Archived cards/lists don't appear in list operations. Use Trello web UI to unarchive.
- **Rate limits:** Trello allows 100 requests per 10 seconds. Warn user before batch operations.
