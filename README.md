# Skills

Agent skills that I use every day.
They work in any agent that reads `SKILL.md` files: Claude Code, Codex, OpenCode, Cursor, Copilot, Gemini CLI, and others.

## Install

These skills pair with [Matt Pocock's skills](https://github.com/mattpocock/skills), and some of them call his skills.
Install his skills first:

```bash
npx skills@latest add mattpocock/skills
```

The [skills](https://github.com/vercel-labs/skills) CLI copies the skills into each agent that you select:

```bash
npx skills@latest add VanTanev/skills
```

Add `--global` to install for your user, not for one project.
Add `--skill <name>` to install one skill.
Run `npx skills@latest update` to get the latest version.

To install by hand, copy `skills/<name>/` into `.agents/skills/<name>/`.
Most agents read that directory.
Claude Code reads `.claude/skills/<name>/`, so also link that path to the copy.

## Invocation

A **user-invoked** skill runs only when you type its name as a command, for example `/name` in Claude Code or `$name` in Codex.
The agent cannot start it by itself.

A **model-invoked** skill also runs when the agent finds that the task matches its description.

## User-invoked

### build

Implements a spec or tickets with the `risk-first` skill, then runs `code-review` and fixes its findings.

```bash
npx skills@latest add VanTanev/skills --skill build --skill risk-first
```

Then invoke:

```
/build
```

### build-spec

Implements a whole spec from `/to-spec` and `/to-tickets` on one integration branch.
Implementer subagents build each ready ticket in parallel with the `risk-first` skill.

```bash
npx skills@latest add VanTanev/skills --skill build-spec --skill risk-first
```

Run `/setup-matt-pocock-skills` once in the repo, then invoke:

```
/build-spec
```

### expert-test

Tests each decision against the best expert in its field.
It removes each choice that the expert would reject, and states every trade-off.

```bash
npx skills@latest add VanTanev/skills --skill expert-test
```

Then invoke:

```
/expert-test
```

### sharpen

The agent finds what a top expert would do in the task that you do not ask for: their raw material, their methods and tools, and an outside check that the result is correct.
Then it gives you your prompt again, rewritten to ask for that, and does not do the work.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill sharpen
```

Then invoke, with your task:

```
/sharpen <task>
```

### in-your-own-words

The agent restates your goals and your problem in its own words, so that you can correct it before the work starts.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill in-your-own-words
```

Then invoke:

```
/in-your-own-words
```

### ketchup

Catches you up on what changed in the chat since your last message, in plain words.
It lists every decision that waits on you, each with the agent's pick, the evidence, and the risk, so that you can decide from the reply alone.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill ketchup
```

Then invoke:

```
/ketchup
```

### ketchup-video

Catches you up as `ketchup` does, but shows what happened in a short silent video of slides with subtitles.
The decisions that wait on you are text under the video.
The agent makes and renders the video by itself, for example with `ffmpeg`.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill ketchup-video
```

Then invoke:

```
/ketchup-video
```

### no-comments

Sends a diff to Comment Sicko, a subagent that deletes comments and marks the code that the comments explained.
The skill then fixes that code, and offers to put each "do not remove" rule into a type, test, or lint rule.
Your agent must be able to start subagents.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill no-comments
```

Then invoke:

```
/no-comments main
```

### create-verification-skill

Writes a project skill, `verify-<app>`, that starts your app, uses it the way a user does, and records proof of its behavior.
It also writes a feature map for the app.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill create-verification-skill --skill maintain-verification-skill
```

Then invoke:

```
/create-verification-skill
```

### maintain-verification-skill

Keeps a `verify-<app>` skill and its feature map correct.
Subagents read the source of each feature, one live session uses every feature, and the report is a coverage table.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill maintain-verification-skill
```

Then invoke:

```
/maintain-verification-skill
```

### create-formal-verification-skill

Finds the code where a bug costs the most and tests reach the least, and formally verifies one property of it with the tool that fits, such as TLA+.
Then it writes a project skill that lets the next agent check a change against that property.
For a TLA+ model, the project skill reads each result with the `statechart` skill.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill create-formal-verification-skill --skill maintain-formal-verification-skill --skill statechart
```

Then invoke:

```
/create-formal-verification-skill
```

### maintain-formal-verification-skill

Brings a project's formal verification back in line with the code after changes that did not recheck it.
It reads the commits that touched verified code, updates the model or harness, reruns each check, and says whether each failure is drift in the verification or a bug in the code.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill maintain-formal-verification-skill --skill statechart
```

Then invoke:

```
/maintain-formal-verification-skill
```

### interrogate

Sends adversaries on two model families to break a change or a design, each in its own git worktree.
An adversary reports only a finding that it proved with a run, such as a failing test or a repro script, and the agent reruns each command before it keeps the finding.
Requires the CLI of the other model family: `codex` for a Claude agent, or `claude` for other agents.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill interrogate
```

Then invoke:

```
/interrogate
```

### blast-radius

Finds what a change can break outside the diff: library code at the pinned version, wire formats, DB columns, feature flags, and code three calls away.
It proves the one fact that makes the change safe with a script that runs the real code, or marks the fact unproven.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill blast-radius
```

Then invoke:

```
/blast-radius
```

### why

Finds why code has its current shape.
One subagent searches git and the PRs, and one subagent searches each other source that the agent can reach through MCP: tickets, docs, chat, monitoring, error tracking, and analytics.
The answer keeps what the sources say apart from what the agent infers, and lists what it could not find.
Your agent must be able to start subagents.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill why
```

Then invoke, with your question:

```
/why <question>
```

### correct

Finds the mistakes that agents repeat in a repo, from commits, reverts, review comments, and agent memory.
It makes each mistake impossible at the highest level that works: architecture, then types or a lint, then a test, and docs last.
It proves that each new check fails on a real past mistake, and keeps a rule table in `docs/agents/corrections.md`.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill correct
```

Then invoke:

```
/correct
```

### technical-writing

A layered standard to write and review docs, RFCs, READMEs, PR descriptions, PR reviews, and commit messages.
It picks one Diátaxis mode for each document (tutorial, how-to, reference, or explanation), then applies Google developer style, STE rules, and Global English to each sentence.
Then it applies the `unslop` rules.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill technical-writing
```

Then invoke, with what to write or review:

```
/technical-writing <task>
```

### unslop

A numbered list of AI writing patterns, with the fix for each: filler, AI vocabulary, metaphor nouns, mannered prose, and over-compressed text.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill unslop
```

Then invoke, with the text or file to fix:

```
/unslop <text or file>
```

## Model-invoked

### risk-first

Finds the risks in a change before code: unclear spec lines and likely mistakes.
It settles each risk with an oracle and proves the result with a check that tells the correct behavior apart from the wrong one.

```bash
npx skills@latest add VanTanev/skills --skill risk-first
```

The agent uses it when it implements a spec, ticket, feature, or bug fix.
To start it yourself:

```
/risk-first
```

### bash

Rules to write, review, and debug Bash scripts, with ShellCheck and proof of behavior.
Requires [ShellCheck](https://www.shellcheck.net/) with the `check-extra-masked-returns` optional check.

```bash
npx skills@latest add VanTanev/skills --skill bash
```

The agent uses it when it works on a Bash script.
To start it yourself:

```
/bash
```

### benchmark-checklist

Checks a measured number before the agent reports it or acts on it: a speedup, a regression, or an eval score such as precision and recall.
Before the run, it asks which result would change a decision.
After the run, it asks what limits the number, whether both sides were tuned, whether errors or skipped work explain it, and whether it repeats.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill benchmark-checklist
```

The agent uses it when it runs a benchmark or reports a measured number.
To start it yourself:

```
/benchmark-checklist
```

### hillclimb

Improves one measured number in a loop: one change, one measurement, keep or revert.
It freezes a measurement harness, logs each attempt, and scores a held-out test set one time at the end, so the loop does not fit the data it tunes on.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) playbook (MIT).

```bash
npx skills@latest add VanTanev/skills --skill hillclimb --skill benchmark-checklist
```

The agent uses it when a metric must improve over many attempts, or when a matcher or ranker needs tuning.
To start it yourself:

```
/hillclimb
```

### statechart

Checks a TLA+ model with TLC and draws it as a Mermaid statechart, in the words of the person who reads it.
The report gives the shortest path to each state that breaks a rule.
It needs Node 22.18 or later, Bun, or Deno.
The first run installs TLC and Java with [mise](https://mise.jdx.dev).
Without mise, set `TLA2TOOLS` to the path of `tla2tools.jar` and `JAVA` to Java 11 or later.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill statechart
```

The agent uses it when it checks a TLA+ model or reads its result.
To start it yourself:

```
/statechart
```

### writing-for-people

The model-invoked form of `technical-writing`, for text that people read outside the chat: PR bodies, PR reviews and replies, issues, commit messages, Jira tickets, and docs.
It applies the same layers, checks the text against each `unslop` pattern, then runs a script that finds the faults that a pattern can find.
The script reports Markdown that renders wrong as an error, and every other finding as a suggestion that the agent applies or keeps on purpose.
With `--markdown`, the script also finds Markdown that renders wrong and line breaks inside a sentence.
With `--changed`, it reports only the lines that differ from git `HEAD`, so an edit to an old doc does not rewrite lines that the task did not touch.
Requires Python 3.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill writing-for-people
```

The agent uses it before it writes or edits any of these texts.
To start it yourself:

```
/writing-for-people <task>
```

## License

[MIT](LICENSE), except for the skills that have an `UPSTREAM.md` file.
These skills are changed copies of skills from [cursor/plugins](https://github.com/cursor/plugins), under the MIT license in their own `LICENSE` file.
Their `UPSTREAM.md` file records the upstream version and each change.
