# Upstream

`risk-first` is a skill of this repo, under the repo's MIT license.
Only `references/prove-it-works.md` is a vendored copy, of the `principle-prove-it-works` skill from the Cursor pstack plugin.
`LICENSE` in this directory covers only that file.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/principle-prove-it-works/SKILL.md`, which is `references/prove-it-works.md` here.
- Base: `b0b9c7a0baf8b6aa1d00bf77d4101e577d4ba411` (2026-09-23, "docs(pstack): cut 19 more instructions Opus 5.5 does not need (#419)").
  The file here is equal to upstream at this commit, except for the local change below.
- Checked up to: `1e5c90a4b6f249917bd21fe361b3a2a7deb741b8` (upstream `main`, 2026-10-14).
  Upstream has no changes to this file between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.
It is byte-identical to `skills/hillclimb/references/prove-it-works.md`, and `scripts/check-repeats.sh` keeps the two copies equal.

## Local changes

- The frontmatter stays, so the copy is the whole upstream `SKILL.md`.
  Step 2 of `SKILL.md` points to it as `{SKILLBASE}/references/prove-it-works.md`.
- "(the **show-me-your-work** skill)" is removed, because this repo does not vendor that skill.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from upstream to this copy:

```diff
--- a/references/prove-it-works.md
+++ b/references/prove-it-works.md
@@ -19,4 +19,4 @@
 
 The strongest proof is a deterministic script that re-runs the same comparison, not a one-time eyeball. Write the script, run it, and keep its output as an artifact a reviewer can re-run instead of trusting your word.
 
-Keep the artifact visible for the human. Commit it only for large or complex work where the trail has to be auditable later, like a big port or migration (the **show-me-your-work** skill).
+Keep the artifact visible for the human. Commit it only for large or complex work where the trail has to be auditable later, like a big port or migration.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/principle-prove-it-works/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/principle-prove-it-works/SKILL.md > references/prove-it-works.md`, and copy `pstack/LICENSE` to `LICENSE`.
3. Re-apply the local change: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If the hunk fails, apply the change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/references/prove-it-works.md --label b/references/prove-it-works.md <(git -C <clone> show origin/main:pstack/skills/principle-prove-it-works/SKILL.md) references/prove-it-works.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
5. Run `scripts/check-repeats.sh` from the repo root.
   It fails until every other copy of `principle-prove-it-works`, such as `skills/hillclimb/references/prove-it-works.md`, has the same update.
