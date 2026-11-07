# Upstream

This skill is a vendored copy of `create-formal-verification-skill` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/create-formal-verification-skill/`.
- Base: `34b1b7c96f09f81a21a6c78f65b7833f7dcb5b24` (2026-10-26, "feat(pstack): port the statechart compiler (#977)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `ae5650febf4320793844c12c4adaa937f417f8da` (upstream `main`, 2026-10-31).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-11-03.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the "Use for /create-formal-verification-skill, \"model-check this race\", \"prove this invariant\", or when ..." trigger list becomes "For concurrency, retries, state machines, parsers, or unsafe code that need more than tests."
  Model invocation is off, so trigger phrases for the model contradict the frontmatter.
- Location: the generated skill goes in `.agents/skills/<name>/`, with `.claude/skills/<name>` as a relative symlink to it, as in `create-verification-skill`.
  Upstream names no directory, and `.agents/skills` is the canonical skill directory.
- Frontmatter warning: "Without frontmatter, the skill never registers" becomes "Without a description, agents do not advertise the skill to the model", as in `create-verification-skill`.
- Default tool: "TLA+ is the default" becomes "Quint is the default", with one sentence on what Quint is.
  Quint checks the same logic as TLA+, its syntax is closer to the code that engineers write, and its simulator needs only Node.js.
- Quint check: the paragraph that sends each TLA+ result to the pstack `statechart` skill becomes a paragraph on a Quint check.
  The agent reads `references/quint-lang/quint-lang.md`, copies that reference into the generated skill, pins the Quint version, and picks `quint run` or `quint verify` from the tools that the developers have.
  It says that `--max-steps` bounds only Apalache, because TLC checks every reachable state and runs without end on a model with no limit on its states.
  This repo does not have `statechart`, because it needs a TLA+ model and Java.
- Hand off: "Point the user at `/maintain-formal-verification-skill`" becomes "tell the user to type `/maintain-formal-verification-skill`", because only the user can start a user-invoked skill.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,9 @@
 ---
 name: create-formal-verification-skill
-description: "Generate a project-local skill that formally verifies the code where a bug costs the most and tests reach the least, in any language, with whichever verification tool fits. Use for /create-formal-verification-skill, \"model-check this race\", \"prove this invariant\", or when concurrency, retries, state machines, parsers, or unsafe code need more than tests."
+description: "Generate a project-local skill that formally verifies the code where a bug costs the most and tests reach the least, in any language, with whichever verification tool fits. For concurrency, retries, state machines, parsers, or unsafe code that need more than tests."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Create a formal verification skill
@@ -16,7 +18,7 @@
 
 ## Let the question choose the tool
 
-Pick the tool that answers the question at the lowest cost: a model checker, a proof assistant, an SMT-backed verifier, or another tool. Whether events can happen in a bad order usually suits a model checker over a small model of the design, and TLA+ is the default for that in any language. Whether the code itself behaves for every input, as with memory safety, overflow, or a data-structure invariant, usually suits a verifier that runs on the code. If no verifier runs on this language, say so, and test the real code with generated inputs, not a hand model of the function. A property that must hold at every size, where a bound is not enough, can need a proof. Prefer a tool that the repo's developers can install and run, and tell the user why you chose it.
+Pick the tool that answers the question at the lowest cost: a model checker, a proof assistant, an SMT-backed verifier, or another tool. Whether events can happen in a bad order usually suits a model checker over a small model of the design, and Quint is the default for that in any language. Quint is the logic of TLA+ with a syntax that engineers can read. Whether the code itself behaves for every input, as with memory safety, overflow, or a data-structure invariant, usually suits a verifier that runs on the code. If no verifier runs on this language, say so, and test the real code with generated inputs, not a hand model of the function. A property that must hold at every size, where a bound is not enough, can need a proof. Prefer a tool that the repo's developers can install and run, and tell the user why you chose it.
 
 ## What makes it good
 
@@ -30,9 +32,9 @@
 
 ## Generate the verify skill
 
-Write a project-local skill with frontmatter that names the area and says when to use it. Without frontmatter, the skill never registers. From the skill alone, the next agent must be able to tell whether a change touches the verified code, run the check, tell a real bug from a modeling error, and update the verification when a change is intended. Put the coverage record and the sync commit in the skill, and tell the next agent to move the sync commit forward only after it confirms that the verification describes the code at the new commit. Use this repo's real commands, paths, and nouns, and leave no placeholders.
+Write a project-local skill at `.agents/skills/<name>/SKILL.md`, with frontmatter that names the area and says when to use it. Without a description, agents do not advertise the skill to the model. Create `.claude/skills/<name>` as a relative symlink to `../../.agents/skills/<name>` so both runtimes use the same project-local skill; never maintain a second copy. From the skill alone, the next agent must be able to tell whether a change touches the verified code, run the check, tell a real bug from a modeling error, and update the verification when a change is intended. Put the coverage record and the sync commit in the skill, and tell the next agent to move the sync commit forward only after it confirms that the verification describes the code at the new commit. Use this repo's real commands, paths, and nouns, and leave no placeholders.
 
-If the check is a TLA+ model, tell the next agent to read every result with the pstack [`/statechart`](../statechart/SKILL.md) skill. It shows each invariant violation the checker finds as its shortest path in plain words. When the check passes, `/statechart` draws a chart of how the system moves between states. Refer to `/statechart` by name. Its commands, options, and file paths change between releases and machines, so copy none of them into the generated skill or its scripts.
+If the check is a Quint model, read `references/quint-lang/quint-lang.md` in this skill's folder before you write the model. Copy the `references/quint-lang/` folder, with its `LICENSE`, into the generated skill's folder, so that the next agent can edit the model without this skill. Pin the exact Quint version in the repo, for example as a dev dependency on `@informalsystems/quint`. `quint run --invariant=<name>` needs only Node.js, and when the invariant breaks, it prints the steps that lead to the break. A pass of `quint run` covers only the random runs that it made. `quint verify` needs Java 21 or newer. With Apalache, the default, it checks every state up to `--max-steps`. With `--backend=tlc`, it ignores `--max-steps` and checks every reachable state, so it ends only when the model has a finite number of states. Choose the check that runs on every change from the tools that the developers have, and say which of the two checks a result comes from.
 
 ## Prove it before you hand off
 
@@ -40,4 +42,4 @@
 
 ## Hand off
 
-Tell the user what you verified, which tool you used and why, the bounds, what the check found in plain words, how to run it, and what it does not cover. Suggest a second target only if you found a close one. Point the user at `/maintain-formal-verification-skill` for bringing the verification back in line after changes that did not recheck it.
+Tell the user what you verified, which tool you used and why, the bounds, what the check found in plain words, how to run it, and what it does not cover. Suggest a second target only if you found a close one. For bringing the verification back in line after changes that did not recheck it, tell the user to type `/maintain-formal-verification-skill`.
```

