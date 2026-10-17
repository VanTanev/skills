---
name: build
description: "Implement a spec or tickets risk-first, then /code-review"
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

Implement the work in the spec or tickets the user names.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask.

Decide each reversible detail yourself and keep going: a name, a file layout, the order of work, or which review finding to fix and how.
Stop and ask the user only for an irreversible action, a change of scope or goal, or a `risk-first` question whose readings lead to materially different work.

1. Call the Skill tool with `risk-first` to build the work.

2. Call the Skill tool with `code-review` and act on its findings.
   Fix each defect and spec gap with the smallest change that removes it, and with a deletion where one works.
   For a finding that asks for more structure, such as a new type, helper, or layer, take the fix only when it removes at least as much code or reader effort as it adds.
   Then cut your fixes as in the `risk-first` Cut step.

3. Report the account from `risk-first`, updated for any behavior the review fixes changed, and each detail you decided, with its reason.
