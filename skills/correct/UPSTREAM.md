# Upstream

This skill is a vendored copy of `correct` from the Cursor pstack plugin, with the design red flags reference of pstack `architect`.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Paths: `pstack/skills/correct/SKILL.md` and `pstack/skills/architect/references/design-red-flags.md`.
  Here the red flags are `references/design-red-flags.md`.
- Base: `a58628271271837ef5f386adca29c0812683a19a` (2026-10-03, "feat(pstack): make /architect designs resist agent mistakes (#495)").
  The last upstream change to `SKILL.md` is `9511e60321f7e533a187d62854a3d53a53752874` (2026-10-03, "feat(pstack): add /correct skill (#494)").
  The files here are equal to upstream at the base, except for the local changes below.
- Checked up to: `1e5c90a4b6f249917bd21fe361b3a2a7deb741b8` (upstream `main`, 2026-10-14).
  Upstream has no changes to these files between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

```upstream
repo: cursor/plugins
branch: main
checked: 1e5c90a4b6f249917bd21fe361b3a2a7deb741b8
path: pstack/skills/correct/
path: pstack/skills/architect/references/design-red-flags.md
path: pstack/LICENSE
```

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
- Architecture level: points to `references/design-red-flags.md`.
  Upstream `architect` uses this file to screen design candidates.
  Its last four flags (split ownership, two ways to do one task, importable internals, hand-synced list) are the architecture fixes of `correct`, and this repo does not vendor `architect`.
- `references/design-red-flags.md`: "Screen every candidate before synthesis." becomes "Screen the code for each flag.", because `correct` screens a repo, not design candidates.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from the upstream base to this copy.
The `a/references/design-red-flags.md` side is upstream `pstack/skills/architect/references/design-red-flags.md`.

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
@@ -12,11 +14,11 @@
 
 ## Find the mistake classes
 
-First, read recent commits, reverts, review comments, agent instruction files, and comments that explain workarounds. Group the mistakes into classes. A class counts once it has happened twice.
+First, read recent commits, reverts, review comments, agent instruction files, agent memory of past corrections, the rule table, and comments that explain workarounds. Group the mistakes into classes. A class counts once it has happened twice.
 
 ## Fix each class at the highest level that works
 
-1. **Eliminate it with architecture.** Give each piece of state one owner and each task one supported way. Hide internals so the wrong import fails. Replace hand-synced lists with one source of truth. Delete old ways and dead code an agent would copy.
+1. **Eliminate it with architecture.** Give each piece of state one owner and each task one supported way. Hide internals so the wrong import fails. Replace hand-synced lists with one source of truth. Delete old ways and dead code an agent would copy. Screen the repo for each flag in [`references/design-red-flags.md`](references/design-red-flags.md).
 2. **Enforce it with types so the bad state can't be written.** If bad code still compiles, add a lint or CI check whose error names the file, type, or function to use instead. If the pattern is already common, fail only when a change adds more.
 3. **Test the behavior.** Fix or delete any test that would still pass if every function it calls returned nothing.
 4. **Write docs or agent rules last, only for judgment calls.** Nothing fails when an agent skips them.
@@ -27,6 +29,6 @@
 
 ## Keep the rule table
 
-Last, keep a table in the agent instruction file that pairs each rule with what enforces it. When the operator corrects you, fix the mistake and add the rule. If the rule was already there and nothing enforces it, that's a repeat, so fix it at the highest level in the same change. Drop a rule once its mistake can't happen.
+Last, keep a table in `docs/agents/corrections.md` that pairs each rule with what enforces it. When the operator corrects you, fix the mistake and add the rule. If the rule was already there and nothing enforces it, that's a repeat, so fix it at the highest level in the same change. Drop a rule once its mistake can't happen.
 
 **Reply:** each class with its evidence, the level you picked, and why a higher level didn't work.
--- a/references/design-red-flags.md
+++ b/references/design-red-flags.md
@@ -1,6 +1,6 @@
 # Design red flags
 
-Screen every candidate before synthesis. A red flag is a reason to revise or reject the shape.
+Screen the code for each flag. A red flag is a reason to revise or reject the shape.
 
 ## Shallow module
 
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/correct/ pstack/skills/architect/references/design-red-flags.md pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/correct/SKILL.md > SKILL.md` and `git -C <clone> show origin/main:pstack/skills/architect/references/design-red-flags.md > references/design-red-flags.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of these two commands, in this order:
   `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/correct/SKILL.md) SKILL.md` and
   `diff -u --label a/references/design-red-flags.md --label b/references/design-red-flags.md <(git -C <clone> show origin/main:pstack/skills/architect/references/design-red-flags.md) references/design-red-flags.md`.
   Set "Base" and "Checked up to" to the new upstream SHA and date.
