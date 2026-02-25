# Implementation Workflow

Default workflow for implementation tasks. Read this at the start of any task involving code changes.

## Phase 1: Plan & Scope

Follow the `create-plan` skill process. This covers:
- Clarification of goals, assumptions, and context
- Establishing a verification process (primarily tests)
- Scoping the implementation
- Finalising the plan into a file in `plans/`

**Skip if**: the change is a one-liner or trivially scoped (e.g., fixing a typo, updating a config value).

**Gate: User must approve the plan before proceeding.**

## Phase 2: Create Checklist

- From the finalised plan, create `tasks/todo-{plan}.md`
- This is the implementation checklist used to track progress

**Skip if**: Phase 1 was skipped.

## Phase 3: Worktree Setup

- Ask the user if an existing worktree exists for the target repository
- If not, ask for the ticket number
- Create worktree named `{repository-name}-TFXENG{ticket-number}-{short-description}`
- Keep the main repository on main/master branch and up to date

**Skip if**: never — always required.

**Gate: User must provide the ticket number.**

## Phase 4: Implementation

- Read `agent_docs/development.md` and follow the TDD approach
- Read `agent_docs/database-migration.md` if database migrations are involved
- Work through the checklist in `tasks/todo-{plan}.md`, marking items complete as you go
- Highlight what changed in each step

**Skip if**: never — always required for code changes.

## Phase 5: Self-Review

- Spawn the `code-reviewer` agent on the current branch's diff
- If verdict is **NEEDS CHANGES**: address the feedback and re-run the review
- Iterate until verdict is **PASS**

**Skip if**: the change is a one-liner or trivially scoped.

## Phase 6: Create PR

Follow the `create-pr` skill process. This covers:
- Pre-PR checks (tests, lint, version bumps)
- Base branch detection and confirmation
- PR template selection and filling
- Commit message formatting
- PR creation via `gh pr create`

**Skip if**: never — always required.

**Gate: User must confirm the base branch (handled by the create-pr skill).**

## Phase 7: CI Check

- Run the `check-pr` skill process
- Handle failures:
  - **Flaky/unrelated failures**: re-run the failed jobs
  - **Related failures**: fix the issue and loop back to Phase 5
- If checks are still pending: wait 5 minutes (`sleep 300`), then re-run `check-pr`
- Repeat until all checks pass or a related failure needs user input

**Skip if**: never — always required.

## Phase 8: Request Review

- **TMM repos** (treasury, order-management, market-connector, bank-scraper-service, transactions-inventory): open the PR URL in the browser
- **Non-TMM repos**: comment `/request-review` on the PR, then open the PR URL in the browser

**Skip if**: never — always required.

## Progress Tracking

- Mark checklist items in `tasks/todo-{plan}.md` as you go
- After completion, add a review section to the checklist file
- Capture lessons in `tasks/lessons.md` after any corrections from the user
