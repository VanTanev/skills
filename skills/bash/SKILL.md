---
name: bash
description: Write, review, or debug Bash script files in a repository.
compatibility: Requires ShellCheck with check-extra-masked-returns support.
metadata:
  sources: Wooledge BashPitfalls and BashProgramming, GNU Bash and coreutils manuals, ShellCheck wiki
---

# Bash

Use Bash to connect commands, not to replace a suitable data parser or application language.

## Expert Test

For each decision, ask what the best expert in that field would choose and why they would reject your approach.
If you can identify a valid reason to reject it, change the approach.
Choose correctness over the cheapest way to meet the stated constraints.
State every trade-off to the user.
Syntax, lint, convention, and a copied example are not proof; prove behavior with the actual expansion, status, and process result.

## Environment

Check these before guessing:

- The nearest `AGENTS.md`, shell conventions, and existing tests and ShellCheck configuration.
- The actual interpreter, minimum supported Bash version, and whether code is executed or sourced.
- The target operating system and implementations of external commands, especially GNU versus BSD tools.
- Local `help` and `man` output when behavior is uncertain.

## Branch Chooser

Read every matching reference before analysis or editing.

- Quoting, arrays, patterns, arithmetic, configuration, embedded languages, or SSH: [Arguments and Data](references/ARGUMENTS_AND_DATA.md).
- Conditions, exit status, command substitution, pipelines, process substitution, or shell error options: [Status and Control](references/STATUS_AND_CONTROL.md).
- Globs, `find`, `read`, redirection, temporary files, file replacement, or symlinks: [Files and Streams](references/FILES_AND_STREAMS.md).
- Background jobs, signals, cleanup, locks, concurrency, or timeouts: [Processes](references/PROCESSES.md).

## Script Contract

For every script or library creation, edit, or review, apply [Portability](references/PORTABILITY.md): interpreter contract, proportionate prerequisite checks, and support preservation.

## Core Defaults

- Preserve arguments with quoted expansions, `"$@"`, and `"${args[@]}"`.
- Store argument lists in arrays and reusable command sequences in functions.
- Print data with a fixed format: `printf '%s\n' "$value"`.
- Enumerate filenames with globs or `find`; pass them directly or through NUL-delimited streams.
- Define behavior for no matches, hidden files, and symlinks.
- Stop option parsing with `--` where supported, or use unambiguous path prefixes.
- Use `[[ ]]` for Bash string and file tests; quote the right operand for literal equality.
- Test command status directly and distinguish an expected negative result from an execution error.
- Check prerequisites such as `cd` explicitly before dependent work.
- Separate declarations from command substitutions whose exit status matters.
- Keep output data on standard output and diagnostics on standard error.
- Prefer simple parameter expansion for simple string operations and a format-aware parser for structured data.

## Check

Run ShellCheck on every changed or in-scope shell file, by explicit path, including files without a `.sh` extension:

```bash
shellcheck -x --enable=check-extra-masked-returns -- path/to/script
```

A missing or broken ShellCheck fails this command: stop Bash work, report the setup problem, and resume after it passes.
Fix findings rather than weakening the checks; use focused suppressions only for proven intentional behavior.
For a sourced file, declare its language with `# shellcheck shell=bash`, and resolve source paths rather than disabling source diagnostics.
Review project configuration and `SHELLCHECK_OPTS` if the check is unexpectedly silent.

## Completion

Use the behavioral-proof procedures in [Testing](references/TESTING.md).
Apply every matching row:

| Task | Complete when |
| --- | --- |
| Script or library change | Every changed shell file passes the check, and behavioral proof covers the intended behavior and relevant failure paths. |
| Review | Every in-scope shell file is assessed against the applicable rules; findings identify locations, consequences, and evidence gaps. |
| Diagnosis | A reproduction or captured evidence identifies the failing mechanism; unresolved causes remain explicit. |

Report checked files, tool versions, test outcomes, and untested environments.
