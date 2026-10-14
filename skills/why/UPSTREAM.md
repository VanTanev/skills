# Upstream

This skill is a vendored copy of `why` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/why/`.
- Base: `ce649c03ac3b75b6ae80cbd15b7e2c536caedb5a` (2026-10-14, "feat(pstack): match subagent effort to the job, drop Graphite from orchestrate, and cut playbooks to principles (#613)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `1e5c90a4b6f249917bd21fe361b3a2a7deb741b8` (upstream `main`, 2026-10-14).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

```upstream
repo: cursor/plugins
branch: main
checked: 1e5c90a4b6f249917bd21fe361b3a2a7deb741b8
path: pstack/skills/why/
path: pstack/LICENSE
```

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the trigger phrases and "Use how for runtime behavior." are removed, because model invocation is off and this repo does not vendor `how`.
  The description starts with what the skill does.
- `how`: the sentence about the companion `how` skill is removed.
- Models: the paragraph that reads the models from `pstack-models.mdc`, and the model defaults in steps 3 and 4, are removed.
  Each agent uses its own subagent models.
- Effort: investigators run two steps below the agent's own effort, and the synthesizer one step below.
  These are the rules for routine work and for judgment work in the Subagents section of `poteto-mode`, which upstream points to.
  This repo does not vendor `poteto-mode`.
- Subagent mode: "Every spawn is `generalPurpose` with `readonly: false` (agent mode). **Do not use readonly/Ask mode.**" becomes "Every spawn is a general-purpose subagent that can call your MCP tools."
  The Cursor read-only mode removes MCP access.
  The rule stays, without the Cursor names.
- Discovery: the Cursor `mcps/` directory and available-tools map become "the MCP servers whose tools you can call", including tools that the agent lists by name only and loads on demand, as Claude Code does.
  A server that offers only an authentication tool is not available, and is a gap.
- MCPs for more than one category: "If an MCP could fit more than one category, choose the one matching its primary evidence." becomes "map it to each category it serves".
  One server can hold both tickets and docs, for example Jira and Confluence.
  With the upstream rule, such a server covers only one category, and the other category reports no source.
  "Map each available MCP to one evidence category" becomes "to an evidence category", to agree.
- `references/`: equal to upstream, including `sources/slack.md`, which numbers its steps 1, 3, 4 since upstream https://github.com/cursor/plugins/pull/571.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,16 +1,18 @@
 ---
 name: why
-description: "Use for 'why does X work this way', 'why we picked Y', design rationale, regressions, postmortems, or data-backed thresholds. Discovers available MCPs and queries each evidence category (source control, issue tracker, long-form docs, real-time chat, infrastructure observability, error tracking, product analytics warehouse) in parallel, then returns a cited read on decisions and tradeoffs. Use how for runtime behavior."
+description: "Find why code has its shape. Queries git and each available evidence source (issue tracker, long-form docs, real-time chat, infrastructure observability, error tracking, product analytics warehouse) in parallel, then returns a cited read on decisions and tradeoffs."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Why
 
-Investigate the motivation and intent behind code. The companion `how` skill answers what the code does and how it works. `why` answers what forces led to its shape.
+Investigate the motivation and intent behind code. `why` answers what forces led to its shape.
 
-Each spawn below names a role line in the `pstack-models.mdc` rule and a default. Set `model` to that line's value, or to the default if the rule or the line is missing. Leave `model` unset when the value is `auto` or `inherit-parent`. If the Task tool rejects a slug, use the default and say so. If it rejects the default, use the closest valid slug of the same family from its error message. Pick each subagent's reasoning level and fast or standard speed for the job, per the Subagents section of the **poteto-mode** skill.
+Set each investigator's effort two steps below your own, and the synthesizer's effort one step below your own. If you do not know your effort, do not set it.
 
-Every spawn is `generalPurpose` with `readonly: false` (agent mode). **Do not use readonly/Ask mode.** It strips MCP access, which disables the MCP-backed investigators and the synthesizer's citation spot-checks. Investigators still shouldn't write anything.
+Every spawn is a general-purpose subagent that can call your MCP tools. Without them, the MCP-backed investigators and the synthesizer's citation spot-checks do not work. Investigators still shouldn't write anything.
 
 ## Operating Posture
 
@@ -32,9 +34,9 @@
 
 ### Discovery
 
-Before spawning investigators, list the available MCPs from the Cursor environment. Use the available-tools map when present. Otherwise inspect the `mcps/` directory Cursor exposes for enabled MCP servers.
+Before spawning investigators, list the MCP servers whose tools you can call, including tools your agent lists by name only and loads on demand. A server that offers only an authentication tool is not available: record it as a gap.
 
-Map each available MCP to one evidence category:
+Map each available MCP to an evidence category:
 
 1. Source control history
 2. Issue / ticket tracker
@@ -44,9 +46,9 @@
 6. Error / exception tracking
 7. Product analytics warehouse
 
-Source control is always available through git and `gh`. For the other six, classify using the MCP name, server instructions, tool names, and resource descriptors. If an MCP could fit more than one category, choose the one matching its primary evidence. Record ambiguous cases in the coverage map.
+Source control is always available through git and `gh`. For the other six, classify using the MCP name, server instructions, tool names, and resource descriptors. If one MCP serves more than one category, such as one server for both tickets and docs, map it to each category it serves. Record ambiguous cases in the coverage map.
 
-Spawn one investigator per category that has a matching MCP, all in a single message so they run concurrently, each owning exactly one tool or MCP. Don't ask one agent to cover multiple MCPs. `model`: the `why investigators` line, default `grok-4.7-xhigh-fast`.
+Spawn one investigator per category that has a matching MCP, all in a single message so they run concurrently, each owning exactly one tool or MCP. Don't ask one agent to cover multiple MCPs.
 
 Each investigator's prompt is `references/investigator-prompt.md` filled in, plus:
 - the category playbook `references/sources/<source>.md` for the selected MCP, adapted from the examples in `references/source-playbook.md`
@@ -76,7 +78,7 @@
 
 ## Step 4. Synthesize
 
-Spawn one synthesizer. `model`: the `why synthesizer` line, default `claude-opus-5-5-xhigh`. It gets:
+Spawn one synthesizer. It gets:
 1. The investigator findings, including any null results and any categories skipped with justification
 2. The code anchor
 3. The user's original question
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/why/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/why/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
