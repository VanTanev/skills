---
name: build
description: "Implement a request or tickets risk-first with less code, then /code-review and cut the diff"
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

Implement the work in the request, spec, or tickets that the user names.

Decide each reversible detail yourself and keep going: a name, a file layout, the order of work, or which review finding to fix and how.
Stop and ask the user only for an irreversible action, a change of scope or goal, or a `risk-first` question whose readings lead to materially different work.

1. Call the Skill tool with `risk-first`.

2. Call the Skill tool with `less-code`.

3. Build the work by both skills.
   Continue until the requested behavior works and the repository's required checks pass.

4. Call the Skill tool with `code-review`.
   Fix each defect and spec gap that it finds, and each other finding that the Plan of `less-code` allows.

5. Do the Cut of `less-code` on the whole diff.

6. Report the account from `risk-first` and the report from `less-code`, updated for any behavior that the review fixes changed, and each detail that you decided, with its reason.
