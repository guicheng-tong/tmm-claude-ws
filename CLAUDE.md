# Overview

This workspace is a meta-repo for team collaboration. It is organised as such:
- owned: This folder contains all repositories directly owned by the team
- related: This folder contains repositories not owned by the team, but with direct connections to team repositories
- infra: This folder contains repositories that provide infrastructure, indirectly used by the team
- projects: This folder contains md files for projects that are in progress.

## Team Configuration

Set these values for your team. All skills, agents, and docs reference them.

```yaml
team_name: <your team name>
jira_project_key: <Jira project prefix, e.g. PROJ>
jira_base_url: <Jira base URL, e.g. https://yourorg.atlassian.net>
github_org: <GitHub org name, e.g. yourorg>
```

## Repository-Level Documentation
Before exploring or searching a repository's code, first check for documentation at its root:
- `CLAUDE.md`, `README.md`, `AGENTS.md`, and `agent_docs/` in the target repository
- These files describe architecture, conventions, and domain context that will save unnecessary exploration
- Only fall back to broad codebase exploration if the docs don't answer your question

## Aliases

See `agent_docs/aliases.md` for team-specific aliases and domain terminology.

## Implementation workflow — MANDATORY
You MUST follow `agent_docs/workflow/implementation.md` before writing any code.
This applies to every task: features, bug fixes, refactors, config changes — no exceptions.

**When the user says "continue working on X":**
- This is NOT a shortcut to skip the workflow. It means "pick up where the last session left off."
- Still start at Phase 0 (load project context), then resume from the next incomplete phase.
- If there is no approved plan for the next piece of work, run Phase 1 (Plan & Scope) before coding.
- If there IS an approved plan and checklist, resume at Phase 4 (Implementation).

**Do NOT:**
- Skip straight to coding because "the task is obvious"
- Read the workflow doc and then ignore it
- Treat project familiarity as a substitute for following the phases

## Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution
- Subagent specifications live in `.claude/agents/` - read all the use cases for the agents, so you can use the correct subagent for each scenaril.

## Additional Documentation
  You MUST read the relevant agent_docs/ file before performing these tasks:
  - database-migration.md - Before writing any database migration files
  - git-conventions.md - Before any git commit or push
