# Pitches

A pitch is the output of shaping a feature before anyone builds it. It is written with the `/shaper` skill, or by hand, and it is the shared context every builder reads afterwards.

One file per feature, `docs/pitches/<feature>.md`, with these sections:

1. **Problem.** Who is stuck, on what, in one paragraph. Name who: a prospective traveller, a returning client, or the agency.
2. **Appetite.** How much time this deserves. A number of days, not an estimate of how long it will take.
3. **Epicenter.** The one screen or action the feature cannot exist without.
4. **Storyboard.** Screen by screen from the epicenter outward: who is looking, on what device, what they see, what they do, what the site does — and what happens on the agency's side. Include the states nobody designs for: empty, one, many, error, a slow phone connection, a visitor deep-linked past the home page.
5. **Acceptance criteria.** Written as test names.
6. **Rabbit holes.** What looks small and is not. Here, look hard at anything that would be the app's first model, first sign-in, or first email; anything storing a visitor's personal data; anything a public form exposes to spam; content someone has to keep true; photography; and anything that cannot safely go live half-built, because merging to `main` deploys.
7. **No-gos.** What this deliberately does not do.
8. **Decisions touched.** The records in `docs/decisions.md` this depends on or would change.

A pitch that adds an admin screen, a setting, or a client login should say why something simpler — content in the repo, an email to the agency — was not enough.
