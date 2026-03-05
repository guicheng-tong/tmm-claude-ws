# Implementation Workflow

Default workflow for implementation tasks. Read this at the start of any task involving code changes.

## Phase 1: Plan & Scope

Follow the `create-plan` skill process. This covers:
- Determining project context (existing project, new project, or no project for simple changes)
- Clarification of goals, assumptions, and context
- Establishing a verification process (primarily tests)
- Scoping the implementation
- Finalising the plan into the appropriate location:
  - `projects/{project-name}/plans/` if using project structure
  - `plans/` for standalone plans


After the first draft of the plan is done, help user review the plan: 
  - Show the user each subsection. Do not attempt to group multiple subsections for one review.
  - User will comment on any refinement or modifications
  - After each comment from user to update the subsection, show the updated subsection and wait for more comments
  - Once user approves the subsection, move on to show the next one subsection

**Skip if**: the change is a one-liner or trivially scoped (e.g., fixing a typo, updating a config value).

**Gate: User must approve the plan before proceeding.**

## Phase 2: Create Checklist

- From the finalised plan, create a checklist file named `todo-{plan-name}.md`
- Save to the appropriate location:
  - `projects/{project-name}/tasks/` if using project structure
  - `tasks/` directory in the workspace root otherwise
- This is the implementation checklist used to track progress

**Skip if**: Phase 1 was skipped.

## Phase 3: Git Setup

- Ask the user if an existing worktree exists for the target repository
- If not, ask for the ticket number
- Ask the user for the base branch to be used later on in Phase 6
- Create worktree named `{repository-name}-TFXENG{ticket-number}-{short-description}`
- Keep the main repository on main/master branch and up to date

**Skip if**: never — always required.

**Gate: User must provide the ticket number.**

## Phase 4: Implementation

- Read `agent_docs/development.md` and follow the TDD approach
- Read `agent_docs/database-migration.md` if database migrations are involved
- Work through the checklist in `tasks/todo-{plan}.md`, marking items complete as you go
- Highlight what changed in each step
- Move to the next phase without user confirmation after completion

**Skip if**: never — always required for code changes.

## Phase 5: Self-Review

- Spawn the `code-reviewer` agent on the current branch's diff
- If verdict is **NEEDS CHANGES**: address the feedback and re-run the review
- Iterate until verdict is **PASS**
- Move to the next phase without user confirmation after completion

**Skip if**: the change is a one-liner or trivially scoped.

## Phase 6: Create PR

Follow the `create-pr` skill process. This covers:
- Base branch should be the one provided in Phase 3, do not prompt user
- Pre-PR checks (tests, lint, version bumps)
- Base branch detection and confirmation
- PR template selection and filling
- Commit message formatting
- PR creation via `gh pr create`
- Move to the next phase without user confirmation after completion

**Skip if**: never — always required.

## Phase 7: CI Check

- Run the `check-pr` skill process
- Handle failures:
  - **Flaky/unrelated failures**: re-run the failed jobs
  - **Related failures**: fix the issue and loop back to Phase 5
- If checks are still pending: wait 5 minutes (`sleep 300`), then re-run the entire `check-pr` skill process
- Repeat until all checks pass or a related failure needs user input
- Move to the next phase without user confirmation after completion

**Skip if**: never — always required.

## Phase 8: Request Review

- **TMM repos** : open the PR URL in the browser
- **Non-TMM repos**: comment `/request-review` on the PR, then open the PR URL in the browser

**Skip if**: never — always required.

## Progress Tracking

- Mark checklist items in `tasks/todo-{plan}.md` as you go
- After completion, add a review section to the checklist file
