---
name: architect
description: "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for non-trivial work where jumping to code would lock in the wrong shape."
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Architect

Before writing code, trace every system the change touches, then sketch two different shapes for it (types, signatures, module boundaries) and pick the one where each piece of state has one owner, each task has one way to do it, and callers need to know least. Redesign instead of patching if workarounds repeat.

For a large or contested design, ask the user to start the **arena** skill instead of sketching alone, because it is user-invoked, and only the user can start it.
