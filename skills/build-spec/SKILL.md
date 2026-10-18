---
name: build-spec
description: "Implement the result of /to-spec and /to-tickets risk-first with less code, review and cut the diff, and open the PR with visual-pr."
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

The goal is the entire spec implemented on a single **integration branch**, with every ticket resolved the way the issue tracker closes work, and one PR for the branch.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.
A brief to an implementer names no tests, inputs, or standards files: `risk-first` chooses the checks, and `code-review` applies the standards.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

Decide each reversible detail yourself and keep going: a name, a file layout, the order of tickets, a rebase conflict, or which review finding to fix and how.
Record each decision and its reason on the ticket it belongs to.
Stop and ask the user only for an irreversible action, a change of scope or goal, or an implementer question whose readings lead to materially different work.

## Steps

1. Read the spec and tickets to understand the task graph.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets - relevant codebase files or external documentation. Ensure the exploration subagent can save files - it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the integration branch.

4. Use **implementer subagents** to implement each ticket, each in its own worktree on its own branch. Each implementer subagent:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - calls the Skill tool with `risk-first`, and calls the Skill tool with `less-code`;
   - builds the ticket by both skills, until it works and the repository's required checks pass;
   - for a `risk-first` question whose readings lead to materially different work, stops before it writes code, and reports the question with its readings;
   - rebases its branch onto the integration branch tip before reporting done with the **account** from `risk-first` and the report from `less-code`.

5. Once an **implementer subagent** completes, land its work on the integration branch with a **merger subagent**: rebase onto the tip if it moved, then fast-forward. If the implementer reports a question instead, decide it yourself or ask the user, by the rule above, and send the answer to that same subagent.

6. If this changes the **frontier** of available tickets, kick off more **implementer subagents** to work on the new tickets. This allows for maximum concurrency.

7. Once all tickets are complete, read `{SKILLBASE}/references/no-comments.md` and follow it on the integration branch, with the base branch as the fixed point.
   Its `references/comment-sicko.md` is `{SKILLBASE}/references/comment-sicko.md`.
   You are its caller: approve or decline each encoding offer yourself.
   If it fails, report it open and continue.

8. Call the Skill tool with `code-review` on the integration branch.
   Give its findings, the whole integration diff against the base branch, and each ticket's **account** to a single **implementer subagent**.
   It calls the Skill tool with `risk-first`, and calls the Skill tool with `less-code`.
   It fixes each defect and spec gap, and each other finding that the `less-code` Plan allows.
   Then it does the `less-code` Cut on the whole integration diff, with the accounts as the record of what each hunk serves.
   Tickets built in parallel repeat each other: two helpers or two tests for one behavior, or an old path that a later ticket replaced.

9. Call the Skill tool with `unslop`.
   Rebase the integration branch into small, ordered commits that tell the story: fold a fix into the commit it corrects, and keep a separable change as its own commit.
   Write each commit message in the repository's style, by the `unslop` rules.
   Run the repository's required checks on the branch tip.

10. Clean up all **implementer subagent** worktrees.

11. Read `{SKILLBASE}/references/visual-pr.md` and follow it for the integration branch.
    If the issue tracker closes work through PRs, put a closing line for the spec and for each ticket, such as `Closes #12`, in the header of the PR body.
    Otherwise, when the PR exists, resolve each ticket the way the issue tracker closes work.
    In the final answer, also report each ticket's **account** and decisions, the `no-comments` report, and the account of the step 8 fixes: every gap and unconfirmed assumption.
