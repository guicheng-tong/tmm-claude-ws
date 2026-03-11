# Claude Workspace

A meta-repo template for organising team repositories and providing Claude Code with structured skills, agents, and conventions.

## Getting Started

1. Fork this workspace
2. Fill in the **Team Configuration** section in `CLAUDE.md` with your team's details
3. Update `agent_docs/aliases.md` with your team's repository and domain aliases
4. Place your repositories in `owned/`, `related/`, and `infra/`

## Features

### Documentation

Generates, reviews, and validates AI documentation (`CLAUDE.md`, `AGENTS.md`, `agent_docs/`) for repositories. Detects drift between docs and code, and can wire validation scripts into CI so builds fail on stale docs.

| File | Type |
|------|------|
| `agent_docs/aliases.md` | Reference doc |
| `.claude/agents/documentation-creator.md` | Agent |
| `.claude/agents/documentation-reviewer.md` | Agent |
| `.claude/agents/documentation-validator.md` | Agent |
| `.claude/skills/verify-docs/SKILL.md` | Skill |

### Planning & Project Management

Enforces a mandatory 8-phase implementation workflow (Context > Plan > Checklist > Git > Implement > Review > PR > CI > Request Review). Scaffolds project folders for multi-phase initiatives and produces structured, user-approved plans before any code is written.

| File | Type |
|------|------|
| `agent_docs/workflow/implementation.md` | Reference doc |
| `.claude/skills/create-plan/` | Skill |
| `.claude/skills/start-project/` | Skill |

### Code Quality & Review

Reviews diffs for correctness and regressions, investigates bugs by tracing code paths, writes tests in Groovy/Spock, and audits session interactions for anti-patterns.

| File | Type |
|------|------|
| `.claude/agents/code-reviewer.md` | Agent |
| `.claude/agents/debugger.md` | Agent |
| `.claude/agents/test-writer.md` | Agent |
| `.claude/skills/audit-anti-patterns/` | Skill |

### Git & PR Workflow

Manages the full lifecycle from commit to merge: enforces commit message format and branch safety, handles database migration conventions, creates PRs with template detection and Jira linking, polls CI with automatic flaky-test retries, and organises diffs for reviewer experience.

| File | Type |
|------|------|
| `agent_docs/git-conventions.md` | Reference doc |
| `agent_docs/database-migration.md` | Reference doc |
| `.claude/skills/create-pr/` | Skill |
| `.claude/skills/check-pr/` | Skill |
| `.claude/skills/review-pr/` | Skill |

### Workspace Configuration

Central configuration that all skills, agents, and docs reference. Defines team identity (`team_name`, `jira_project_key`, `jira_base_url`, `github_org`), folder conventions (`owned/`, `related/`, `infra/`), and tool permissions.

| File | Type |
|------|------|
| `CLAUDE.md` | Config |
| `.claude/settings.json` | Config |
