# Files and Streams

## Filename Boundaries

Filenames can contain spaces, newlines, wildcard characters, and leading dashes.
Parsed `ls` output and `$(find ...)` split on whitespace and break on such names.
For direct batch processing, prefer `find -exec tool ... {} +` when the tool accepts multiple files.
Check the `find` implementation's exit-status behavior when command failure must propagate.

For a current-directory glob, specify what counts as a match:

```bash
for file in ./*.txt; do
  [[ -e $file || -L $file ]] || continue
  printf '%s\n' "$file"
done
```

This skips an unmatched literal glob while retaining dangling symlinks.
Add a file-type test if only regular files belong in the operation.
If using `nullglob`, `dotglob`, or `globstar`, keep option changes within their intended scope.

For arbitrary filename records from a checked file:

```bash
while IFS= LC_ALL=C read -r -d '' file; do
  printf '%s\n' "$file"
done < "$names_file"
```

The file must use NUL separators, for example from a successful `find ... -print0`.
The NUL delimiter is consumed, not stored in the variable.
Use command-local `LC_ALL=C` for byte-safe reading across affected Bash versions.
`xargs -0` preserves this record format; plain `xargs` does not.
Check empty-input behavior and option support on the target platform.
Guard empty arrays before `printf '%s\0' "${files[@]}"`, which otherwise emits an empty record.

## Text and Binary Data

Use `IFS= read -r` to preserve whitespace and backslashes in lines.
If a final line without a newline is valid input, use:

```bash
while IFS= read -r line || [[ -n $line ]]; do
  printf '%s\n' "$line"
done < "$file"
```

This example adds a newline when printing the final record; it is not a byte-for-byte copy.
Commands such as SSH inside a loop can consume its remaining stdin.
Use `ssh -n` when no remote input is needed, or give the loop a separate file descriptor.

Traditional `$(...)` strips trailing newlines, even inside quotes.
A here-string adds a newline; `<<< "$(producer)"` is not a lossless stream.
Bash variables cannot hold NUL bytes.
Keep binary content in files or pipes and use byte-preserving tools.

## Redirection and Replacement

Redirections run left to right before the command.
Use `command > "$log" 2>&1` to send both streams to a file.
`sudo command > file` does not give the caller's redirection elevated privileges.
Choose the privilege boundary deliberately; do not add `sudo` just to make a check pass.

Never read a file while truncating it as output in the same pipeline.
For replacement, create a secure temporary file on the destination filesystem, write it, check success, and then rename it.
Account for permissions, ownership, symlinks, hardlinks, and concurrent writers.
A rename can provide atomic visibility; it is not by itself a guarantee of durability after power loss.
Cross-filesystem `mv` may copy and remove instead of renaming.
Use the repository's dedicated editing tools for source changes when available.

## Temporary Storage

Use a supported `mktemp` form that creates the object; check its status before use.
`mktemp -u` only generates a name and leaves a race before creation.
Use a private temporary directory when several related files are needed.
Install cleanup only for successfully acquired resources, and keep paths stable until cleanup completes.
Read [Processes](PROCESSES.md) before adding signal traps or child cleanup.
