# Upstream

This skill is a vendored copy of `sharpen` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/sharpen/`.
- Base: `bf0c7cd80abdbf7fe47b634978a7d1b4071f71a7` (2026-11-14, "feat(pstack): new default models, one-file why and how, statechart fixes, sharpen and reflect text (#1236)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `bf0c7cd80abdbf7fe47b634978a7d1b4071f71a7` (upstream `main`, 2026-11-14).

`VanTanev/skills` added the copy on 2026-10-14.
The skill was updated to upstream #729 on 2026-11-03.
After upstream #712 and #729, the skill gives back a rewritten prompt and does not do the task.
The skill was updated to upstream #1236 on 2026-11-16. Since then, the rewritten prompt asks the agent to prototype each choice that an experiment can settle.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill from one canonical copy in `.agents/skills`.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: "Use for /sharpen." is removed.
  Model invocation is off, so trigger phrases for the model contradict the frontmatter, and agents do not all start skills with a slash command.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: sharpen
-description: "Make a task deeper, not bigger, then rewrite the prompt. Use for /sharpen."
+description: "Make a task deeper, not bigger, then rewrite the prompt."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 I want a deeper version of this task, not a bigger one. Before rewriting it, do four things:
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/sharpen/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/sharpen/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
