# Upstream

This skill is a vendored copy of `correct` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/correct/SKILL.md`.
- Base: `e5136d82418d2db3165ea1050d17577cd618cc05` (2026-10-15, "pstack: restate four overspecified principles as reasoning, not rules (#633)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `792440e8a560a4a3f63748cdee70491ecd412982` (upstream `main`, 2026-11-20).
  Upstream has no changes to this file between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.
`SKILL.md` was updated to upstream #633 on 2026-11-03.
The copy of `architect/references/design-red-flags.md` was removed on 2026-11-21, because upstream #1249 deleted that file.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill from one canonical copy in `.agents/skills`, without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: becomes one line for a person who reads a list of commands.
  The upstream text has the full procedure and "Use for /correct.".
  Model invocation is off, so trigger phrases for the model contradict the frontmatter, and agents do not all start skills with a slash command.
- Rule table: it goes in `docs/agents/corrections.md`, not in the agent instruction file.
  Agents load the agent instruction file in every session, and a check enforces most rules in the table, so agents do not need to read them.
  Step 4 still puts rules for judgment calls in the agent instruction files.
- Find the mistake classes: reads the rule table too, because a rule that is in the table and that agents still break is a repeat.
  It also reads agent memory of past corrections.
  An agent that keeps a memory stores the operator's corrections there, and a correction that is only in memory is a mistake class that nothing enforces.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from the upstream base to this copy.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: correct
-description: "Find the mistakes agents keep repeating in this repo and make each one impossible. Try architecture first, then types, then a lint whose error names the fix, then a test, and write docs last. Prove each check fails on a real past mistake. Repeat this each time the operator corrects you. Use for /correct."
+description: "Find the mistakes that agents repeat in a repo, and make each one impossible with architecture, types, a lint, or a test."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Correct
@@ -12,7 +14,7 @@
 
 ## Find the mistake classes
 
-First, read recent commits, reverts, review comments, agent instruction files, and comments that explain workarounds. Group the mistakes into classes. A class counts once it has happened twice.
+First, read recent commits, reverts, review comments, agent instruction files, agent memory of past corrections, the rule table, and comments that explain workarounds. Group the mistakes into classes. A class counts once it has happened twice.
 
 ## Fix each class at the highest level that works
 
@@ -27,6 +29,6 @@
 
 ## Keep the rule table
 
-Last, keep a table in the agent instruction file that pairs each rule with what enforces it. When the operator corrects you, fix the mistake and add the rule. If the rule was already there and nothing enforces it, that's a repeat, so fix it at the highest level in the same change. Drop a rule once its mistake can't happen.
+Last, keep a table in `docs/agents/corrections.md` that pairs each rule with what enforces it. When the operator corrects you, fix the mistake and add the rule. If the rule was already there and nothing enforces it, that's a repeat, so fix it at the highest level in the same change. Drop a rule once its mistake can't happen.
 
 **Reply:** each class with its evidence, the level you picked, and why a higher level didn't work.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/correct/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/correct/SKILL.md > SKILL.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/correct/SKILL.md) SKILL.md`.
   Set "Base" and "Checked up to" to the new upstream SHA and date.

