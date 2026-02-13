---
name: verify-docs
description: |
  Verify that CLAUDE.md, AGENTS.md, and agent_docs/ documentation is up to date with code changes on the current branch. Outputs a review file to .tmp/ with the result.
---

# Documentation Verification

This skill checks whether documentation (CLAUDE.md, AGENTS.md, agent_docs/) is up to date with the code changes on the current branch.

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

Compare the code changes against the existing documentation. Consider:

- **New features or modules**: Are they documented? Do they need new entries in AGENTS.md or new files in agent_docs/?
- **Changed APIs or interfaces**: Are the documented APIs still accurate?
- **Changed dependencies or integrations**: Are service integration docs still correct?
- **Changed build/test processes**: Are build and testing docs still accurate?
- **Removed functionality**: Is removed code still documented?
- **Changed state machines or workflows**: Are state transition docs still accurate?

Focus only on changes that materially affect what the documentation describes. Minor refactors, variable renames, or internal implementation changes that don't affect documented behaviour do not require doc updates.

### 5. Write the review file

Create the directory if it doesn't exist:
```
mkdir -p <workspace>/.tmp
```

Write the review file to: `<workspace>/.tmp/doc-review-<repo-name>-<HEAD-hash>.md`

**If docs are up to date** (no changes needed):

```
0
```

**If docs need updates** (changes needed):

```
1

## Suggested Updates

### <filename>
- <description of what to change>

### <filename>
- <description of what to change>
```

For each suggested update, be specific:
- Name the exact file to update
- Describe what section or content to add/change/remove
- Provide the suggested new text where possible

### 6. Output summary

After writing the review file, output a brief summary to the conversation:

- If `0`: "Documentation is up to date. No changes needed."
- If `1`: Show the suggested updates and ask the user if they'd like to apply them.

If the user agrees to apply the suggestions, make the documentation changes, then re-run the verification to confirm the docs are now up to date (write a new review file for the new HEAD after committing).
