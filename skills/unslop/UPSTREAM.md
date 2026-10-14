# Upstream

This skill is a vendored copy of `unslop` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/unslop/`.
- Base: `bc697d0a5a163cec979e362b601e36f5616083fd` (2026-10-11, "fix(pstack): drop "Must always apply." from unslop description (#572)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `1e5c90a4b6f249917bd21fe361b3a2a7deb741b8` (upstream `main`, 2026-10-14).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

## Local changes

All changes let the agent start the skill by itself, and let other skills call it.

- Invocation: model-invoked.
  `disable-model-invocation: true` is removed, so the agent starts the skill when it writes prose for a person.
  Other skills in this repo, such as `blast-radius`, call it with the Skill tool, which works only for a model-invoked skill.
- Description: the upstream sentence stays first, and a second sentence says when to use the skill: prose that a person reads, or a request to remove slop or mannered prose.
- `agents/openai.yaml`: added, with `interface` only, because the skill is model-invoked.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,6 @@
 ---
 name: unslop
-description: Cut AI tells from any writing.
-disable-model-invocation: true
+description: "Cut AI tells from any writing. Use when you write or edit prose that a person reads, such as a doc, PR description, commit message, ticket, review comment, or report, or when the user asks to remove slop or mannered prose."
 ---
 
 # Unslop
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/unslop/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/unslop/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
