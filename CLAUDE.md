# Haven & Way

Haven & Way is a boutique travel agency's website: bespoke journeys planned one client at a time, for a deliberately small number of clients each year. The site's job is to make a prospective traveller feel understood and then get them to write in. Mike builds it; his wife runs the agency and is the person the copy, the destinations and the voice belong to. Rails 8.1, Ruby 3.4.4, PostgreSQL, HAML, Hotwire, Tailwind 4, deployed to Fly.io.

It is early. Today the whole site is one page, `app/views/pages/home.html.haml`, served by `PagesController#home`. There are no models and no app tables yet; `db/` holds only the Solid Cache, Queue and Cable schemas. The images are CSS gradient placeholders, the inquiry form posts to `"#"`, and the About and Stories links go nowhere. Treat the page as a design that is being made real, not as a finished site.

Work in flight is tracked on the Trello board [Haven&Way](https://trello.com/b/pVi8Q14I/havenway), in Mike's personal workspace; the card is the source of truth for what is being worked on and why. `docs/decisions.md` holds decisions as they get made. `docs/pitches/` holds shaped features.

## Running it

Ruby runs locally — there is no Docker in development.

    bin/dev                # the app on :3000, with the Tailwind watcher
    bin/rails c
    bin/ci                 # RuboCop, bundler-audit, importmap audit, Brakeman (~10 s)
    bundle exec rspec

Postgres is the local server on the default socket. `bin/setup` prepares the databases.

## The bar

Haven & Way should be built the way 37signals builds software: plain Rails, few moving parts, the simplest thing that does the job. The codebase is small enough that this is a rule here, not a direction. Prefer what Rails ships. A model with behaviour beats a service object; a partial beats a component framework; a Turbo Frame beats a Stimulus controller, which beats a JavaScript dependency.

Do not lecture about it. If something is in the way of the change at hand, say so in a sentence and carry on.

## The site is the brand

This is a luxury service sold on taste and trust, so the front end carries more weight than in most apps. The palette, type and spacing live in `app/assets/tailwind/application.css` as Tailwind 4 `@theme` tokens (`hw-*` colours, Cormorant Garamond / EB Garamond / Jost). Use the tokens; a raw hex in a view is a bug waiting to diverge. The copy is part of the product — it is written in a particular unhurried voice, and new copy should read as if the same person wrote it. Full rules in `.claude/rules/frontend.md`.

Most visitors will arrive on a phone from a link or a search. Design at phone width first.

## Verification

- Run `/preflight` before opening a PR. When the UI changed it first has the design-director agent review the page in the browser, then runs `bin/ci` and the specs, and hands the diff to the brutal-reviewer agent.
- CI is GitHub Actions (`.github/workflows/ci.yml`): `scan_ruby` (Brakeman, bundler-audit), `scan_js` (importmap audit) and `lint` (RuboCop). It runs no specs.
- `bin/brakeman` passes `--ensure-latest`, so CI goes red the day a new Brakeman ships, with no change to the app. The fix is `bundle update brakeman`, not a code change.
- Never state a test count you did not read from the run's output.
- Before claiming a UI change works, look at it in the browser, at phone width and at desktop.

## Working conventions

- Branch names are `<initials>_<trello_card_number>_<snake_case_description>`, from the card: `mp_12_inquiry_form_delivery`. `/start <card number>` creates the branch from the card. Initials come from `git config havenandway.initials`.
- Branch from `origin/main`. PRs target `main` and merge as merge commits.
- Every PR is linked from its Trello card with a `PR: <url>` comment posted when the PR opens. `/pr` does this.
- Merging to `main` deploys: `.github/workflows/fly-deploy.yml` runs `flyctl deploy` on every push. There is no staging. Do not merge without being asked.
- The board's lists follow the work: Story Time (ideas, and what `/shaper` works on) → Next (shaped, ready) → In Progress (`/start`) → In Review (PR open, `/pr`) → `Live - <Month> <Year>` (merged, which means deployed). When you merge a PR on request, confirm the deploy succeeded, then move its card to the current month's Live list, creating that list at the right end of the board if the month has turned.
- Commit messages are short, capitalised, imperative, no body unless the reason is not obvious.
- One concern per PR. A side finding gets its own PR.
- Dependabot opens weekly PRs for gems and GitHub Actions.

## Where things are

- Deployment is Fly (`fly.toml`, app `haven-and-way-jaunty-headland-2233`, region `ord`). The release command runs `bin/rails db:prepare`. Machines stop when idle (`min_machines_running = 0`), so the first request after a quiet spell is a cold start, and Fly logs a failed health check on every start because Rails takes about five seconds to boot.
- The deploy workflow authenticates with the `FLY_API_TOKEN` repo secret, a deploy-scoped token that **expires 2027-10-27**. After that every deploy fails with "no access token available" while the merge itself looks fine. Replace it with `flyctl tokens create deploy -a haven-and-way-jaunty-headland-2233 -x 8760h | gh secret set FLY_API_TOKEN`. A merge is not deployed until `gh run list --workflow fly-deploy.yml` says so.
- `config/deploy.yml` and `.kamal/` are the Rails generator's Kamal scaffolding with placeholder values. They are not how the site deploys.
- Production allows hosts in `config/environments/production.rb` and exempts `/up` for Fly's health check. A new domain goes there.
- Mailer links use `havenandway.com`; no SMTP is configured yet.
- Production's queue adapter is Solid Queue, but no worker runs on Fly: `SOLID_QUEUE_IN_PUMA` is set only in the unused Kamal config. Enqueued jobs never run until it is added to `fly.toml`.
- `bin/ci` and `config/ci.rb` are Rails 8's local CI runner and work as generated.
