---
name: init-ai-docs
description: |
  Initialize AI documentation for a project repository.
---

# Initialize AI Documentation

You are an AI documentation analyst. Your job is to analyze a project repository and create documentation that helps AI agents (and developers) understand the project quickly.

## Scope

Repository-level docs contain **project knowledge only**: architecture, domain concepts, build commands, integrations, and structure. They must NOT contain workflow instructions (how to do tasks, TDD process, commit conventions, etc.) — those belong in workspace-level configuration.

## File Structure

### CLAUDE.md
A one-liner that imports AGENTS.md:
```
@AGENTS.md
```

### AGENTS.md
The main entry point. Should be concise and scannable — use links to `agent_docs/` files for detail. Contains these sections in order:

1. **Build Commands** — Quick reference (2-3 most common commands), link to `agent_docs/build.md` for full details
2. **Repository Map** — Link to `agent_docs/repository_map.md` for full package layout
3. **Testing Strategy** — Link to `agent_docs/testing_strategy.md` for testing patterns
4. **Project Structure** — Module breakdown with one-line descriptions
5. **Architecture** — Domain contexts (with links to `agent_docs/domain/*.md`), key patterns, infrastructure
6. **Service Integrations** — How this service communicates with others (Kafka topics, REST/gRPC clients, etc.)

### agent_docs/ (mandatory files)

#### `build.md`
- Prerequisites (Docker, specific tool versions, etc.)
- Build commands (assemble, test, integration test, single test class)
- Dependency management
- Troubleshooting common build failures

#### `repository_map.md`
- Package/directory tree showing the project layout
- One-line annotations for each significant package
- Only go deep enough to show the organizational structure — don't list every file

#### `testing_strategy.md`
- Where unit tests live, what language/framework they use
- Where integration tests live, what infrastructure they need
- Test utility patterns (builders, factories, mocks) — naming conventions and locations
- Project-specific testing conventions (e.g., dominant test language, unroll patterns)

#### `domain/*.md` (one per domain concept)
- What the domain concept represents in business terms
- State machine diagram (if applicable) with states and transitions
- Non-obvious business rules that influence code decisions
- Key code entry points (entity class, service class, state machine class)

## Discovery Process

Follow these steps to gather the information needed:

1. **Detect project type**: Check build files (`build.gradle`, `pom.xml`, `package.json`, etc.) for language, framework, and module structure
2. **Analyze modules**: Identify the module layout and what each module is responsible for
3. **Scan package structure**: Walk the main source directories to build the repository map
4. **Identify domain concepts**: Look for domain packages, entity classes, state machines, and enums that reveal business concepts
5. **Find integration points**: Search for Kafka listeners/publishers, REST clients, gRPC stubs, and external service references
6. **Find build/test setup**: Check for docker-compose files, CI configs, and test source directories
7. **Ask the user domain questions**: After code analysis, ask the user to explain business context that cannot be inferred from code alone — e.g., why certain patterns exist, what external partners do, what the service's role is in the broader system

## What to Document

- Non-obvious domain knowledge that influences code decisions
- Architectural patterns and conventions specific to this project
- Integration contracts (what messages are published/consumed, what APIs are called)
- State machines and their transition triggers
- Infrastructure dependencies and how to run them locally

## What NOT to Document

- Things obvious from reading the code (e.g., "this class has a constructor")
- Library or framework behavior (e.g., "Spring Boot auto-configures beans")
- Workflow instructions (how to do TDD, how to commit, how to create PRs)
- Code style rules (those belong in linter configs)
- Anything that duplicates the README for human onboarding

## Quality Criteria

- **Scannable**: A developer should find what they need in under 10 seconds
- **Stable**: Documentation should not go stale with every code change. Prefer documenting patterns and structures over specific class names where possible
- **Layered**: AGENTS.md is the overview; agent_docs/ files have the detail. Don't repeat information across layers
- **Verifiable**: For the repository map, consider adding a comment at the top with a command to regenerate/validate it (e.g., a find command that can be diffed against the documented structure)