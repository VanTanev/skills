# Upstream

This skill is a vendored copy of `statechart` from the Cursor pstack plugin.

## Source

- Repository: https://github.com/cursor/plugins, branch `main`.
- Path: `pstack/skills/statechart/`.
- Files: `SKILL.md`, `references/render.md`, and `scripts/`, except `scripts/test/`.
- Base: `519d36aa98955bf680db01bcde5fdfba686dc901` (2026-10-26, "test(pstack): wait for the reap in the statechart SIGKILL view test (#981)").
  The files here are equal to upstream at this commit, except for the local changes below.
- Checked up to: `ae5650febf4320793844c12c4adaa937f417f8da` (upstream `main`, 2026-10-31).
  Upstream has no changes to this directory between the base and this commit.

`VanTanev/skills` added the copy on 2026-11-03.

## Local changes

- Frontmatter: `disable-model-invocation: true` is removed, so the skill is model-invoked.
  A verify skill that `create-formal-verification-skill` generates tells the next agent to call the Skill tool with `statechart`, and an agent can start only a model-invoked skill.
- Description: "Use for /statechart, or to show a bug as a path through states" becomes "Use to check a TLA+ model or read its result, or to show a bug as a path through states", so that it says to the model when to use the skill.
- `scripts/test/`: not copied.
  It is 3.8 MB of tests and test corpus, and the skill does not use it at run time.
  `scripts/package.json` stays a byte copy, so its `test` script fails here.
- `agents/openai.yaml`: added, with `interface` only, because the skill is model-invoked.
- `LICENSE`: added as a byte copy of upstream `pstack/LICENSE` (MIT), to keep the license notice with the copy.

`references/` and `scripts/` are equal to upstream, and `scripts/statechart` keeps its executable mode.
This is the exact diff of `SKILL.md` from the upstream base to this copy:

```diff
--- a/SKILL.md
+++ b/SKILL.md
@@ -1,7 +1,6 @@
 ---
 name: statechart
-description: "Check a TLA+ model of a system that moves between states, such as a product flow, a protocol, or a service, and draw it as a Mermaid statechart. The report gives the shortest path to each state that breaks a rule. Use for /statechart, or to show a bug as a path through states."
-disable-model-invocation: true
+description: "Check a TLA+ model of a system that moves between states, such as a product flow, a protocol, or a service, and draw it as a Mermaid statechart. The report gives the shortest path to each state that breaks a rule. Use to check a TLA+ model or read its result, or to show a bug as a path through states."
 ---
 
 # Statechart
```

## Run time

The `scripts/statechart` launcher runs `scripts/statechart.ts` with Node 22.18 to 22.x, Node 23.6 or later, Bun 1.1.5 or later, or Deno 2.0 or later.
The scripts use only the runtime's built-in modules, so no `npm install` is necessary.
To check a spec, the scripts need TLC and Java.
They install both with [mise](https://mise.jdx.dev) on the first run, which needs the network.
Without mise, set `TLA2TOOLS` to the path of `tla2tools.jar`, and `JAVA` to a Java 11 or later binary.

## Tests

To run the upstream tests, use a clone of https://github.com/cursor/plugins.
From the root of the clone, run the same commands as upstream CI (`.github/workflows/validate-plugins.yml`):

```sh
npm install --no-save fast-check@4.5.3
node --disable-warning=ExperimentalWarning --test pstack/skills/statechart/scripts/test/*.test.ts
```

The tests that run TLC are skipped when `TLA2TOOLS` is not set to the path of `tla2tools.jar`.

## Update procedure

Update this skill together with `create-formal-verification-skill`, because the skills that it generates call this skill.

1. In an up-to-date clone of https://github.com/cursor/plugins, run `git diff <checked-up-to>..origin/main -- pstack/skills/statechart/ ':!pstack/skills/statechart/scripts/test/' pstack/LICENSE`.
   If the diff is empty, set "Checked up to" to the `origin/main` SHA and date, and stop.
2. In this directory, run `rsync -a --delete --exclude /UPSTREAM.md --exclude /LICENSE --exclude /agents/ --exclude /scripts/test/ <clone>/pstack/skills/statechart/ ./`, and copy `pstack/LICENSE` to `LICENSE`.
   Check that `scripts/statechart` is still executable.
3. Re-apply the local changes: in this directory, run `sed -n '/^```diff$/,/^```$/p' UPSTREAM.md | sed '1d;$d' | patch -p1`.
   If a hunk fails, apply that change by hand from the list above.
4. In this file, replace the diff with the output of `diff -u --label a/SKILL.md --label b/SKILL.md <clone>/pstack/skills/statechart/SKILL.md SKILL.md`, and set "Base" and "Checked up to" to the new upstream SHA and date.
   If upstream adds a file outside `scripts/test/` that the skill does not use at run time, ask the user whether to copy it.
