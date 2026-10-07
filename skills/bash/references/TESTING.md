# Testing

## Behavioral Proof

Use relevant existing tests or a focused temporary reproduction to prove the changed behavior.
Behavioral proof does not require committed test files.
Add permanent tests only when requested or when the change warrants ongoing coverage in the project's existing suite.
For a command wrapper, test its added behavior without duplicating tests of the underlying command.
A wrapper with no added logic needs no separate test suite.
For a read-only review, run relevant existing tests where authorized and report missing coverage without adding tests.
Use isolated fixtures and fake external commands when live execution could change user or production state.
Execute a target only when its side effects are known; passing checks are not authorization to run it.

Select relevant cases:

| Behavior | Useful test cases |
| --- | --- |
| Arguments | Empty values, spaces, quotes, wildcard characters, leading dashes |
| Filename handling | No matches, newlines, hidden files, dangling symlinks |
| Text reading | Empty file, blank records, backslashes, final line without newline |
| Status handling | Producer failure, consumer failure, expected negative result, missing prerequisite |
| File updates | Failed transformation, original preserved, permissions and link policy |
| Background work | One failed child, interruption, cleanup, no remaining owned children |
| Environment | Different working directory, redirected stdin, supported Bash versions |
| Prerequisites | Missing tool, unsupported version or OS, rejected capability, no operational side effects before failure |

Assert the exit status, standard output, standard error, and relevant filesystem or process effects.
For a bug fix, prove that the regression test fails before the fix and passes after it when practical.
Avoid arbitrary sleeps when a file, pipe, or explicit synchronization event can establish readiness.

## Debugging

Reduce a failure to a small reproduction before changing several mechanisms at once.
Use `bash -x` only on controlled input: tracing prints expanded arguments and can expose secrets.
Keep tracing scoped and keep trace output separate from returned data.
Use `printf '%q\n'` or `declare -p` to inspect argument or array shape; printed shell notation is not proof of the original byte stream.
Reproduce with the caller's actual shell options and function-call context.
