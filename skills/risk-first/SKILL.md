---
name: risk-first
description: "Risk-first testing: find where a change can go wrong before you write it, and check each risk with a discriminating input. Use when you implement a feature, ticket, or spec, or fix a bug."
---

## 1. Hunt the risks

Before you write code, list the risks of the change:

- a line of the request with two **readings** that lead to different behavior;
- a likely **mistake** at a place where code goes subtly wrong: a boundary, an ordering or tie, absent versus empty, time and zone, identity, a repeat, a partial failure, the data of another system.

A risk needs an input that the request names, or one that a caller or another system can send past the types and the schema.
When the request or a review already names the risks, take those.
A change of a few lines has one risk or none.

For each risk, write a **discriminating** input, where the intended behavior and the mistake or the other reading give different results, and its expected result from an **oracle**.
Include the boundary value itself, and pick values where a swap or a reversal changes the result.
For the data of another system, take the input from a real sample, such as a captured response or the real schema, not from a fixture that you write.
The request settles intent, and a probe of the real system settles a fact about that system.
With no oracle, take one reading as a stated assumption.
When the readings lead to materially different work, ask before you write code.

Done when each risk has an input and an expected result from an oracle or a stated assumption.

## 2. Check each risk

For a bug fix, reproduce the failure before you fix it.

Check each risk with the cheapest thing that shows the behavior: an existing test, a probe that you delete after use, a real use of the feature as its user does it, or a new test.
Keep a new test only when it fails on a mistake or a wrong reading that no other test catches, and add it as a row of an existing table test where one fits.

Call the code as its users do, and assert the literal result or effect that they see.
Rewrite or delete each test in the change that still passes when the code returns a wrong value: a bare `toBeDefined` or `toHaveBeenCalled`, a restated constant, or an assertion on data that the test built.

Extend an existing property test when the change affects what it covers.
Write a new property test only for a relation over a whole flow, such as a fixed point, a replay, or a round trip, and not for unit logic.
In a property test, generate only valid inputs, and assert relations and literal anchors, not a copy of the production logic.

When a check fails, the code is wrong until the oracle shows that the check is wrong.
A narrower generator or a looser assertion needs that proof.

Done when each risk has a check result or a named gap.

## 3. Account

In the report, give each acceptance criterion and each risk its evidence or its gap.
State each assumption that you did not confirm, and each check that fails or that you could not run.
