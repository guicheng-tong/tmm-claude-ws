# Overview

This workspace contains source code of several services for development of TMM (treasury money movement) team in Wise. It is organised as such:
- tmm-repos: This folder contains all services directly owned by TMM
- relevant-repos: This folder contains services not owned by TMM, but might have some direct connection to TMM services, such as payout-service being used by TMM services for payouts
- infra-repos: This folder contains services that provide infrastructure, and indirectly are related to TMM services, such as configurations for kubernetes setup
- plans: This folder contains md files for projects that are in progress. 

## Aliases
- UI - treasury
- OMS - order-management
- MC - market-connector
- BSS - bank-scraper-service
- trxinv - transactions-inventory

## Domain aliases
- MO - market order
- trade - market order or NDF
- IT - internal transfer
- NDF - non-deliverable forward
- POI - payout instruction

## Development cycle
When dealing with code development, always begin in planning mode. Do not implement any changes until prompted by the user.
1. Use the `/create-plan` skill to create a plan for the changes
2. Write tests for verification that feature is implemented correctly
3. Implement code changes
4. Verify that test passes, otherwise go back to implementation
5. Create pull request and publish it

## Tool Preferences

**Always prefer Claude Code's native tools over bash equivalents:**

| Instead of | Use |
|------------|-----|
| `bash grep`, `bash rg` | `Grep` tool (supports `-A`, `-B`, `-C` context, `head_limit`, `glob` filters) |
| `bash cat`, `bash head`, `bash tail` | `Read` tool (supports `offset` and `limit` parameters) |
| `bash find` | `Glob` tool (supports patterns like `**/*.java`) |

**Why**: Native tools don't require bash permissions, avoid permission prompts for piped commands, and provide structured output optimized for Claude's processing.

**When bash is still appropriate**:
- Commands with no native equivalent (git, gradlew, docker, gh, etc.)
- Complex shell operations that genuinely require piping between multiple commands
- System operations (mkdir, rm, etc.)

## Assumptions
If you're making assumptions about codebase structure or making guesses, explicitly flag them as assumptions
Ask the user questions if there are assumptions or hypothesis made.

For any task that involves more than 2 files or has multiple possible approaches, briefly state your intended approach and ask if it aligns with my expectations before starting

## Directory
When entering a directory, ensure that you are on main or master branch, and that latest changes are pulled.

## Additional Documentation
  You MUST read the relevant agent_docs/ file before performing these tasks:
  - development.md - Before making code changes
  - testing.md - Before writing tests
  - pull-request.md - Before creating pull requests
  - database-migration.md - Before writing any databse migration files
