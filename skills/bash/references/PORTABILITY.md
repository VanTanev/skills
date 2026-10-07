# Portability

## Interpreter Contract

Identify the shell that will parse the code.
A Bash shebang does not help if a caller explicitly runs `sh script`.
Do not convert a POSIX script to Bash without agreement on the runtime requirement.

Use the project's minimum supported version and test on it when available.
ShellCheck's Bash dialect is not a minimum-version checker.

Some feature boundaries:

| Feature | First Bash release |
| --- | --- |
| Associative arrays, `mapfile`, `globstar` | 4.0 |
| Dynamic file descriptors, such as `exec {fd}< file` | 4.1 |
| `lastpipe` | 4.2 |
| Namerefs, `wait -n` | 4.3 |
| `inherit_errexit`, `mapfile -d`, `${value@Q}` | 4.4 |
| New `${ command; }` substitution forms | 5.3 |

Check fixes and options as well as feature availability.
Associative-array subscripts and membership tests changed across releases.
Avoid copying a quoting workaround without testing the target version and shell options.
For arbitrary-byte `read` input, Bash 5.0 through 5.3-rc1 have a multibyte regression; command-local `LC_ALL=C` avoids it.
Vendor backports can change the result without changing the major/minor version.

## Prerequisites

Require each added safeguard to solve a concrete problem.
Base the decision on the script's responsibility and failure consequences, not its line count or filename.

Keep command wrappers that set environment variables and forward arguments small.
Their shebang and command can be sufficient when command failure already produces a clear diagnostic and nonzero exit status.
Preserve argument boundaries and propagate the command's exit status.

Add an early prerequisite check when failure can cause partial changes, incorrect results, or an unclear diagnostic.
For example, a failed `cd` must stop dependent migration commands.
Use existing repository requirements as the source of truth.
Add `# Supports:` or `# Requires:` declarations only for additional requirements that callers need.
When a declaration is necessary, distinguish the shell and version from the operating system, tool capabilities, and environment inputs.

For each necessary prerequisite check, give a specific diagnostic and stop before the affected operation.
Use `command -v` for tool availability and non-mutating probes for required capabilities.
If a capability probe can change state, use an authoritative version check or an isolated fixture.
Validate required environment inputs without printing secrets.
Keep dependency installation in the explicit workflow, separate from prerequisite checks.

Keep interpreter checks in syntax that the bootstrap interpreter can parse.
A version guard inside a function containing unsupported syntax may be too late: the shell must parse the function before running it.
Keep newer syntax after an independently parsed guard, or use a compatible launcher.
For sourced libraries, use the caller's checked contract or a prerequisite function that returns failure without changing the caller's global state.

During every edit:

1. Identify added syntax, commands, flags, and environment assumptions.
2. Compare each with every declared target, not just the development host.
3. Add prerequisite checks only where the failure consequences require them, and preserve supported targets.
4. Run checks and focused tests on each supported environment available to the project.
5. Report missing environments; obtain agreement before narrowing support.

For GNU/Linux plus macOS support, test both utility implementations or use a deliberately installed common toolchain.
For a POSIX `sh` target, use the `sh` ShellCheck dialect and an actual supported `sh` implementation.

## External Utilities

Check flags for `sed -i`, `date`, `stat`, `readlink`, `realpath`, `mktemp`, `find`, and `xargs` on the target.
Do not accumulate legacy workarounds for platforms the project does not support.

## Environment and Sourced Files

Sourced files share the caller's working directory, shell options, traps, and variables.
Keep changes scoped or restore the exact prior state, including unset versus empty values.
Use `return` for library failure rather than terminating the caller with `exit`.
Function-local variables have dynamic scope: called functions can see a caller's local variables.
Use deliberate names and contracts for output parameters and namerefs.

`CDPATH` can change directory resolution and add unexpected output.
Use an explicit path and `CDPATH= cd -- "$directory"` where inherited search behavior is unwanted.
Scope `IFS`, locale, `umask`, and glob options to the operation that needs them.
An empty `IFS` is not equivalent to an unset `IFS`.
Use `LC_ALL=C` for byte-oriented operations, not as a blanket substitute for correct user-language handling.

Test noninteractive execution with the actual PATH, working directory, stdin, and credentials contract.
Do not rely on aliases or interactive startup files.
Noninteractive Bash can read `BASH_ENV`; `--noprofile --norc` alone does not disable it.
Use LF line endings and no byte-order mark for shell source.
