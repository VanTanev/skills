# Arguments and Data

## Command Arguments

Use arrays to preserve empty arguments, whitespace, and wildcard characters.

```bash
args=(--output "$output")
if [[ $verbose == yes ]]; then
  args+=(--verbose)
fi
tool "${args[@]}" -- "$input"
```

Confirm that the target command supports `--`.
Arrays hold arguments, not pipelines or redirections.
Embedded quote characters in a string do not become shell quoting when the string expands.
Quote a heredoc delimiter, as in `<<'EOF'`, when its body must remain literal.

## Patterns and Numbers

Use an unquoted right operand only for intentional pattern or regular-expression matching.
`[[ $value > 7 ]]` compares strings, not numbers.

Before arithmetic, define and validate the accepted numeric format and range.
For example, this function accepts only unsigned decimal ports in a bounded range:

```bash
valid_port() {
  local value=$1
  [[ $value =~ ^[0-9]{1,5}$ ]] || return 1
  (( 10#$value >= 1 && 10#$value <= 65535 ))
}
```

The length bound prevents machine-integer overflow here.
Adapt bounds to the domain; `10#` handles decimal interpretation, not validation.
Signed numbers need separate sign handling.
Arithmetic also occurs in indexed-array subscripts, integer variables, numeric `[[ ]]` tests, and substring offsets.
Variable values can be evaluated recursively as expressions; outer quotes do not make them safe.
Use a suitable numeric library when the required range exceeds shell arithmetic.

## Embedded Languages and Configuration

Pass values separately from code supplied to `bash -c`, `find -exec`, `awk`, or another interpreter.

```bash
find . -type f -exec bash -c '
  for file do
    printf "%s\n" "$file"
  done
' bash {} +
```

The first argument after the code fills `$0`; data starts at `$1`.
Shell quoting does not escape `sed` replacement syntax or another language's expressions.
Use the receiving tool's data API, such as `jq --arg`, rather than text interpolation.

`source` and `.` execute code in the current shell, even without executable permission.
Only source trusted shell files through an intentional path.
Parse untrusted configuration as data instead.

## SSH

SSH joins remote command arguments into a command string for the remote shell.
`ssh host tool "$value"` does not preserve the local argument boundary remotely.
Prefer fixed remote code with a defined data stream; otherwise encode arguments for the actual remote shell and test that boundary.
`printf %q` and `${value@Q}` are not universal shell quoting functions.
Verify client and remote Bash versions and locale before using such recipes.
Use `ssh -T` for byte streams; a pseudo-terminal can change bytes.
If stdin carries a script, it cannot also carry an independent data stream without a framing scheme.
