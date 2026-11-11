---
name: cut-review
description: Four models read a PR or diff and propose cuts and design simplifications against the next scope; you compile one verified review.
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

# Cut review

A **cut review** asks four reviewers, in parallel, two questions about a fixed code state:

- **Cut**: what can go? An item is a cut only when it is _unused now_ AND _outside the horizon_.
- **Simplify**: what design change gives more depth or locality?

The **horizon** is the next scope that the code must serve: a milestone, a spec, or the ticket list that follows this PR.
Code that the horizon needs stays, also when nothing uses it now.

## 1. Pin the subject

1. Use the caller's PR or diff. Otherwise pin the fixed point the caller named (a commit SHA, branch name, tag, `HEAD~5`, etc.); without one, ask in chat.
2. Capture the diff once: `git diff <fixed-point>...<head>` (three-dot, so the comparison is against the merge-base).
   Confirm that both refs resolve (`git rev-parse`) and that the diff is not empty.
   A bad ref fails here. An empty diff stops the review here: tell the user that the diff is empty.
3. Make a detached checkout at the head in your scratchpad: `git worktree add --detach <scratchpad>/snap-<sha8> <head>`.
   Reviewers read this snapshot, so work on the branch can continue.
4. Get the file count and the main areas (top directories by changed lines). Save the PR description to a file.

Done when: the snapshot exists, its diff is not empty, and you have the fixed-point and head SHAs.

## 2. Collect the horizon and the settled list

- **Horizon**: find the scope document (spec, milestone ticket, issue list). Write its path and a 3 to 6 line summary in the brief.
  If you cannot find one, ask the user for it in chat. A cut review with no horizon is only a dead-code search.
- **Settled list**: every decision the reviewers must take as fixed.
  Sources: ADRs in the touched area, the PR description, earlier reviews, and this conversation.
  Write each as one positive fact ("The core reads the Run record").

Done when: the horizon path is known, and each settled item has its source.

## 3. Write the briefs

Fill [`BRIEF.md`](BRIEF.md) once, to `<scratchpad>/cut-review/brief.md`.
Make one copy per reviewer that changes only the report name and the output line.

## 4. Start the reviewers

Default roster, all at `xhigh`. Arguments from the user replace it.

| Letter | Reviewer | How |
| --- | --- | --- |
| F | Fable | Agent tool, `model: fable`, `effort: xhigh`, background |
| O | Opus | Agent tool, `model: opus`, `effort: xhigh`, background |
| S | gpt-6.1-sol | `codex exec -m gpt-6.1-sol -c model_reasoning_effort=xhigh -s read-only --ephemeral -C <snapshot> -o <scratchpad>/cut-review/sol.md - < <brief>`, background Bash |
| A | gpt-6-astra | the same command with `-m gpt-6-astra` and `astra.md` |

Start all four in one response.
Then tell the user, in one line per reviewer, what runs and where its report goes.
The Codex reviewers are background shell commands, not agents, so the user does not see them in the agent list.

Done when: four reviewers run, and the user has the four lines.

## 5. Compile

Wait for all four reports. Read each report in full.
Call the Skill tool with "codebase-design", so you judge the Design items in the same terms as the reviewers.

Each report item has a **source ID**: the reviewer letter and the item id (`F.C1`, `S.D3`, `A.K2`).
Map every source ID to exactly one final item in one bucket.
Several source IDs can map to the same final item: that is how duplicates merge.
Top 5 entries are references to items, not items.

- **Defect** (B): the code does not do what the spec or an ADR says. Confirm it in the code: give the rule, the file:line, and the wrong result.
- **Cut, no decision** (C): unused now, outside the horizon, and the evidence holds. Run the reviewer's search again for each cut of more than ~20 lines.
- **Decision for the user** (Q): a cut or change that touches a settled item, the horizon, or behaviour. Give the options and your recommendation.
- **Design** (D): check the reviewer's interface before and after, the owner of each rule, and the tests at the new interface in the code. Then rank by value.
- **Keep**: unused now, but the horizon needs it. Give the horizon line.
- **Rejected**: the item is wrong or already settled. Give the reason in one line.

Each final item lists its source IDs (`F.C1, S.C4`), file:line, and its gain.
Count the lines of each distinct cut once, so that overlapping items do not add up twice.
End with an **Order of work**: the sequence that you recommend.

Done when: every source ID of the four reports is on exactly one final item.

## 6. Show it

Copy [`page-template.html`](page-template.html) and fill it with the compiled review: one section per bucket, one card or table row per item, in the order of the template.
Keep its styles and classes. The reviewer chips (`r f`, `r o`, `r s`, `r a`) show who proposed each item.
Use real names, file:line and numbers. Show a mechanism as a short `pre` (a call trace or a diff), next to the sentence it proves.
Publish the page as the user's CLAUDE.md says.
Write the header, the reviewer legend and the tiles from the compiled review: the reviewers that ran, what you checked, and the counts.
In chat, give the headline numbers (defects, lines to cut with no decision, lines behind decisions, the design change that most reviewers proposed) and the open questions Q1, Q2, ...
