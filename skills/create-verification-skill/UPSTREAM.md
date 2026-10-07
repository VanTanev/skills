# Upstream

This skill is a vendored copy of `create-verification-skill` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/create-verification-skill/`.
- Base: `4483dcd246c3212ff38890bd53977c16d7b54fb7` (2026-07-30, "Add feature map reference to create-verification-skill (#178)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `fadd23794c0075468eb8964b0fd93e06e09486ad` (upstream `main`, 2026-09-24).
  Upstream has no changes to this directory between the base and this commit.

The port recorded no upstream SHA, so the base is the last upstream commit that changes this directory.
Ivan ported the skill on 2026-09-03 into his dotfiles (`VanTanev/motors-dotfiles` commit `b527a29`, `~/.agents/skills/create-verification-skill`).
https://github.com/mcu-development/agentic-workflows/pull/5 copied it unchanged into that repo, and `VanTanev/skills` took the copy from there.

## Local changes

All changes let Claude Code, OpenCode, and other agents run the skill from one canonical copy in `.agents/skills`.

- Frontmatter: keeps `disable-model-invocation: true`, which Claude Code and Cursor read, and adds `metadata.opencode/autoinvoke: false`, the OpenCode form of the same setting.
- Description: the "Use for /create-verification-skill, \"make a control skill for this repo\", or when ..." trigger list becomes "For a project with no scripted way to prove UI/CLI/service behavior."
  Model invocation is off, so trigger phrases for the model contradict the frontmatter, and agents do not all start skills with a slash command.
- Paths: `.cursor/skills/verify-<app>/` becomes `.agents/skills/verify-<app>/` in 3 places (intro, step 2, step 3), because `.agents/skills` is the canonical skill directory.
- Symlink: the intro and step 2 tell the agent to link `.claude/skills/verify-<app>` to `../../.agents/skills/verify-<app>`, so Claude Code finds the skill without a second copy.
- Step 2 warning: "without frontmatter the skill never registers" becomes "without a description, agents do not advertise the skill to the model".
- Step 5: "Point the user at `/maintain-verification-skill`" becomes "offer to call the Skill tool with "maintain-verification-skill"", the agent-agnostic form that Matt Pocock's skills use.
- `agents/openai.yaml`: added, with `policy.allow_implicit_invocation: false`, the Codex form of the same setting.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

`references/` is equal to upstream.
This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,12 +1,14 @@
 ---
 name: create-verification-skill
-description: "Generate a project-local verification skill that drives your app the way a user does — any language, framework, or platform. Use for /create-verification-skill, \"make a control skill for this repo\", or when a project has no scripted way to prove UI/CLI/service behavior."
+description: "Generate a project-local verification skill that drives your app the way a user does — any language, framework, or platform. For a project with no scripted way to prove UI/CLI/service behavior."
 disable-model-invocation: true
+metadata:
+  opencode/autoinvoke: false
 ---
 
 # Create a verification skill
 
-Every serious project needs a scripted way to drive the real app and prove behavior: launch it, exercise a feature the way a user would, and capture evidence. This skill generates that as a project-local skill (`.cursor/skills/verify-<app>/`) tailored to the repo. You write the generator's output for the next agent, not for a human: it will be read cold, mid-task, by an agent that has never seen the app.
+Every serious project needs a scripted way to drive the real app and prove behavior: launch it, exercise a feature the way a user would, and capture evidence. This skill generates that as a project-local skill (`.agents/skills/verify-<app>/`) tailored to the repo, then links `.claude/skills/verify-<app>` to that canonical directory. You write the generator's output for the next agent, not for a human: it will be read cold, mid-task, by an agent that has never seen the app.
 
 ## 1. Interview the repo, not the user
 
@@ -22,7 +24,7 @@
 
 ## 2. Generate the skill
 
-Write `.cursor/skills/verify-<app>/SKILL.md` with YAML frontmatter (`name: verify-<app>` and a `description` that names the app, the surface, and when to reach for it — without frontmatter the skill never registers) and these sections, each grounded in what the interview actually found (no placeholders left):
+Write `.agents/skills/verify-<app>/SKILL.md` with YAML frontmatter (`name: verify-<app>` and a `description` that names the app, the surface, and when to reach for it — without a description, agents do not advertise the skill to the model) and these sections, each grounded in what the interview actually found (no placeholders left). Create `.claude/skills/verify-<app>` as a relative symlink to `../../.agents/skills/verify-<app>` so both runtimes use the same project-local skill; never maintain a second copy.
 
 - **Launch:** the exact command that starts the app for verification, and how to tell it's ready (a log line, a port answering, a prompt). Include teardown. For a short-lived CLI or TUI there is no server to keep alive: launch means build the binary (or install deps) once, then start each drive in its own isolated PTY or tmux session.
 - **Doctor:** one read-only check that answers "is this instance worth driving?" — process up, right version/build, port owned by us, auth valid. An agent runs this first whenever anything looks off.
@@ -33,7 +35,7 @@
 
 ## 3. Seed the feature map
 
-Create `.cursor/skills/verify-<app>/features/README.md` plus one file per user-facing feature you can identify (aim for the top 3-5 to start, from routes, commands, menus, or docs). Follow the shape in [`references/feature-map-example/`](references/feature-map-example/), with a README index and one file per feature. Each file answers, from the user's point of view: what the feature is, how to reach it, how to drive it with the harness, and what observable end state proves it works. The four H2s are `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, and `Gotchas`. The map is the repo's maintained verification source; a proof that drives one convenient entry point is incomplete when the map lists others.
+Create `.agents/skills/verify-<app>/features/README.md` plus one file per user-facing feature you can identify (aim for the top 3-5 to start, from routes, commands, menus, or docs). Follow the shape in [`references/feature-map-example/`](references/feature-map-example/), with a README index and one file per feature. Each file answers, from the user's point of view: what the feature is, how to reach it, how to drive it with the harness, and what observable end state proves it works. The four H2s are `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, and `Gotchas`. The map is the repo's maintained verification source; a proof that drives one convenient entry point is incomplete when the map lists others.
 
 ## 4. Prove the generated skill before handing it over
 
@@ -41,4 +43,4 @@
 
 ## 5. Offer the maintenance loop
 
-Point the user at `/maintain-verification-skill` for keeping the map honest as the app changes. Suggest a cadence only if they ask.
+To keep the map honest as the app changes, offer to call the Skill tool with "maintain-verification-skill". Suggest a cadence only if they ask.
```

## Update procedure

Update this skill together with `maintain-verification-skill`, because both use the `verify-<app>` layout.

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <base>..origin/main -- pstack/skills/create-verification-skill/ pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. Replace the files in this directory with the upstream files at `origin/main`, and copy `pstack/LICENSE` to `LICENSE`.
   Keep `UPSTREAM.md` and `agents/openai.yaml`.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/create-verification-skill/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
