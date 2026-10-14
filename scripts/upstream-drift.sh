#!/usr/bin/env bash
# Reports upstream changes to the files that copied skills come from.
#
# Usage: scripts/upstream-drift.sh [--issue]
#
# Each skills/*/UPSTREAM.md has exactly one ```upstream block:
#   repo: <owner>/<name>
#   branch: <upstream branch>
#   checked: <40-hex SHA, the same as the "Checked up to" line>
#   path: <upstream file or directory>    (one line per path)
#   pr: <number> <40-hex head SHA>        (optional, an open upstream PR)
#
# Prints a Markdown report of each upstream commit after "checked" that
# touches a path, and of each tracked PR whose head moved or that closed.
# With --issue, also opens or updates the open issue labeled upstream-drift,
# or closes that issue when nothing changed.
#
# Exit status: 0 nothing changed, 1 changes found, 2 error.
# Requires: Bash 4.0+, gh (authenticated), jq.

# Backticks in the printf formats are Markdown code spans, not commands.
# shellcheck disable=SC2016

set -euo pipefail

readonly issue_label=upstream-drift
readonly issue_title='Upstream changes to copied skills'
readonly max_commits=100

die() {
  printf 'upstream-drift: %s\n' "$*" >&2
  exit 2
}

api() {
  local json
  if ! json=$(gh api "$1"); then
    printf 'upstream-drift: GitHub API request failed: %s\n' "$1" >&2
    return 1
  fi
  printf '%s\n' "$json"
}

# Succeeds when commit $2 is commit $3 or one of its ancestors in repo $1.
is_ancestor_or_same() {
  local json status
  [[ $2 == "$3" ]] && return 0
  json=$(api "repos/$1/compare/$2...$3") || exit 2
  status=$(jq -r '.status' <<<"$json") || die "cannot read compare status for $2...$3 in $1"
  case $status in
    ahead | identical) return 0 ;;
    behind | diverged) return 1 ;;
    *) die "unexpected compare status '$status' for $2...$3 in $1" ;;
  esac
}

section_open=0
emit_section_header() {
  if ((section_open == 0)); then
    printf '\n## %s\n\nUpstream: `%s` branch `%s`, checked up to [`%s`](https://github.com/%s/compare/%s...%s).\n\n' \
      "$skill" "$repo" "$branch" "${checked:0:7}" "$repo" "$checked" "$branch" >>"$report"
    section_open=1
  fi
}

