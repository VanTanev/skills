---
name: build-spec
description: "Implement the result of /to-spec and /to-tickets in code, building each ticket risk-first."
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

The goal is the entire spec implemented on a single **integration branch**, with every ticket resolved the way the issue tracker closes work.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

Decide each reversible detail yourself and keep going: a name, a file layout, the order of tickets, a rebase conflict, or which review finding to fix and how.
Record each decision and its reason on the ticket it belongs to.
Stop and ask the user only for an irreversible action, a change of scope or goal, or an implementer question whose readings lead to materially different work.

## Steps

1. Read the spec and tickets to understand the task graph.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets - relevant codebase files or external documentation. Ensure the exploration subagent can save files - it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the integration branch. If the issue tracker closes work through PRs, or the user asks for one, open a draft PR after step 5 lands the first ticket (a branch with no commits ahead of main can't open one), marked as closing the spec and tickets.

4. Use **implementer subagents** to implement each ticket, each in its own worktree on its own branch. Each implementer subagent:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - calls the Skill tool with `risk-first` to build the ticket;
   - rebases its branch onto the integration branch tip before reporting done with the **account** from `risk-first`.

5. Once an **implementer subagent** completes, land its work on the integration branch with a **merger subagent**: rebase onto the tip if it moved, then fast-forward. If the implementer reports a question instead, decide it yourself or ask the user, by the rule above, and send the answer to that same subagent.

6. If this changes the **frontier** of available tickets, kick off more **implementer subagents** to work on the new tickets. This allows for maximum concurrency.

7. Once all tickets are complete, call the Skill tool with `code-review` on the integration branch. Fix all issues raised by the code review in a single **implementer subagent**.

8. If a draft PR exists, mark it ready for review. Otherwise, resolve each ticket the way the issue tracker closes work, and report the integration branch. Report each ticket's **account** and decisions, and the account of the step 7 fixes: every gap and unconfirmed assumption.

9. Clean up all **implementer subagent** worktrees.
