# Upstream

This skill is a vendored copy of `architect` from the Cursor pstack plugin, with the `arena`, `principle-redesign-from-first-principles`, and `principle-prove-it-works` skills as references.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- File map, one line per file: the upstream path under `pstack/skills/`, then the path here.

  ```text
  architect/SKILL.md SKILL.md
  architect/references/design-red-flags.md references/design-red-flags.md
  architect/references/rationale-template.md references/rationale-template.md
  architect/references/runner-prompt.md references/runner-prompt.md
  arena/SKILL.md references/arena.md
  principle-redesign-from-first-principles/SKILL.md references/redesign-from-first-principles.md
  principle-prove-it-works/SKILL.md references/prove-it-works.md
  ```

- Base of the `architect` files and of `references/redesign-from-first-principles.md`: `00b14f1df36b32a8dd1529324a3a459f6563b127` (2026-10-10, "refactor(pstack): distill skill prompts to cut tokens (#538)").
- Base of `references/arena.md`: `ab1f702ce8e8b6557edb56b09f52cde8bfb83f17` (2026-10-27, "feat(pstack): port recent skill updates (#986)").
- Base of `references/prove-it-works.md`: `b0b9c7a0baf8b6aa1d00bf77d4101e577d4ba411` (2026-09-23, "docs(pstack): cut 19 more instructions Opus 5.5 does not need (#419)").
  The files here are equal to upstream at these commits, except for the local changes below.
- Checked up to: `c742dd61706fbacc1b95f1a20b7b988cf096ce6c` (upstream `main`, 2026-10-27).
  Upstream has no changes to these files between their bases and this commit.

It was added on 2026-10-28.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the trigger phrases are removed, because model invocation is off.
- `how`: Phase A reads the subsystems end to end and writes the explanation with the sections of the `how` explainer (Overview, Key Concepts, How It Works, Where Things Live, Gotchas).
  `how` starts Cursor model roles that this setup does not have.
  Step 1 of Phase E re-grounds "as in Phase A".
- `why`: Phase A gives the git and `gh` commands from step 2 of `why`, because `why` is user-invoked, and another skill cannot start it.
- `arena`: Phase B runs the copy in `{SKILLBASE}/references/arena.md`, because `arena` is user-invoked upstream, and another skill cannot start it.
  The paragraph that reads the `architect runners` line of `pstack-models.mdc` is removed.
  The runners come from Phase A of `references/arena.md`.
- `interrogate`: Phase C offers the invoker `/interrogate`, because `interrogate` is user-invoked, and another skill cannot start it.
- Principle links in `SKILL.md`: `redesign-from-first-principles` points to its copy in `references/`.
  The links to `exhaust-the-design-space`, `foundational-thinking`, `outcome-oriented-execution`, `fix-root-causes`, and `subtract-before-you-add` are removed, because the sentence already states the rule.
  Phase C keeps the "scaffold first" mode of `foundational-thinking` as "as a scaffold that implementation fills in".
  Phase E keeps the rule of `fix-root-causes` as "Fix the root cause, not each symptom."
- `references/arena.md`:
  - Runners: upstream reads them from `pstack-models.mdc` and starts each one as a Cursor `Task` subagent with a model slug.
    Claude Code subagents can use only Claude models.
    So Runner 1 is a subagent on the agent's own model, and Runner 2 is the CLI of the other family: `codex exec -s workspace-write` from a Claude model, and `claude -p --permission-mode acceptEdits` from any other model.
    If that CLI is missing or fails, Runner 2 is a second subagent, and the arena says that it has one model family.
    These are the rules of `interrogate`, with write access, because a runner writes its candidate.
    The user can name more models for more runners, in place of the runner list in the rule file.
  - Effort: Runner 1 runs at the agent's own effort, because a runner does the whole task.
    This replaces the pointer to the Subagents section of `poteto-mode`, which this setup does not vendor.
  - Fan out: "Spawn all N subagents in one message with `run_in_background: true`" becomes "Start all N runners at the same time, in the background", because Runner 2 is a CLI, not a subagent.
  - Judge: the cross-judge is the CLI of the other family, read-only, with the commands of `interrogate`.
    If the CLI is missing or fails, the agent picks the base alone, as upstream does when no judge model runs.
  - Output location: `/tmp/arena-<slug>/candidate-<n>/` becomes a directory in the scratch or temporary directory, because Claude Code gives each session its own scratch directory.
  - Principle links: `redesign-from-first-principles` and `prove-it-works` point to their copies in `references/`.
    The links to `separate-before-serializing-shared-state` and the Laziness Protocol are removed, because the sentence already states the rule.
    Step 4 of Phase A keeps the reason as "so no two candidates write to the same file".
  - Frontmatter: equal to upstream.
