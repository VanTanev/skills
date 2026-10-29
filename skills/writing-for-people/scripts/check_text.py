#!/usr/bin/env python3
"""Find the writing faults that a pattern can find.

Usage: check_text.py [--markdown] [--changed] FILE...

An error is Markdown that renders wrong. A suggestion is a pattern that is usually a fault, and the
writer applies it or keeps the text on purpose. It skips code blocks, code spans, and URLs.
With --changed, it reports only the lines that differ from git HEAD, or every line of a file that
git does not track.
Exit 0: no errors. Exit 1: errors. Exit 2: usage.
"""

import os
import re
import subprocess
import sys

PROSE_RULES = [
    ("dash", re.compile(r"[—–]"), "em or en dash: end the sentence or use a comma (unslop 13)"),
    ("semicolon", re.compile(r";"), "semicolon: use a period"),
    ("curly-quote", re.compile(r"[“”‘’]"), "curly quote: use a straight quote (unslop 19)"),
    (
        "ai-word",
        re.compile(
            r"\b(additionally|crucial|delve\w*|enduring|enhanc\w*|foster\w*|garner\w*|interplay"
            r"|intricate|pivotal|showcas\w*|testament|underscor\w*|vibrant)\b",
            re.IGNORECASE,
        ),
        "AI vocabulary: use a plain word (unslop 7)",
    ),
    (
        "plain-word",
        re.compile(r"\b(utiliz\w*|leverag\w*|facilitat\w*|numerous)\b", re.IGNORECASE),
        "use the plain word: use, help, many (unslop 31)",
    ),
    (
        "filler",
        re.compile(
            r"\b(in order to|due to the fact that|in the event that|it is important to note"
            r"|it's important to note|it is worth noting)\b",
            re.IGNORECASE,
        ),
        "filler phrase (unslop 23)",
    ),
    (
        "chatbot",
        re.compile(r"(I hope this helps|let me know if|great question|certainly!|of course!)", re.IGNORECASE),
        "chatbot phrase (unslop 20)",
    ),
    ("please", re.compile(r"\bplease\b", re.IGNORECASE), "no 'please': write the instruction as a command"),
    ("simply", re.compile(r"\bsimply\b", re.IGNORECASE), "no 'simply': if it were simple, the reader would not be here"),
    (
        "latin",
        re.compile(r"(?<![\w.])(e\.g\.|i\.e\.|etc\.)", re.IGNORECASE),
        "Latin abbreviation: write 'for example' or 'that is', or say up front that a list is partial",
    ),
    ("and-or", re.compile(r"\band/or\b|\w\(s\)", re.IGNORECASE), "no 'and/or' and no '(s)' plurals"),
]

ERRORS = {"fence", "code-span", "table"}

FENCE = re.compile(r"^\s*(```|~~~)")
CODE_SPAN = re.compile(r"(`+)(.+?)\1")
URL = re.compile(r"https?://\S+")
HEADING = re.compile(r"^(#{1,6})\s")
LIST_ITEM = re.compile(r"^\s*([-*+]|\d+[.)])\s")
QUOTE = re.compile(r"^\s*>\s?")


def frontmatter_end(lines):
    """The line number that closes the YAML frontmatter, or 0 when the file has none."""
    if not lines or lines[0].strip() != "---":
        return 0
    for number, line in enumerate(lines[1:], 2):
        if line.strip() == "---":
            return number
    return 0


def prose_lines(lines):
    """Yields (line number, text) for each line outside the frontmatter and the code blocks."""
    in_fence = False
    skip = frontmatter_end(lines)
    for number, line in enumerate(lines, 1):
        if number <= skip:
            continue
        if FENCE.match(line):
            in_fence = not in_fence
            continue
        if not in_fence:
            yield number, line


def without_code(text):
    return URL.sub("", CODE_SPAN.sub("", text))


def check_prose(lines):
    for number, line in prose_lines(lines):
        text = without_code(line)
        for rule, pattern, message in PROSE_RULES:
            match = pattern.search(text)
            if match:
                yield number, rule, f"{message}: '{match.group(0)}'"


def table_cells(line):
    stripped = CODE_SPAN.sub("x", line.strip()).replace("\\|", "")
    return stripped.strip("|").count("|") + 1


def continues_sentence(line, following):
    """True when `following` continues the sentence of `line` on a new line."""
    body, next_body = QUOTE.sub("", line).strip(), QUOTE.sub("", following).strip()
    if not body or not next_body:
        return False
    if HEADING.match(body) or body.startswith("|") or next_body.startswith("|"):
        return False
    if LIST_ITEM.match(QUOTE.sub("", following)) or HEADING.match(next_body):
        return False
    return next_body[0].islower()


def check_markdown(lines):
    in_fence, fence_line = False, 0
    table_width, table_line = None, 0
    last_level = None
    skip = frontmatter_end(lines)
    for number, line in enumerate(lines, 1):
        if number <= skip:
            continue
        if FENCE.match(line):
            in_fence, fence_line = not in_fence, number
            continue
        if in_fence:
            continue
        if "`" in CODE_SPAN.sub("", line):
            yield number, "code-span", "odd number of backticks: a code span does not close"
        if line.strip().startswith("|"):
            width = table_cells(line)
            if table_width is None:
                table_width, table_line = width, number
            elif width != table_width:
                yield number, "table", f"{width} cells, but the table row on line {table_line} has {table_width}"
        else:
            table_width = None
        heading = HEADING.match(line)
        if heading:
            level = len(heading.group(1))
            if last_level is not None and level > last_level + 1:
                yield number, "heading", f"heading level {level} after level {last_level}: skips a level"
            last_level = level
        if number < len(lines) and continues_sentence(line, lines[number]):
            yield number, "wrap", "line break inside a sentence: break lines only at sentence ends"
    if in_fence:
        yield fence_line, "fence", "code block does not close"


def changed_lines(path):
    """The line numbers that differ from git HEAD, or None when git does not track the file."""
    folder, name = os.path.split(os.path.abspath(path))
    tracked = subprocess.run(
        ["git", "ls-files", "--error-unmatch", "--", name], cwd=folder, capture_output=True, check=False
    )
    if tracked.returncode != 0:
        return None
    diff = subprocess.run(
        ["git", "diff", "--unified=0", "--no-color", "HEAD", "--", name],
        cwd=folder, capture_output=True, text=True, check=True,
    ).stdout
    lines = set()
    for hunk in re.finditer(r"^@@ -\S+ \+(\d+)(?:,(\d+))? @@", diff, re.MULTILINE):
        start, count = int(hunk.group(1)), int(hunk.group(2) or 1)
        lines.update(range(start, start + count))
    return lines


def main(argv):
    flags = {"--markdown", "--changed"}
    paths = [arg for arg in argv if arg not in flags]
    if not paths or any(path.startswith("-") for path in paths):
        print(__doc__.strip(), file=sys.stderr)
        return 2
    errors = 0
    for path in paths:
        with open(path, encoding="utf-8") as file:
            lines = file.read().splitlines()
        findings = list(check_prose(lines))
        if "--markdown" in argv:
            findings += list(check_markdown(lines))
        changed = changed_lines(path) if "--changed" in argv else None
        if changed is not None:
            findings = [finding for finding in findings if finding[0] in changed]
        for number, rule, message in sorted(findings):
            kind = "error" if rule in ERRORS else "suggestion"
            print(f"{path}:{number}: {kind}: {rule}: {message}")
        errors += sum(rule in ERRORS for _, rule, _ in findings)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
