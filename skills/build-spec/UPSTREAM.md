# Upstream

`SKILL.md` is a skill of this repo.
Its `references/` has copies of two user-invoked skills, because `build-spec` runs them and a skill cannot start a user-invoked skill.
Each file is a byte copy of its source at the base below.

## `no-comments`

- Source: `skills/no-comments/` in this repo, a changed copy of pstack `no-comments` (see `skills/no-comments/UPSTREAM.md`).
- Paths: `skills/no-comments/SKILL.md` is `references/no-comments.md`, and `skills/no-comments/references/comment-sicko.md` is `references/comment-sicko.md`.
- Base: `37bb8fb3a9b9f27c34d97f8af29c5aa9e86795f9` (2026-10-14, "Port pstack #613 effort rule to no-comments and check pstack to 79afd75"), the last change to these files.
- License: the pstack notice in `LICENSE`.

## `visual-pr`

- Repository: https://github.com/humanlayer/skills, branch `main`.
- Path: `plugins/visual-pr/skills/visual-pr/`.
  Its `SKILL.md` is `references/visual-pr.md`, and its `references/pr_description_template.md`, `references/show-me.md`, and `references/describe_pr_final_answer.md` keep their names.
- Base: `4e39d8fe020f17e5810b450e2646a7c4a7aa7a74` (2026-09-17, "add visual-pr skill").
- Checked up to: `653b6411c1f70c275a18e37673b042ff99f67ceb` (upstream `main`, 2026-10-08).
  Upstream has no changes to this directory between the base and this commit.
- License: the HumanLayer notice in `LICENSE`.

## Local changes

None.
`references/no-comments.md` points to `references/comment-sicko.md`, and `SKILL.md` step 8 says that this is `{SKILLBASE}/references/comment-sicko.md`, so the copy needs no change.
The `visual-pr` files point to `{SKILLBASE}/references/`, which is this skill's `references/`.

## Update procedure

1. When `skills/no-comments/SKILL.md` or `skills/no-comments/references/comment-sicko.md` changes, copy the file again, and set "Base" to the commit of the change.
2. In an up-to-date clone of https://github.com/humanlayer/skills, run `git diff <checked-up-to>..origin/main -- plugins/visual-pr/skills/visual-pr/ LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
3. Otherwise, run `git -C <clone> show origin/main:plugins/visual-pr/skills/visual-pr/SKILL.md > references/visual-pr.md`, do the same for each file in its `references/`, and copy the new license text into `LICENSE`.
   Set "Base" and "Checked up to" to the new upstream SHA and date.
