---
name: start
description: Start work on a Haven & Way Trello card — read the card, create its branch with the right name, move the card to In Progress, and bring the card's problem statement into the session as the reason for the work. Use when the user says to start, pick up, or work on a card by number or URL.
user-invocable: true
---

The Trello card is the source of truth for what is being worked on. This skill turns a card into a branch whose name, and whose sense of why, both come from the card rather than from memory.

The board is [Haven&Way](https://trello.com/b/pVi8Q14I/havenway) (`ari:cloud:trello::board/workspace/608b047fb7746b398c84bfd2/6ae012905d0be1e045bc6f98`).

## 1. Find the card

The argument is a card number (`12`) or a card URL.

- A URL: `trelloReadCard` with `action: "get"`.
- A number: `trelloSearch` with `action: "search_cards"`, the number as the query, and `boardIds` set to the board ARI above. Search matches text as well as numbers, so **confirm the hit by its URL**: a card's number is the slug prefix, `https://trello.com/c/<shortLink>/12-...`. A result without that prefix is not the card. Small numbers match a lot of text; if search does not turn it up, list the board's cards with `trelloReadCard` `action: "list_by_board"` and find the URL with that prefix. If nothing matches, say so and ask for the URL. Never guess.

Read the card's description and its comments. Comments often carry the decision that changed the scope after the card was written.

## 2. Say what it is

Tell the user in a few sentences: the card's title, the list it sits in, and the problem as the card states it. If the card is in `In Review` or a `Live -` list, the work may already be done, so say so and ask before going on. If it is in `Story Time`, it has not been shaped; say so, and offer `/shaper` before building.

Name anything the card leaves open that would change what gets built, as questions. Do not start designing yet.

## 3. Create the branch

Check first:

- **Is there already a branch for this card?** Run `git fetch --quiet origin`, then `git branch -a --list '*_<number>_*'`. If one exists, switch to it rather than creating a second.
- **Are initials set?** Run `git config --get havenandway.initials`. If it is empty, stop and ask the user to run `git config havenandway.initials <xx>`. Do not guess them.
- **Is the working tree clean?** If `git status --short` shows changes, stop and ask what to do with them rather than carrying them onto the new branch.

Then branch from the remote, not from a local `main` that may be stale:

    git switch -c <initials>_<number>_<description> origin/main

The description is three to five words from the card title, lowercased and joined with underscores: card 12 "Deliver inquiry form to the agency inbox" gives `mp_12_inquiry_form_delivery`.

## 4. Move the card

Move it to `In Progress` with `trelloWriteCard`, `action: "move"`. This is standing practice on this board, so do it without asking. Never move a card to a `Live -` list from here.

## 5. A design brief, if the card touches the site

If the work will change what a visitor sees — a new or changed page, section, form, email, or image — hand the card to the `design-director` agent in **brief** mode before any code is written. Give it the card URL, its description and the comments that matter, and any Figma link they carry. It writes `tmp/design_brief.md`, which its review grades against.

Relay its brief, including its open questions. Skip this for back-end-only cards and say you skipped it.

## 6. Keep the card's words

The card's problem statement is the **Why** that `/pr` will write later. Keep it with the card URL, so the PR body can link the card and cite it instead of paraphrasing from memory.
