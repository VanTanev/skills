# Status and Control

## Explicit Failure Handling

Check the command's documented status contract before treating a nonzero status as an error.
Use `if`, not `a && b || c`, for an actual if/else decision: failure of `b` also runs `c`.

```bash
read_result() {
  local result status
  if result=$(producer); then
    printf '%s\n' "$result"
  else
    status=$?
    printf 'producer failed with status %s\n' "$status" >&2
    return "$status"
  fi
}
```

Capture `$?` before any other command replaces it.
Inside `if ! command; then`, `$?` is the negated result, not the original failure.
`local value=$(command)`, `export`, and `readonly` can hide the substitution's status.

## Shell Error Options

Use project error-option conventions, but prove failure handling independently of them.
`set -e` ignores failures in conditional contexts.
If a function runs as an `if` test or in a tested part of an AND/OR list, this affects its body too.

```bash
run_in_directory() {
  CDPATH= cd -- "$1" || return
  build
}
```

The `cd` check remains necessary when the caller adds `if run_in_directory ...`.
Traditional `$(...)` normally clears `errexit` in non-POSIX Bash.
`inherit_errexit` changes inheritance, not the conditional exceptions.
In a multi-command substitution, check each required predecessor explicitly.

`((count++))` returns nonzero when its expression evaluates to zero, including an initial count of zero.
For a plain update whose status is not a predicate, use `count=$((count + 1))`.
With `set -u`, define optional values deliberately; `${value-default}` and `${value:-default}` differ for empty values.
Distinguish unset from empty rather than adding empty defaults everywhere.

## Pipelines

Without `pipefail`, a pipeline normally reports its last command's status.
With `pipefail`, it reports the rightmost nonzero status, if any.
Use the option when that matches the operation's meaning.
An early-exiting consumer such as `grep -q` or `head` can cause a producer to receive SIGPIPE after the consumer has succeeded.
Decide whether that producer status is a failure for the operation before classifying it.

When individual statuses matter, capture `PIPESTATUS` immediately, before another command changes it.
ShellCheck cannot decide which failures your application should accept.

## Subshells and Process Substitution

A pipeline loop normally runs in a subshell; its variable updates do not reach the parent.
`lastpipe` changes this under specific conditions and is not a portable assumption.
Input redirection keeps the loop in the current shell:

```bash
count=0
while IFS= read -r line; do
  count=$((count + 1))
done < "$file"
```

`done < <(producer)` also preserves loop state, but the loop's status does not report producer failure.
`pipefail` does not include process-substitution jobs.
If producer success is required, use a checked temporary file or explicitly collect its status with a target-version-tested process design.
A checked file uses storage and delays consumption, but gives a simple failure boundary.
