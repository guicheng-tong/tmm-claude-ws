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

### 3. Self-Improvement Loop
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself to avoid the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for every relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main or master and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

## Task Management

1. **Plan First**: Use `/create-plan` to create a plan.
2. **Create checklist**: Using the plan from before, create a checklist in `tasks/todo-{plan}.md`
3. **Begin Implementation**: Begin implementation based on the checklist
4. **Track Progress**: Mark items complete as you go
5. **Explain Changes**: Highlight what changed in each step
6. **Document Results**: Add review section to `tasks/todo-{plan}.md`
7. **Capture Lessons**: Update `tasks/lessons.md` after corrections

## Core Principles
- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Chainsaw. Not flamethrower. Surgical. Avoid introducing bugs.

## Skill Usage
- Always use `/create-pull-request` skill for creating pull requests

## Git worktree
When making changes to a repository, always ask if there is an existing worktree for it, if not, create a new worktree for it and ask user for ticket number, format the worktree name as `{repository-name}-TFXENG{ticket-number}-{short-description}`. The main repository should always be kept as the main or master branch and kept up to date.

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
  You MUST read the relevant agent_docs/ file before performing these tasks:
  - development.md - Before making code changes
  - testing.md - Before writing tests
  - database-migration.md - Before writing any databse migration files
