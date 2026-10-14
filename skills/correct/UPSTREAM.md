# Upstream

This skill is a vendored copy of `correct` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/correct/`.
- Base: `9511e60321f7e533a187d62854a3d53a53752874` (2026-10-03, "feat(pstack): add /correct skill (#494)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `1e5c90a4b6f249917bd21fe361b3a2a7deb741b8` (upstream `main`, 2026-10-14).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.
Two changes also fit the skill to agents that keep a memory and keep their instruction files short.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: "Use for /correct." is removed.
  Model invocation is off, so trigger phrases for the model contradict the frontmatter, and agents do not all start skills with a slash command.
- Sources: "agent memory of past corrections" is added to what the skill reads first.
  An agent that keeps a memory stores the operator's corrections there, and a correction that is only in memory is a mistake class that nothing enforces.
- Rule table: it moves from the agent instruction file to a doc that the instruction file links to.
  The instruction file loads into every session, and a rule that a type, lint, or test enforces needs no place there, because its error names the fix.
  Rules for judgment calls still go into docs or agent rules, as level 4 says.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: correct
-description: "Find the mistakes agents keep repeating in this repo and make each one impossible. Try architecture first, then types, then a lint whose error names the fix, then a test, and write docs last. Prove each check fails on a real past mistake. Repeat this each time the operator corrects you. Use for /correct."
+description: "Find the mistakes agents keep repeating in this repo and make each one impossible. Try architecture first, then types, then a lint whose error names the fix, then a test, and write docs last. Prove each check fails on a real past mistake. Repeat this each time the operator corrects you."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Correct
@@ -12,7 +14,7 @@
 
 ## Find the mistake classes
 
-First, read recent commits, reverts, review comments, agent instruction files, and comments that explain workarounds. Group the mistakes into classes. A class counts once it has happened twice.
+First, read recent commits, reverts, review comments, agent instruction files, agent memory of past corrections, and comments that explain workarounds. Group the mistakes into classes. A class counts once it has happened twice.
 
 ## Fix each class at the highest level that works
 
@@ -27,6 +29,6 @@
 
 ## Keep the rule table
 
-Last, keep a table in the agent instruction file that pairs each rule with what enforces it. When the operator corrects you, fix the mistake and add the rule. If the rule was already there and nothing enforces it, that's a repeat, so fix it at the highest level in the same change. Drop a rule once its mistake can't happen.
+Last, keep a table that pairs each rule with what enforces it, in a doc that the agent instruction file links to. When the operator corrects you, fix the mistake and add the rule. If the rule was already there and nothing enforces it, that's a repeat, so fix it at the highest level in the same change. Drop a rule once its mistake can't happen.
 
 **Reply:** each class with its evidence, the level you picked, and why a higher level didn't work.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/correct/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/correct/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
