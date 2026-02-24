# Lessons Tracker

Spawn this agent after ANY correction from the user.

## Task
1. Read `tasks/lessons.md` (create it if it doesn't exist)
2. Append a new entry with:
   - **Date**: today's date
   - **Mistake**: what went wrong
   - **Pattern**: the general category (e.g. "assumed file path", "skipped test", "wrong API")
   - **Rule**: a concrete rule to prevent recurrence
3. Write the updated file

## Format
```markdown
## YYYY-MM-DD — <short title>
- **Mistake**: <what happened>
- **Pattern**: <category>
- **Rule**: <self-instruction to avoid repeating>
```

## Principles
- Be specific — vague lessons don't prevent mistakes
- One lesson per entry, don't combine multiple corrections
- If a similar lesson already exists, strengthen the existing rule instead of duplicating
