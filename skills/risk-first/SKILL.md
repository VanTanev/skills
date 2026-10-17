---
name: risk-first
description: "Risk-first implementation: hunt the risks before code, settle each with an oracle, pin it with a discriminating check. Use when implementing a spec, ticket, or feature, or fixing a bug."
---

Implement the work in the spec, tickets, or request you were given, with the smallest change that does it.

## 1. Hunt the risks

Before you write code, identify risks in the change: a spec line that admits multiple **readings**, or a plausible **mistake** at a place where code goes subtly wrong: a boundary, an ordering or tie, absent versus empty, time and zone, identity, a repeat, a partial failure.
Keep the hunt proportional to the change; a simple edit can have no risks.
A case that no spec line names, and that no caller or input can produce, is not a risk: it gets no code and no check.

For each risk, write down:

- the competing readings, each with the spec line it rests on, or the mistake and the requirement it would violate;
- the **oracle** that settles it. Checks expose ambiguity; they cannot decide intent. The oracle is a spec line, an acceptance criterion, an ADR, a seam profile, a worked example, or a run of the project's verification skill. With no oracle, take one reading as a stated assumption. When the readings lead to materially different work, ask the user. As a subagent, stop before writing code and report the question with its competing readings to your caller;
- one concrete input and its literal result from the oracle or stated assumption, as the intended behavior.

Done when every identified risk has an intended behavior supported by an oracle or stated assumption, and no unresolved ambiguity would materially change the work.

## 2. Plan the smallest change

Fit the requirement into the code that it touches as if it had been there from the start, then plan the smallest diff that gets there.

- **Subtract first.** In the code that the change touches, delete dead code, unused parameters, redundant checks, and stale references before you add code.
  A bug fix deletes only the code that the fix makes dead.
- **Replace the old code.** When new code replaces a function, path, flag, or API, move every caller to it and delete the old one in the same change.
  Keep an old path only when the spec asks for it, or when a caller outside the repository, stored data, or an older deployed version still needs it.
- **Reuse** the helpers and patterns that the repository has.
- **Guard only real states.** Write a guard, fallback, retry, or validation only for a case that the spec names, or that a caller or input outside your control can produce.
  When code in the repository can produce the bad state, fix it at its source.
- **Add structure only when it pays.** Add a layer, wrapper, option, or abstraction only when it removes at least as much code or reader effort as it adds.
  Three similar lines are better than an early abstraction.
  Put a rule that must change everywhere at once in one place.

## 3. Build and verify

For a bug fix, attempt to reproduce the existing failure before the fix.
If reproduction is blocked, state the missing conditions and use the available evidence to guide the fix.
Every line of the fix traces to evidence of the fault.
When evidence refutes a hypothesis, revert the code that it motivated.

Choose and run the smallest checks that can expose each risk through observable behavior: an existing test, a new test, a temporary probe, or a direct use of the feature, by hand or through the project's verification skill.
Keep a permanent test for the chosen interpretation when competing readings would produce different observable results.
Keep another new test only when no other test would fail on the mistake that it catches.

For each check, choose a **discriminating input** that distinguishes the intended behavior from the competing reading or mistake.
Derive the expected result from the oracle or stated assumption.
Prefer a **boundary pair**, one input on each side of the boundary, plus the boundary itself, and an **asymmetric** input, where swapped arguments or a reversed comparison give a different answer.
When a check is a test with several inputs, write one table test for it.

Call the code as its users do, and assert the literal result or effect they see: for a mock, the payload it received; for an absence, also the presence on another input; for a constant, the behavior of the code that reads it.
A test that would still pass if every imported function returned `undefined` or a wrong value discriminates nothing: `toBeDefined`, `toBeTruthy`, `toHaveBeenCalled`, `expect(f(a)).toBe(f(a))`, a restated constant or prompt string, an assertion on data the test built.
Rewrite or delete each such test in the change.

Extend existing property tests when the change affects the behavior they cover.
When a risk generalises into a **relation** that must hold across valid inputs, put it in a property test: extend the one that covers the behavior, or write one.
When writing that property test:

- Construct the valid relationships the behavior needs directly in the generator: related identifiers, ordered times, unequal amounts, valid sequences of actions.
  Preserve those relationships during shrinking.
  Prefer the workspace's existing generator patterns.
- Exercise each class the risk names, and sample generated inputs until each class has appeared.
- State relations and literal **anchors**; restate no production logic.

When a check fails, use its oracle or stated assumption to decide whether the code or the check is wrong.
Cite the basis for any changed expected value.

When implementation reveals a new risk or changes an assumption, update the risk analysis and verify the affected behavior.
Continue until the requested behavior is implemented, every identified risk has its check result or a named gap, and the repository's required checks pass.

## 4. Cut

Read the whole diff as a reviewer who wants less code after the change.
For each hunk, name what it serves: a requirement, an identified risk, evidence of the fault, a deletion of dead or replaced code, or a rule of the repository's coding standards.
Revert each hunk that serves nothing: a speculative guard, an option that every caller sets the same way, a wrapper with one caller, an old path beside its new one, a probe, a test that repeats another test, a narrating comment, an edit outside the request.

Done when you can name what each hunk serves, and the required checks pass after the cut.

## 5. Account

In the report, account for every acceptance criterion and identified risk: the verification evidence, or the gap that remains.
State any assumptions that remain unconfirmed, and any unresolved failure or blocked check.
Name each old path that you kept, and what still needs it.
