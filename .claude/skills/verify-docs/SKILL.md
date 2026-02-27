---
name: verify-docs
description: |
  Verify that CLAUDE.md, AGENTS.md, and agent_docs/ documentation is up to date with code changes on the current branch. Evaluates documentation quality (usefulness, staleness risk) and suggests new documentation for significant code changes. Outputs a review file to .tmp/ with the result.
---

# Documentation Verification

This skill checks whether documentation (CLAUDE.md, AGENTS.md, agent_docs/) is up to date with the code changes on the current branch. It also evaluates documentation quality and identifies code changes that should be documented.

## Documentation Philosophy

Good AI-agent documentation has these properties:

- **Captures intent and "why"** — not implementation details an agent can read from code
- **Describes stable concepts** — domain models, architectural decisions, workflows, integration boundaries
- **Avoids restating code** — don't document method signatures, class names, or file paths that will change with refactors
- **Stays high-level where possible** — prefer "orders go through these states" over "OrderStatus enum has these values at line 42"

Documentation that merely mirrors code structure adds maintenance cost without value. Documentation that captures decisions, domain rules, and non-obvious behaviour stays useful as code evolves.

## Instructions

### 1. Determine context

- Get the current working directory and identify the repository name
- Get the current branch name and HEAD commit hash
- Identify the workspace root (the claude-ws directory)

### 2. Compute the diff

- Find the remote tracking branch (e.g., `origin/main` or `origin/master`)
- Compute the diff of all commits on the current branch vs the remote tracking branch:
  ```
  git diff <remote-tracking-branch>...HEAD
  ```
- Also get the list of changed files:
  ```
  git diff --name-only <remote-tracking-branch>...HEAD
  ```
- If there is no remote tracking branch, diff against `origin/main` or `origin/master`

### 3. Find documentation files

Search for these documentation files in the repository root:

- `CLAUDE.md`
- `AGENTS.md`
- `agent_docs/**/*.md`

Read all documentation files that exist. If none exist, write a review file with `0` and stop.

### 4. Analyze

Perform four analyses:

#### 4a. Code-to-docs gap analysis (when code files changed)

Compare the code changes against the existing documentation. Consider:

- **New features or modules**: Are they documented? Do they need new entries in AGENTS.md or new files in agent_docs/?
- **Changed APIs or interfaces**: Are the documented APIs still accurate?
- **Changed dependencies or integrations**: Are service integration docs still correct?
- **Changed build/test processes**: Are build and testing docs still accurate?
- **Removed functionality**: Is removed code still documented?
- **Changed state machines or workflows**: Are state transition docs still accurate?

Focus only on changes that materially affect what the documentation describes. Minor refactors, variable renames, or internal implementation changes that don't affect documented behaviour do not require doc updates.

#### 4b. Fact-check changed documentation against the codebase

For every documentation file that was added or modified on this branch, verify factual claims against the actual source code. This step is critical — it catches incorrect statements even when no code files changed.

For each changed doc file:
1. Identify concrete factual claims (e.g., "X is used exclusively for Y", "state transitions are A → B → C", "class Foo handles Bar")
2. Search the codebase to verify each claim. Use grep/glob to find relevant source files, then read them.
3. Flag any claim that is inaccurate, misleading, or cannot be confirmed by the code.

Examples of what to check:
- **Exclusivity claims** ("X is only used for Y") — search for all usages of X and confirm none are outside Y
- **State machines** — compare documented states and transitions against the actual enum and transition logic in code
- **Class/method references** — confirm referenced classes, methods, and packages exist and behave as described
- **Relationship claims** ("A depends on B", "C calls D") — trace the actual code paths

Do NOT skip this step even if only documentation files changed. The purpose is to prevent incorrect documentation from being merged.

#### 4c. Usefulness evaluation (for changed or new documentation)

For every documentation file that was added or modified on this branch, evaluate each section/claim for usefulness. Flag content that falls into these anti-patterns:

