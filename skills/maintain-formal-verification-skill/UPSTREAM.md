# Upstream

This skill is a vendored copy of `maintain-formal-verification-skill` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/maintain-formal-verification-skill/`.
- Base: `7b353f78f6ec193bdbe48ed8059444eb09b6878e` (2026-10-19, "pstack: add maintain-formal-verification-skill (#716)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `ae5650febf4320793844c12c4adaa937f417f8da` (upstream `main`, 2026-10-31).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-11-03.

## Local changes

All changes let Claude Code, OpenCode, and Codex run the skill without the rest of pstack.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the "Use for /maintain-formal-verification-skill, \"is the model still true to the code\", or after merges and refactors ..." trigger list is removed.
  Model invocation is off, so trigger phrases for the model contradict the frontmatter.
- Intro: "a verify skill that `/create-formal-verification-skill` generated" becomes "a verify skill that the `create-formal-verification-skill` skill generated", because agents do not all start skills with a slash command.
- Step 1: the agent looks in `.agents/skills` and `.claude/skills`, where `create-formal-verification-skill` puts the generated skill and its symlink.
  A symlink and its target are one match, and the agent edits the target, as in `maintain-verification-skill`.
- Step 1: "stop and point at `/create-formal-verification-skill`" becomes "stop and tell the user to type `/create-formal-verification-skill`", because only the user can start a user-invoked skill.
- Edit scope: a new sentence tells the agent to read `references/quint-lang/quint-lang.md` before it edits a Quint model, because `create-formal-verification-skill` in this repo makes Quint the default.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,12 +1,14 @@
 ---
 name: maintain-formal-verification-skill
-description: "Bring a project's formal verification back in line with the code after the code changes: find the commits that touched verified code, update the model, harness, or properties to describe the code as it is now, rerun, and say whether each failure is drift in the verification or a bug in the code. Use for /maintain-formal-verification-skill, \"is the model still true to the code\", or after merges and refactors that touched verified code without rechecking it."
+description: "Bring a project's formal verification back in line with the code after the code changes: find the commits that touched verified code, update the model, harness, or properties to describe the code as it is now, rerun, and say whether each failure is drift in the verification or a bug in the code."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Maintain a formal verification skill
 
-A formal check proves a property of what it describes. When the code changes and the verification does not, the check can keep passing while it describes code that no longer exists. That pass is the dangerous case, because it looks like a proof. This skill is the upkeep loop for a verify skill that `/create-formal-verification-skill` generated, or for any project-local skill that runs a model checker, prover, or code-level verifier against named code. The project-local skill handles a change that an agent makes while it uses that skill. This skill handles the changes that skipped it: merges, edits made without the skill, and drift that builds up across many commits.
+A formal check proves a property of what it describes. When the code changes and the verification does not, the check can keep passing while it describes code that no longer exists. That pass is the dangerous case, because it looks like a proof. This skill is the upkeep loop for a verify skill that the `create-formal-verification-skill` skill generated, or for any project-local skill that runs a model checker, prover, or code-level verifier against named code. The project-local skill handles a change that an agent makes while it uses that skill. This skill handles the changes that skipped it: merges, edits made without the skill, and drift that builds up across many commits.
 
 ## Outcomes
 
@@ -21,11 +23,11 @@
 
 ## Edit scope
 
-Edit only the verification: models, harnesses, property files, and the verify skill itself. Never edit product code during a run, unless the user asks you to. When a property fails on the current code, do not weaken the property or the model to make it pass. Report the failure.
+Edit only the verification: models, harnesses, property files, and the verify skill itself. Never edit product code during a run, unless the user asks you to. When a property fails on the current code, do not weaken the property or the model to make it pass. Report the failure. If a check is a Quint model, read `references/quint-lang/quint-lang.md` in this skill's folder before you edit the model.
 
 ## Pass
 
-1. **Find the checks.** A verify skill has no fixed name, so find it by what it does: a project skill that runs a model checker, a prover, or another verifier against named code. Read each one you find, or the one the user named. For each check, collect the property, the code it covers, the bounds and assumptions, the command that runs it, and the commit where it was last confirmed to describe the code. If no verify skill exists, stop and point at `/create-formal-verification-skill`. If the skill does not record a sync commit, use the last commit that changed the verification files, and say that you did.
+1. **Find the checks.** A verify skill has no fixed name, so find it by what it does: a project skill that runs a model checker, a prover, or another verifier against named code. Look in `.agents/skills` and `.claude/skills`. A symlink and its target are one match: edit the target, usually under `.agents/skills`, because the `.claude/skills` entry is only its compatibility symlink. Read each one you find, or the one the user named. For each check, collect the property, the code it covers, the bounds and assumptions, the command that runs it, and the commit where it was last confirmed to describe the code. If no verify skill exists, stop and tell the user to type `/create-formal-verification-skill`. If the skill does not record a sync commit, use the last commit that changed the verification files, and say that you did.
 
 2. **Run it as it is.** Run each check once before you change anything, and record the result. A pass here does not tell you that the code is correct. It tells you that the old description still holds. A failure here can be drift or a bug. Do not decide which until step 5.
 
```

## Reference files

`references/quint-lang/` is a byte copy of the `quint-lang` skill from Quint LLM Kit, with its license.

- Repository: https://github.com/quint-co/quint-llm-kit, branch `main`.
- Path: `quint-llm-kit-plugin/skills/quint-lang/`, which is `references/quint-lang/` here. Its `SKILL.md` is `quint-lang.md` here, so that no agent finds a second skill named `quint-lang` in this folder. Its links to `guidelines/` still work. The repository's `LICENSE` (Apache-2.0) is `references/quint-lang/LICENSE`. The repository has no `NOTICE` file.
- Base: `cc75369f741af7d490936f82002c2d28e3b3d78d` (2026-07-01, "Merge quint skill suite updates onto main (#12)").
- Checked against Quint 0.33.1: each CLI flag in the copy exists. The example modules fail to type-check only on imports of files that the copy does not include, template names, or an empty function body.
  The copy does not say that `quint verify` needs Java 21, or that it takes `--backend=tlc`, so `SKILL.md` in this skill says both where it needs them.

## Update procedure

Update this skill together with `create-formal-verification-skill`, because this skill maintains the skills that it generates.

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/maintain-formal-verification-skill/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md`, `agents/openai.yaml`, and `references/`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/maintain-formal-verification-skill/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.

To update `references/quint-lang/`, copy `quint-llm-kit-plugin/skills/quint-lang/` and `LICENSE` from https://github.com/quint-co/quint-llm-kit at `main` into `references/quint-lang/` of both `create-formal-verification-skill` and `maintain-formal-verification-skill`.
Rename its `SKILL.md` to `quint-lang.md`. Check each CLI flag in the copy against `quint <command> --help` of the newest Quint release, and set "Base" under "Reference files" in both `UPSTREAM.md` files.
