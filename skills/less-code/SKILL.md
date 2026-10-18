---
name: less-code
description: "Build only the code that the request needs, and cut the diff before you report it. Use when you implement a change, and after a code review."
---

Each line of the change must serve the request, a risk that a caller can reach, the evidence of the fault in a bug fix, or the removal of code that the change replaces.
Each result that the request states must hold, also for an input that no caller sends today.

## Plan

While you write the code:

- Build only what the request or a current caller reads.
  Add no field, export, option, mode, or endpoint for a later need.
- Before you write a helper, parser, retry, or schema, look for one in the repository and its libraries, and use it.
- When the change replaces a function, path, flag, or API, move every caller to the new one and delete the old one.
  Keep the old one only when stored data or a caller outside the repository still needs it.
- Write a guard, fallback, or retry only for a state that a caller or an outside input can produce.
  When code in the repository produces the bad state, fix that code.
- Add a layer, wrapper, or type only when it removes at least as much code or reader effort as it adds.
  Give each value one source.
- In a bug fix, each line traces to the evidence of the fault.
  When the evidence refutes a hypothesis, revert the code that it motivated.
- Write a comment only for a constraint that the code cannot show.

## Cut

Before you report, and after the code review when one runs, read the whole diff as a reviewer who wants less code.
For each hunk, name what it serves, or the review finding that it fixes.
Revert each hunk that serves nothing or breaks a Plan rule, such as a probe, a planning file, a test that another test covers, or an edit outside the request.

Done when each hunk has a name, and the required checks pass after the cut.

In the report, name each hunk that the request did not ask for, with what it serves, and each old path that you kept, with what still needs it.
