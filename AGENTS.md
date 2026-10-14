# Skills repo

Each skill is a folder `skills/<name>/` with a `SKILL.md` and an `agents/openai.yaml`.
The [skills](https://github.com/vercel-labs/skills) CLI installs them.
This repo has no Claude Code plugin and no marketplace.

## Invocation

Each skill is user-invoked or model-invoked.
Keep all markers of a skill in agreement.

A user-invoked skill has three markers:

- `disable-model-invocation: true` in the `SKILL.md` frontmatter, for Claude Code and Cursor.
- `metadata.opencode/autoinvoke: false` in the `SKILL.md` frontmatter, for OpenCode.
- `policy.allow_implicit_invocation: false` in `agents/openai.yaml`, for Codex.

Its `description` is for a person who reads a list of commands: one line, with no trigger phrases.

A model-invoked skill has none of these markers.
Its `description` is for the model, and says when to use the skill.

Every `agents/openai.yaml` has `interface.display_name` and `interface.short_description`.

A skill starts another skill with "Call the Skill tool with `<name>`", one skill for each call.
Only a model-invoked skill can be started this way.
For a user-invoked skill, tell the user to type it.

## README

`README.md` has one section for each skill, under **User-invoked** or **Model-invoked**.
A section has a short description, the `npx skills@latest add` command, and the invoke line.
The command also installs each skill that the skill calls from this repo.
The README tells the user to install all of Matt Pocock's skills first, so the command does not install them.
When you add, rename, or change a skill, update its section.

## Upstream copies

A skill with an `UPSTREAM.md` is a changed copy of another project's skill.
Keep its `LICENSE` file.
When you change the skill, update the list of local changes and the diff in `UPSTREAM.md`.

Each `UPSTREAM.md` has one fenced `upstream` block: `repo`, `branch`, `checked` (the "Checked up to" SHA), one `path` line for each upstream file or directory, and an optional `pr: <number> <head SHA>`.
When you change "Checked up to" or the tracked PR head, change the block too.
`scripts/upstream-drift.sh` reads only this block. A weekly workflow runs it and keeps one issue, labeled `upstream-drift`, with each new upstream commit on a tracked path.

A copy can depend on a skill from its source that this repo does not have.
Write the rule inline when the copy needs only one sentence of it.
When the copy needs the whole text, copy that skill's `SKILL.md`, frontmatter included, to a file in `references/`, and point to it as `{SKILLBASE}/references/<file>.md`.
This also works when the source skill is user-invoked, because the copy reads a file and does not start a skill.
Record each reference file in `UPSTREAM.md`, with its upstream path, base, and diff.

## Agent skills

### Issue tracker

GitHub Issues on `VanTanev/skills`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default five labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context. See `docs/agents/domain.md`.
