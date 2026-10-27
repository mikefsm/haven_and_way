---
paths:
  - "spec/**"
---

# Tests

RSpec, run locally with `bundle exec rspec`. `.rspec` requires `spec_helper`; a spec that touches Rails requires `rails_helper` on its first line.

The suite is empty today: `spec/` holds only the two helpers, and CI does not run specs. That makes the first specs the ones that set the pattern, so set it well.

## Which kind

In order of preference:

- **Request spec** for a controller: what it renders, what it saves, where it redirects. Most of this site — pages and a form — is covered this way.
- **Model spec** for model behaviour.
- **Mailer spec** for what an email says and who it goes to.
- **System spec** only for behaviour that needs a browser: a Stimulus controller, a Turbo interaction. None of the current JavaScript is worth one yet.

A system spec for something a request spec can see is the default mistake. Do not make it.

## Harness

- `use_transactional_fixtures` is on. There are no factories and no fixtures yet. Prefer Rails fixtures in `spec/fixtures/` when records arrive — they are what Rails ships, and a site this size does not need FactoryBot.
- Time: `travel_to` from `ActiveSupport::Testing::TimeHelpers`. Mail: `ActionMailer::Base.deliveries` and `have_enqueued_mail`.

## CI

Adding the first meaningful spec is the moment to add `bundle exec rspec` to `config/ci.rb` and a `test` job (with a Postgres service) to `.github/workflows/ci.yml`. Do it in its own PR.
