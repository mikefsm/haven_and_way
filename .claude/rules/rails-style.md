---
paths:
  - "app/**"
  - "lib/**"
  - "config/routes.rb"
---

# Ruby and Rails style

The 37signals way, applied for real: this codebase is new and small, so there is no legacy to accommodate. The brutal reviewer cites this file.

## Shape

- **Rich models, thin controllers.** Behaviour lives on the record it belongs to. A controller authorizes, finds, hands off to the model, and redirects or renders.
- **No `app/services`.** A multi-step operation is a method on the model it centres on, or a plain object under `app/models` named for what it is (`Inquiry::Notification`, not `SendInquiryService`). Concerns name a capability and are included where that capability is needed — not a place to move code so a file gets shorter.
- **REST all the way down.** A new action that is not one of the seven is usually a new resource: `resource :publication` under a trip, not `post :publish`.
- **Prefer what Rails ships.** Action Mailer, Active Storage, Solid Queue, Action Text, `has_secure_password` and the Rails 8 authentication generator before any gem. A new gem is a decision: record it in `docs/decisions.md` with what it replaces.

## Jobs and mail

Solid Queue runs inside Puma in production (`SOLID_QUEUE_IN_PUMA`). Send mail with `deliver_later`. A job takes ids, not objects. Recurring work goes in `config/recurring.yml`, which is version-controlled — prefer it over any external scheduler.

No SMTP is configured yet. Anything that sends mail needs that settled first, and the credentials go in `bin/rails credentials:edit`, never in the repo.

## Inquiries are personal data

The inquiry form is the site's reason to exist, and what it collects — names, emails, where someone wants to go and why — belongs to real people. Do not log it (`filter_parameter_logging.rb` already filters `email`; add new sensitive fields there), do not put it in URLs, and protect the form from spam with something Rails-native (an invisible honeypot field, `rate_limit` in the controller) before reaching for a CAPTCHA gem.

## Comments

Full sentences that give the reason. Never a comment that restates what the code does.

## Ruby

RuboCop is `rubocop-rails-omakase`, unmodified: double-quoted strings, spaces inside array brackets (`[ :a, :b ]`), no trailing-comma rule. `bin/rubocop -a` fixes most offences. Do not add house overrides to `.rubocop.yml` without a reason recorded in `docs/decisions.md`.
