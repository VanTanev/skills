# Processes

## Ownership and Status

Record `$!` immediately after starting each background job.
Check each required job with `wait "$pid"`.
Bare `wait` normally returns zero after waiting; `wait "$first" "$second"` reports only the last specified job's result.
Neither aggregates failures.

For finite jobs with no special cancellation requirement:

```bash
pids=()
first_job &
pids+=("$!")
second_job &
pids+=("$!")

result=0
for pid in "${pids[@]}"; do
  if wait "$pid"; then
    :
  else
    status=$?
    printf 'Job %s failed with status %s\n' "$pid" "$status" >&2
    result=1
  fi
done
```

This waits for every job rather than stopping at the first failure.
Propagate `result` from the owning function or script.
It is not a general process-tree supervisor or a signal-handling recipe.
Use a supervisor when the requirement includes durable service management or complex process trees.

## Signals and Cleanup

Define what interruption means before adding traps.
A trapped signal can interrupt `wait`; a returned status greater than 128 does not always mean the child has completed.
Track running children separately from completed children, and reap owned children after stopping them.
Do not search process names and kill matches as a substitute for ownership.
Signaling a parent PID does not necessarily stop its descendants.

Keep cleanup idempotent: repeated cleanup must not affect unrelated resources.
Preserve the original failure status when cleanup runs and report cleanup failures separately.
`EXIT` cleanup is useful for normal shell exit but cannot handle SIGKILL or machine failure.
Test actual INT and TERM behavior if interruption matters; do not assume an EXIT trap covers every signal path.
Signal handlers must terminate or re-raise deliberately instead of cleaning up and continuing by accident.
Avoid installing global traps from a sourced library unless that is its documented contract.

## Concurrency, Locks, and Timeouts

Bound parallelism and collect every required result.
Parallel writers can interleave output, even when each logical record uses `printf`.
Use per-job output files or a tool with serialized output when complete records matter.

A check for a lock file followed by its creation has a race.
Use a supported lock primitive, such as `flock`, or atomic directory creation where appropriate.
Check filesystem semantics, inherited descriptors, and stale-lock recovery before choosing a recipe.

Prefer a command's built-in timeout when it meets the requirement.
Otherwise use a supported timeout tool and test whether it stops the required descendants.
Distinguish timeout, interruption, and ordinary command failure in the result.
Do not build a sleep-and-kill scheme without proving PID lifetime and cleanup behavior.
