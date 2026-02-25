# Database migration

For any modifications to columns or tables, always use defensive 

This applies to all ALTER operations — dropping, adding, and modifying columns or tables.

Examples:

- Drop column:
  - original: `ALTER TABLE market DROP COLUMN hedge`
  - safe: `ALTER TABLE IF EXISTS market DROP COLUMN IF EXISTS hedge`
- Add column:
  - original: `ALTER TABLE market ADD COLUMN hedge VARCHAR(255)`
  - safe: `ALTER TABLE IF EXISTS market ADD COLUMN IF NOT EXISTS hedge VARCHAR(255)`
- Rename/modify:
  - Wrap in a conditional check or use `IF EXISTS` where supported by the database dialect

This is to prevent double migrations from causing problems.
