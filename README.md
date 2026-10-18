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

Implements a spec or tickets with the `risk-first` skill, then runs `code-review`.
It fixes each defect with the smallest change, and adds a type, helper, or layer only when the fix removes as much code as it adds.

```bash
npx skills@latest add VanTanev/skills --skill build --skill risk-first
```

Then invoke:

```
/build
```

### build-spec

Implements a whole spec from `/to-spec` and `/to-tickets` on one integration branch, and opens the PR.
Implementer subagents build each ready ticket in parallel with the `risk-first` skill.
Then it cuts what the tickets repeat, runs `no-comments`, runs `code-review`, and writes the PR description with `visual-pr`.
It has its own copies of `no-comments` and [HumanLayer](https://github.com/humanlayer/skills)'s `visual-pr` (MIT), so you do not install them.
Requires the GitHub CLI, `gh`.

```bash
npx skills@latest add VanTanev/skills --skill build-spec --skill risk-first --skill unslop
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

Before the work starts, the agent asks how a top expert would do the task, what you really want, and whether the task has too many or too few constraints.
Then it does the work, with one outside check that the result is correct.
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

Catches you up on what changed in the chat since your last message, in less than 150 words.
It lists each decision that waits on you, with a recommendation and what happens if you do not answer.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill ketchup
```

Then invoke:

```
/ketchup
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

### interrogate

Sends a change to two reviewers on different model families, and sorts their findings into Act on, Consider, Noted, and Dismissed.
A map shows where the models agree, because a finding that two models raise on their own is the strongest signal.
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
npx skills@latest add VanTanev/skills --skill blast-radius --skill unslop
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

## Model-invoked

### risk-first

Finds the risks in a change before code: unclear spec lines and likely mistakes.
It settles each risk with an oracle and proves the result with a check that tells the correct behavior apart from the wrong one.
It builds the smallest change: it deletes the old code that the change replaces, adds a guard or a layer only when the work needs it, and cuts the diff before it reports.

```bash
npx skills@latest add VanTanev/skills --skill risk-first
```

The agent uses it when it implements a spec, ticket, feature, or bug fix.
To start it yourself:

```
/risk-first
```

### less-code

Keeps a change to the code that the request needs.
While the agent writes code, it builds only what a caller reads, uses the helpers that the repository has, and deletes the code that the change replaces.
Before it reports, and after a code review, it reverts each hunk that serves no requirement.

```bash
npx skills@latest add VanTanev/skills --skill less-code
```

The agent uses it when it implements a change, and after a code review.
To start it yourself:

```
/less-code
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
It asks what limits the number, whether both sides were tuned, whether errors or skipped work explain it, and whether it repeats.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill benchmark-checklist
```

The agent uses it when it runs a benchmark or reports a measured number.
To start it yourself:

```
/benchmark-checklist
```

### unslop

A numbered list of AI writing patterns, with the fix for each: filler, AI vocabulary, metaphor nouns, mannered prose, and over-compressed text.
Based on the [Cursor pstack](https://github.com/cursor/plugins/tree/main/pstack) skill (MIT).

```bash
npx skills@latest add VanTanev/skills --skill unslop
```

The agent uses it when it writes prose that a person reads, such as a doc, a PR description, or a ticket.
To start it yourself:

```
/unslop
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

## License

[MIT](LICENSE), except for the files that an `UPSTREAM.md` file records.
These files are copies of skills from [cursor/plugins](https://github.com/cursor/plugins) or [humanlayer/skills](https://github.com/humanlayer/skills), under the MIT license in the skill's own `LICENSE` file.
The `UPSTREAM.md` file records the upstream version and each change.
