# Upstream

This skill is a vendored copy of `interrogate` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/interrogate/`.
- Base: `ab1f702ce8e8b6557edb56b09f52cde8bfb83f17` (2026-10-27, "feat(pstack): port recent skill updates (#986)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `ae5650febf4320793844c12c4adaa937f417f8da` (upstream `main`, 2026-10-31).
  Upstream has no changes to this directory between the base and this commit.
- Inlined rules come from `pstack/skills/arena/SKILL.md` at `ab1f702ce8e8b6557edb56b09f52cde8bfb83f17` (2026-10-27) and `pstack/skills/in-your-own-words/SKILL.md` at `dbf49813a39c1a5389c5e28cb8e4c1c2379e2454` (2026-10-13, "refactor(pstack): reword /in-your-own-words around goals and the problem (#606)").
  Upstream has no changes to these files between those commits and "Checked up to".

`VanTanev/skills` added the copy on 2026-10-14.
Upstream deleted `references/` in #986, and so does this copy.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the trigger phrases are removed, because model invocation is off.
- `in-your-own-words`: Frame states its one sentence inline, because that skill is user-invoked, and another skill cannot start it.
- `arena`: Fan out and Verify state inline the rules they use from `arena`, because `arena` is user-invoked, and another skill cannot start it.
  Interrogate uses Phase A steps 3 and 4, Phase B, and Phase F of `arena`, and each of those needs only a sentence or two.
  Step 4 becomes "Give each adversary its own git worktree, so no two adversaries write to the same file."
  Phase B becomes "Start all adversaries at the same time, in the background" and the dropout sentence.
  Phase F becomes "by rerunning its command in that adversary's worktree", because the repro files are in that worktree.
  Verify ends with "Then remove the adversary worktrees.", which upstream does not have, so that no worktree stays behind after the review.
  "Skip arena Phases C, D, and E." is removed, because no arena runs.
- Adversaries: upstream reads the models from the `interrogate reviewers` line of `~/.cursor/rules/pstack-models.mdc`, with the runner rules of arena Phase A step 3, and starts each adversary as a Cursor `generalPurpose` subagent with a model slug.
  Claude Code subagents can use only Claude models.
  So here Adversary A is a subagent on the agent's own model, and Adversary B is the CLI of the other family.
  From a Claude model, B is `codex exec -s workspace-write -C <worktree>`, so it can write only in its worktree.
  From any other model, B is `claude -p --permission-mode auto` in its worktree, because an adversary must run its repro, and `acceptEdits` refuses commands such as `python3 repro.py` in print mode.
  If that CLI is missing or fails, B is a second subagent, and the output says that the review has one model family.
  The user can name more models for more adversaries, in place of the list in the rule file.
- Effort: Adversary A runs one step below the agent's own effort, or with no effort set when the agent does not know its own.
  This replaces the pointer to the Subagents section of `poteto-mode` in arena Phase A step 3, which this repo does not vendor.
- Fresh context: each adversary subagent starts with a fresh context window, because Claude Code and Codex can both fork the parent conversation into a subagent, and a forked adversary gets the author's reasoning.
- Brief: each adversary also gets the path of its worktree, because Adversary B runs in another CLI.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: interrogate
-description: "Use for \"interrogate\", \"adversarial review\", \"multi-model review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Adversaries try to break a change or design, and only findings proven by a run survive."
+description: "Adversaries try to break a change or design, and only findings proven by a run survive."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Interrogate
@@ -10,19 +12,27 @@
 
 ## Frame
 
-The scope is what the user names. Otherwise it is the branch diff from its merge base with the base branch, through the working tree. State the intent with the **in-your-own-words** skill, from the user's message, the commits, and the PR description. Ask the user when the intent is unclear.
+The scope is what the user names. Otherwise it is the branch diff from its merge base with the base branch, through the working tree. From the user's message, the commits, and the PR description, restate in your own words what you think the user's goals are and what problem they are trying to solve. This restatement is the intent. Ask the user when the intent is unclear.
 
 ## Fan out
 
-Run Phase A steps 3 and 4 and Phase B of the **arena** skill, with four changes. Read the `interrogate reviewers` line in place of `arena runners`. Copy the scope's uncommitted changes into each worktree. Spawn each adversary as `generalPurpose`. In place of the arena task and rationale, give each adversary the scope, the intent, and this brief:
+By default there are two adversaries, on two model families. Start each subagent with a fresh context window.
+
+- **Adversary A** is a subagent on your own model. Set its effort one step below your own. If you do not know your effort, do not set it.
+- **Adversary B** runs on a different model family, through that family's CLI, with its prompt on stdin. If you are a Claude model, run `codex exec -s workspace-write -C <worktree> -o <output-file> -`. Otherwise, run `claude -p --permission-mode auto` in its worktree, and send its output to a file. The CLI uses its own configured model. If the CLI is missing or fails, run Adversary B as a second subagent on your own model, and say in the output that the review has one model family.
+- If the user names more models, add one adversary for each, labeled Adversary C, D, and so on.
+
+Give each adversary its own git worktree, so no two adversaries write to the same file. Copy the scope's uncommitted changes into each worktree. Start all adversaries at the same time, in the background. Give each adversary the scope, the intent, the path of its worktree, and this brief:
 
 > Break this change. Prove each finding with a run against the real code, such as a failing test, a repro script, or command output that shows the wrong behavior. For a design or plan, run a prototype or probe the current tree. Keep repros in your own worktree. Report each finding with a title, the exact command, the output it printed, and the output the intent requires. Leave out anything you did not run. That covers style, naming, structure, and risks that need a future change to matter. No findings is a valid result.
 
+If an adversary produces no output, go on with the others and note the dropout.
+
 ## Verify
 
-Verify each finding per arena Phase F by rerunning its command. Keep a finding when the output shows the failure and the failure breaks the intent. Drop the rest. Merge findings that share a root cause.
+Verify each finding by rerunning its command in that adversary's worktree. Keep a finding when the output shows the failure and the failure breaks the intent. Drop the rest. Merge findings that share a root cause.
 
-Skip arena Phases C, D, and E. Adversaries find different failures, so the verdict keeps every verified finding, not one adversary's list.
+Adversaries find different failures, so the verdict keeps every verified finding, not one adversary's list. Then remove the adversary worktrees.
 
 ## Output
 
```

## Update procedure

In the commands below, `<clone>` is an up-to-date clone of https://github.com/cursor/plugins.

1. Run `git -C <clone> diff <checked-up-to>..origin/main --stat -- pstack/skills/interrogate/ pstack/skills/arena/ pstack/skills/in-your-own-words/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
   If only `arena` or `in-your-own-words` changed, update the inlined rules by hand, and set their commits and "Checked up to".
2. Replace `SKILL.md` with `pstack/skills/interrogate/SKILL.md` at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   If upstream adds a file to `pstack/skills/interrogate/`, copy it too.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/interrogate/SKILL.md) SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
