#!/usr/bin/env bash
# Checks that each copy of a skill in skills/*/references/ is byte-identical
# to skills/<name>/SKILL.md when this repo has that skill, and otherwise to
# the other copies with the same frontmatter name.
# Requires: Bash 4.0+ (associative arrays).
set -euo pipefail

frontmatter_name() {
  awk '
    NR == 1 { if ($0 != "---") exit; next }
    $0 == "---" { exit }
    /^name:[[:space:]]/ {
      sub(/^name:[[:space:]]*/, "")
      gsub(/^"|"$/, "")
      print
      exit
    }
  ' "$1"
}

CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

declare -A first_copy=()
status=0
for file in skills/*/references/*.md; do
  [[ -f $file ]] || continue
  name=$(frontmatter_name "$file")
  [[ -n $name ]] || continue

  source=skills/$name/SKILL.md
  if [[ ! -f $source ]]; then
    if [[ -z ${first_copy[$name]+set} ]]; then
      first_copy[$name]=$file
      continue
    fi
    source=${first_copy[$name]}
  fi

  if ! cmp -s -- "$source" "$file"; then
    printf '%s is not an exact copy of %s:\n' "$file" "$source" >&2
    diff -u -- "$source" "$file" >&2 || :
    status=1
  fi
done
exit "$status"
