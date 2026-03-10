# Overview

This workspace is a meta-repo for TMM team. It is organised as such:
- tmm-repos: This folder contains all repositories directly owned by TMM
- relevant-repos: This folder contains repositories not owned by TMM, but might have some direct connection to TMM repositories, such as payout-service
- infra-repos: This folder contains repositories that provide infrastructure, and indirectly are used by TMM, such as configurations for kubernetes setup
- projects: This folder contains md files for projects that are in progress.

## Repository-Level Documentation
Before exploring or searching a repository's code, first check for documentation at its root:
- `CLAUDE.md`, `README.md`, `AGENTS.md`, and `agent_docs/` in the target repository
- These files describe architecture, conventions, and domain context that will save unnecessary exploration
- Only fall back to broad codebase exploration if the docs don't answer your question

## Aliases
- UI - treasury
  - LD - liquidity dashboard
- OMS - order-management
- MC - market-connector
- BSS - bank-scraper-service
- trxinv - transactions-inventory
- TMM - Treasury Money Movement

## Domain aliases
- MO - market order
- trade - market order or NDF
- IT - internal transfer
- NDF - non-deliverable forward
- POI - payout instruction
- LP - liquidity provider
- VD - value date

## Implementation workflow — MANDATORY
You MUST start each session following `agent_docs/workflow/implementation.md`.
This applies to every task: features, bug fixes, refactors, config changes — no exceptions.
Do NOT skip straight to coding. The first step is always Phase 1: Plan & Scope.

## Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution
- Subagent specifications live in `.claude/agents/` - read all the use cases for the agents, so you can use the correct subagent for each scenaril.

## Additional Documentation
  You MUST read the relevant agent_docs/ file before performing these tasks:
  - database-migration.md - Before writing any database migration files
