# Upstream

This skill is a vendored copy of `ketchup` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/ketchup/`.
- Base: `c86f349b102feb91f1966f8a6a60882a4e601b50` (2026-10-13, "refactor(pstack): make /ketchup read like /bro in 150 words (#609)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `79afd75d5bd51383fbb526b72f36db03180b8301` (upstream `main`, 2026-10-14).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.

```upstream
repo: cursor/plugins
branch: main
checked: 79afd75d5bd51383fbb526b72f36db03180b8301
path: pstack/skills/ketchup/
path: pstack/LICENSE
```

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill in a terminal, without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: "Use for /ketchup." is removed, because model invocation is off.
  "and small visuals" is removed, because the reply has no pictures (see below).
- Voice: "Use [`/bro`](../bro/SKILL.md)'s voice, not its task:" becomes "Use a plain voice:", because this repo does not vendor `bro`.
  The words after the colon already give the voice.
- Visuals: a terminal does not show Mermaid diagrams, and `/visualize` is a Cursor tool.
  So "what happened" is a list of at most four items, and each action item is a small table.
  Upstream says that a Markdown table is not a visual, and this copy uses tables in place of visuals.
  The "Visuals" section becomes "Lists, tables, and screenshots", with the same size limits and the same rules for screenshots and numbers.
  "Make visuals only from what you already have" is removed from the read-only rule, because the reply makes no visuals.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,37 +1,37 @@
 ---
 name: ketchup
-description: "Catch the user up on what changed in this chat since their last message, in a few plain sentences and small visuals. Give each action item just enough context to make the call. Use for /ketchup."
+description: "Catch the user up on what changed in this chat since their last message, in a few plain sentences. Give each action item just enough context to make the call."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Ketchup
 
 Catch the user up on what changed in this chat since the last message they wrote before `/ketchup`. Notifications and subagent results are not their messages. Assume the user remembers their last message and nothing after it.
 
-Use [`/bro`](../bro/SKILL.md)'s voice, not its task: plain words, short sentences, no jargon, like one person catching up another. Say what changed for the user, not how you did it. Say "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless the user needs one to act. Call each PR, branch, or agent by a name the user would know, not by a label you invented. If a fact needs context to make sense, give the context or leave the fact out.
+Use a plain voice: plain words, short sentences, no jargon, like one person catching up another. Say what changed for the user, not how you did it. Say "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless the user needs one to act. Call each PR, branch, or agent by a name the user would know, not by a label you invented. If a fact needs context to make sense, give the context or leave the fact out.
 
 ## Gather what changed
 
-Keep this turn read-only. Make visuals only from what you already have: do not change code, start an app or a job, or post anything. Collect your own work since that message, reports from subagents, and messages from anyone else in this chat. Check the current state of each PR, CI run, or agent this chat touched. Check each number you will show against the facts it comes from, and say so when you correct one.
+Keep this turn read-only: do not change code, start an app or a job, or post anything. Collect your own work since that message, reports from subagents, and messages from anyone else in this chat. Check the current state of each PR, CI run, or agent this chat touched. Check each number you will show against the facts it comes from, and say so when you correct one.
 
-An action item is a decision or step only the user can take, such as a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item. Never make up a call to fill the reply. A step the user did not ask for and the work does not need is not an action item, unless it is irreversible and waiting on the user: give it one action line, no visual, and skip what happens if the user does not answer.
+An action item is a decision or step only the user can take, such as a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item. Never make up a call to fill the reply. A step the user did not ask for and the work does not need is not an action item, unless it is irreversible and waiting on the user: give it one action line, no table, and skip what happens if the user does not answer.
 
 ## Write the reply
 
-Keep the whole reply well under 150 words, counting the words inside visuals and tables. Never give a fact in both the text and a visual. Leave out work that changed nothing for the user. When words run short, cut from what happened before you cut from the action items.
+Keep the whole reply well under 150 words, counting the words inside lists and tables. Never give one fact twice. Leave out work that changed nothing for the user. When words run short, cut from what happened before you cut from the action items.
 
 Open with one sentence that says how many things need the user, or that nothing does. If nothing happened and nothing waits on the user, say so and stop.
 
-Then show what happened in one visual of at most four boxes. Give each thing the user asked for a box that says what came of it and whether it is done, still running, failed, or not checked. Write each box the way you would say it out loud: "Search was slow from a missing index", not "Search review: done" or "Slow search: missing index". Name any bug found and fixed on the way. Each box must stay true when read alone. Never mark something done that still waits on the user. Under the visual, give at most three short lines that change what the user knows or must do. Then name in one line any work left that you can do yourself.
+Then show what happened as a list of at most four items. Give each thing the user asked for an item that says what came of it and whether it is done, still running, failed, or not checked. Write each item the way you would say it out loud: "Search was slow from a missing index", not "Search review: done" or "Slow search: missing index". Name any bug found and fixed on the way. Each item must stay true when read alone. Never mark something done that still waits on the user. Under the list, give at most three short lines that change what the user knows or must do. Then name in one line any work left that you can do yourself.
 
 Then give each action item two lines, or one for an unasked irreversible step: the decision with your recommendation and why, then what happens if the user does not answer. Ask the call the user owns, such as merge, approve, or pick. A step you would take first goes in your recommendation. So does anything that must happen first, and anything that cannot be undone. Write "unknown" for a part you do not know. Link to the detail.
 
-Show each action item as a before and after, side by side, in a visual. For a choice, put the current state beside each option, or the options alone when there is no current state. Put every option the work weighed in the visual, each with what it gets the user and what it costs. Keep them out of the text. Skip the visual only for access requests and unasked irreversible steps.
+Show each action item as a before and after, side by side, in a small table. For a choice, put the current state beside each option, or the options alone when there is no current state. Put every option the work weighed in the table, each with what it gets the user and what it costs. Keep them out of the text. Skip the table only for access requests and unasked irreversible steps.
 
-## Visuals
+## Lists, tables, and screenshots
 
-A visual is a picture: a screenshot, a video, a Mermaid diagram, a chart or diagram from `/visualize`, or a generated image. A Markdown table is not a visual, even with before and after columns.
+The reply goes to a terminal, so use only Markdown lists and small tables. Keep each table small enough to read at a glance: at most six cells, with at most eight words in each, not counting "No screenshot yet." Write labels as plain words a person would say, not tags like "Tests: pass". Group small items together. A fact that needs a sentence belongs in the text, or nowhere.
 
-Keep each visual small enough to read at a glance: at most six boxes, with at most eight words in each, not counting "No screenshot yet." Write labels as plain words a person would say, not tags like "Tests: pass". Group small items into one box. A fact that needs a sentence belongs in the text, or nowhere.
-
-Use screenshots or a video when the change is visible. If a visible change has none, mark the box it belongs to "No screenshot yet," and say in a line under the visual what changed on screen. For anything else, draw the visual from facts you have: a Mermaid diagram for states, flows, and structures, and a `/visualize` chart for numbers. Never invent a number, and never draw or generate a picture of a screen you did not capture. Link only artifacts that exist.
+Link screenshots or a video when the change is visible. If a visible change has none, mark the item it belongs to "No screenshot yet," and say in a line under the list what changed on screen. Never invent a number, and never generate a picture of a screen you did not capture. Link only artifacts that exist.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/ketchup/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/ketchup/SKILL.md > SKILL.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/ketchup/SKILL.md) SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
