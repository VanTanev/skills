---
name: risk-first
description: "Risk-first implementation: hunt the risks before code, settle each with an oracle, pin it with a discriminating check. Use when implementing a spec, ticket, or feature, or fixing a bug."
---

Implement the work in the spec, tickets, or request you were given.

## 1. Hunt the risks

Before you write code, identify risks in the change: a spec line that admits multiple **readings**, or a plausible **mistake** at a place where code goes subtly wrong: a boundary, an ordering or tie, absent versus empty, time and zone, identity, a repeat, a partial failure.
Keep the hunt proportional to the change; a simple edit can have no risks.

For each risk, write down:

- the competing readings, each with the spec line it rests on, or the mistake and the requirement it would violate;
- the **oracle** that settles it. Checks expose ambiguity; they cannot decide intent. The oracle is a spec line, an acceptance criterion, an ADR, a seam profile, a worked example, or a run of the project's verification skill. With no oracle, take one reading as a stated assumption. When the readings lead to materially different work, ask the user. As a subagent, stop before writing code and report the question with its competing readings to your caller;
- one concrete input and its literal result from the oracle or stated assumption, as the intended behavior.

Done when every identified risk has an intended behavior supported by an oracle or stated assumption, and no unresolved ambiguity would materially change the work.

## 2. Build and verify

For a bug fix, attempt to reproduce the existing failure before the fix.
If reproduction is blocked, state the missing conditions and use the available evidence to guide the fix.

Choose and run the smallest checks that can expose each risk through observable behavior: an existing test, a new test, a temporary probe, or a direct use of the feature, by hand or through the project's verification skill.
Keep a permanent test for the chosen interpretation when competing readings would produce different observable results.

For each check, choose a **discriminating input** that distinguishes the intended behavior from the competing reading or mistake.
Derive the expected result from the oracle or stated assumption.
Prefer a **boundary pair**, one input on each side of the boundary, plus the boundary itself, and an **asymmetric** input, where swapped arguments or a reversed comparison give a different answer.

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

## 3. Account

In the report, account for every acceptance criterion and identified risk: the verification evidence, or the gap that remains.
State any assumptions that remain unconfirmed, and any unresolved failure or blocked check.
