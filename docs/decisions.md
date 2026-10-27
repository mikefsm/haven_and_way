# Haven & Way — Decision Record

**What this is:** decisions and their reasons, recorded as they are made. A record says what was decided, why, and what it rules out. Number them within a section and cite them from code comments and pitches the way `(decisions 1.2)` reads.

Related: `docs/pitches/` for shaped features.

---

## 1. Working with agents

### 1.1 The Claude setup follows ResNet's, cut to the size of this app

*2026-10-26.* The `.claude/` directory is modelled on ResNet's: `CLAUDE.md` kept short, conventions in path-scoped `.claude/rules/`, `/preflight` and `/pr` skills, a `/shaper` skill with its `pitch-researcher`, and `brutal-reviewer` and `design-director` agents.

What was left out, and why:

- **The Docker guard hook.** Ruby runs locally here and `bin/ci` passes natively.
- **Tenancy and i18n rules, and the locale parity hook.** There is one site, one tenant and one language.
- **`/start` and Trello linking.** There is no board; work in flight is the open PRs.
- **Worktrees.** One person works on the site at a time.
- **The performance agent.** A static page has nothing to measure yet. Revisit when there is a database behind a page.
- **ViewComponent and Lookbook duties** in the design director. The site uses partials (decisions 2.1).

Rules out: carrying ResNet process into this app for its own sake. Add a piece back when this app grows the problem it solves.

### 1.2 Conventions live in `.claude/rules/`, not in one long file

*2026-10-26.* Four rule files (frontend, rails-style, specs, migrations) each declare a `paths:` glob, so Claude Code loads a rule when it reads a file the rule governs. That keeps `CLAUDE.md` to what every session needs.

---

## 2. Building the site

### 2.1 Plain Rails, the 37signals way — as a rule, not a direction

*2026-10-26.* ResNet treats 37signals-style simplicity as a direction because it carries years of history. Haven & Way has none, so here it is the rule: no `app/services`, no ViewComponent, models with behaviour, REST resources, what Rails ships before a gem. Repeated markup becomes a partial.

Rules out: service objects, component frameworks, and JavaScript dependencies added "for later".

### 2.2 Merging to `main` is deploying

*2026-10-26.* `.github/workflows/fly-deploy.yml` deploys every push to `main` to Fly, and there is no staging. Agents never merge without being asked, and a feature that cannot safely be live half-built stays on its branch or behind an unlinked route until it is whole.
