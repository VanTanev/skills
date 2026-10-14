---
name: ketchup
description: "Catch the user up on what changed in this chat since their last message, in a few plain sentences. Give each action item just enough context to make the call."
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Ketchup

Catch the user up on what changed in this chat since the last message they wrote before `/ketchup`. Notifications and subagent results are not their messages. Assume the user remembers their last message and nothing after it.

Use a plain voice: plain words, short sentences, no jargon, like one person catching up another. Say what changed for the user, not how you did it. Say "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless the user needs one to act. Call each PR, branch, or agent by a name the user would know, not by a label you invented. If a fact needs context to make sense, give the context or leave the fact out.

## Gather what changed

Keep this turn read-only: do not change code, start an app or a job, or post anything. Collect your own work since that message, reports from subagents, and messages from anyone else in this chat. Check the current state of each PR, CI run, or agent this chat touched. Check each number you will show against the facts it comes from, and say so when you correct one.

An action item is a decision or step only the user can take, such as a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item. Never make up a call to fill the reply. A step the user did not ask for and the work does not need is not an action item, unless it is irreversible and waiting on the user: give it one action line, no table, and skip what happens if the user does not answer.

## Write the reply

Keep the whole reply well under 150 words, counting the words inside lists and tables. Never give one fact twice. Leave out work that changed nothing for the user. When words run short, cut from what happened before you cut from the action items.

Open with one sentence that says how many things need the user, or that nothing does. If nothing happened and nothing waits on the user, say so and stop.

Then show what happened as a list of at most four items. Give each thing the user asked for an item that says what came of it and whether it is done, still running, failed, or not checked. Write each item the way you would say it out loud: "Search was slow from a missing index", not "Search review: done" or "Slow search: missing index". Name any bug found and fixed on the way. Each item must stay true when read alone. Never mark something done that still waits on the user. Under the list, give at most three short lines that change what the user knows or must do. Then name in one line any work left that you can do yourself.

Then give each action item two lines, or one for an unasked irreversible step: the decision with your recommendation and why, then what happens if the user does not answer. Ask the call the user owns, such as merge, approve, or pick. A step you would take first goes in your recommendation. So does anything that must happen first, and anything that cannot be undone. Write "unknown" for a part you do not know. Link to the detail.

Show each action item as a before and after, side by side, in a small table. For a choice, put the current state beside each option, or the options alone when there is no current state. Put every option the work weighed in the table, each with what it gets the user and what it costs. Keep them out of the text. Skip the table only for access requests and unasked irreversible steps.

## Lists, tables, and screenshots

The reply goes to a terminal, so use only Markdown lists and small tables. Keep each table small enough to read at a glance: at most six cells, with at most eight words in each, not counting "No screenshot yet." Write labels as plain words a person would say, not tags like "Tests: pass". Group small items together. A fact that needs a sentence belongs in the text, or nowhere.

Link screenshots or a video when the change is visible. If a visible change has none, mark the item it belongs to "No screenshot yet," and say in a line under the list what changed on screen. Never invent a number, and never generate a picture of a screen you did not capture. Link only artifacts that exist.
