---
name: architect
description: "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for non-trivial work where jumping to code would lock in the wrong shape."
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Architect

Before writing code, trace every system the change touches, then sketch two different shapes for it (types, signatures, module boundaries) and pick the one where each piece of state has one owner, each task has one way to do it, and callers need to know least. Redesign instead of patching if workarounds repeat.

For a large or contested design, run the **arena** skill in `references/arena.md` in this skill's folder instead of sketching alone. In that file, `{SKILLBASE}` is this skill's folder. Read `~/.agents/docs/other-models.md` first: it names the provider, model, effort and command for each model.
