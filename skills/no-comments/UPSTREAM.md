# Upstream

This skill is a vendored copy of `no-comments` and the Comment Sicko agent from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Paths: `pstack/skills/no-comments/SKILL.md` and `pstack/agents/comment-sicko.md`.
  Here the agent is `references/comment-sicko.md`.
- Base: `99559f2f52047978602ef365589275831e76af07` (2026-08-02, "pstack: add bro, babysit/shipping/orchestrate/worktree-cleanup, and catch-up ports (0.14.0) (#187)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `997ffc7fe26bdaa6478a14e7f5b8d5f9ed747102` (upstream `main`, 2026-10-12).
  Upstream has two changes after the base that are not applied here. See "Upstream changes not applied".

The copy recorded no upstream SHA.
Its text has "Authoring agents defend comments.", which upstream #329 removed, so the base is the last upstream commit before #329 that changes these files.
`VanTanev/skills` added the copy on 2026-10-07 in commit `e159729`.

## Local changes

All changes let Claude Code, OpenCode, and other agents run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: "Spawn Comment Sicko, fix accepted findings" becomes "Spawn Comment Sicko on the scoped diff, act on accepted findings".
- Scope: there is no default diff against `main`.
  The caller names a fixed point, or the agent asks in chat.
  The skill gets the diff once with `git diff <fixed-point>...HEAD`, and before it starts the subagent, it makes sure that the ref resolves and that the diff is not empty.
- Comment Sicko: upstream is a pstack agent definition that step 1 starts by its id.
  Here it is `references/comment-sicko.md`, and step 1 starts a general-purpose subagent with that file as its prompt, because other agents cannot load a pstack agent definition.
- `/how` and `/why`: replaced by a `## Trace` section in `references/comment-sicko.md` (`git log -S`, `git blame`, the PR, the named ticket), because this repo does not vendor the `how` and `why` skills.
  Step 2 and Comment Sicko run the Trace.
- `/architect`: step 3 makes the sketch itself (caller usage first, signatures with `not implemented` bodies, two shapes, keep the one with the smaller public surface), because this repo does not vendor `architect`.
  Step 6 reports the "sketch", not the "architect sketch".
- Principle skills: step 4 gives the two rules from `principle-fix-root-causes` and `principle-redesign-from-first-principles` directly, because this repo does not vendor them.
- Step 5: "Wait for interactive approval. Unattended and eval require caller pre-approval." becomes "Ask in chat and wait for approval. Unattended runs require caller pre-approval."
- Comment Sicko scope: "If none exists, feed me the current diff against `main`." becomes "Nothing outside it exists.", to agree with the skill scope.
- Comment Sicko keep list: "`// prettier-ignore`" becomes "Formatter-ignore directives", so that the rule applies to all formatters.
- Comment Sicko suppressions: adds `oxlint-disable`.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from the upstream base to this copy.
The `a/references/comment-sicko.md` side is upstream `pstack/agents/comment-sicko.md`.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: no-comments
-description: "Spawn Comment Sicko, fix accepted findings, and offer encodings for claimed constraints."
+description: "Spawn Comment Sicko on the scoped diff, act on accepted findings, and offer encodings for claimed constraints."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # No comments
@@ -12,13 +14,15 @@
 
 ## Scope
 
-Use the caller's files or diff. Otherwise use the current diff against the base branch, default `main`, including the working tree.
+Use the caller's files or diff. Otherwise pin the fixed point the caller named (a commit SHA, branch name, tag, `HEAD~5`, etc.); without one, ask in chat.
+
+Capture the diff once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty before spawning; a bad ref or empty diff fails here, not inside the Sicko.
 
 ## Steps
 
-1. Spawn `Task` with `subagent_type: "Comment Sicko"`. Pass the scope. Do not restate its rules.
-2. Inspect its report and diff. Reject application-code edits, scope escapes, exception-protected deletions, misstated `MUST KILL` reasons, and flags that treat kept intentional code as guilty. Reshape flags on our-code surprises stay actionable. Do not restore those comments. A keep survives only with proof it is about something we cannot change. Audit missed scoped lint and TypeScript suppressions. Correctness or safety suppressions stay actionable `MUST KILL`s. Restore deletions only with exact exceptions and scoped proof. Before accepting thin `IMPORTANT` or `do not remove` kills or keeps, run `/how` or `/why` on their symbol. If a kill is ambiguous, do not restore. If a keep is refuted or still ambiguous, delete it. Revert and rerun one rejected report with the failure named. Reject a second, report it open, and fail `/no-comments`.
-3. Fix trivial accepted flags directly by deleting a dead path, dropping a parameter, or using the real API. If any fix needs a shape, run `/architect` once for the accepted set and surrounding code. Stop at the sketch. Architect shapes. Step 4 implements.
-4. Implement the smallest root-cause fix in scope. Remove every named workaround. If the root cause is out of scope, land the smallest in-scope fix and report the rest open. The **principle-fix-root-causes** and **principle-redesign-from-first-principles** skills guide intent only: fix real causes, redesign as if requirements always existed, never bolt on symptom guards. Neither authorizes widening the fence nor fixing instances outside it.
-5. Constraint comments say `do not remove`, `do not change wording`, or `talk to X before changing`. Leave keeps about things we cannot change. Offer the cheapest in-scope type, runtime, test, or CI lint. Wait for interactive approval. Unattended and eval require caller pre-approval. If approved, encode then delete. Otherwise delete, report the constraint open, and sketch out-of-scope work.
-6. Report the deletion count, restored comments, reruns, architect sketch, fixes, encoding offers, encodings, unenforced constraints, and other open work.
+1. Read `references/comment-sicko.md`. Spawn `Agent` with `subagent_type: "general-purpose"` and that file verbatim as the prompt, followed by the scope.
+2. Inspect its report and diff. Reject application-code edits, scope escapes, exception-protected deletions, misstated `MUST KILL` reasons, and flags that treat kept intentional code as guilty. Reshape flags on our-code surprises stay actionable. Do not restore those comments. A keep survives only with proof it is about something we cannot change. Audit missed scoped lint and TypeScript suppressions. Correctness or safety suppressions stay actionable `MUST KILL`s. Restore deletions only with exact exceptions and scoped proof. Before accepting thin `IMPORTANT` or `do not remove` kills or keeps, run the Sicko's Trace on their symbol. If a kill is ambiguous, do not restore. If a keep is refuted or still ambiguous, delete it. Revert and rerun one rejected report with the failure named. Reject a second, report it open, and fail `/no-comments`.
+3. Fix trivial accepted flags directly by deleting a dead path, dropping a parameter, or using the real API. If any fix needs a shape, sketch once for the accepted set and surrounding code: write the caller's usage first, then types and signatures with `not implemented` bodies. Sketch two structurally distinct shapes and keep the one that hides more behind a smaller public surface. Stop at the sketch. Step 4 implements.
+4. Implement the smallest root-cause fix in scope against the sketch. Remove every named workaround. Fix the cause where it lives: a guard that silences a symptom is not a fix. Redesign as if the requirement had existed from day one. If the root cause is out of scope, land the smallest in-scope fix and report the rest open. Neither rule authorizes widening the fence nor fixing instances outside it.
+5. Constraint comments say `do not remove`, `do not change wording`, or `talk to X before changing`. Leave keeps about things we cannot change. Offer the cheapest in-scope type, runtime, test, or CI lint. Ask in chat and wait for approval. Unattended runs require caller pre-approval. If approved, encode then delete. Otherwise delete, report the constraint open, and sketch out-of-scope work.
+6. Report the deletion count, restored comments, reruns, sketch, fixes, encoding offers, encodings, unenforced constraints, and other open work.
--- a/references/comment-sicko.md
+++ b/references/comment-sicko.md
@@ -9,24 +9,35 @@
 
 Yes... Ha ha ha... Yes!
 
-I hate comments. Feed me the parent scoped files or diff. If none exists, feed me the current diff against `main`. Narration, banners, commented-out corpses, workaround sermons. I want them all.
+I hate comments. Feed me the parent's scoped files or diff. Nothing outside it exists. Narration, banners, commented-out corpses, workaround sermons. I want them all.
 
 Only these exceptions get to crawl away.
 
 - Legal or license headers.
 - Non-obvious behavior forced by an external dependency, platform, vendor, or protocol we cannot reshape. Surprises in our own code are meat. Kill them and mark the exact symbol `MUST KILL` for rename, extract, type, or rearchitecture that makes the behavior obvious without prose.
-- `// prettier-ignore`. Lint suppressions survive only when their rule is faulty, pedantic, or style-only.
+- Formatter-ignore directives. Lint suppressions survive only when their rule is faulty, pedantic, or style-only.
 - Doc comments that define a public API contract.
 - Issue or RFC links that explain a constraint code cannot express.
 
 That list is my only leash. When I am not sure a keep clause applies, the comment dies. Everything else is meat.
 
-`eslint-disable`, `@ts-ignore`, `@ts-expect-error`, and similar suppressions stink. Look up the rule. If it catches real bugs or protects correctness or safety, kill the suppression and mark the exact guilty symbol `MUST KILL`.
+`eslint-disable`, `oxlint-disable`, `@ts-ignore`, `@ts-expect-error`, and similar suppressions stink. Look up the rule. If it catches real bugs or protects correctness or safety, kill the suppression and mark the exact guilty symbol `MUST KILL`.
 
-`IMPORTANT`, `do not remove`, `too risky`, `fine for now`, and long justifications are scent, not conviction. Before judging, I read nearby code. If its claim is not obvious there, I run `/how`, `/why`, or both from the **how** and **why** skills on the named symbol or call. Only a foreign keep-list gotcha proven true today on a live path crawls away. Our-code surprises die with the reshape flag above. Doubt after the hunt is meat.
+`IMPORTANT`, `do not remove`, `too risky`, `fine for now`, and long justifications are scent, not conviction. Before judging, I read nearby code. If its claim is not obvious there, I run the Trace on the named symbol or call. Only a foreign keep-list gotcha proven true today on a live path crawls away. Our-code surprises die with the reshape flag above. Doubt after the hunt is meat.
 
 A long justification without a proven keep-list exception is a confession. Kill it. Never polish meat into a shorter alibi. Mark the exact guilty symbol `MUST KILL`. My kill ends there. I do not touch the code.
 
 Every flag names code inside the scope and tells the truth. I invent nothing. I touch comments and identify refactor targets. I never write application code.
 
 Report only. Name touched files, deletion count, `MUST KILL` flags with one line each, and skips.
+
+## Trace
+
+Evidence for one symbol, cheapest first. Stop when a keep-list exception is proven or refuted.
+
+- Read the symbol and every caller.
+- `git log -S'<symbol>' --oneline -- <file>` and `git blame -L <start>,<end> <file>` for the commits that shaped it.
+- `git log -1 --format=%B <commit>` for the PR number, then `gh pr view <number> --json title,body,comments,reviews`.
+- Open any ticket, issue, or RFC the comment names.
+
+The code says what it does, never why it exists. Intent comes from the record above or it is a guess, and a guess is meat.
```

## Upstream changes not applied

- https://github.com/cursor/plugins/pull/329 (`e8d856f`) removes "Authoring agents defend comments." from `SKILL.md`.
  Its other change to `SKILL.md`, in step 4, is to text that the local changes replace.
- https://github.com/cursor/plugins/pull/486 (`de2dba6`) changes the agent `name` from `Comment Sicko` to `comment-sicko`, and the `subagent_type` in step 1 to agree.
  It has no effect here, because step 1 does not start the agent by its id.

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/no-comments/ pstack/agents/comment-sicko.md pstack/LICENSE`.
   If the diff is empty and you do not apply the changes in "Upstream changes not applied", set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/no-comments/SKILL.md > SKILL.md` and `git -C <clone> show origin/main:pstack/agents/comment-sicko.md > references/comment-sicko.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of these two commands, in this order:
   `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/no-comments/SKILL.md) SKILL.md` and
   `diff -u --label a/references/comment-sicko.md --label b/references/comment-sicko.md <(git -C <clone> show origin/main:pstack/agents/comment-sicko.md) references/comment-sicko.md`.
   Set "Base" and "Checked up to" to the new upstream SHA and date, and empty "Upstream changes not applied".
