# Upstream

This skill is a vendored copy of the `hillclimb` playbook of the `poteto-mode` skill in the Cursor pstack plugin, with the `principle-prove-it-works` skill as a reference.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Paths:
  - `pstack/skills/poteto-mode/playbooks/hillclimb.md`, which is `SKILL.md` here.
  - `pstack/skills/principle-prove-it-works/SKILL.md`, which is `references/prove-it-works.md` here.
- Base of `SKILL.md`: `ce649c03ac3b75b6ae80cbd15b7e2c536caedb5a` (2026-10-14, "feat(pstack): match subagent effort to the job, drop Graphite from orchestrate, and cut playbooks to principles (#613)").
- Base of `references/prove-it-works.md`: `b0b9c7a0baf8b6aa1d00bf77d4101e577d4ba411` (2026-09-23, "docs(pstack): cut 19 more instructions Opus 5.5 does not need (#419)").
  The files here are equal to upstream at these commits, except for the local changes below.
- Checked up to: `1e5c90a4b6f249917bd21fe361b3a2a7deb741b8` (upstream `main`, 2026-10-14).
  Upstream has no changes to either file between its base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

## Local changes

The playbook becomes a skill that Claude Code, OpenCode, and Codex run without the rest of pstack.

- Frontmatter and title: added, because a playbook has none.
  The skill is model-invoked, and its description says when to use it.
- Playbook links: "A one-off fix is Bug fix or Perf issue." becomes "A one-off fix needs no loop.", and step 8 ships "the way the repo ships: a push or a PR" in place of the Opening a PR playbook.
  Step 4 gives the seven performance mantras inline, in place of a pointer to step 2 of the Perf issue playbook.
  Step 5 wakes "on the event you wait for", in place of the wake mechanism of the Autonomous run playbook, which uses the Cursor `/loop`.
- `how`: step 1 reads "the code that produces the metric end to end", because `how` starts Cursor model roles that this repo does not have.
- `show-me-your-work`: step 3 opens "a decision log" directly, because the playbook already gives its own columns.
- `prove-it-works`: the core discipline points to `{SKILLBASE}/references/prove-it-works.md`, a copy of the upstream principle skill with its frontmatter.
  In the reference, "(the **show-me-your-work** skill)" is removed, because this repo does not vendor it.
- `benchmark-checklist`: step 2 calls the Skill tool with `benchmark-checklist`, which this repo has as a model-invoked skill.
- Principle links: the links to `build-the-lever`, `guard-the-context-window`, `separate-before-serializing-shared-state`, `sequence-verifiable-units`, and `laziness-protocol` are removed, because the sentence before each link already states the rule.
  Step 5 keeps the reason of `guard-the-context-window` as "so your context holds the loop, not the code".
- Subagents: step 5 drops the Grok model slug and the poteto-mode effort rule.
- Parallel attempts: step 5 adds "measure each one alone: parallel runs on one machine measure each other's load".
- Holdout: step 1 splits labeled or sampled data into a dev set for the loop and a held-out test set, and step 7 scores the baseline and the final version on the test set once.
  The Reply adds the test score.
  Without a holdout, a loop on a labeled score fits the dev set.
- `agents/openai.yaml`: added, with `interface` only, because the skill is model-invoked.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from upstream to this copy.
The `a/SKILL.md` side is upstream `pstack/skills/poteto-mode/playbooks/hillclimb.md`, and the `a/references/prove-it-works.md` side is upstream `pstack/skills/principle-prove-it-works/SKILL.md`.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,21 +1,28 @@
-### Hillclimb
+---
+name: hillclimb
+description: "Improve one measured number in a loop against a target: one change, one measurement, keep or revert. Use when a metric must move over many attempts (latency, throughput, precision, recall, a score), or when a matcher or ranker needs tuning."
+---
 
-**You own the metric and the experiment's integrity. Supervise and review. Delegate the attempts.** For sustained, iterative improvement of one measurable thing against a target. A one-off fix is Bug fix or Perf issue. This is the loop.
+# Hillclimb
 
