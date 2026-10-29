---
name: build-spec
description: "Implement the result of /to-spec and /to-tickets risk-first, cut and review the diff, and open the PR with visual-pr."
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

The goal is the entire spec implemented on a single **integration branch**, with every ticket resolved the way the issue tracker closes work, and one PR for the branch.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Start every subagent with a fresh context window.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

Decide each reversible detail yourself and keep going: a name, a file layout, the order of tickets, a rebase conflict, or which review finding to fix and how.
Record each decision and its reason on the ticket it belongs to.
Stop and ask the user only for an irreversible action, a change of scope or goal, or an implementer question whose readings lead to materially different work.

## Steps

1. Read the spec and tickets to understand the task graph.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets - relevant codebase files or external documentation. Ensure the exploration subagent can save files - it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the integration branch.

4. Use a fresh **implementer subagent** for each ticket, each in its own worktree on its own branch. Each implementer subagent:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - calls the Skill tool with `risk-first` to build the ticket;
   - rebases its branch onto the integration branch tip before reporting done with the **account** from `risk-first`.

5. Once an **implementer subagent** completes, land its work on the integration branch with a **merger subagent**: rebase onto the tip if it moved, then fast-forward. If the implementer reports a question instead, decide it yourself or ask the user, by the rule above, and send the answer to that same subagent.

6. If this changes the **frontier** of available tickets, kick off more **implementer subagents** to work on the new tickets. This allows for maximum concurrency.

7. Once all tickets are complete, give a single fresh **implementer subagent** the whole integration diff against the base branch, and each ticket's **account**.
   It calls the Skill tool with `risk-first` and does only its Cut step, with the accounts as the record of what each hunk serves.
   Tickets built in parallel repeat each other: two helpers or two tests for one behavior, or an old path that a later ticket replaced.

8. Read `references/no-comments.md` in this skill's folder and follow it on the integration branch, with the base branch as the fixed point.
   Its `references/comment-sicko.md` is in this skill's folder too.
   You are its caller: approve or decline each encoding offer yourself.
   If it fails, report it open and continue.

9. Call the Skill tool with `code-review` on the integration branch.
   Choose the findings to fix: each defect and spec gap, and a finding that asks for more structure, such as a new type, helper, or layer, only when its fix removes at least as much code or reader effort as it adds.
   Give them to a single fresh **implementer subagent**, to fix each one with the smallest change that removes it, and with a deletion where one works.
   Its Cut step also covers the step 8 changes.

10. Call the Skill tool with `unslop`.
    Rebase the integration branch into small, ordered commits that tell the story: fold a fix into the commit it corrects, and keep a separable change as its own commit.
    Write each commit message in the repository's style, by the `unslop` rules.
    Run the repository's required checks on the branch tip.

11. Clean up all **implementer subagent** worktrees.

12. Read `references/visual-pr.md` in this skill's folder and follow it for the integration branch.
    In that file, `{SKILLBASE}` is this skill's folder.
    If the issue tracker closes work through PRs, put a closing line for the spec and for each ticket, such as `Closes #12`, in the header of the PR body.
    Otherwise, when the PR exists, resolve each ticket the way the issue tracker closes work.
    In the final answer, also report each ticket's **account** and decisions, the `no-comments` report, and the account of the step 9 fixes: every gap and unconfirmed assumption.
