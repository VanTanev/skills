# Upstream

This skill is a vendored copy of `create-formal-verification-skill` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/create-formal-verification-skill/`.
- Base: `34b1b7c96f09f81a21a6c78f65b7833f7dcb5b24` (2026-10-26, "feat(pstack): port the statechart compiler (#977)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `ae5650febf4320793844c12c4adaa937f417f8da` (upstream `main`, 2026-10-31).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-11-03.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the "Use for /create-formal-verification-skill, \"model-check this race\", \"prove this invariant\", or when ..." trigger list becomes "For concurrency, retries, state machines, parsers, or unsafe code that need more than tests."
  Model invocation is off, so trigger phrases for the model contradict the frontmatter.
- Location: the generated skill goes in `.agents/skills/<name>/`, with `.claude/skills/<name>` as a relative symlink to it, as in `create-verification-skill`.
  Upstream names no directory, and `.agents/skills` is the canonical skill directory.
- Frontmatter warning: "Without frontmatter, the skill never registers" becomes "Without a description, agents do not advertise the skill to the model", as in `create-verification-skill`.
- `statechart`: the generated skill tells the next agent "Call the Skill tool with `statechart`", in place of a link to `../statechart/SKILL.md` and the `/statechart` command.
  The link breaks outside the pstack tree, and `statechart` is model-invoked in this repo, so an agent can start it.
- Hand off: "Point the user at `/maintain-formal-verification-skill`" becomes "tell the user to type `/maintain-formal-verification-skill`", because only the user can start a user-invoked skill.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: create-formal-verification-skill
-description: "Generate a project-local skill that formally verifies the code where a bug costs the most and tests reach the least, in any language, with whichever verification tool fits. Use for /create-formal-verification-skill, \"model-check this race\", \"prove this invariant\", or when concurrency, retries, state machines, parsers, or unsafe code need more than tests."
+description: "Generate a project-local skill that formally verifies the code where a bug costs the most and tests reach the least, in any language, with whichever verification tool fits. For concurrency, retries, state machines, parsers, or unsafe code that need more than tests."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Create a formal verification skill
@@ -30,9 +32,9 @@
 
 ## Generate the verify skill
 
-Write a project-local skill with frontmatter that names the area and says when to use it. Without frontmatter, the skill never registers. From the skill alone, the next agent must be able to tell whether a change touches the verified code, run the check, tell a real bug from a modeling error, and update the verification when a change is intended. Put the coverage record and the sync commit in the skill, and tell the next agent to move the sync commit forward only after it confirms that the verification describes the code at the new commit. Use this repo's real commands, paths, and nouns, and leave no placeholders.
+Write a project-local skill at `.agents/skills/<name>/SKILL.md`, with frontmatter that names the area and says when to use it. Without a description, agents do not advertise the skill to the model. Create `.claude/skills/<name>` as a relative symlink to `../../.agents/skills/<name>` so both runtimes use the same project-local skill; never maintain a second copy. From the skill alone, the next agent must be able to tell whether a change touches the verified code, run the check, tell a real bug from a modeling error, and update the verification when a change is intended. Put the coverage record and the sync commit in the skill, and tell the next agent to move the sync commit forward only after it confirms that the verification describes the code at the new commit. Use this repo's real commands, paths, and nouns, and leave no placeholders.
 
-If the check is a TLA+ model, tell the next agent to read every result with the pstack [`/statechart`](../statechart/SKILL.md) skill. It shows each invariant violation the checker finds as its shortest path in plain words. When the check passes, `/statechart` draws a chart of how the system moves between states. Refer to `/statechart` by name. Its commands, options, and file paths change between releases and machines, so copy none of them into the generated skill or its scripts.
+If the check is a TLA+ model, tell the next agent to read every result with the `statechart` skill, in the words "Call the Skill tool with `statechart`". It shows each invariant violation the checker finds as its shortest path in plain words. When the check passes, `statechart` draws a chart of how the system moves between states. Refer to `statechart` by name. Its commands, options, and file paths change between releases and machines, so copy none of them into the generated skill or its scripts.
 
 ## Prove it before you hand off
 
@@ -40,4 +42,4 @@
 
 ## Hand off
 
-Tell the user what you verified, which tool you used and why, the bounds, what the check found in plain words, how to run it, and what it does not cover. Suggest a second target only if you found a close one. Point the user at `/maintain-formal-verification-skill` for bringing the verification back in line after changes that did not recheck it.
+Tell the user what you verified, which tool you used and why, the bounds, what the check found in plain words, how to run it, and what it does not cover. Suggest a second target only if you found a close one. For bringing the verification back in line after changes that did not recheck it, tell the user to type `/maintain-formal-verification-skill`.
```

## Update procedure

Update this skill together with `maintain-formal-verification-skill` and `statechart`, because the generated skill calls `statechart`, and `maintain-formal-verification-skill` maintains the generated skill.

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/create-formal-verification-skill/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/create-formal-verification-skill/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
