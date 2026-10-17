---
name: eval
description: "Measure whether a variant of a skill, prompt, or agent document changes what agents do: blind candidates on two model families, one blind judge, and a check of the files each candidate read. Use when such a change needs evidence before it ships, or when asked to eval one."
---

# Eval

**You own the experiment design. Plan, blind, run, synthesize.**

**Non-negotiables for blinding:**

- No `eval`, `test`, `judge`, `experiment`, `rubric`, `score`, `compare`, `benchmark`, `candidate`, or `arena` in any directory, file, or prompt the candidate sees.
- The candidate prompt looks like an organic user request. State the goal, not the meta.
- No chain-eliciting cues. Don't ask the candidate to list which skills, principles, or files they applied. Ask for design notes generally and grade chain-following from code shape, not self-report.
- Sanitize directory and slug names. Use project-shaped names a user might pick.
- Don't tell the candidate other candidates exist.
- The judge can know it's judging but sees outputs by sanitized label only, never by model name.
- Comparing two variants: one judge scores both sets in a single pass on one scale, blind to which set each came from.

**Steps:**

1. **Frame.** State what variant is under test and what behavior counts as success. Write the rubric (3-6 concrete criteria) for the judge only. Hold it back from candidates.
2. **Set up sanitized environments.** Per-candidate working dir with the variant in place. Plant any context an organic task would have: a project skeleton, the skills the candidate would naturally read. Skills go in `.claude/skills/` for Claude and `.agents/skills/` for Codex. Keep transcripts and outputs outside the candidate's dir.
3. **Author one organic prompt.** What a user would type. No leakage of what's being measured.
4. **Spawn N parallel candidates** on different model families, in the background. Each is a fresh CLI process in its own sanitized dir, so it loads only what you planted there, never your own instructions, skills, or memory. A subagent shares yours, so it cannot be a candidate. Same prompt to each.
   - Claude: `claude -p --setting-sources project --output-format json`, with `--permission-mode acceptEdits` and `--allowedTools` for the commands the task needs.
   - Codex: `HOME=<empty dir> CODEX_HOME=~/.codex codex exec --json -s workspace-write -C <dir> -`, with the prompt on stdin and stdout saved as the transcript.

   If a candidate produces no output, go on with N-1 and note the dropout.
5. **Spawn one blinded judge** on a different model family from yours, read-only, after every candidate finishes: `codex exec -s read-only` if you are a Claude model, `claude -p --permission-mode plan` otherwise. Judge sees outputs by sanitized label and the rubric, scores each criterion, and never sees a model name.
6. **Verify the chain from transcripts, not self-report.** Read each candidate's transcript. For Claude it is `~/.claude/projects/<slug>/<session_id>.jsonl`: the slug is the candidate's dir path with each `/` and `.` changed to `-`, and `session_id` is in its JSON output. For Codex it is the saved stdout. Do not glob across `~/.claude/projects/*/`. That crosses workspace boundaries and reads private chats from unrelated projects. Look at which files each candidate actually opened. Grade chain-following from the files it really read plus the shape of the code, never from the candidate's own claims.
7. **Read every candidate output yourself** end to end. Compare to the judge's verdict. Disagreement means a model is biased or the rubric is ambiguous. Synthesize.

**Reply:** variant under test, rubric, per-candidate notes, judge's verdict, your synthesis, and a recommendation for whether to promote the variant.
