# Implementation Workflow

Default workflow for implementation tasks. Read this at the start of any task involving code changes.

## Phase 0: Load Project Context

If the task relates to an existing project in `projects/`:
- Read `projects/README.md` for conventions
- Read the project's `PROJECT.md` for scope, affected repos, status, and decisions
- Read any active task checklists in the project's `tasks/` directory

If no existing project applies and the task is non-trivial (multi-phase, multi-repo, or multiple PRs):
- Create a new project using the `start-project` skill

This ensures continuity across sessions. Skip if the change is a one-liner or trivially scoped.

## Phase 1: Plan & Scope

Follow the `create-plan` skill process.

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

Follow the `create-pr` skill process.
- Base branch should be the one provided in Phase 3, do not prompt user
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

- Determine the repo owner (check CODEOWNERS, repo settings, or README)
- If the repo is owned by TMM: open the PR URL in the browser
- If the repo is owned by another team: comment `/request-review {team-name}` on the PR, then open the PR URL in the browser
- If there are multiple owning teams or ownership is unclear: ask the user which team to request review from, then comment `/request-review {team-name}`

**Skip if**: never — always required.

## Progress Tracking

- Mark checklist items in `tasks/todo-{plan}.md` as you go
- After completion, add a review section to the checklist file
