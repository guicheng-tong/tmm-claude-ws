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

## File Naming Convention

Some repositories have non-standard Flyway version numbering due to historical drift. **Always check the target repo's `agent_docs/database-migration.md`** for repo-specific naming rules before creating a migration file.

Known repos with non-standard prefixes:
- **transactions-inventory**: The version prefix has drifted from the actual calendar year. Check the highest existing version in `service/src/main/resources/db/migration/` and use that prefix with the current month and day (e.g., if the highest prefix is `V2226` and today is 2026-03-10, use `V2226_03_10__description.sql`, not `V2026_03_10__...`). Do **not** use the actual calendar year as the prefix — it will sort before existing migrations and cause Flyway validation failures.
