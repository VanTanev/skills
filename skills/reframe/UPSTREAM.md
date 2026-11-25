# Upstream

This skill is a vendored copy of `reframe` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/reframe/`.
- Base: `9e278fe4d4ecd8bfe98b1b79bf4be662efb338cc` (2026-11-23, "feat(pstack): have /reframe list the problems a vague description could be (#1326)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `41e400932eca14f289e7db717a70455256b6d388` (upstream `main`, 2026-11-24).

`VanTanev/skills` added the copy on 2026-11-25.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill from one canonical copy in `.agents/skills`.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: "Use for /reframe." is removed.
  Model invocation is off, so trigger phrases for the model contradict the frontmatter, and agents do not all start skills with a slash command.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: reframe
-description: "Teach the expert words for what the operator is building, borrow words from neighboring fields that solved the same problem, then rewrite their description with them. Use for /reframe."
+description: "Teach the expert words for what the operator is building, borrow words from neighboring fields that solved the same problem, then rewrite their description with them."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 Teach the operator the expert words for what they are building. Start from their own files, code and description, not a summary.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/reframe/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/reframe/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