## Reference files

`references/quint-lang/` is a byte copy of the `quint-lang` skill from Quint LLM Kit, with its license.

- Repository: https://github.com/quint-co/quint-llm-kit, branch `main`.
- Path: `quint-llm-kit-plugin/skills/quint-lang/`, which is `references/quint-lang/` here. Its `SKILL.md` is `quint-lang.md` here, so that no agent finds a second skill named `quint-lang` in this folder. Its links to `guidelines/` still work. The repository's `LICENSE` (Apache-2.0) is `references/quint-lang/LICENSE`. The repository has no `NOTICE` file.
- Base: `cc75369f741af7d490936f82002c2d28e3b3d78d` (2026-07-01, "Merge quint skill suite updates onto main (#12)").
- Checked against Quint 0.33.1: each CLI flag in the copy exists. The example modules fail to type-check only on imports of files that the copy does not include, template names, or an empty function body.
  The copy does not say that `quint verify` needs Java 21, or that it takes `--backend=tlc`, so `SKILL.md` in this skill says both where it needs them.

## Update procedure

Update this skill together with `maintain-formal-verification-skill`, because `maintain-formal-verification-skill` maintains the generated skill.

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/create-formal-verification-skill/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md`, `agents/openai.yaml`, and `references/`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/create-formal-verification-skill/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.

To update `references/quint-lang/`, copy `quint-llm-kit-plugin/skills/quint-lang/` and `LICENSE` from https://github.com/quint-co/quint-llm-kit at `main` into `references/quint-lang/` of both `create-formal-verification-skill` and `maintain-formal-verification-skill`.
Rename its `SKILL.md` to `quint-lang.md`. Check each CLI flag in the copy against `quint <command> --help` of the newest Quint release, and set "Base" under "Reference files" in both `UPSTREAM.md` files.
