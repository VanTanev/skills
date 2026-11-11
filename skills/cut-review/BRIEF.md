You are a subagent. Don't run memo.

This is a read-only review. Your only output is the report.

## Subject

<PR URL and title>

- Snapshot, detached at <head sha>: `<snapshot path>`
- Diff: `git -C <snapshot path> diff <base>...HEAD` (<N> files, +<a> / −<d>)
- PR description: `<path>`
- Main areas: <directories>

Read the end state of each touched file, not only the diff hunks.

## Horizon

The horizon is the next scope this code must serve: <name>, at `<path>`.
<3 to 6 line summary of what the horizon adds.>

## Task 1: cut

List every item that is BOTH:

1. **Unused now**: one of the smells from Fowler's _Refactoring_, or unused text and config:
   - **Speculative Generality**: only tests reach it; a type, union member, field, parameter, option or branch that is written but never read, or that always has one value.
   - **Lazy Element** and **Middle Man**: a module that fails the deletion test.
   - **Temporary Field**: a field that has a value only in some cases.
   - **Dead code**: an export with no importer outside tests; a test helper or fixture that no test needs; code that this change makes dead elsewhere.
   - A workflow input, env var or permission that nothing reads; docs, skill text or glossary entries for things that are not in the code.
2. **Outside the horizon**: no horizon item needs it.
   Code kept for a need that the horizon does not have is a presumptive feature, so it is a cut.

Small items count: one export, one parameter, one union member.
Each item carries its evidence (the search you ran and its result), the refactoring that removes it (Remove Dead Code, Inline Function, Inline Class, Collapse Hierarchy, Remove Middle Man, Change Function Declaration), and its cost of carry: what each later change no longer has to read, test and keep working.
An item that is unused now but that the horizon needs goes under "Keep", with the horizon line that needs it.

## Task 2: simplify

Call the Skill tool with "codebase-design".
Use its terms exactly: module, interface, implementation, depth, seam, adapter, leverage, locality.

Look for: shallow modules and pass-throughs; modules to merge or split; seams in the wrong place; one rule spread over several modules; state that is stored but can be derived; one concept owned in two places; interfaces that can be smaller; tests that go past an interface; import edges the change added.
Prefer changes that make the horizon work smaller. Flag each part of this design that the horizon must undo.

## Settled: take these as fixed

<one positive fact per line>

Repository rules: <CODING_STANDARDS.md, glossary, ADR paths>.

## Report

<Claude reviewers: Write Markdown to `<scratchpad>/cut-review/<name>.md`, then reply with only its path.>
<Codex reviewers: Your final message is the report, in Markdown.>

```
# <name>

## Cut
C1. <what> — <smell> — <file:line> — evidence: <search and result> — refactoring: <name> — horizon: <why not needed> — cost of carry: <what later changes skip>, ~N lines

## Keep
K1. <what> — <file:line> — <horizon line that needs it>

## Defects
B1. <rule and source> — <file:line> — <input → wrong result>

## Design
D1. <title>
- Problem: <file:line>
- Target shape: <call tree, file tree or diff>
- Interface: <what callers must know now> → <what they must know after>
- Owner: <the one module that owns each rule after the change>
- Tests: <which tests cross the new interface; which existing tests become redundant>
- Gain: <depth and locality from the lines above, then lines and imports>
- Cost and risk:
- Horizon: <effect>

## Top 5
1. <id> — one line
```

Terse. Short sentences in plain English.
