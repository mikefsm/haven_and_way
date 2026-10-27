---
name: pr
description: Open a Haven & Way pull request with a body that says why, what changed, how it was verified, and what was deliberately left out. Runs preflight first unless it has already run. Use when a branch is ready to open or update a PR.
user-invocable: true
---

Open or update a PR on `mikefsm/haven_and_way`.

Run `/preflight` first unless it has already run in this session and nothing has changed since. Do not open a PR on top of a failing check without saying so in the body.

## Title

A sentence describing what the change does, capitalised. `Send inquiries to the agency inbox`, not `inquiry-form` — GitHub offers the branch name as the title and it reads badly in the history.

## Base branch

`main`.

## Body

Long-form prose with these sections:

**Why.** The problem, in terms of the site's visitors or the agency. A reader who was not in the conversation should understand the motivation without asking.

**What changed.** What a reviewer should look at and in what order. Name the files that carry the substance; skip the ones that are consequences. If a decision in the diff could reasonably have gone another way, say why it went this way.

**Verification.** What was actually run and what it said, read from the output — `bin/ci`'s steps, the spec count. If something was not run, say so here rather than leaving it implied. For a UI change, say it was looked at in the browser at phone width and desktop, and attach screenshots of both.

**Copy for review.** Any visitor-facing words this PR adds or changes, quoted, so the person who runs the agency can read them without reading the diff. Omit the section if there are none.

**Not built.** What was deliberately left out and why. Side findings that belong in their own PR go here, named, so they are not lost.

## Before you open it

- One concern per PR. If a side fix crept in, offer to pull it out.
- Confirm the diff contains nothing accidental: no scratch files, no `debugger`, no commented-out block left behind, no `.env`, credential or master key change.

## After

Check whether the branch already has a PR:

    gh pr view --json number,baseRefName

If it does, update it in place — a new body, and `--title` only if the title was wrong:

    gh pr edit <number> --body-file <file>

If it does not:

    gh pr create --base main --title "..." --body-file <file>

Report the URL.

Merging is not the next step. Merging to `main` deploys to production through `fly-deploy.yml`, so the merge is the user's call. Say that the PR is ready to merge when CI is green, and leave it there.
