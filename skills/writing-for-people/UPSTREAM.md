# Upstream

This skill is a changed copy of `technical-writing` from the Cursor pstack plugin, with the `unslop` skill as a reference.
It is the model-invoked form of `technical-writing` in this repo: the agent starts it before it writes text that people read outside the chat.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Paths:
  - `pstack/skills/technical-writing/SKILL.md`, which is `SKILL.md` here.
  - `pstack/skills/unslop/SKILL.md`, which is `references/unslop.md` here.
- Base of `SKILL.md`: `00b14f1df36b32a8dd1529324a3a459f6563b127` (2026-10-10, "refactor(pstack): distill skill prompts to cut tokens (#538)").
- Base of `references/unslop.md`: `bc697d0a5a163cec979e362b601e36f5616083fd` (2026-10-11, "fix(pstack): drop "Must always apply." from unslop description (#572)").
  The files here are equal to upstream at these commits, except for the local changes below.
- Checked up to: `9580c23696ac8d7abed0c166f2f9918800afb819` (upstream `main`, 2026-10-23).

## Local changes

- Name and title: `writing-for-people`, because `technical-writing` in this repo stays user-invoked, as upstream.
  The name pairs with Matt Pocock's `writing-for-agents`, which covers text that agents read.
- Frontmatter: no `disable-model-invocation`, so the agent can start the skill.
  The description names each kind of text that triggers it.
- The intro says to run the check at the end.
- `unslop`: "Apply the **unslop** skill" becomes "Apply the **unslop** skill in `references/unslop.md` in this skill's folder".
  `unslop` is user-invoked, and another skill cannot start it, so `references/unslop.md` is a byte copy of the upstream skill, with its frontmatter.
  The path is relative to the skill's folder, because Claude Code does not replace a `{SKILLBASE}` placeholder.
- `swarm`: "swarm logs" becomes "agent logs", because this repo does not vendor `swarm`.
- Indentation: "Indent code snippets with tabs" becomes "Indent code snippets the way the repo indents its code", because tabs are the rule of the pstack repo, not of every repo.
- "Check the text before you publish it": a new section that runs `scripts/check_text.py`.
  The script finds the unslop and Global English faults that a pattern can find, and with `--markdown`, Markdown that renders wrong and line breaks inside a sentence.
  Only Markdown that renders wrong is an error. Every other finding is a suggestion, because the top rule lets a writer keep a sentence that a rule makes worse.
  With `--changed`, it reports only the lines that differ from git `HEAD`, so an edit to an old doc does not rewrite lines that the task did not touch.
  The script is new in this repo, not from upstream.
- `agents/openai.yaml`: added, with no `policy`, so Codex can start the skill.
- `LICENSE`: a byte copy of upstream `pstack/LICENSE` (MIT).

This is the exact diff of `SKILL.md` from the upstream base to this copy.
`references/unslop.md` is equal to upstream, so it has no diff.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,12 +1,11 @@
 ---
-name: technical-writing
-description: "Layered technical-writing standard: Diátaxis structure, Google developer style sentences, STE instruction rules, Global English syntax. Use for /technical-writing or when writing or reviewing docs, RFCs, readmes, PR descriptions, or commit messages."
-disable-model-invocation: true
+name: writing-for-people
+description: "Writing standard for text that people read outside the chat: PR bodies, PR reviews and replies, issues, commit messages, Jira tickets, and docs. Use before you write or edit any of them."
 ---
 
-# Technical writing
+# Writing for people
 
-Write so a tired engineer understands on the first read. Apply all four layers.
+Write so a tired engineer understands on the first read. Apply all four layers, then run the check at the end.
 
 Three rules sit above the layers:
 
@@ -90,10 +89,21 @@
 
 ## Voice and repo specifics
 
-- Apply the **unslop** skill to every doc this skill touches. That skill owns the slop-pattern catalog: AI vocabulary, filler, hedging, formatting tells.
-- PR descriptions and commit messages are writing too. Every layer except Diátaxis applies to them. A PR body is a briefing that a reviewer can read in under a minute. Do not paste swarm logs, SHA lists, or metric tables. Link them.
+- Apply the **unslop** skill in `references/unslop.md` in this skill's folder to every doc this skill touches. That skill owns the slop-pattern catalog: AI vocabulary, filler, hedging, formatting tells.
+- PR descriptions and commit messages are writing too. Every layer except Diátaxis applies to them. A PR body is a briefing that a reviewer can read in under a minute. Do not paste agent logs, SHA lists, or metric tables. Link them.
 - Product UI strings are not documentation. Use your product's copy guidelines for those.
-- Indent code snippets with tabs. Write real paths. Make every count or tree claim true at the commit that lands it, and include the command that regenerates it.
+- Indent code snippets the way the repo indents its code. Write real paths. Make every count or tree claim true at the commit that lands it, and include the command that regenerates it.
+
+## Check the text before you publish it
+
+`scripts/check_text.py`, in this skill's folder, finds the faults that a pattern can find. It reads files, so write the text to a file first.
+
+1. Run `python3 <this skill's folder>/scripts/check_text.py <file>`. If the text renders as Markdown, as GitHub text and docs in a repo do, add `--markdown`. A Jira ticket and a commit message take no flag. If you edit a file that git tracks, add `--changed`: the script then reports only the lines that differ from `HEAD`, and the lines that the task did not touch stay as they are.
+2. Fix each error. An error is Markdown that renders wrong.
+3. Weigh each suggestion. Apply it, or keep the text when the change makes the sentence worse. Code, commands, and quoted messages belong in code font, which the script skips.
+4. Run the script again. The check is done when it exits 0 and you applied or kept each suggestion on purpose.
+
+The script finds patterns only. The four layers still need your judgement.
 
 ## Worked example
 
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/technical-writing/ pstack/skills/unslop/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/technical-writing/SKILL.md > SKILL.md` and `git -C <clone> show origin/main:pstack/skills/unslop/SKILL.md > references/unslop.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md`, `agents/openai.yaml`, and `scripts/`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/technical-writing/SKILL.md) SKILL.md`.
   Set both bases and "Checked up to" to the new upstream SHA and date.