- `references/runner-prompt.md`: the orchestrator replaces `{SKILLBASE}` with the skill directory, and the runner reads `SKILL.md` and `references/rationale-template.md` from there.
  Runner 2 runs in another CLI, with the prompt on stdin, so a relative link does not resolve.
  The principle links are removed, because each bullet already states its rule.
- `references/rationale-template.md`: the `arena` link points to `arena.md` in the same directory.
- `references/prove-it-works.md`: "(the **show-me-your-work** skill)" is removed, because this setup does not vendor it.
  This is the same change as in the `hillclimb` copy.
- `references/design-red-flags.md` and `references/redesign-from-first-principles.md`: equal to upstream.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from upstream to this copy.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: architect
-description: "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for /architect, 'architect this', 'design this', or non-trivial work where jumping to code would lock in the wrong shape."
+description: "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for non-trivial work where jumping to code would lock in the wrong shape."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Architect
@@ -20,17 +22,15 @@
 
 ## Phase A: Ground the problem
 
-Build a real mental model of every system the new code touches. Run the **how** skill over the relevant subsystems. Naming a file isn't grounding. Produce the architectural explanation `how` prescribes. If the design redefines ownership or layering, also run the **why** skill on the existing shape so the rationale becomes a constraint, not a guess.
+Build a real mental model of every system the new code touches. Read the relevant subsystems end to end. Naming a file isn't grounding. Write the architectural explanation a senior engineer needs to onboard onto each subsystem, with the sections Overview, Key Concepts, How It Works, Where Things Live, and Gotchas, dropping any that do not apply. If the design redefines ownership or layering, also find why the existing shape is what it is, so the rationale becomes a constraint, not a guess. Run `git blame -L <start>,<end> <file>` for last-touch commits, `git log --follow -p -- <file>` for full history through renames, and `git log -1 --format=%B <commit>` for PR numbers, then read the PR bodies and discussion with `gh pr view <number> --json title,body,comments,reviews`.
 
 Skip Phase A only when the work is genuinely greenfield with no surrounding system to integrate.
 
 ## Phase B: Sketch
 
-Run the **arena** skill with the design-sketch task and the Phase A grounding artifacts. Pass `references/runner-prompt.md` as each runner's prompt.
+Run the **arena** skill in `{SKILLBASE}/references/arena.md` with the design-sketch task and the Phase A grounding artifacts. Pass `references/runner-prompt.md` as each runner's prompt.
 
-Take the runners from the `architect runners` line in the `pstack-models.mdc` rule, in place of the `arena runners` line. If the rule or that line is missing, use `claude-opus-5-5-xhigh` and `grok-4.7-xhigh-fast`. Alias and rejected entries follow the runner rules in the **arena** skill's Phase A.
-
-Design it twice. Require at least two structurally distinct candidates before synthesis, even when the first looks sufficient. This is the **exhaust-the-design-space** principle skill made concrete. Whole-shape alternatives, not point fixes inside one shape.
+Design it twice. Require at least two structurally distinct candidates before synthesis, even when the first looks sufficient. Whole-shape alternatives, not point fixes inside one shape.
 
 Screen every candidate against [`references/design-red-flags.md`](references/design-red-flags.md) before synthesis. Assume the next contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Prefer the design where a change that looks right from one file is right for the whole repo.
 
@@ -44,7 +44,7 @@
 
 Opt in to a checkpoint when the invoker explicitly asks: "/architect with checkpoint," "stop and show me before implementing," or similar. Then surface the synthesized design and pause for sign-off.
 
-The synthesis can ship as its own commit either way, as the "scaffold first" mode of the **foundational-thinking** principle skill. Planned and scoped breakage during fill-in is fine, per the **outcome-oriented-execution** principle skill. For adversarial pressure on the design before implementing, run the **interrogate** skill on the synthesized sketch.
+The synthesis can ship as its own commit either way, as a scaffold that implementation fills in. Planned and scoped breakage during fill-in is fine. For adversarial pressure on the design before implementing, offer the invoker `/interrogate` on the synthesized sketch.
 
 If the human pushes back on the shape (in a checkpoint or after the fact), treat that as Phase A evidence. Re-ground and re-run Phase B before writing more code.
 
@@ -54,7 +54,7 @@
 
 ## Phase E: Scrap when the architecture is wrong
 
