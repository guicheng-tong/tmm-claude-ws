---
name: create-pr
description: |
  Guides the creation of pull requests following Wise's standardized templates and conventions.
  Use this skill when users ask to "create a PR", "make a pull request", "submit changes",
  "create commit and PR" or any variation requesting help with pull request creation.
---

# PR Creator

This skill helps create pull requests that follow Wise's standardized templates and conventions.

## Instructions

When helping users create pull requests, follow these guidelines:

### 1. Pre-PR Checks

Before creating a PR, verify:
- All changes are committed
- Code quality checks and tests pass (run the repository's standard test/lint commands)
- All required library versions are bumped
  - Library version needs to be bumped if there are any code changes, even for any code addition 
  - If changelog exists, update changelog

### 2. Determine Base Branch

Determine the PR target branch and confirm it with the user before proceeding:

1. **Detect the repository's default branch**:
   ```bash
   gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
   ```
2. **Suggest the base branch to the user** and ask for confirmation:
   - Present the default branch as the suggested target (e.g., "The default branch is `master`. Should I use this as the PR base, or a different branch?")
   - Wait for the user to confirm or specify a different branch
3. **Store the confirmed base branch** and use it for all subsequent steps (template detection, freshness check, `gh pr create --base`, etc.)

**Do NOT proceed until the user has confirmed the base branch.**

### 3. Pull Request Template Selection

**Always use the appropriate PR template:**

1. **Check for a repository-specific template** by reading it from the confirmed base branch (this works regardless of which branch you are currently on):
   ```bash
   git show <base-branch>:.github/PULL_REQUEST_TEMPLATE.md 2>/dev/null || \
   git show <base-branch>:.github/pull_request_template.md 2>/dev/null || \
   git show <base-branch>:PULL_REQUEST_TEMPLATE.md 2>/dev/null || \
   git show <base-branch>:pull_request_template.md 2>/dev/null || \
   echo "NO_REPO_TEMPLATE"
   ```

2. **If no repository template exists** (output is `NO_REPO_TEMPLATE`): Fetch the organization-wide template using GitHub CLI:
   ```bash
   gh api repos/transferwise/.github/contents/PULL_REQUEST_TEMPLATE.md --jq '.content' | base64 -d
   ```

**IMPORTANT**: Do NOT create custom PR description structures. Always follow the standardized template for consistency and compliance with security and documentation requirements.

### 4. Template Usage Guidelines

When filling out PR templates:

- **Modify only the comment sections**: Template parts marked with `<!-- ... -->` comments should be replaced with actual content (remove the comments after modification)
- **Do not modify anything else**: Keep all other template content intact
- **Do not check checkboxes**: This should be human action after PR creation
- **Keep `[optional]` markers**: Leave `[optional]` words as-is for optional items
- **Add meaningful description**: Describe what has been changed, why it was changed, and the expected outcome (up to 300 characters)

### 5. PR Creation Process

Follow these steps:

1. **Understand changes**: Use `git status` and `git diff` to understand what has been modified
2. **Ensure branch is up to date with base**:
   ```bash
   git fetch origin <base-branch>
   git log --oneline HEAD..origin/<base-branch>
   ```
   If there are commits on the base branch not in the feature branch:
   - Inform the user that the branch is **behind** the base by N commits
   - Ask the user whether to rebase before creating the PR
   - If yes, rebase and force push:
     ```bash
     git rebase origin/<base-branch>
     git push --force-with-lease
     ```
   - If no, proceed but note the PR will need updating later
3. **Create branch** (if not already on a feature branch): Use format `<ticket-id>-<short-description>`
3. **Commit changes**: Ensure only tracked files are committed with a clear commit message
4. **Create PR**: Use `gh pr create` with the template

### 6. Commit Message Format

Structure commit messages as follows:
- **First line**: `<ticket-id> <short description>` (up to 50 characters)
  - Example: `TW-1234 add new payment validation`
- **Second line**: Blank
- **Body**: Longer description of the change (if needed)
- **Footer** Always end with:
  ```
  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

### 7. PR Creation Command

Use `gh pr create` with a HEREDOC for proper formatting.

```bash
gh pr create --title "TW-1234 short description" --body "$(cat <<'EOF'
## Context

<Fill in the template content from repository or org template here>

Summary (1-3 bullet points):
- First change description
- Second change description

> [!NOTE]
> This PR is split into separate commits to simplify review process. Each commit's message explains scope of the PR changes it contains. Reviewing commit-by-commit will improve PR review experience.

## Checklist
- [ ] <checklist items from template>

<details>
<summary>User prompts that led to this change</summary>

1. **"first user prompt here"**
   - Context for this prompt

2. **"second user prompt here"**
   - Context for this prompt

</details>

🤖 Generated with Claude Code
EOF
)"
```

### 8. Linking Issues

If a Jira ticket is referenced:
- Add the ticket link to the PR description: `https://transferwise.atlassian.net/browse/<ticket-id>`

## Example Workflow

When a user says "create a PR for my changes":

1. Check `git status` for changes
2. **Determine base branch** using `gh repo view` and **ask user to confirm** before proceeding
3. Check for repo PR template using `git show <base-branch>:.github/PULL_REQUEST_TEMPLATE.md`
4. If no repo template found, fetch org-wide template via `gh api`
5. Create branch if needed
6. Commit with proper message format
7. Run repository's standard test/lint commands to ensure code quality
8. **Create PR using `gh pr create`**
9. Return the PR URL to the user and open it in the browser using `open <PR_URL>`

## Additional Guidelines

### 9. Multi-Commit PRs

When a PR contains multiple commits:

1. **Check commit count**: Compare the number of commits between your branch and the base branch using `git rev-list --count <base-branch>..HEAD` (base branch is typically `main` or `master`)
2. **Add review note**: If there are 2 or more commits, include the following note in the PR description **after the summary section**:

```markdown
> [!NOTE]
> This PR is split into separate commits to simplify review process. Each commit's message explains scope of the PR changes it contains. Reviewing commit-by-commit will improve PR review experience.
```

**Example PR body with multiple commits:**
```markdown
## Summary
- Added new validation for payment amounts
- Refactored error handling in PaymentService

> [!NOTE]
> This PR is split into separate commits to simplify review process. Each commit's message explains scope of the PR changes it contains. Reviewing commit-by-commit will improve PR review experience.

<rest of template content>
```

### 10. Session Prompts History

**Always include** a collapsible section at the end of the PR body (before the "Generated with Claude Code" line) containing all user prompts from the current session that led to the changes being submitted.

**Format:**
```markdown
<details>
<summary>User prompts that led to this change</summary>

1. **"<first user prompt>"**
   - Brief context of what this prompt addressed

2. **"<second user prompt>"**
   - Brief context of what this prompt addressed

... (continue for all prompts)

</details>
```

**Guidelines:**
- Include substantive user prompts from the session, in chronological order
- **Filter out trivial prompts**: Skip short confirmations like "yes", "no", "ok", "proceed", "continue", "do it", single-word answers to questions
- Quote each prompt exactly as the user wrote it
- Add a brief one-line context explaining what the prompt addressed
- Place the section before the "🤖 Generated with Claude Code" footer
- This provides transparency and traceability for reviewers

## Quality Checklist

Before submitting the PR, verify:
- [ ] Template is correctly filled out
- [ ] Description clearly explains the changes
- [ ] Jira ticket is linked (if applicable)
- [ ] Code quality checks pass
- [ ] Session prompts history is included
