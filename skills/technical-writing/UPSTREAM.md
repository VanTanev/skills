# Upstream

This skill is a vendored copy of `technical-writing` from the Cursor pstack plugin, with the `unslop` skill as a reference.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Paths:
  - `pstack/skills/technical-writing/SKILL.md`, which is `SKILL.md` here.
  - `pstack/skills/unslop/SKILL.md`, which is `references/unslop.md` here.
- Base of `SKILL.md`: `2f87c854fe3e2fcda44ca86b46ede35aad3c46b7` (2026-11-16, "feat(pstack): shorter skill texts, worker.md, and Opus-first routing capped at xhigh (#1249)").
- Base of `references/unslop.md`: `2f87c854fe3e2fcda44ca86b46ede35aad3c46b7` (2026-11-16, "feat(pstack): shorter skill texts, worker.md, and Opus-first routing capped at xhigh (#1249)").
  The files here are equal to upstream at these commits, except for the local changes below.
- Checked up to: `792440e8a560a4a3f63748cdee70491ecd412982` (upstream `main`, 2026-11-20).
  Upstream has no changes to either file between its base and this commit.

`VanTanev/skills` added the copy on 2026-10-24.
It was updated to the shorter texts of upstream #1249 on 2026-11-21.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: "Use for /technical-writing or when writing or reviewing" is removed, because model invocation is off.
  The list of document types moves to the start, so the line tells a person what the command is for.
- `unslop`: "Apply the **unslop** skill to every doc this skill touches" becomes "Apply the **unslop** skill in `references/unslop.md` in this skill's folder to every doc this skill touches".
  `unslop` is user-invoked, and another skill cannot start it, so `references/unslop.md` is a byte copy of the upstream skill, with its frontmatter.
  The path is relative to the skill's folder, because Claude Code does not replace a `{SKILLBASE}` placeholder.
- `swarm`: "swarm logs" becomes "agent logs", because this repo does not vendor `swarm`.
- Indentation: "Indent code snippets with tabs" becomes "Indent code snippets the way the repo indents its code", because tabs are the rule of the pstack repo, not of every repo.
- PR reviews: a new bullet in "Voice and repo specifics" says that a review body states the verdict, the items that block, and answers to the author's questions, and that every other point goes into an inline comment.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy.
`references/unslop.md` is equal to upstream, so it has no diff.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: technical-writing
-description: "Layered technical-writing standard: Diátaxis structure, Google developer style sentences, STE instruction rules, Global English syntax. Use for /technical-writing or when writing or reviewing docs, RFCs, readmes, PR descriptions, or commit messages."
+description: "Layered technical-writing standard for docs, RFCs, readmes, PR descriptions, and commit messages: Diátaxis structure, Google developer style sentences, STE instruction rules, Global English syntax."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Technical writing
@@ -64,7 +66,8 @@
 
 ## Voice and repo specifics
 
-- Apply the **unslop** skill to every doc this skill touches. That skill owns the slop-pattern catalog: AI vocabulary, filler, hedging, formatting tells.
-- PR descriptions and commit messages are writing too. Every layer except Diátaxis applies to them. A PR body is a briefing that a reviewer can read in under a minute. Do not paste swarm logs, SHA lists, or metric tables. Link them.
+- Apply the **unslop** skill in `references/unslop.md` in this skill's folder to every doc this skill touches. That skill owns the slop-pattern catalog: AI vocabulary, filler, hedging, formatting tells.
+- PR descriptions and commit messages are writing too. Every layer except Diátaxis applies to them. A PR body is a briefing that a reviewer can read in under a minute. Do not paste agent logs, SHA lists, or metric tables. Link them.
+- A PR review body states the verdict and the items that block, and answers any question the author asked. Every other point goes into an inline comment on the line it is about.
 - Product UI strings are not documentation. Use your product's copy guidelines for those.
-- Indent code snippets with tabs. Write real paths. Make every count or tree claim true at the commit that lands it, and include the command that regenerates it.
+- Indent code snippets the way the repo indents its code. Write real paths. Make every count or tree claim true at the commit that lands it, and include the command that regenerates it.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/technical-writing/ pstack/skills/unslop/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/technical-writing/SKILL.md > SKILL.md` and `git -C <clone> show origin/main:pstack/skills/unslop/SKILL.md > references/unslop.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/technical-writing/SKILL.md) SKILL.md`.
   Set both bases and "Checked up to" to the new upstream SHA and date.
