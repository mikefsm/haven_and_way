---
paths:
  - "db/**"
---

# Migrations

The app has no tables of its own yet. `db/cache_schema.rb`, `db/queue_schema.rb` and `db/cable_schema.rb` belong to the Solid gems; do not hand-edit them. The first `bin/rails g migration` creates `db/schema.rb` and `db/migrate/`.

- Never edit `db/schema.rb` by hand. Run the migration and commit the regenerated file; `git diff db/schema.rb` should show only your change.
- Every migration is reversible — `change` with reversible operations, or explicit `up` and `down`.
- A required `belongs_to` gets a `NOT NULL` and a foreign key, not only the model's default presence check.
- Schema changes and data changes are separate migrations.
- Fly's release command runs `bin/rails db:prepare` before the new machines take traffic, so a migration ships with the deploy that merges it. A failed migration fails the deploy and leaves the old release serving.
