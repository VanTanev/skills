# Upstream

This skill is a vendored copy of `blast-radius` from the Cursor pstack plugin, with the `unslop` skill as a reference.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Paths:
  - `pstack/skills/blast-radius/SKILL.md`, which is `SKILL.md` here.
  - `pstack/skills/unslop/SKILL.md`, which is `references/unslop.md` here.
- Base of `SKILL.md`: `df581122cde17e6e27686b5a448bde23e4ad4318` (2026-10-05, "feat(pstack): drop Sol, default to Opus xhigh and Grok (#511)").
- Base of `references/unslop.md`: `bc697d0a5a163cec979e362b601e36f5616083fd` (2026-10-11, "fix(pstack): drop "Must always apply." from unslop description (#572)").
  The files here are equal to upstream at these commits, except for the local changes below.
- Checked up to: `9580c23696ac8d7abed0c166f2f9918800afb819` (upstream `main`, 2026-10-23).
  Upstream has no changes to either file between its base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the trigger phrases are removed, because model invocation is off.
  The body keeps its "Use for" line, which gives the scope of the command.
- `how`: removed from the companion line, because this repo does not vendor `how`.
- `why`: step 1 gives the git and `gh` commands from step 2 of `why` in place of "Use `why` step 2", because `why` is user-invoked, and another skill cannot start it.
  "Same rules as `why`." is removed from step 4, because the rules follow in the same step.
- `arena`: step 6 asks a model of another family through its CLI, read-only, with the same commands as `interrogate`, because this repo does not vendor `arena`.
- `unslop`: "Write it through `unslop`" becomes "Write it through `unslop` in `{SKILLBASE}/references/unslop.md`".
  `unslop` is user-invoked, and another skill cannot start it, so `references/unslop.md` is a byte copy of the upstream skill, with its frontmatter.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy.
`references/unslop.md` is equal to upstream, so it has no diff.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,14 +1,16 @@
 ---
 name: blast-radius
-description: "Find what a change could break somewhere else before it ships, beyond the diff, and prove the one fact it's safe because of by running real code instead of writing it up. Use for 'blast radius of X', 'what could this break', or reviewing a small diff you don't trust."
+description: "Find what a change could break somewhere else before it ships, beyond the diff, and prove the one fact it's safe because of by running real code instead of writing it up."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Blast radius
 
 Find what a change breaks somewhere else, before it ships. Use for "blast radius of X", "what could this break", or reviewing a small diff you don't trust yet.
 
-Companion to `how` and `why`. `how` tells you what the code does. `why` tells you why it's shaped that way. Blast radius tells you what it breaks somewhere else.
+Companion to `why`. `why` tells you why the code is shaped that way. Blast radius tells you what it breaks somewhere else.
 
 Listing the callers is not the job. The agent can grep those in a second. The job is the breakage grep won't show you.
 
@@ -30,12 +32,12 @@
 
 ## Steps
 
-1. Read the change. The diff, the symbols it adds, changes, and deletes, and what it now does differently, including the part the diff doesn't spell out. Use `why` step 2 to pull the PR and commits.
+1. Read the change. The diff, the symbols it adds, changes, and deletes, and what it now does differently, including the part the diff doesn't spell out. Pull the commits and the PR: `git blame -L <start>,<end> <file>`, `git log --follow --oneline -- <file>`, `git log -1 --format=%B <commit>` for the PR number, then `gh pr view <number> --json title,body,comments,reviews`.
 2. Find the one fact it's safe because of. Most changes that look risky are safe because of a single fact, like "this call only drops already-dead cache entries and does nothing else". Find that fact. If it holds, most risky cases are cleared at once. Spend your time here, not on a long list of maybes.
 3. Look where grep stops. Read the source of the library you call, and check its pinned version and any local patch. Work out when things run: microtasks, unmount and teardown, Solid versus React. Follow what a symbol search misses: the JSON an API returns, a DB column, a wire format, another language reading the same bytes, a feature flag, code three hops downstream.
-4. Be honest about each risk. Give it a real chance of happening and a real cost if it does. Keep the risks you confirmed. List the ones you checked and cleared separately. Same rules as `why`. Cite a real `file:line`, a search that finds nothing is still an answer, and never make up a caller or an API.
+4. Be honest about each risk. Give it a real chance of happening and a real cost if it does. Keep the risks you confirmed. List the ones you checked and cleared separately. Cite a real `file:line`, a search that finds nothing is still an answer, and never make up a caller or an API.
 5. Prove the one fact. Write a script or test that runs the real code, run it, and paste what happened.
-6. For a big or wide change, run it as an `arena`. Ask more than one model the same question and merge the answers. Different models catch different real bugs.
+6. For a big or wide change, ask a model of another family the same question and merge the answers. Run its CLI read-only: `codex exec -s read-only` if you are a Claude model, `claude -p --permission-mode plan` otherwise. Different models catch different real bugs.
 
 ## What to hand back
 
@@ -45,6 +47,6 @@
 - **Cleared.** What you checked and why it's fine.
 - **Before you merge.** The cheapest test or repro that catches the real bug, including the script you wrote.
 
-Write it through `unslop`, cite real code, and strip anything private before it goes anywhere public.
+Write it through `unslop` in `{SKILLBASE}/references/unslop.md`, cite real code, and strip anything private before it goes anywhere public.
 
 **Reply:** the writeup above, with the one safety fact either proven or marked unproven.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/blast-radius/ pstack/skills/unslop/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/blast-radius/SKILL.md > SKILL.md` and `git -C <clone> show origin/main:pstack/skills/unslop/SKILL.md > references/unslop.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/blast-radius/SKILL.md) SKILL.md`.
   Set both bases and "Checked up to" to the new upstream SHA and date.
