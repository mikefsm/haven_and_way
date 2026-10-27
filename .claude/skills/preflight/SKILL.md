---
name: preflight
description: Run every check that matters before opening a Haven & Way PR — a design review from the design-director agent when the UI changed, bin/ci, the specs, and a review from the brutal-reviewer agent. Use before opening a PR, or whenever asked to check whether a change is ready.
user-invocable: true
---

The gate before a PR. Report what actually happened, including failures, and never state a count you did not read from the output.

## 1. What changed

    git diff --find-renames --diff-filter=ACMR origin/main...HEAD --name-only
    git status --short

Work from both — uncommitted changes count. `R` is in the filter deliberately: a file moved on the branch is reported as a rename, and a filter of `ACM` would drop it from every check below. In `git status --short` a staged rename prints as `R old -> new`; take the right-hand side.

The base is `origin/main`, and the three-dot form takes the merge base, so a `main` that has moved on does not widen the diff.

## 2. Design review, when the UI changed

Decide from every path the branch touches, deletions included: `git diff --name-only origin/main...HEAD` plus `git status --short`, without the filter.

If those paths touch `app/views`, `app/javascript`, `app/assets` or `app/helpers`, hand the branch to the `design-director` agent in **review** mode. Skip it otherwise and say so.

It runs first because it may apply small polish — classes, spacing, alt text, labels — as uncommitted edits, and every check below must see them. Relay its findings and its list of applied polish; do not re-review them. Its Blocking findings count toward the verdict. If it reports that it could not see the page, say so in the verdict: a code-only design pass is not the browser check `CLAUDE.md` asks for.

**If it applied any polish, stop here.** Show the user the diff of its edits and let them keep, change or discard them, and commit what they keep, before going on. Otherwise the checks below verify a working tree the PR will not contain.

## 3. bin/ci

    bin/ci

It runs `bin/setup --skip-server`, RuboCop over the whole repo, bundler-audit, the importmap audit and Brakeman — a superset of the GitHub Actions jobs, in about ten seconds. Report each step's result.

Two failures that are not the branch's fault: a Brakeman "not the latest version" failure (`bin/brakeman` runs `--ensure-latest`) and a fresh bundler-audit advisory. Both fail on `main` too. Say so, and offer the fix — `bundle update brakeman`, or a conservative update of the flagged gem — as its own PR rather than folding it in.

## 4. Specs

    bundle exec rspec

CI does not run specs, so this is the only place they run. With an empty suite it reports `0 examples`; say that, and say whether the change is one that ought to have added the first spec (`.claude/rules/specs.md`).

## 5. Review

Hand the diff to the `brutal-reviewer` agent. Relay its findings; do not re-review them yourself.

## 6. The checklist

Answer each, briefly:

- Was the change looked at in a browser, at phone width and desktop?
- Does new copy read in the site's voice, and is it flagged in the PR as a draft for the agency to read?
- Does anything new handle a visitor's personal data — and is it kept out of logs and URLs?
- Is this one concern, or has a side fix crept in that belongs in its own PR?
- Merging deploys to production. Is there anything here that should not go live the moment it merges?

## Reporting

Finish with a short verdict: ready, ready with notes, or not ready, and why. List what failed with its real output. If you skipped a step, say which and why.