-If implementation keeps producing friction the sketch can't absorb, throw the sketch out. Don't bolt fixes onto a wrong design, per the **redesign-from-first-principles** and **fix-root-causes** principle skills.
+If implementation keeps producing friction the sketch can't absorb, throw the sketch out. Don't bolt fixes onto a wrong design, per the **redesign-from-first-principles** principle skill in `{SKILLBASE}/references/redesign-from-first-principles.md`. Fix the root cause, not each symptom.
 
 The signal is a *pattern*, not single instances. Tells:
 
@@ -69,9 +69,9 @@
 
 When you scrap:
 
-1. Re-run the **how** skill over what's been built.
+1. Re-ground on what's been built, as in Phase A.
 2. Redesign as if the new constraints had been day-one assumptions, per redesign-from-first-principles.
-3. Subtract before adding, per the **subtract-before-you-add** principle skill. The new sketch should be smaller than the old one before it grows.
+3. Subtract before adding. The new sketch should be smaller than the old one before it grows.
 4. Return to Phase B and re-run arena.
 
 ## Outputs
--- a/references/rationale-template.md
+++ b/references/rationale-template.md
@@ -16,7 +16,7 @@
 
 ## Synthesis decision
 
-*Filled in by [arena](../../arena/SKILL.md). Records which candidate became the base and why, what was adapted from each of the others, and what was rejected and why.*
+*Filled in by [arena](arena.md). Records which candidate became the base and why, what was adapted from each of the others, and what was rejected and why.*
 
 ## Tradeoffs accepted
 
--- a/references/runner-prompt.md
+++ b/references/runner-prompt.md
@@ -1,20 +1,20 @@
 # Architect runner prompt
 
-The orchestrator passes this file through to every parallel candidate runner during Phase B and fills in the variable inputs around it: the task, the Phase A grounding artifacts, the isolated working directory, and the path to write outputs. The working directory is a git worktree when available, otherwise a per-runner subdirectory under the sketch dir. What matters is independence between candidates.
+The orchestrator passes this file through to every parallel candidate runner during Phase B and fills in the variable inputs around it: the task, the Phase A grounding artifacts, the isolated working directory, and the path to write outputs. It replaces `{SKILLBASE}` with the architect skill's directory, because a runner in another CLI does not know it. The working directory is a git worktree when available, otherwise a per-runner subdirectory under the sketch dir. What matters is independence between candidates.
 
-You are producing one candidate design in architect's parallel exploration. Read the **architect** skill in full first. That's the workflow you're inside. Output a candidate design package: type sketch, function signatures, module map, and prose rationale shaped per [`rationale-template.md`](rationale-template.md).
+You are producing one candidate design in architect's parallel exploration. Read the **architect** skill in `{SKILLBASE}/SKILL.md` in full first. That's the workflow you're inside. Output a candidate design package: type sketch, function signatures, module map, and prose rationale shaped per `{SKILLBASE}/references/rationale-template.md`.
 
 Apply the following discipline. The orchestrator compares candidates on these axes to pick a base.
 
 - Caller's usage first. Write the README-style usage and two or three real call sites before the types, then derive the type sketch from them. The usage is the spec. The two must agree, so reconcile the sketch to the usage, not the reverse.
 - Data structures first. Get the core types right and the code becomes obvious. Trace each dominant access pattern through the proposed structure. If the answer is "we'll add a map / index / cache later," the structure is wrong.
 - Interface depth. Compare the capability hidden behind the public surface relative to the size of that surface. Prefer a simple interface that pulls complexity into the callee, even when the implementation becomes less simple. Do not put transport or wire types on the public API. Parse into domain types behind the interface.
-- Shared state: if two actors might both write, ask "what happens?" If the answer isn't "nothing," default to per-actor state with a merge at the read boundary, per the **separate-before-serializing-shared-state** principle skill.
+- Shared state: if two actors might both write, ask "what happens?" If the answer isn't "nothing," default to per-actor state with a merge at the read boundary.
 - Make boundaries visible. `not implemented` errors for bodies, `// TODO` pseudocode for tricky logic, doc comments stating intent and invariants. A reader should trace data from input to output by reading types and signatures alone.
-- Encode invariants in types: hard-to-misuse types > runtime checks > prose comments, per the **encode-lessons-in-structure** principle skill.
-- Validate at boundaries, trust types inside, per the **boundary-discipline** principle skill. Business logic as pure functions. The shell stays thin.
+- Encode invariants in types: hard-to-misuse types > runtime checks > prose comments.
+- Validate at boundaries, trust types inside. Business logic as pure functions. The shell stays thin.
 - Single source of truth per invariant. Derive instead of sync.