check_copy() {
  local file=$1 block line key value p json list sha url message found_base count fields
  local pr_state pr_merged pr_now pr_url
  local -a paths=() commits=()
  skill=${file%/UPSTREAM.md}
  skill=${skill##*/}
  repo='' branch='' checked='' pr_number='' pr_head=''
  section_open=0

  if ! block=$(awk '
    /^```upstream$/ { blocks++; inside = 1; next }
    inside && /^```$/ { inside = 0; next }
    inside { print }
    END { if (blocks != 1 || inside) exit 3 }
  ' "$file"); then
    die "$file: needs exactly one closed \`\`\`upstream block"
  fi

  while IFS= read -r line; do
    [[ -n $line ]] || continue
    [[ $line == *': '* ]] || die "$file: block line is not 'key: value': $line"
    key=${line%%: *}
    value=${line#*: }
    case $key in
      repo) repo=$value ;;
      branch) branch=$value ;;
      checked) checked=$value ;;
      path) paths+=("$value") ;;
      pr) read -r pr_number pr_head <<<"$value" ;;
      *) die "$file: unknown block key '$key'" ;;
    esac
  done <<<"$block"

  [[ $repo =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || die "$file: bad repo '$repo'"
  [[ $branch =~ ^[A-Za-z0-9_./-]+$ ]] || die "$file: bad branch '$branch'"
  [[ $checked =~ ^[0-9a-f]{40}$ ]] || die "$file: checked must be a full SHA"
  ((${#paths[@]} > 0)) || die "$file: needs at least one path"
  for p in "${paths[@]}"; do
    [[ $p =~ ^[A-Za-z0-9_./-]+$ ]] || die "$file: bad path '$p'"
  done
  grep -qF -- "Checked up to: \`$checked\`" "$file" ||
    die "$file: block checked $checked does not match the \"Checked up to\" line"
  if [[ -n $pr_number || -n $pr_head ]]; then
    [[ $pr_number =~ ^[0-9]+$ && $pr_head =~ ^[0-9a-f]{40}$ ]] ||
      die "$file: pr must be '<number> <full head SHA>'"
    grep -qF -- "\`$pr_head\`" "$file" ||
      die "$file: block pr head $pr_head is not in the text"
  fi

  if ! is_ancestor_or_same "$repo" "$checked" "$branch"; then
    emit_section_header
    printf -- '- `%s` is not on `%s` any more. Find a new base by hand.\n' "${checked:0:7}" "$branch" >>"$report"
    changed=1
  fi

  for p in "${paths[@]}"; do
    json=$(api "repos/$repo/commits?sha=$branch&path=${p%/}&per_page=$max_commits") || exit 2
    list=$(jq -r '.[] | [.sha, .html_url, (.commit.message | split("\n")[0])] | @tsv' <<<"$json") ||
      die "$file: cannot read the commit list for $p"
    [[ -n $list ]] || die "$file: upstream has no commits for path $p"
    mapfile -t commits <<<"$list"

    found_base=0
    count=0
    for line in "${commits[@]}"; do
      IFS=$'\t' read -r sha url message <<<"$line"
      if is_ancestor_or_same "$repo" "$sha" "$checked"; then
        found_base=1
        break
      fi
      if ((count == 0)); then
        emit_section_header
        printf -- '- `%s`:\n' "$p" >>"$report"
      fi
      printf -- '  - [`%s`](%s) %s\n' "${sha:0:7}" "$url" "$message" >>"$report"
      count=$((count + 1))
    done
    if ((found_base == 0 && ${#commits[@]} == max_commits)); then
      die "$file: $p has $max_commits or more new commits; check it by hand"
    fi
    if ((count > 0)); then
      changed=1
    fi
  done

  if [[ -n $pr_number ]]; then
    json=$(api "repos/$repo/pulls/$pr_number") || exit 2
    fields=$(jq -r '[.state, (.merged | tostring), .head.sha, .html_url] | @tsv' <<<"$json") ||
      die "$file: cannot read PR $pr_number"
    IFS=$'\t' read -r pr_state pr_merged pr_now pr_url <<<"$fields"
    if [[ $pr_merged == true ]]; then
      emit_section_header
      printf -- '- PR %s merged.\n' "$pr_url" >>"$report"
      changed=1
    elif [[ $pr_state != open ]]; then
      emit_section_header
      printf -- '- PR %s closed without a merge.\n' "$pr_url" >>"$report"
      changed=1
    elif [[ $pr_now != "$pr_head" ]]; then
      emit_section_header
      printf -- '- PR %s head moved from `%s` to `%s`.\n' "$pr_url" "${pr_head:0:7}" "${pr_now:0:7}" >>"$report"
      changed=1
    fi
  fi
}

ensure_label() {
  local names
  names=$(gh label list --limit 200 --json name --jq '.[].name') || die "cannot list labels"
  if ! grep -qxF -- "$1" <<<"$names"; then
    gh label create "$1" --color "$2" --description "$3" >/dev/null || die "cannot create label $1"
  fi
}

update_issue() {
  local number body
  number=$(gh issue list --label "$issue_label" --state open --json number --jq '.[0].number // empty') ||
    die "cannot list issues"
  if ((changed == 0)); then
    if [[ -n $number ]]; then
      gh issue close "$number" --comment 'No upstream changes remain.' >/dev/null || die "cannot close issue #$number"
    fi
    return 0
  fi
  body=$tmp/body.md
  {
    printf 'Upstream changed files that copied skills come from.\n'
    printf 'For each skill, follow the update procedure in its `UPSTREAM.md`, then update its `upstream` block.\n'
    printf 'The weekly check updates this issue, and closes it when no change remains.\n'
    cat -- "$report"
  } >"$body"
  if [[ -n $number ]]; then
    gh issue edit "$number" --body-file "$body" >/dev/null || die "cannot update issue #$number"
  else
    ensure_label "$issue_label" FBCA04 'Upstream changed a file that a copied skill comes from'
    ensure_label needs-triage D4C5F9 'Maintainer needs to evaluate this issue'
    gh issue create --title "$issue_title" --label "$issue_label" --label needs-triage --body-file "$body" >/dev/null ||
      die "cannot create the issue"
  fi
}

issue_mode=0
case ${1-} in
  '') ;;
  --issue) issue_mode=1 ;;
  *) die "usage: scripts/upstream-drift.sh [--issue]" ;;
esac

command -v gh >/dev/null || die "gh is not installed"
command -v jq >/dev/null || die "jq is not installed"
CDPATH='' cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

tmp=$(mktemp -d) || die "cannot create a temporary directory"
trap 'rm -rf -- "$tmp"' EXIT
report=$tmp/report.md
: >"$report"

changed=0
copies=0
for file in skills/*/UPSTREAM.md; do
  [[ -f $file ]] || continue
  check_copy "$file"
  copies=$((copies + 1))
done
((copies > 0)) || die "no skills/*/UPSTREAM.md found"

if ((issue_mode)); then
  update_issue
fi
if ((changed)); then
  cat -- "$report"
  exit 1
fi
printf 'No upstream changes in %s copied skills.\n' "$copies"
