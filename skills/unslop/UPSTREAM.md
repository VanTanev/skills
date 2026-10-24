# Upstream

This skill is a vendored copy of `unslop` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/unslop/`.
- Base: `bc697d0a5a163cec979e362b601e36f5616083fd` (2026-10-11, "fix(pstack): drop "Must always apply." from unslop description (#572)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `9580c23696ac8d7abed0c166f2f9918800afb819` (upstream `main`, 2026-10-23).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

Other skills in this repo cannot start `unslop`, because it is user-invoked.
`blast-radius` and `technical-writing` read a byte copy of the upstream file in their own `references/unslop.md`, and their `UPSTREAM.md` files keep those copies up to date.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -2,6 +2,8 @@
 name: unslop
 description: Cut AI tells from any writing.
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
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
5. Follow the update procedure of `blast-radius` and `technical-writing`, so that their copies in `references/unslop.md` stay equal to upstream.
