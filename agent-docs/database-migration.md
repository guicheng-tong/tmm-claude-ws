# Database migration

For any modifications to columns or tables, always use `IF EXISTS`.

Example: 

- original migration: `ALTER TABLE market DROP COLUMN hedge`
- safe migration: `ALTER TABLE IF EXISTS market DROP COLUMN IF EXISTS hedge`

This is to prevent double migrations from causing problems.
