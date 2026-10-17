# Upstream

This skill is a vendored copy of the `eval` playbook of the `poteto-mode` skill in the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/poteto-mode/playbooks/eval.md`, which is `SKILL.md` here.
- Base: `ce649c03ac3b75b6ae80cbd15b7e2c536caedb5a` (2026-10-14, "feat(pstack): match subagent effort to the job, drop Graphite from orchestrate, and cut playbooks to principles (#613)").
  The file here is equal to upstream at this commit, except for the local changes below.
- Checked up to: `101b274dd991f694e1f7024be2157e5f3adf07de` (upstream `main`, 2026-10-16).
  Upstream has no changes to the file between its base and this commit.

`VanTanev/skills` added the copy on 2026-10-17.

## Local changes

The playbook becomes a skill that Claude Code, OpenCode, and Codex run without the rest of pstack.

- Frontmatter and title: added, because a playbook has none.
  The skill is model-invoked, and its description says when to use it.
- `arena`: steps 4 and 5 give the rules of arena Phases B and C inline, because this repo does not vendor `arena`.
  The Cursor model slugs and the `pstack-models.mdc` rule are removed.
  The other family is Codex for a Claude parent, through its CLI, as in `interrogate`.
- Candidates: step 4 runs each candidate as a fresh `claude -p` or `codex exec` process in its sanitized dir, in place of a `Task` subagent.
  A subagent shares the parent's instructions, skills, and memory, so it sees more than an organic user's agent would.
  `claude -p --setting-sources project` loads only the project's skills and `CLAUDE.md`, and `codex exec` with `HOME` set to an empty folder loads only the project's skills and `AGENTS.md`.
  Step 2 names the skill folder of each CLI, and keeps transcripts and outputs out of the candidate's dir.
  Step 4 turns Codex memories off, because `CODEX_HOME` would carry them into the candidate.
- Subagents: step 4 drops the poteto-mode effort rule.
- Transcripts: step 6 reads the Claude Code session file and the saved Codex `--json` stream, in place of the Cursor `agent-transcripts/` folder.
- `agents/openai.yaml`: added, with `interface` only, because the skill is model-invoked.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff from upstream to this copy.
The `a/SKILL.md` side is upstream `pstack/skills/poteto-mode/playbooks/eval.md`.

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,4 +1,9 @@
-### Eval
+---
+name: eval
+description: "Measure whether a variant of a skill, prompt, or agent document changes what agents do: blind candidates on two model families, one blind judge, and a check of the files each candidate read. Use when such a change needs evidence before it ships, or when asked to eval one."
+---
+
+# Eval
 
 **You own the experiment design. Plan, blind, run, synthesize.**
 
@@ -15,11 +20,15 @@
 **Steps:**
 
 1. **Frame.** State what variant is under test and what behavior counts as success. Write the rubric (3-6 concrete criteria) for the judge only. Hold it back from candidates.
-2. **Set up sanitized environments.** Per-candidate working dir with the variant in place. Plant any context an organic task would have: a project skeleton, the skills the candidate would naturally read.
+2. **Set up sanitized environments.** Per-candidate working dir with the variant in place. Plant any context an organic task would have: a project skeleton, the skills the candidate would naturally read. Skills go in `.claude/skills/` for Claude and `.agents/skills/` for Codex. Keep transcripts and outputs outside the candidate's dir.
 3. **Author one organic prompt.** What a user would type. No leakage of what's being measured.
-4. **Spawn N parallel candidates** on different models per the **arena** skill's Phase B. Each works in its own sanitized dir. Same prompt to each. Pick each subagent's reasoning level and fast or standard speed for the job, per the Subagents section.
-5. **Spawn one blinded judge** on a different model family per the **arena** skill's Phase C. Judge sees outputs by sanitized label and the rubric, never a model name.
-6. **Verify the chain from transcripts, not self-report.** Read each candidate's local transcript under the active workspace's `agent-transcripts/` directory (the system prompt names this path). Do not glob across `~/.cursor/projects/*/`. That crosses workspace boundaries and reads private chats from unrelated projects. Look at which files each candidate actually opened. Grade chain-following from the files it really read plus the shape of the code, never from the candidate's own claims.
+4. **Spawn N parallel candidates** on different model families, in the background. Each is a fresh CLI process in its own sanitized dir, so it loads only what you planted there, never your own instructions, skills, or memory. A subagent shares yours, so it cannot be a candidate. Same prompt to each.
+   - Claude: `claude -p --setting-sources project --output-format json`, with `--permission-mode acceptEdits` and `--allowedTools` for the commands the task needs.
+   - Codex: `HOME=<empty dir> CODEX_HOME=~/.codex codex exec -c features.memories=false --json -s workspace-write -C <dir> -`, with the prompt on stdin and stdout saved as the transcript.
+
+   If a candidate produces no output, go on with N-1 and note the dropout.
+5. **Spawn one blinded judge** on a different model family from yours, read-only, after every candidate finishes: `codex exec -s read-only` if you are a Claude model, `claude -p --permission-mode plan` otherwise. Judge sees outputs by sanitized label and the rubric, scores each criterion, and never sees a model name.
+6. **Verify the chain from transcripts, not self-report.** Read each candidate's transcript. For Claude it is `~/.claude/projects/<slug>/<session_id>.jsonl`: the slug is the candidate's dir path with each `/` and `.` changed to `-`, and `session_id` is in its JSON output. For Codex it is the saved stdout. Do not glob across `~/.claude/projects/*/`. That crosses workspace boundaries and reads private chats from unrelated projects. Look at which files each candidate actually opened. Grade chain-following from the files it really read plus the shape of the code, never from the candidate's own claims.
 7. **Read every candidate output yourself** end to end. Compare to the judge's verdict. Disagreement means a model is biased or the rubric is ambiguous. Synthesize.
 
 **Reply:** variant under test, rubric, per-candidate notes, judge's verdict, your synthesis, and a recommendation for whether to promote the variant.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/poteto-mode/playbooks/eval.md pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/poteto-mode/playbooks/eval.md > SKILL.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/poteto-mode/playbooks/eval.md) SKILL.md`.
   Set the base and "Checked up to" to the new upstream SHA and date.