-Core discipline: one change, one measurement, keep or revert. Never stack untested changes, and never claim a win from code inspection (the **prove-it-works** principle skill).
+**You own the metric and the experiment's integrity. Supervise and review. Delegate the attempts.** For sustained, iterative improvement of one measurable thing against a target. A one-off fix needs no loop. This is the loop.
 
-1. Ground the workload and architecture before choosing the metric. Run the **how** skill over the target, name the realistic workload dimensions that can move the result (data size, history, state, concurrency), and select a case that reproduces the user's complaint. If no case reproduces it, fix the repro instead of hillclimbing. Then fix one metric, the direction that counts as better, and a checkable stop predicate that pairs a target with a floor on attempts so a lucky early win can't end the run (the example "at least 50% better than baseline and at least 10 iterations" is this shape). Use the user's numbers when given, otherwise agree them.
-2. Build the measurement harness, prove its sensitivity, then freeze it (the **build-the-lever** principle skill). Run contrasting realistic workloads and confirm the target case reproduces the symptom while easier cases separate as expected. If the harness cannot distinguish them, revise the workload or metric. Vet the harness with the **benchmark-checklist** skill before you freeze it, and make it print its error count and a count of the work done. Once frozen, one repeatable command emits the metric, sampled enough to clear the noise (median of N, not a single run). Record the baseline metric and a green run of the regression gate (the tests that must keep passing) before any change.
-3. Open the decision log via the **show-me-your-work** skill. A `decision.tsv`, one row per attempt: id, hypothesis, change, before, after, delta, tests, verdict (kept or reverted), note. Read it before each attempt. Keep it out of the tree (gitignored).
-4. Ground each hypothesis in the architecture model from step 1, so it names a specific mechanism ("defer X off the boot path because it blocks first paint"), not "try memoizing something". For a perf metric, order hypotheses by the performance mantras in step 2 of the Perf issue playbook (`playbooks/perf-issue.md`). Borrow only their order, not that step's stop rule.
+Core discipline: one change, one measurement, keep or revert. Never stack untested changes, and never claim a win from code inspection. Before the first keep, read `{SKILLBASE}/references/prove-it-works.md`.
+
+1. Ground the workload and architecture before choosing the metric. Read the code that produces the metric end to end, name the realistic workload dimensions that can move the result (data size, history, state, concurrency), and select a case that reproduces the user's complaint. If no case reproduces it, fix the repro instead of hillclimbing. Then fix one metric, the direction that counts as better, and a checkable stop predicate that pairs a target with a floor on attempts so a lucky early win can't end the run (the example "at least 50% better than baseline and at least 10 iterations" is this shape). Use the user's numbers when given, otherwise agree them.
+   If the metric is a score on labeled or sampled data, split the data before the first measurement: a dev set for the loop, and a held-out test set that no attempt, hypothesis, or subagent sees. The loop measures only the dev set.
+2. Build the measurement harness, prove its sensitivity, then freeze it. Run contrasting realistic workloads and confirm the target case reproduces the symptom while easier cases separate as expected. If the harness cannot distinguish them, revise the workload or metric. Before you freeze the harness, call the Skill tool with `benchmark-checklist` to vet it, and make it print its error count and a count of the work done. Once frozen, one repeatable command emits the metric, sampled enough to clear the noise (median of N, not a single run). Record the baseline metric and a green run of the regression gate (the tests that must keep passing) before any change.
+3. Open a decision log: a `decision.tsv`, one row per attempt: id, hypothesis, change, before, after, delta, tests, verdict (kept or reverted), note. Read it before each attempt. Keep it out of the tree (gitignored).
+4. Ground each hypothesis in the architecture model from step 1, so it names a specific mechanism ("defer X off the boot path because it blocks first paint"), not "try memoizing something". For a perf metric, order hypotheses cheapest first: don't do it, do it once, do it less, do it later, do it when nobody waits, do it concurrently, do it cheaper.
 5. Loop, one hypothesis per iteration:
