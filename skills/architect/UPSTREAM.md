# Upstream

This skill is a vendored copy of `architect` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- File map, one line per file: the upstream path under `pstack/skills/`, then the path here.

  ```text
  architect/SKILL.md SKILL.md
  ```

- Base of `SKILL.md`: `2f87c854fe3e2fcda44ca86b46ede35aad3c46b7` (2026-11-16, "feat(pstack): shorter skill texts, worker.md, and Opus-first routing capped at xhigh (#1249)").
  The file here is equal to upstream at this commit, except for the local changes below.
- Checked up to: `7a583913eb1b8d1a0ee76753d1a2cf072e7b54f9` (upstream `main`, 2026-11-21).
  Upstream has no changes to this file between its base and this commit.

It was added on 2026-10-28.
It was updated to the short `architect` of upstream #1249 on 2026-11-21.
On 2026-11-22, its copy of `arena` and the two principle skills that only `arena` uses moved to the `arena` skill of this repo.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the trigger phrases are removed, because model invocation is off.
- `arena`: "run the **arena** skill" becomes "ask the user to start the **arena** skill", because `arena` is user-invoked, and another skill cannot start it.
  The `arena` skill of this repo is the copy to start.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from upstream to this copy.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,11 +1,13 @@
 ---
 name: architect
-description: "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for /architect, 'architect this', 'design this', or non-trivial work where jumping to code would lock in the wrong shape."
+description: "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for non-trivial work where jumping to code would lock in the wrong shape."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Architect
 
 Before writing code, trace every system the change touches, then sketch two different shapes for it (types, signatures, module boundaries) and pick the one where each piece of state has one owner, each task has one way to do it, and callers need to know least. Redesign instead of patching if workarounds repeat.
 
-For a large or contested design, run the **arena** skill instead of sketching alone.
+For a large or contested design, ask the user to start the **arena** skill instead of sketching alone, because it is user-invoked, and only the user can start it.
```

## Update procedure

In the commands below, `<clone>` is an up-to-date clone of https://github.com/cursor/plugins, and `<map>` is the file map above, saved to a file.

1. Run `git -C <clone> diff <checked-up-to>..origin/main --stat -- pstack/skills/architect/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
   If upstream adds a file to `pstack/skills/architect/`, add it to the file map.
2. In this directory, run `while read -r up here; do git -C <clone> show "origin/main:pstack/skills/$up" > "$here"; done < <map>`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `while read -r up here; do diff -u --label "a/$here" --label "b/$here" <(git -C <clone> show "origin/main:pstack/skills/$up") "$here"; done < <map>`.
   Set the base and "Checked up to" to the new upstream SHA and date.
