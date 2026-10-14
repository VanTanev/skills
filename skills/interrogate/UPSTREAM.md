# Upstream

This skill is a vendored copy of `interrogate` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/interrogate/`.
- Base: `ce649c03ac3b75b6ae80cbd15b7e2c536caedb5a` (2026-10-14, "feat(pstack): match subagent effort to the job, drop Graphite from orchestrate, and cut playbooks to principles (#613)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `1e5c90a4b6f249917bd21fe361b3a2a7deb741b8` (upstream `main`, 2026-10-14).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the trigger phrases are removed, because model invocation is off.
  "Multiple LLM reviewers" becomes "Reviewers from different model families", because here the second reviewer always uses a different family.
- Reviewers: upstream reads the reviewer models from `~/.cursor/rules/pstack-models.mdc`, which `setup-pstack` writes, and starts each reviewer as a Cursor `Task` subagent with a model slug.
  Claude Code subagents can use only Claude models.
  So here Reviewer A is a subagent on the agent's own model, and Reviewer B is the CLI of the other family: `codex exec -s read-only` from a Claude model, and `claude -p --permission-mode plan` from any other model.
  The user can name more models for more reviewers, in place of the reviewer list in the rule file.
- Fallback: the upstream rules for rejected model slugs are removed.
  If the other family's CLI is missing or fails, Reviewer B is a second subagent, and the output says that the review has one model family.
- Order: the paragraph that fills in the reviewer template now comes before the reviewers start, because Reviewer B gets the filled template on stdin.
- Effort: "Pick each subagent's reasoning level and fast or standard speed for the job, per the Subagents section of the **poteto-mode** skill." becomes "Set its effort one step below your own. If you do not know your effort, do not set it."
  This is the rule for judgment work in that section, in the same form as in `no-comments`.
  This repo does not vendor `poteto-mode`, and Claude Code has no speed setting for each subagent.
- "one reviewer per configured model" becomes "one reviewer per model", because there is no configuration.
- `references/`: equal to upstream.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,12 +1,14 @@
 ---
 name: interrogate
-description: "Use for \"interrogate\", \"adversarial review\", \"multi-model review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Multiple LLM reviewers challenge changes from independent angles."
+description: "Reviewers from different model families challenge changes from independent angles."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Interrogate
 
-Spawn one reviewer per configured model to adversarially review code changes. The adversarial signal comes from model diversity, not assigned personas. The deliverable is a synthesized verdict. Do NOT auto-apply changes.
+Spawn one reviewer per model to adversarially review code changes. The adversarial signal comes from model diversity, not assigned personas. The deliverable is a synthesized verdict. Do NOT auto-apply changes.
 
 ## Step 1, Scope
 
@@ -24,18 +26,15 @@
 
 ## Step 3, Spawn Reviewers
 
-Launch all reviewers in a single message with the Task tool, one per entry on the `interrogate reviewers` line in `~/.cursor/rules/pstack-models.mdc`, labeled Reviewer A, B, and so on to match the entry count. If the rule or that line is missing, use the table defaults.
+Read `references/reviewer-prompt.md` and fill in the same template for every reviewer with the stated intent, the diff or file contents, the rubric from `references/rubric.md`, and the code-quality lens from `references/code-quality-review.md`.
 
-| Subagent | Default model |
-|----------|---------------|
-| Reviewer A | `claude-opus-5-5-xhigh` |
-| Reviewer B | `grok-4.7-xhigh-fast` |
+Start all reviewers at the same time. Each reviewer is read-only: it reads the repo and runs read-only commands, and edits nothing.
 
-Each reviewer gets `subagent_type: generalPurpose`, `readonly: true`, and `model` set to its configured entry, or its table default when there is no configured line. Omit `model` for an `auto` or `inherit-parent` entry, so that reviewer runs on the parent model.
+- **Reviewer A** is a subagent on your own model. Set its effort one step below your own. If you do not know your effort, do not set it.
+- **Reviewer B** runs on a different model family, through that family's CLI, in the background, with the filled template on stdin. If you are a Claude model, run `codex exec -s read-only -C <repo> -o <output-file> -`. Otherwise, run `claude -p --permission-mode plan` and send its output to a file. The CLI uses its own configured model.
+- If the user names more models, add one reviewer for each, labeled Reviewer C, D, and so on.
 
-If the Task tool rejects a configured entry, run that reviewer on its family's table default and say so. Families go by prefix: `claude-*`, and `grok-*` with `cursor-grok-*` and `composer-*`. A refused `composer-*` entry runs on Reviewer B's default. With no family match, use Reviewer A's default. If it rejects a table default, spawn with the closest equivalent from the valid slugs in its error message (prefer the same family and reasoning tier), and open a separate PR to update the default table. Do not block the review on the slug issue. Never treat an alias entry as a rejected slug or apply either fallback to it.
-
-Read `references/reviewer-prompt.md` and fill in the same template for every reviewer with the stated intent, the diff or file contents, the rubric from `references/rubric.md`, and the code-quality lens from `references/code-quality-review.md`. Pick each subagent's reasoning level and fast or standard speed for the job, per the Subagents section of the **poteto-mode** skill.
+If the other family's CLI is missing or fails, run Reviewer B as a second subagent on your own model, and say in the output that the review has one model family. Do not block the review on it.
 
 ## Step 4, Synthesize
 
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/interrogate/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/interrogate/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