-- Idempotent state transitions where applicable, per the **make-operations-idempotent** principle skill. Ask what happens if the operation runs twice or crashes halfway.
-- Short call chains. If tracing the flow needs more than three files, flatten the hierarchy, per the **laziness-protocol** and **minimize-reader-load** principle skills.
+- Idempotent state transitions where applicable. Ask what happens if the operation runs twice or crashes halfway.
+- Short call chains. If tracing the flow needs more than three files, flatten the hierarchy.
 
 You are one of the parallel runners, each on a different model. Produce the best design your model can make. Don't hedge against the others. Differences between candidates are the signal used to pick a base and graft. Converging on a safe-looking middle defeats the exploration.
--- a/references/arena.md
+++ b/references/arena.md
@@ -14,34 +14,34 @@
 
 1. State the artifact each candidate is producing.
 2. Derive the rubric, 3-6 concrete gradeable criteria for what success looks like on *this* task. It is the picker's tool in Phase D. Candidates only see the task.
-3. Pick the runners. Use the `arena runners` line in `~/.cursor/rules/pstack-models.mdc`. If the rule or that line is missing, default to one each on `claude-opus-5-5-xhigh` and `grok-4.7-xhigh-fast`. An `auto` or `inherit-parent` entry in this line means the parent model, so omit `model` for it. If the Task tool rejects a configured entry, run that seat on its family's default and say so. Families go by prefix: `claude-*`, and `grok-*` with `cursor-grok-*` and `composer-*`. A refused `composer-*` entry runs on `grok-4.7-xhigh-fast`. If the family has no default, or the Task tool rejects that default, use the closest valid slug of the same family from its error message, or drop the seat and say so when there is none. If dropped seats leave fewer than two runners, add runners until there are two, or one when the line has one entry. Run each added runner on a remaining runner's model, or omit `model` so it runs on the parent model when none remain, and say so. Spawn more runners when the arena covers multiple design directions. Use the same model N times when the work is generation-bound rather than judgment-sensitive. Pick each subagent's reasoning level and fast or standard speed for the job, per the Subagents section of the **poteto-mode** skill.
-4. Give each candidate its own output location (a git worktree where possible, otherwise `/tmp/arena-<slug>/candidate-<n>/`), per the **separate-before-serializing-shared-state** principle skill.
+3. Pick the runners. By default there are two, on two model families. **Runner 1** is a subagent on your own model, at your own effort, because a runner does the whole task. If you do not know your effort, do not set it. **Runner 2** runs on a different model family, through that family's CLI, in the background, with its prompt on stdin. If you are a Claude model, run `codex exec -s workspace-write --skip-git-repo-check -C <output location> -o <rationale file> -`. Otherwise, run `claude -p --permission-mode acceptEdits` in its output location, and send its output to the rationale file. The CLI uses its own configured model. If the other family's CLI is missing or fails, run Runner 2 as a second subagent on your own model, and say that the arena has one model family. If the user names more models, add one runner for each. Spawn more runners when the arena covers multiple design directions. Use the same model N times when the work is generation-bound rather than judgment-sensitive.
+4. Give each candidate its own output location (a git worktree where possible, otherwise a new directory `arena-<slug>/candidate-<n>/` in your scratch or temporary directory), so no two candidates write to the same file.
 
 ## Phase B: Fan out
 
-Spawn all N subagents in one message with `run_in_background: true`, each with the task, the path to the shared grounding, its own output path, and instructions to produce the artifact and a short rationale naming the alternatives it considered and what it rejected.
+Start all N runners at the same time, in the background, each with the task, the path to the shared grounding, its own output path, and instructions to produce the artifact and a short rationale naming the alternatives it considered and what it rejected.
 
 If a candidate produces no output, proceed with N-1 and note the dropout.
 
 ## Phase C: Cross-judge
 
