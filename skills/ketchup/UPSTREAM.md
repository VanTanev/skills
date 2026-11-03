# Upstream

This skill is a vendored copy of `ketchup` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/ketchup/`.
- Base: `bc1443790cc980d0ea857663260a831299884508` (2026-10-17, "fix(pstack): say outright that ketchup never cuts items to stay under a word count (#708)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `ae5650febf4320793844c12c4adaa937f417f8da` (upstream `main`, 2026-10-31).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-10-14.
The skill was updated to upstream #628, #692, and #708 on 2026-11-03.
`ketchup-video` has a byte copy of this `SKILL.md` in its `references/ketchup.md`, so update both together.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill in a terminal, without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: "Use for /ketchup." is removed, because model invocation is off.
  "and small visuals" is removed, because the reply has no diagrams (see below).
- Voice: "Use [`/bro`](../bro/SKILL.md)'s voice, not its task:" becomes "Use a plain voice:", because this repo does not vendor `bro`.
  The words after the colon already give the voice.
- Visuals: a terminal does not show Mermaid diagrams, and `/visualize` is a Cursor tool.
  So the reply draws no diagrams or charts, and its only pictures are the screenshots and videos the work produced.
  The "Visuals" section becomes "Screenshots and videos": it keeps the rules for screenshots, numbers, and facts given twice, and embeds a picture only when the chat shows images, else links it.
  "what happened, pictures first" becomes "screenshots first", without "then any diagram that explains a change".
  "Make visuals only from what you already have" is removed from the read-only rule, because the reply makes no visuals.
  An unasked irreversible step gets "no picture" in place of "no visual".
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,20 +1,22 @@
 ---
 name: ketchup
-description: "Catch the user up on what changed in this chat since their last message, in plain words and small visuals. List every item waiting on them with what they need to decide it from the reply alone. Use for /ketchup."
+description: "Catch the user up on what changed in this chat since their last message, in plain words. List every item waiting on them with what they need to decide it from the reply alone."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Ketchup
 
 Catch the user up on what changed in this chat since the last message they wrote before `/ketchup`, and help them understand each change, not only where it stands. Then lay out every call waiting on them so they can make it from your reply alone. Notifications and subagent results are not their messages. Assume the user remembers their last message and nothing after it.
 
-Use [`/bro`](../bro/SKILL.md)'s voice, not its task: plain words, short sentences, no jargon, like one person catching up another. Say what changed for the user, not how you did it. Say "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless the user needs one to act. Call each PR, branch, or agent by a name the user would know, not by a label you invented. If a fact needs context to make sense, give the context or leave the fact out.
+Use a plain voice: plain words, short sentences, no jargon, like one person catching up another. Say what changed for the user, not how you did it. Say "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless the user needs one to act. Call each PR, branch, or agent by a name the user would know, not by a label you invented. If a fact needs context to make sense, give the context or leave the fact out.
 
 ## Gather what changed
 
-Keep this turn read-only. Make visuals only from what you already have: do not change code, start an app or a job, or post anything. Collect your own work since that message, reports from subagents, and messages from anyone else in this chat. Check the current state of each PR, CI run, or agent this chat touched. Check each number you will show against the facts it comes from, and say so when you correct one.
+Keep this turn read-only: do not change code, start an app or a job, or post anything. Collect your own work since that message, reports from subagents, and messages from anyone else in this chat. Check the current state of each PR, CI run, or agent this chat touched. Check each number you will show against the facts it comes from, and say so when you correct one.
 
-An action item is a call or step only the user can take, such as a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item. Never make up a call to fill the reply. A step the user did not ask for and the work does not need is not an action item, unless it is irreversible and waiting on the user: give it one line and no visual.
+An action item is a call or step only the user can take, such as a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item. Never make up a call to fill the reply. A step the user did not ask for and the work does not need is not an action item, unless it is irreversible and waiting on the user: give it one line and no picture.
 
 One call can cover many items, such as each PR in a set awaiting merge. For each item, collect its link, what it changes for users, the evidence behind your pick, its risk, and your pick. Write "unknown" for a fact the call needs that you do not know. Leave out a link you do not have.
 
@@ -24,7 +26,7 @@
 
 Open with one short sentence that names what waits on the user, or says nothing does. The action items give the detail. If nothing happened and nothing waits on the user, say so and stop.
 
-Then show what happened, pictures first. Embed inline the screenshots and videos the work produced, then any diagram that explains a change. Then sum up in one short bullet per thing the user asked for: what came of it, and whether it is done, still running, failed, or not checked. Write each line the way you would say it out loud: "Search was slow from a missing index", not "Search review: done" or "Slow search: missing index". Name any bug found and fixed on the way. Each line must stay true when read alone. Never mark something done that still waits on the user, and leave out anything the action items say. Under the summary, give at most three short lines that change what the user knows or must do. Then name in one line any work left that you can do yourself.
+Then show what happened, screenshots first. Show the screenshots and videos the work produced. Then sum up in one short bullet per thing the user asked for: what came of it, and whether it is done, still running, failed, or not checked. Write each line the way you would say it out loud: "Search was slow from a missing index", not "Search review: done" or "Slow search: missing index". Name any bug found and fixed on the way. Each line must stay true when read alone. Never mark something done that still waits on the user, and leave out anything the action items say. Under the summary, give at most three short lines that change what the user knows or must do. Then name in one line any work left that you can do yourself.
 
 Then list the action items. Ask the call the user owns, such as merge, approve, or pick, and give your pick. A step you would take first goes in your pick. So does anything that must happen first, and anything that cannot be undone. Give the number or link of each PR, issue, or agent a call is about, also in a call between options.
 
@@ -32,12 +34,8 @@
 
 For a call between options, give every option the work weighed, each with what it gets the user and what it costs, and the current state when there is one. Those costs are the call's risk, so add no separate risk line. When the screenshots above show the options, write each option's gain and cost under its screenshot.
 
-## Visuals
+## Screenshots and videos
 
-A visual is a picture: a screenshot, a video, a Mermaid diagram, a chart or diagram from `/visualize`, or a generated image. A Markdown table is not a visual, even with before and after columns.
+The reply can go to a terminal, which shows no diagrams or charts, so the pictures are the screenshots and videos the work produced. Never give a fact twice, in text or across pictures.
 
-When something is easier to grasp as a picture than as sentences, draw it: how a design or system works, a PR stack or dependency chain with each PR's state, a before and after of a fix, or options side by side. Never draw a status list, a list of action items, or boxes with nothing connecting them. Never give a fact twice, in text or across visuals.
-
-Keep each visual small enough to read at a glance: at most six boxes, with at most eight words in each. Write labels as plain words a person would say, not tags like "Tests: pass". A fact that needs a sentence belongs in the text, or nowhere.
-
-Embed screenshots and videos inline when the change is visible, not only as links. If a visible change has none, mark its summary line "No screenshot yet," and say there what changed on screen. Draw diagrams and charts from facts you have: a Mermaid diagram for how things connect and a `/visualize` chart for numbers. Never invent a number, and never draw or generate a picture of a screen you did not capture. Link only artifacts that exist.
+Embed screenshots and videos inline when the change is visible and the chat shows images, and link them when it does not. If a visible change has none, mark its summary line "No screenshot yet," and say there what changed on screen. Never invent a number, and never generate a picture of a screen you did not capture. Link only artifacts that exist.
```

## Update procedure

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/ketchup/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `git -C <clone> show origin/main:pstack/skills/ketchup/SKILL.md > SKILL.md`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <(git -C <clone> show origin/main:pstack/skills/ketchup/SKILL.md) SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
5. Update `ketchup-video` by its `UPSTREAM.md`, because its `references/ketchup.md` is a byte copy of this `SKILL.md`.
