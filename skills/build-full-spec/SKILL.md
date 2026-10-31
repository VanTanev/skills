---
name: build-full-spec
description: "Implement the result of /to-spec and /to-tickets unattended, up to a PR that is ready to merge, and hand it off without a merge."
disable-model-invocation: true
metadata:
  opencode/autoinvoke: false
---

The user is not watching this run.
Do the whole spec on your own, up to a PR that passes the **readiness gate**, then hand it off.
Reach the user only with a question from "Decisions and questions", or at the **handoff**.

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

The goal is the entire spec implemented on a single **integration branch**, with one PR for the branch that passes the **readiness gate**.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Start every subagent with a fresh context window.

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

## Permissions

This run gives you and your subagents permission to:

- commit, push, rebase, and fix conflicts on the integration branch and the ticket branches, and force-push them with `--force-with-lease`;
- use the test methods that **proof** needs without asking first.

The merge is the user's.
Leave the PR open and unmerged: no merge, auto-merge, merge queue, push to the default branch, or bypass of branch protection.
If the repository can merge the PR without the user, turn that off for this PR, check again before each push, and report it.

The test permission replaces each project rule that says to ask before a test method, or to leave testing to the user: computer use, browser automation, simulators and devices, the app or a dev server, screenshots.
Rules about how to test still apply.
It covers only the tests that this spec needs, it does not cover the actions that "Decisions and questions" lists, and it does not bypass a harness approval prompt.

## Decisions and questions

Decide each reversible detail yourself and keep going: a name, a file layout, the order of tickets, a rebase conflict, or which review finding to fix and how.
Record each decision and its reason on the ticket it belongs to.

Ask the user only when you cannot continue alone:

- an irreversible action, or an action outside the permissions: deleting data, touching production, changing things outside the repository, closing a PR, or force-pushing another branch;
- a change of scope or goal, or an implementer question whose readings lead to materially different work;
- a change that you cannot prove;
- a readiness gate that cannot pass, and that you cannot fix;
- another PR that makes this one obsolete.

Ask with the harness's question tool, so the thread shows that it waits: `AskUserQuestion` in Claude Code, `request_user_input` in Codex.
Put all the context in the question: the PR link, what blocks you, and the options with your recommendation first.
If no question tool is available, or it returns no answer, leave the PR open and unmerged, and start the handoff with the question.

## Steps

1. Read the spec and tickets to understand the task graph.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets - relevant codebase files or external documentation. Ensure the exploration subagent can save files - it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the integration branch.

4. Use a fresh **implementer subagent** for each ticket, each in its own worktree on its own branch. Each implementer subagent:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - calls the Skill tool with `risk-first` to build the ticket;
   - rebases its branch onto the integration branch tip before reporting done with the **account** from `risk-first`.

5. Once an **implementer subagent** completes, land its work on the integration branch with a **merger subagent**: rebase onto the tip if it moved, then fast-forward. If the implementer reports a question instead, decide it yourself or ask the user, by the rules above, and send the answer to that same subagent.

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

10. Give a single fresh **implementer subagent** the spec, the base branch, and each ticket's **account**.
    It calls the Skill tool with `sol-loop` on the integration branch, with the base branch as the base and the spec as the intent, and reports the `sol-loop` report.
    When the loop ends with a disputed finding, decide it yourself, by the rules above.

11. Call the Skill tool with `unslop`.
    Rebase the integration branch into small, ordered commits that tell the story: fold a fix into the commit it corrects, and keep a separable change as its own commit.
    Write each commit message in the repository's style, by the `unslop` rules.
    Run the repository's required checks on the branch tip.

12. Clean up all **implementer subagent** worktrees.

13. Read `references/visual-pr.md` in this skill's folder and follow it for the integration branch, to open the PR ready for review.
    In that file, `{SKILLBASE}` is this skill's folder.
    If the issue tracker closes work through PRs, put a closing line for the spec and for each ticket, such as `Closes #12`, in the header of the PR body.
    Otherwise, when the PR exists, resolve each ticket the way the issue tracker closes work.
    Add one short line that says how you proved the change, and the `Reviewed with sol-loop` line from the step 10 report.

14. Call the Skill tool with `babysit-pr` for the PR.
    Fix each real finding and CI failure with the smallest change that removes it, and get proof for each fix before you push it.
    Continue until the readiness gate passes, or until only a question from "Decisions and questions" remains.

15. Hand off, as in "Handoff".

Stay active from step 1 to the handoff.
A turn that ends while checks or reviews are pending stops the work, because nobody prompts you again.
Wait with the watcher from `babysit-pr`, so that a change on the PR wakes you.

## Proof

Proof is evidence that you or a subagent observed in this run: command output, a reproduction, a screenshot.
Use the most direct proof that the change allows:

- Reproduce the original failure, apply the fix, then watch the same reproduction pass.
- Run the checks that the repository's CI runs.
- For UI and runtime behavior, run the app and look at the change.
  Green mocked tests do not prove that the user experience works.
  Attach screenshots to the PR when they help and you can upload them.

## Readiness gate

The PR passes the readiness gate when all of these are true on its latest commit:

- Proof covers every change in the diff.
- Required checks are green.
- Review bots have finished, and each finding is fixed or dismissed with a written reason.
  You can dismiss an automated review that asks for human review when your proof covers the change.
- No human review requests changes.
- The branch is up to date with the base branch, and GitHub reports the PR as mergeable.
- The PR is open, not a draft, and nothing merges it without the user.

## Handoff

Fetch the base branch, and read the live PR: its head, base, checks, reviews, and mergeability.
If someone else merged it, report that.
Give the PR one verdict:

- **Ready to merge:** the readiness gate passes.
- **Waiting for required approval:** only a human approval remains. Confirm that this is the actual blocker.
- **Blocked:** what prevents readiness, what you tried, and what is needed. Ask with the question tool, as in "Decisions and questions".

In T3 Code, call `unwatch_pull_request` before the handoff or a question.

The handoff is one final message with the PR link, its final head, the verdict, the proof, the reviewer outcome, each ticket's **account** and decisions, the `no-comments` report, the `sol-loop` report, the account of the step 9 fixes (every gap and unconfirmed assumption), and the remaining risks.
State that the PR is still open and unmerged.