- **Code restating**: Documentation that just describes what the code literally does, e.g. "The `processOrder` method processes orders" or "This class has fields X, Y, Z." An agent can read the code — the docs should explain *why* or *when*, not *what*.
- **Volatile specifics**: References to specific class names, method names, line numbers, file paths, or package structures that will break on the next refactor. Prefer describing the concept or pattern instead. E.g. "orders use a state machine" is durable, "OrderStateMachine.java in package ee.tw.oms.order.statemachine handles transitions" is fragile.
- **Exhaustive enumerations**: Listing every enum value, every field, every endpoint when the code is the authoritative source. Only list values if the *meaning* of each value needs explaining and isn't obvious from the name.
- **Obvious statements**: Documentation that any developer would infer from the code structure or naming conventions, e.g. "The `UserService` handles user operations."
- **Duplicated information**: Content that exists elsewhere in the docs or is a copy of code comments.

For each flagged item, explain *why* it's low-value and suggest either:
- Removing it entirely
- Rewriting it to capture the *intent*, *decision*, or *non-obvious behaviour* instead

#### 4d. Staleness risk assessment (for all documentation)

For every documentation file (not just changed ones), assess how likely each section is to become outdated as the codebase evolves. Categorise sections as:

- **High staleness risk**: Content tightly coupled to implementation — specific class/method names, file paths, configuration values, exact state lists, specific port numbers, database table schemas. These break silently when code changes.
- **Low staleness risk**: Content describing domain concepts, architectural decisions, integration boundaries, "why" explanations, workflow descriptions at the business level. These remain accurate across refactors.

For each high-risk section, suggest one of:
- **Rewrite**: Replace volatile specifics with stable descriptions. E.g. change "MariaDB runs on port 3306" to "uses MariaDB (port configured in application config)".
- **Remove**: If the information is trivially discoverable from code, remove it. Fewer docs to maintain is better than more docs that lie.
- **Accept**: If the specific detail genuinely needs documenting (e.g., a port that external teams depend on), mark it as accepted but flag it for the reviewer's awareness.

### 5. Suggest new documentation for code changes

For code changes on the branch that are NOT already covered by existing docs, evaluate whether they *should* be documented. Not all code changes need documentation. Use these criteria:

**SHOULD document** (suggest adding):
- New domain concepts or business rules that aren't obvious from the code
- New state machines or workflows, especially with non-obvious transitions or edge cases
- New integration points with external services (what, why, failure modes)
- Architectural decisions — why a particular pattern was chosen over alternatives
- Non-obvious constraints or invariants the code enforces
- Gotchas, caveats, or known limitations a future developer/agent would hit

**Should NOT document** (don't suggest):
- New utility classes, helpers, or internal refactors
- Straightforward CRUD operations
- Test files or test utilities
- Changes that follow an existing documented pattern (e.g. adding another event handler in the same style)
- Anything an agent can understand by reading the code and its tests

For each suggestion to add documentation, specify:
- Which file it should go in (existing file or new agent_docs/ file)
- A brief description of what to write
- Why it's worth documenting (what would be non-obvious to a future reader)

### 6. Write the review file

Create the directory if it doesn't exist:
```
mkdir -p <workspace>/.tmp
```

Write the review file to: `<workspace>/.tmp/doc-review-<repo-name>-<HEAD-hash>.md`

**If docs are up to date and no issues found** (no changes needed):

```
0
```

**If there are any findings** (changes needed):

```
1

## Accuracy Issues

### <filename>
- <description of inaccuracy and what to fix>

## Usefulness Issues

### <filename>
- ⚠️ **<anti-pattern>**: <description of what's low-value and why>
  - Suggested action: <remove / rewrite to: "...">

## Staleness Risks

### <filename>
- 🔴 **High risk**: <section/claim> — <why it's fragile>
  - Suggested action: <rewrite / remove / accept>

## Suggested New Documentation

### <suggested filename>
- <what to document and why it's worth capturing>
```

Omit any section that has no findings (e.g. if there are no usefulness issues, don't include the "Usefulness Issues" heading).

For each item, be specific:
- Name the exact file to update
- Describe what section or content to add/change/remove
- Provide the suggested new text where possible

### 7. Output summary

After writing the review file, output a brief summary to the conversation:

- If `0`: "Documentation is up to date. No changes needed."
- If `1`: Show the findings grouped by category and ask the user if they'd like to apply them.

When presenting findings, prioritise them:
1. Accuracy issues (wrong information) — these should always be fixed
2. Suggested new documentation — the user decides what's worth adding
3. Usefulness issues — suggestions to improve existing docs
4. Staleness risks — informational, for the user's awareness

If the user agrees to apply the suggestions, make the documentation changes, then re-run the verification to confirm the docs are now up to date (write a new review file for the new HEAD after committing).
