# Upstream

This skill is a vendored copy of `benchmark-checklist` from the Cursor pstack plugin, with text from `principle-explain-the-number`.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Paths: `pstack/skills/benchmark-checklist/SKILL.md`, and `pstack/skills/principle-explain-the-number/SKILL.md` for the "Eval results" section and the decision rule.
- Base of `benchmark-checklist`: `2f87c854fe3e2fcda44ca86b46ede35aad3c46b7` (2026-11-16, "feat(pstack): shorter skill texts, worker.md, and Opus-first routing capped at xhigh (#1249)").
  The files here are equal to upstream `benchmark-checklist` at this commit, except for the local changes below.
- Base of `principle-explain-the-number`: `2f87c854fe3e2fcda44ca86b46ede35aad3c46b7` (2026-11-16, "feat(pstack): shorter skill texts, worker.md, and Opus-first routing capped at xhigh (#1249)").
- Checked up to: `792440e8a560a4a3f63748cdee70491ecd412982` (upstream `main`, 2026-11-20).
  Upstream has no changes to either file between its base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.
The "Eval results" section was updated to the shorter `principle-explain-the-number` of upstream #1249 on 2026-11-21.

## Local changes

All changes let Claude Code, OpenCode, and Codex use the skill without the rest of pstack, and let the agent start it by itself.

- Invocation: model-invoked.
  `disable-model-invocation: true` is removed, so the agent starts the skill when it reports a measured number.
  The upstream description already says when to use the skill.
- Description and scope: "a perf measurement" becomes "a number", and eval results are added to the triggers.
  The description also fires when a measured number goes into a report, a page, a video script or a PR body, because numbers reached team documents with no check ([control-plane#71](https://github.com/VanTanev/control-plane/issues/71)).
  The first paragraph points to the new "Eval results" section.
- Eval results: a new section, made from the `principle-explain-the-number` text for numbers that are not performance numbers.
  It keeps that skill's list of other things a number can measure, its three questions for eval trials, and its rule to keep the evidence with the number.
  "Eval result" gets a definition with two examples, so that a matcher's precision and recall on labeled pairs counts.
- Decision rule: from `principle-explain-the-number` at `ab1f702`, "Write the decision before you run. Name the result that would change a decision, and the noise floor. Stop when the run-to-run spread is larger than the effect."
  It is a new bullet in "Before you run anything", and one sentence at the start of "Eval results".
  The description says "Use before you run a benchmark or an eval", from that skill's new "Apply before you measure".
- Playbooks: the links to the poteto-mode "Perf issue" and "Hillclimb" playbooks are removed, because this repo does not vendor `poteto-mode`.
- `agents/openai.yaml`: added, with `interface` only, because the skill is model-invoked.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from upstream `benchmark-checklist` at the base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,18 +1,18 @@
 ---
 name: benchmark-checklist
-description: "Vet a perf measurement (limiter, tuning, limits, errors, repeatability, relevance, and whether the work happened) before you report or act on it. Use when you run a benchmark or report a speedup or regression you measured."
-disable-model-invocation: true
+description: "Vet a number (limiter, tuning, limits, errors, repeatability, relevance, and whether the work happened) before you report or act on it. Use before you run a benchmark or an eval, when you report a speedup, regression or eval result, and when you put a measured number in a report, a page, a video script or a PR body."
 ---
 
 # Benchmark checklist
 
-Use this when you produce a performance number: a PR's before and after, a regression claim, a hillclimb harness, or a library or config choice. Answer each question with evidence from a run, not a guess about the code.
+Use this when you produce a performance number: a PR's before and after, a regression claim, a hillclimb harness, or a library or config choice. For an eval result, see "Eval results" below. Answer each question with evidence from a run, not a guess about the code.
 
 For a quick ballpark the user asked for, one run is enough. Still check questions 4 and 7, and say that it is one run. Skip the rest unless that run looks wrong. A choice between options is never a ballpark.
 
 ## Before you run anything
 
 - Write down the claim you expect to make, in the words you would ship ("export is 30% faster at p50 on the 60k-row dataset"). The questions test that sentence.
+- Write down the result that would change a decision, and the noise floor. Stop when the run-to-run spread is larger than the effect.
 - Read the measurement script. Note what it times, counts, and ignores.
 - Check the load average with `uptime` and the core count with `nproc`. If the machine is busy, find out what is running. If you cannot stop it, interleave the sides so both see the same noise, and say so in the report.
 
@@ -33,7 +33,6 @@
 - Call the verdict inconclusive when you claim a difference but cannot name the limiter, when a side ran untuned, or when you could not check questions 4 and 7. Name the gap.
 - Keep a PR body to one primary number. Put the runs, range, and limiter evidence in a linked artifact or notes file.
 
-## Other perf material
+## Eval results
 
-- Vet the **Perf issue** playbook's baseline before the playbook plans from it, and every number after that.
-- Vet the **Hillclimb** playbook's harness before it is frozen. The frozen harness then prints error and work counts, so each keep-or-revert checks questions 4 and 7 for free.
+An eval result is a score from trials of a task, such as a pass rate, or the precision and recall of a matcher on labeled pairs. Before the trials, write down the score that would change a decision, and the noise floor. List what else the score could be measuring, and rule out each one with evidence: errors, skipped or cached work, trials that never ran, an untuned side, noise, and a scenario too small to matter. Then ask whether every run did the task, whether the gap holds across trials and models, and whether the scenario matters. Keep the trial count, the spread, and what limits the score with the number.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/benchmark-checklist/ pstack/skills/principle-explain-the-number/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/benchmark-checklist/SKILL.md > SKILL.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/benchmark-checklist/SKILL.md) SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
   If `principle-explain-the-number` changed, update the "Eval results" section by hand.
