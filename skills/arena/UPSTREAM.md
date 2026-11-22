# Upstream

This skill is a vendored copy of `arena` from the Cursor pstack plugin, with the `principle-redesign-from-first-principles` and `principle-prove-it-works` skills as references.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- File map, one line per file: the upstream path under `pstack/skills/`, then the path here.

  ```text
  arena/SKILL.md SKILL.md
  principle-redesign-from-first-principles/SKILL.md references/redesign-from-first-principles.md
  principle-prove-it-works/SKILL.md references/prove-it-works.md
  ```

- Base of `SKILL.md`: `dd24b6707267cd89c6621c4efc6fa91a1d0666ec` (2026-11-19, "chore(pstack): run the Gemini panel seat at gemini-4-neon-xhigh (#1284)").
- Base of `references/prove-it-works.md`: `2f87c854fe3e2fcda44ca86b46ede35aad3c46b7` (2026-11-16, "feat(pstack): shorter skill texts, worker.md, and Opus-first routing capped at xhigh (#1249)").
- Base of `references/redesign-from-first-principles.md`: `bf0c7cd80abdbf7fe47b634978a7d1b4071f71a7` (2026-11-14, "feat(pstack): new default models, one-file why and how, statechart fixes, sharpen and reflect text (#1236)").
  The files here are equal to upstream at these commits, except for the local changes below.
- Checked up to: `7a583913eb1b8d1a0ee76753d1a2cf072e7b54f9` (upstream `main`, 2026-11-21).
  Upstream has no changes to these files between their bases and this commit.

It was added on 2026-11-22.
Before that, the same copy was `references/arena.md` in the `architect` skill of this repo, which was the only way to start it.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the trigger phrases are removed, because model invocation is off.
  It keeps its "Use when" part, which gives the scope of the command.
- Runners: upstream reads them from `pstack-models.mdc` and starts each one as a Cursor `Task` subagent with a model slug.
  Step 3 of Phase A tells the agent to read `~/.agents/docs/other-models.md` first, which names the model of each runner and of the judge.
  Claude Code subagents can use only Claude models.
  So Runner 1 is a subagent on the agent's own model, and Runner 2 runs on the other family.
  In T3 Code, the agent starts Runner 2 with `delegate_task` on a model of the other family, because T3 Code shows that child to the user, who can follow and stop it.
  Elsewhere, Runner 2 is the CLI of the other family: `codex exec -s workspace-write` from a Claude model, and `claude -p --permission-mode acceptEdits` from any other model.
  If neither way starts it, Runner 2 is a second subagent, and the arena says that it has one model family.
  These are the adversary rules of `interrogate`, because a runner writes its candidate.
  The user can name more models for more runners, in place of the runner list in the rule file.
- Effort: Runner 1 runs at the agent's own effort, because a runner does the whole task.
  This replaces the pointer to the Subagents section of `poteto-mode`, which this repo does not vendor.
- Fan out: "Spawn all N subagents in one message with `run_in_background: true`" becomes "Start all N runners at the same time, in the background", because Runner 2 is a T3 Code child or a CLI, not a subagent.
- Judge: the cross-judge runs on the other family, read-only.
  In T3 Code, the agent starts it with `delegate_task` on a model of the other family, because T3 Code shows that child to the user, who can follow and stop it. Its task says not to edit.
  Elsewhere, it is the CLI of the other family: `codex exec -s read-only` from a Claude model, and `claude -p --permission-mode plan` from any other model.
  If neither way starts it, the agent picks the base alone, and says so.
- Output location: `/tmp/arena-<slug>/candidate-<n>/` becomes a directory in the scratch or temporary directory, because Claude Code gives each session its own scratch directory.
- Principle links: `redesign-from-first-principles` and `prove-it-works` point to their copies in `references/`, which are byte copies of the upstream skills, with their frontmatter.
  The links to `separate-before-serializing-shared-state` and the Laziness Protocol are removed, because the sentence already states the rule.
  Step 4 of Phase A keeps the reason as "so no two candidates write to the same file".
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from upstream to this copy.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: arena
-description: "Spawn N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. Use for /arena, 'arena this', 'throw it in the arena', or when one attempt at a non-trivial artifact would lock in the wrong shape."
+description: "Spawn N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. Use when one attempt at a non-trivial artifact would lock in the wrong shape."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Arena
@@ -14,34 +16,34 @@
 
 1. State the artifact each candidate is producing.
 2. Derive the rubric, 3-6 concrete gradeable criteria for what success looks like on *this* task. It is the picker's tool in Phase D. Candidates only see the task.
-3. Pick the runners from the `arena runners` line in `~/.cursor/rules/pstack-models.mdc`, by default `claude-fable-5-2-high`, `claude-opus-5-5-high-fast`, and `gemini-4-neon-xhigh`. An `auto` or `inherit-parent` entry is the parent model, so omit `model` and spawn `generalPurpose`. If the Task tool rejects a slug, use the nearest valid slug of the same family or drop the seat, keep at least two runners, and say so. Families go by prefix, and the longest match wins: `claude-fable-*`, `claude-*`, and `gemini-*`, after dropping a leading `cursor-`. Any other slug's family is its text before the first hyphen. Spawn more for multiple design directions, and repeat one model when the work is generation-bound, not judgment-sensitive. Pick each subagent's reasoning level per the Subagents section of the **poteto-mode** skill.
-4. Give each candidate its own output location (a git worktree where possible, otherwise `/tmp/arena-<slug>/candidate-<n>/`), per the **separate-before-serializing-shared-state** principle skill.
+3. Pick the runners. Read `~/.agents/docs/other-models.md` first: it names the provider, model, effort and command for each model. By default there are two, on two model families. **Runner 1** is a subagent on your own model, at your own effort, because a runner does the whole task. If you do not know your effort, do not set it. **Runner 2** runs on a different model family, in the background. In T3 Code, start it with `delegate_task` on that family's model, with its output location and rationale file in the task. Elsewhere, run that family's CLI with its prompt on stdin. If you are a Claude model, run `codex exec -s workspace-write --skip-git-repo-check -C <output location> -o <rationale file> -`. Otherwise, run `claude -p --permission-mode acceptEdits` in its output location, and send its output to the rationale file. The CLI uses its own configured model. If neither way starts Runner 2, run Runner 2 as a second subagent on your own model, and say that the arena has one model family. If the user names more models, add one runner for each. Spawn more runners when the arena covers multiple design directions. Use the same model N times when the work is generation-bound rather than judgment-sensitive.
+4. Give each candidate its own output location (a git worktree where possible, otherwise a new directory `arena-<slug>/candidate-<n>/` in your scratch or temporary directory), so no two candidates write to the same file.
 
 ## Phase B: Fan out
 
