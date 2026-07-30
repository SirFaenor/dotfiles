---
name: feedback-no-delete-on-test
description: "Never delete/truncate existing records when running ad-hoc tests (tinker, DB checks) in this project"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2d230008-e518-4f0c-a1b1-694e0077e568
  modified: 2026-07-27T10:28:41.883Z
---

Never call `truncate()`, `delete()`, or any destructive DB operation on real tables while testing something (e.g. via `php artisan tinker`), even if you plan to clean up after yourself.

**Why:** user explicitly flagged this after I truncated the `imputazioni_costi` table to clean up a test record I had just created — even though in that case the table happened to be empty beforehand, the practice is unsafe in general since existing data could be present.

**How to apply:** when a test needs to insert data to verify behavior (uniqueness constraints, model casts, migrations, etc.), either (a) wrap the test in a DB transaction and roll it back, or (b) delete only the specific record(s) by the ID(s) just created — never call table-wide truncate/delete. Applies to this project (service.materna) and by extension to any project with a real/shared database.
