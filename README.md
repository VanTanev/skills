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

### no-comments

Sends a diff to Comment Sicko, a subagent that deletes comments and marks the code that the comments explained.
The skill then fixes that code, and offers to put each "do not remove" rule into a type, test, or lint rule.
Your agent must be able to start subagents.

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

## License

[MIT](LICENSE), except for `create-verification-skill` and `maintain-verification-skill`.
These two skills are changed copies of skills from [cursor/plugins](https://github.com/cursor/plugins), under the MIT license in their own `LICENSE` file.
Their `UPSTREAM.md` file records the upstream version and each change.
