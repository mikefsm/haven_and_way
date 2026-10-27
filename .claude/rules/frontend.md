---
paths:
  - "app/views/**"
  - "app/javascript/**"
  - "app/assets/**"
  - "app/helpers/**"
---

# Front end

HAML, Stimulus over importmap, Tailwind 4 through `tailwindcss-rails`. No component framework, no JavaScript build, no `node_modules`.

## Who is looking

Someone deciding whether to trust a stranger with a trip that matters to them — an anniversary, a sabbatical, the journey they have put off for ten years. Most arrive on a phone, from a link someone sent or a search. They are reading, not doing a task, and the site has one thing to ask of them: write in. Every screen should make that easier or get out of its way.

Design at 390 px wide first, then widen. The page today was drawn desktop-first and shows it: `px-13` gutters and the 72 px `text-hero` headline apply at every width, and the nav links are `hidden md:flex` with no menu to replace them on a phone. Fix what you touch; do not start a site-wide pass unasked.

## HAML, not ERB

Views are `.html.haml`. Write HAML.

**The arbitrary-value trap.** HAML parses `[` in the dot-class shorthand as the start of a Ruby array, so a Tailwind arbitrary value there is a runtime syntax error:

    %p.leading-[1.78]                     # syntax error at render
    %p{ class: "leading-[1.78]" }         # correct

The existing views put every class with an arbitrary value in `class: "..."` and keep dot-shorthand for plain utilities (`.w-9.h-px.bg-hw-gold`). Follow that. A hook warns when it slips.

## The theme

Tokens live in `app/assets/tailwind/application.css` under `@theme`, which is how Tailwind 4 is configured — there is no `tailwind.config.js`.

- **Colour.** `hw-bg`, `hw-bg-2`, `hw-bg-3` (warm parchment, light to deeper); `hw-dark`, `hw-dark-2`; `hw-ink`, `hw-ink-2`, `hw-ink-3` (text, strongest to quietest); `hw-gold`, `hw-gold-light`; `hw-cream`. Use them. A raw hex in a view is a finding; the hook flags it. The gradient `style:` attributes on the home page are placeholders standing in for photographs and are the one exception.
- **Type.** `font-display` (Cormorant Garamond) for headlines, usually with an italic light second line; `font-body` (EB Garamond) for prose; `font-ui` (Jost) for small uppercase labels, navigation and buttons, always with a `tracking-*` token.
- **Size.** The theme overrides Tailwind's scale: `text-xs` is 10 px, `text-sm` 11 px, `text-body` 16 px, `text-7xl` 48 px. Read the scale before picking a size; Tailwind's defaults are not what you get.
- **Motion.** `duration-fast`, `-base`, `-slow`, `-reveal`, `-xfade`. Scroll reveals use the `reveal` class with `data-controller="reveal"`, staggered with an inline `transition-delay`.

Hand-written CSS — keyframes, the nav's scrolled state, the hero slides — sits below the `@theme` block in the same file. Add there only what utilities cannot express. `app/assets/stylesheets/application.css` is the empty Propshaft manifest; leave it empty.

Tailwind rebuilds under `bin/dev`. Outside it, `bin/rails tailwindcss:build`.

## The house style

The page has a settled visual grammar. New sections should be built from it, not beside it:

- An eyebrow: a short gold rule (`.w-9.h-px.bg-hw-gold`) and a tiny uppercase `font-ui` label with `tracking-label`.
- A `font-display` headline in two lines, the second in light italic.
- Prose in `font-body` at `leading-[1.78]`, `hw-ink-2` on light, `hw-cream/55` on dark.
- Sections alternate `bg-hw-bg`, `bg-hw-bg-2` and `bg-hw-dark dark-texture`, with `py-24`.
- Buttons are square, uppercase `font-ui` with `tracking-cta`: solid `bg-hw-gold` for the primary action, a gold hairline border for the secondary.

## Partials, not components

When markup repeats — the three destination cards, the six "How We Work" steps — extract a partial and render it with a collection. There is no ViewComponent here and it should not be added for a site this size. When destinations become records, the partial is what renders them.

## JavaScript

Importmap and Propshaft. Stimulus controllers live in `app/javascript/controllers/` and are picked up by `pin_all_from`: `hero` (the slideshow), `nav` (the scrolled state), `reveal` (scroll-in). `hello_controller.js` is generator scaffolding.

Reach for a Turbo Frame or Stream before a Stimulus controller, and a Stimulus controller before anything else. Declare events with `data-action` in the markup. Respect `prefers-reduced-motion` for anything that moves on its own — the hero advances every five seconds and today does not check it.

## Copy

The copy is the agency speaking, and it has a voice: unhurried, specific, a little literary, first person plural, never salesy. "We read every message ourselves", not "Our team will respond within 24 hours". No exclamation marks, no "luxury", no "curated experiences". Specific places and sensory detail over adjectives.

The copy belongs to the person who runs the agency. Draft it when asked, match the voice, and say in the PR that it is a draft for her to read. Never invent facts about the business — years trading, client counts, testimonials, partnerships. The current testimonial and "Since 2009" are placeholder copy; do not repeat them elsewhere as if they were true.

The site is English only. There is no `t()` discipline and no locale files beyond the generated `en.yml`; write strings in the template.

## Images

When real photography arrives it replaces a gradient placeholder `div` with an `image_tag` that has a real `alt`, explicit dimensions or an aspect class so the layout does not shift, and `loading: "lazy"` below the fold. Active Storage and `image_processing` are installed if images come from an admin rather than the repo.

## Verifying

Before reporting a UI change done, open it in the browser at 390 px and at desktop width and look at it.
