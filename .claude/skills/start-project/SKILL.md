---
name: start-project
description: |
  Create a new project folder structure to organize plans, investigation notes, tasks, and verification artifacts for a feature or initiative.
---

# Start Project

This skill creates a structured project folder for organizing all artifacts related to a feature, initiative, or complex change.

**Important**: Before using this skill, read `projects/README.md` for project structure conventions and best practices.

## When to Use

Use this skill when:
- Starting a new feature that will span multiple phases or PRs
- Working on a complex change that requires investigation, planning, and tracking
- The work affects multiple repositories (e.g., backend + frontend)
- You need to organize multiple related plans, tasks, and notes

Do NOT use for:
- Simple one-off changes (typo fixes, config updates)
- Work that's already tracked in the flat `plans/` directory (unless migrating)

## Instructions

### 1. Gather Project Information

Ask the user for:
- **Project name**: Feature or initiative name (kebab-case, e.g., "trade-confirmation-blocklist")
- **Overview**: Brief description of what this project achieves and why it matters
- **Ticket(s)**: Jira ticket IDs (e.g., TFXENG-8405)

### 2. Create Project Directory Structure

Create the following structure in `projects/{project-name}/`:

```
projects/{project-name}/
├── PROJECT.md              # Project overview and status tracker
├── investigation/          # Pre-planning research and exploration (Planning phase)
├── plans/                  # Implementation plans and designs (Planning phase)
├── tasks/                  # Work-in-progress checklists (Implementation phase)
├── deployment/             # Deployment notes, rollout plans, config changes (Deployment phase)
└── testing/                # Test results, verification checklists (Testing phase)
```

### 3. Create PROJECT.md

**Important**: Follow the conventions in `projects/README.md` when creating the Status section.

Use this template for `PROJECT.md`:

```markdown
# {Project Name}

## Overview
{Brief description from user}

## Ticket(s)
- {TICKET-ID}: {Link to ticket}

## Affected Repositories
{Leave empty — populated automatically during planning and implementation}

## Status
### Planning
- [ ] Investigation & research
- [ ] Create implementation plan
- [ ] Plan review & approval

### Implementation
{List PRs by repo with format: {Repo} PR #{number} - {description}}
- [ ] {Repo} PR - {Description of changes}

### Deployment
{List PRs with format: Deploy {Repo} PR #{number} - {description}}
{Add (depends on {PR}) for deployment dependencies}
- [ ] Deploy {Repo} PR - {Description}

### Testing
{High-level phases only}
- [ ] Manual testing in staging
- [ ] Monitoring and feedback from Ops

## Key Decisions
{Leave empty - to be filled during planning and implementation}

## Links
{Leave empty - to be filled as artifacts are created}
```

### 4. Create Subdirectory READMEs

Create a brief README.md in each subdirectory explaining its purpose:

**`investigation/README.md`**:
```markdown
# Investigation Notes

**Phase: Planning**

This directory contains pre-planning research, codebase exploration findings, and debugging notes collected before formal planning begins.

Add files here when:
- Exploring how existing code works
- Investigating root causes of bugs
- Analyzing integration points between systems
- Documenting current behavior before changes
```

**`plans/README.md`**:
```markdown
# Implementation Plans

**Phase: Planning**

This directory contains implementation designs, architectural decisions, and scoping documents.

Files here should:
- Define goals, assumptions, and context
- Specify verification approach (tests)
- Detail implementation steps
- Break complex changes into phases
- Document key architectural decisions
```

**`tasks/README.md`**:
```markdown
# Task Checklists

**Phase: Implementation**

This directory contains work-in-progress checklists used to track implementation progress.

Files follow the format: `todo-{plan-name}.md`

Each checklist:
- Is derived from a finalized plan
- Contains checkboxes for each implementation step
- Is updated as work progresses
- Links back to the relevant plan file
```

**`deployment/README.md`**:
```markdown
# Deployment Artifacts

**Phase: Deployment**

This directory contains deployment plans, rollout strategies, configuration changes, and deployment notes.

Add files here for:
- Deployment order and sequencing (especially for multi-repo changes)
- Environment-specific configuration changes
- Database migration notes
- Feature flag configurations
- Rollback plans
- Post-deployment verification steps
```

**`testing/README.md`**:
```markdown
# Testing Artifacts

**Phase: Testing**

This directory contains test results, verification checklists, and production validation notes.

Add files here for:
- Unit/integration test results
- Manual test execution checklists
- Staging environment verification
- Production smoke test results
- Performance testing results
- Monitoring dashboards and alerts setup
```

### 5. Confirm with User

Show the user:
- The created directory structure
- The populated PROJECT.md
- Reference to conventions: "See `projects/README.md` for project conventions and best practices."
- Next steps: "You can now start investigation or planning. When ready, use the `create-plan` skill to begin Phase 1."

### 6. Update Git

If the `projects/` directory doesn't exist yet, ensure it's tracked in git:
- Create `projects/.gitkeep` if needed
- Do NOT commit the new project folder yet - let the user decide when to commit