-After all Phase B candidates complete, choose one model from the `arena cross-judge pool` line in `~/.cursor/rules/pstack-models.mdc`. If the rule or that line is missing, choose from `claude-opus-5-5-xhigh` and `grok-4.7-xhigh-fast`. Spawn one readonly judge subagent. The judge is never from the parent's family, as Phase A step 3 defines families. Try only the entries from another family, in pool order. An `auto` or `inherit-parent` entry is the parent model, so it never judges. With the default pool, a Claude parent gets `grok-4.7-xhigh-fast`. A parent from any other family gets `claude-opus-5-5-xhigh` first. If the Task tool rejects an entry, use a valid slug of the same model at the closest level or speed from the error message, or move to the next entry when there is none. If no entry from another family runs, try the default pool's entries from another family the same way. If none of those runs, skip the judge, pick the base alone in Phase D, and say so. If you do not know the parent's model, try the pool's real slugs in pool order and say that the family check did not run. The judge sees the rubric and the candidates by path label, scores each criterion, and recommends a base with rationale. It runs in parallel with your reading in Phase D. Don't spawn it while candidates are still writing.
+After all Phase B candidates complete, start one read-only judge on a different model family from yours, through that family's CLI, with its prompt on stdin. If you are a Claude model, run `codex exec -s read-only -C <repo> -o <verdict file> -`. Otherwise, run `claude -p --permission-mode plan` and send its output to the verdict file. The CLI uses its own configured model. The judge is never from your own family, so if the CLI is missing or fails, skip the judge, pick the base alone in Phase D, and say so. The judge sees the rubric and the candidates by path label, scores each criterion, and recommends a base with rationale. It runs in parallel with your reading in Phase D. Don't spawn it while candidates are still writing.
 
 ## Phase D: Pick a base
 
 Read every candidate end to end before picking. Score each against the rubric criterion by criterion, not on holistic feel, and compare with the cross-judge when Phase C ran one. Agreement on the base confirms the pick. Disagreement means one of you is biased or the rubric was ambiguous. Read both rationales before deciding.
 
-Pick the base a future maintainer can extend most easily without breaking invariants. When two feel tied, prefer the cleaner boundary or smaller API, per the Laziness Protocol.
+Pick the base a future maintainer can extend most easily without breaking invariants. When two feel tied, prefer the cleaner boundary or smaller API.
 
 ## Phase E: Graft
 
-Walk each losing candidate once more for what is worth porting into the base, usually one or two things per candidate, not most of it. Fold each graft in by hand, per the **redesign-from-first-principles** principle skill, so the result stays coherent under one mental model. Don't paste mechanically.
+Walk each losing candidate once more for what is worth porting into the base, usually one or two things per candidate, not most of it. Fold each graft in by hand, per the **redesign-from-first-principles** principle skill in `{SKILLBASE}/references/redesign-from-first-principles.md`, so the result stays coherent under one mental model. Don't paste mechanically.
 
 If the candidates converge on one shape, that is strong agreement. Note it and ship the consensus shape. No graft is needed. If they wildly diverge, Phase A was under-specified. Reframe and re-run rather than averaging the divergence.
 
 ## Phase F: Verify
 
-Verify the synthesized artifact like any other output, per the **prove-it-works** principle skill. If verification finds a problem the arena missed, either Phase A was wrong (re-frame and re-run) or a candidate caught it and you missed the graft (go back to Phase E). Don't paper over it.
+Verify the synthesized artifact like any other output, per the **prove-it-works** principle skill in `{SKILLBASE}/references/prove-it-works.md`. If verification finds a problem the arena missed, either Phase A was wrong (re-frame and re-run) or a candidate caught it and you missed the graft (go back to Phase E). Don't paper over it.
 
 ## Outputs
 
--- a/references/prove-it-works.md
+++ b/references/prove-it-works.md
@@ -19,4 +19,4 @@
 
 The strongest proof is a deterministic script that re-runs the same comparison, not a one-time eyeball. Write the script, run it, and keep its output as an artifact a reviewer can re-run instead of trusting your word.
 
-Keep the artifact visible for the human. Commit it only for large or complex work where the trail has to be auditable later, like a big port or migration (the **show-me-your-work** skill).
+Keep the artifact visible for the human. Commit it only for large or complex work where the trail has to be auditable later, like a big port or migration.
```

## Update procedure

In the commands below, `<clone>` is an up-to-date clone of https://github.com/cursor/plugins, and `<map>` is the file map above, saved to a file.

1. Run `git -C <clone> diff <checked-up-to>..origin/main --stat -- pstack/skills/architect/ pstack/skills/arena/ pstack/skills/principle-redesign-from-first-principles/ pstack/skills/principle-prove-it-works/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
   If upstream adds a file to `pstack/skills/architect/`, add it to the file map.
2. In this directory, run `while read -r up here; do git -C <clone> show "origin/main:pstack/skills/$up" > "$here"; done < <map>`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `while read -r up here; do diff -u --label "a/$here" --label "b/$here" <(git -C <clone> show "origin/main:pstack/skills/$up") "$here"; done < <map>`.
   Set the bases and "Checked up to" to the new upstream SHA and date.
