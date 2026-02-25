# Overview

This workspace contains source code of several services for development of TMM (treasury money movement) team in Wise. It is organised as such:
- tmm-repos: This folder contains all services directly owned by TMM
- relevant-repos: This folder contains services not owned by TMM, but might have some direct connection to TMM services, such as payout-service being used by TMM services for payouts
- infra-repos: This folder contains services that provide infrastructure, and indirectly are related to TMM services, such as configurations for kubernetes setup
- plans: This folder contains md files for projects that are in progress. 

## Aliases
- UI - treasury
  - LD - liquidity dashboard
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
- LP - liquidity provider
- VD - value date

## Workflow Orchestration

### 1. Plan Mode Defaults
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution
- Subagent specifications live in `.claude/agents/` — use them when available

### 3. Self-Improvement Loop
- After ANY correction from the user: spawn the `lessons-tracker` subagent to update `tasks/lessons.md`

## Core Principles
- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Chainsaw. Not flamethrower. Surgical. Avoid introducing bugs.

## Bash Usage
- Do not use pipe or `&&` in bash commands unless absolutely necessary
- Native tool redirection is enforced by the `redirect-to-native-tools` hook — no need to memorize the table

## Additional Documentation
  You MUST read the relevant agent_docs/ file before performing these tasks:
  - implementation-workflow.md - MUST read at the start of any implementation task. Defines the default end-to-end workflow.
  - development.md - Before making code changes
  - database-migration.md - Before writing any database migration files
