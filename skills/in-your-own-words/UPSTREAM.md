# Upstream

This skill is a vendored copy of `in-your-own-words` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/in-your-own-words/`.
- Base: `dbf49813a39c1a5389c5e28cb8e4c1c2379e2454` (2026-10-13, "refactor(pstack): reword /in-your-own-words around goals and the problem (#606)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `79afd75d5bd51383fbb526b72f36db03180b8301` (upstream `main`, 2026-10-14).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill from one canonical copy in `.agents/skills`.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: "Use for /in-your-own-words." is removed.
  Model invocation is off, so trigger phrases for the model contradict the frontmatter, and agents do not all start skills with a slash command.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: in-your-own-words
-description: "Restate in your own words what you think the user's goals are and what problem they're trying to solve. Use for /in-your-own-words."
+description: "Restate in your own words what you think the user's goals are and what problem they're trying to solve."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 Restate in your own words what you think the user's goals are and what problem they're trying to solve.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/in-your-own-words/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/in-your-own-words/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