-Spawn all N subagents in one message with `run_in_background: true`, each with the task, the path to the shared grounding, its own output path, and instructions to produce the artifact and a short rationale naming the alternatives it considered and what it rejected.
+Start all N runners at the same time, in the background, each with the task, the path to the shared grounding, its own output path, and instructions to produce the artifact and a short rationale naming the alternatives it considered and what it rejected.
 
 If a candidate produces no output, proceed with N-1 and note the dropout.
 
 ## Phase C: Cross-judge
 
-After all Phase B candidates complete, spawn one readonly judge from the `arena cross-judge pool` line in `~/.cursor/rules/pstack-models.mdc`, by default `claude-opus-5-5-high-fast`, `gemini-4-neon-xhigh`. The judge is never from the parent's vendor, and Fable counts as Claude for that check, so use the first entry from another vendor. An `auto` or `inherit-parent` entry is the parent model. If you do not know the parent's model, use the first real slug and say that the vendor check did not run. If the Task tool rejects a slug, use the nearest valid slug of the same family, then the next such entry, or skip the judge, and say so. While you read in Phase D, the judge scores each candidate, by path label, on each rubric criterion and recommends a base.
+After all Phase B candidates complete, start one read-only judge on a different model family from yours. In T3 Code, start it with `delegate_task` on that family's model, with `role: "review"` and a task that says not to edit. Elsewhere, run that family's CLI with its prompt on stdin. If you are a Claude model, run `codex exec -s read-only -C <repo> -o <verdict file> -`. Otherwise, run `claude -p --permission-mode plan` and send its output to the verdict file. The CLI uses its own configured model. The judge is never from your own family, so if neither way starts it, skip the judge, pick the base alone in Phase D, and say so. The judge sees the rubric and the candidates by path label, scores each criterion, and recommends a base with rationale. It runs in parallel with your reading in Phase D. Don't spawn it while candidates are still writing.
 
 ## Phase D: Pick a base
 
 Read every candidate end to end before picking. Score each against the rubric criterion by criterion, not on holistic feel, and compare with the cross-judge when Phase C ran one. Agreement on the base confirms the pick. Disagreement means one of you is biased or the rubric was ambiguous. Read both rationales before deciding.
 
-Pick the base a future maintainer can extend most easily without breaking invariants. When two feel tied, prefer the cleaner boundary or smaller API, per the Laziness Protocol.
+Pick the base a future maintainer can extend most easily without breaking invariants. When two feel tied, prefer the cleaner boundary or smaller API.
 
 ## Phase E: Graft
 
-Walk each losing candidate once more for what is worth porting into the base, usually one or two things per candidate, not most of it. Fold each graft in by hand, per the **redesign-from-first-principles** principle skill, so the result stays coherent under one mental model. Don't paste mechanically.
+Walk each losing candidate once more for what is worth porting into the base, usually one or two things per candidate, not most of it. Fold each graft in by hand, per the **redesign-from-first-principles** principle skill in `references/redesign-from-first-principles.md` in this skill's folder, so the result stays coherent under one mental model. Don't paste mechanically.
 
 If the candidates converge on one shape, that is strong agreement. Note it and ship the consensus shape. No graft is needed. If they wildly diverge, Phase A was under-specified. Reframe and re-run rather than averaging the divergence.
 
 ## Phase F: Verify
 
-Verify the synthesized artifact like any other output, per the **prove-it-works** principle skill. If verification finds a problem the arena missed, either Phase A was wrong (re-frame and re-run) or a candidate caught it and you missed the graft (go back to Phase E). Don't paper over it.
+Verify the synthesized artifact like any other output, per the **prove-it-works** principle skill in `references/prove-it-works.md` in this skill's folder. If verification finds a problem the arena missed, either Phase A was wrong (re-frame and re-run) or a candidate caught it and you missed the graft (go back to Phase E). Don't paper over it.
 
 ## Outputs
 
```

## Update procedure

In the commands below, `<clone>` is an up-to-date clone of https://github.com/cursor/plugins, and `<map>` is the file map above, saved to a file.

1. Run `git -C <clone> diff <checked-up-to>..origin/main --stat -- pstack/skills/arena/ pstack/skills/principle-redesign-from-first-principles/ pstack/skills/principle-prove-it-works/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
   If upstream adds a file to `pstack/skills/arena/`, add it to the file map.
2. In this directory, run `while read -r up here; do git -C <clone> show "origin/main:pstack/skills/$up" > "$here"; done < <map>`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `while read -r up here; do diff -u --label "a/$here" --label "b/$here" <(git -C <clone> show "origin/main:pstack/skills/$up") "$here"; done < <map>`.
   Set the bases and "Checked up to" to the new upstream SHA and date.
