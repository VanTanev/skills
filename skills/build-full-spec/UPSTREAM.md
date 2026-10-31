# Upstream

`SKILL.md` is a skill of this repo: `skills/build-spec/SKILL.md` with a `sol-loop` step, and with rules adapted from tstack's `full-send` and `full-stop`.
Its `references/` has copies of two user-invoked skills, because `build-full-spec` runs them and a skill cannot start a user-invoked skill.
Each file in `references/` is a byte copy of its source at the base below.

## `no-comments`

- Source: `skills/no-comments/` in this repo, a changed copy of pstack `no-comments` (see `skills/no-comments/UPSTREAM.md`).
- Paths: `skills/no-comments/SKILL.md` is `references/no-comments.md`, and `skills/no-comments/references/comment-sicko.md` is `references/comment-sicko.md`.
- Base: `2257f9768971772efec8e5161295287310a3cffd` (2026-10-29, "Start subagents with a fresh context window, and port Matt's build and tracker fixes"), the last change to these files.
- License: the pstack notice in `LICENSE`.

## `visual-pr`

- Repository: https://github.com/humanlayer/skills, branch `main`.
- Path: `plugins/visual-pr/skills/visual-pr/`.
  Its `SKILL.md` is `references/visual-pr.md`, and its `references/pr_description_template.md`, `references/show-me.md`, and `references/describe_pr_final_answer.md` keep their names.
- Base: `4e39d8fe020f17e5810b450e2646a7c4a7aa7a74` (2026-09-17, "add visual-pr skill").
- Checked up to: `653b6411c1f70c275a18e37673b042ff99f67ceb` (upstream `main`, 2026-10-08).
  Upstream has no changes to this directory between the base and this commit.
- License: the HumanLayer notice in `LICENSE`.

## `full-send` and `full-stop`

- Repository: https://github.com/VanTanev/tstack, branch `main`, a fork of https://github.com/t3dotgg/tstack.
- Paths: `skills/full-send/SKILL.md` and `skills/full-stop/SKILL.md`.
- Base: `539a5e72df34ec5dfb89c98f3617152a9a5fe12f` (2026-10-31, "feat(full-send): run no-comments before the sol-loop review").
- License: the tstack notice in `LICENSE`.
- These are not byte copies.
  `SKILL.md` rewrites parts of them in its own sections:
  - "Permissions": the grant and the testing permission of `full-send`, and the "No merging" rules of `full-stop`.
  - "Decisions and questions": the "Asking the user" rules of `full-send`, joined with the decision rule of `build-spec`.
  - Steps 14 and 15, and the "Stay active" paragraph: the babysit steps and the watcher rule of `full-send`.
  - "Proof": the "Proof" section of `full-send`, without its "add one focused test" bullet, because `risk-first` chooses the tests.
  - "Readiness gate": the "Merge gate" of `full-send`, with the PR state checks of `full-stop`.
  - "Handoff": the "Stop at the gate" section of `full-stop`.

## Local changes

None in `references/`.
`references/no-comments.md` points to `references/comment-sicko.md`, and `SKILL.md` step 8 says that this file is in this skill's folder too, so the copy needs no change.
The `visual-pr` files point to `{SKILLBASE}/references/`, and `SKILL.md` step 13 says that `{SKILLBASE}` is this skill's folder, so the copies need no change.

## Update procedure

1. When `skills/no-comments/SKILL.md` or `skills/no-comments/references/comment-sicko.md` changes, copy the file again, and set "Base" to the commit of the change.
2. In an up-to-date clone of https://github.com/humanlayer/skills, run `git diff <checked-up-to>..origin/main -- plugins/visual-pr/skills/visual-pr/ LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and go to step 4.
3. Otherwise, run `git -C <clone> show origin/main:plugins/visual-pr/skills/visual-pr/SKILL.md > references/visual-pr.md`, do the same for each file in its `references/`, and copy the new license text into `LICENSE`.
   Set "Base" and "Checked up to" to the new upstream SHA and date.
4. In an up-to-date clone of https://github.com/VanTanev/tstack, run `git diff <base>..origin/main -- skills/full-send/SKILL.md skills/full-stop/SKILL.md`.
   Port each change that applies to the sections listed above, and set its "Base" to the `origin/main` SHA and date.