-   - Hand the change to a subagent using your configured hillclimb model (default `grok-4.7-xhigh-fast`) with a tight scope. Pick each subagent's reasoning level and fast or standard speed for the job, per the Subagents section. Supervise and review the diff rather than typing it (the **guard-the-context-window** principle skill). When several independent hypotheses are live, fan them to parallel subagents, each in its own worktree (the **separate-before-serializing-shared-state** principle skill).
+   - Hand the change to a subagent with a tight scope. Supervise and review the diff rather than typing it, so your context holds the loop, not the code. When several independent hypotheses are live, fan them to parallel subagents, each in its own worktree, and measure each one alone: parallel runs on one machine measure each other's load.
    - Measure before and after with the frozen harness, and run the regression gate.
    - Accept only when the metric moves past noise and the gate stays green. Otherwise revert the change in full. A tweak that "might help" is not kept.
    - One commit per accepted fix, staging only the files you changed (`git add <files>`, never `-A`). Log the row either way, kept or reverted.
-   Each iteration ends in a check before the next begins (the **sequence-verifiable-units** principle skill). If the run is unattended, borrow only the wake mechanism from the Autonomous run playbook (`playbooks/autonomous-run.md`), not its stop rule.
-6. Push past the first plateau. On a stall, several rejects in a row, pivot category, combine near-misses, re-read the source, or try something more radical before concluding the hill is climbed. Correctness and simplicity outrank the number. Revert a win that breaks behavior, and keep a simplification that holds the number (the **laziness-protocol** principle skill).
+   Each iteration ends in a check before the next begins. If the run is unattended, wake on the event you wait for (a background job that ends, a watched file), with a long time-based heartbeat as fallback.
+6. Push past the first plateau. On a stall, several rejects in a row, pivot category, combine near-misses, re-read the source, or try something more radical before concluding the hill is climbed. Correctness and simplicity outrank the number. Revert a win that breaks behavior, and keep a simplification that holds the number.
 7. Stop when the predicate is met, or when the remaining ideas are marginal and not worth their cost. Don't relax the predicate to meet it, and don't quit while cheap untried hypotheses remain. If you are stuck, surface it instead of spinning.
-8. Run **Opening a PR** with the accepted commits stacked in the order they landed.
+   With a held-out test set, score the baseline and the final version on it once, after the loop stops. A test score well below the dev score means the loop fit the dev set: report it, and never tune against the test set.
+8. Ship the accepted commits in the order they landed, the way the repo ships: a push or a PR.
 
-**Reply:** the metric and target, baseline to final with the percent delta, iterations run (kept vs reverted), each accepted fix on one line, the `decision.tsv` path, and the best idea you would try next if pushed further.
+**Reply:** the metric and target, baseline to final with the percent delta, the held-out test score for both if there is a test set, iterations run (kept vs reverted), each accepted fix on one line, the `decision.tsv` path, and the best idea you would try next if pushed further.
--- a/references/prove-it-works.md
+++ b/references/prove-it-works.md
@@ -19,4 +19,4 @@
 
 The strongest proof is a deterministic script that re-runs the same comparison, not a one-time eyeball. Write the script, run it, and keep its output as an artifact a reviewer can re-run instead of trusting your word.
 
-Keep the artifact visible for the human. Commit it only for large or complex work where the trail has to be auditable later, like a big port or migration (the **show-me-your-work** skill).
+Keep the artifact visible for the human. Commit it only for large or complex work where the trail has to be auditable later, like a big port or migration.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/poteto-mode/playbooks/hillclimb.md pstack/skills/principle-prove-it-works/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/poteto-mode/playbooks/hillclimb.md > SKILL.md` and `git -C <clone> show origin/main:pstack/skills/principle-prove-it-works/SKILL.md > references/prove-it-works.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of these two commands, in this order:
   `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/poteto-mode/playbooks/hillclimb.md) SKILL.md` and
   `diff -u --label a/references/prove-it-works.md --label b/references/prove-it-works.md <(git -C <clone> show origin/main:pstack/skills/principle-prove-it-works/SKILL.md) references/prove-it-works.md`.
   Set both bases and "Checked up to" to the new upstream SHA and date.
