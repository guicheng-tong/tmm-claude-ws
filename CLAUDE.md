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
The development cycle is as follows:
1. Plan changes and clarify requirements
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

## Additional Documentation
  You MUST read the relevant agent-docs/ file before performing these tasks:
  - planning.md - Before planning code changes
  - development.md - Before making code changes
  - testing.md - Before writing tests
  - pull-request.md - Before creating pull requests

