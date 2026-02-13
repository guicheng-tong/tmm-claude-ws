---
name: create-pr
description: |
  Guides the creation of pull requests following Wise's standardized templates and conventions.
  Use this skill when users ask to "create a PR", "make a pull request", "submit changes",
  "create commit and PR" or any variation requesting help with pull request creation.
---

# PR Creator

This skill helps create pull requests that follow Wise's standardized templates and conventions.

## ⚠️ MANDATORY: Read Settings First

**STOP. Before doing ANYTHING else, you MUST read the user's settings file.**

```bash
cat ~/.claude/settings.json 2>/dev/null
```

Look for these environment variables in the `env` section:

| Variable | Action Required |
|----------|-----------------|
| `PR_CREATOR_DRAFT` = `"true"` | **MUST** add `--draft` flag to `gh pr create` |
| `PR_CREATOR_SKIP_USER_PROMPTS` = `"true"` | **MUST** omit the user prompts history section |

**Store these values and apply them when creating the PR. Do NOT skip this step.**

---

## Instructions

When helping users create pull requests, follow these guidelines:

### 1. Check Configuration (ALREADY DONE ABOVE)

You should have already read `~/.claude/settings.json` above. If not, do it now before proceeding.

### 2. Pre-PR Checks

Before creating a PR, verify:
- All changes are committed
- Code quality checks and tests pass (run the repository's standard test/lint commands)

### 3. Pull Request Template Selection

**Always use the appropriate PR template:**

1. **If the repository has a `PULL_REQUEST_TEMPLATE.md` or `pull_request_template.md` file** (typically in root or `.github/` folder): Use that template
2. **If the repository does NOT have its own template**: Fetch the organization-wide template using GitHub CLI:
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
2. **Establish PR base**: Check the current branch, if there are newer changes, and ask user if the base of the PR is correct
2. **Create branch** (if not already on a feature branch): Use format `<ticket-id>-<short-description>`
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

**REMEMBER**: If `PR_CREATOR_DRAFT=true` was set in settings, you MUST include `--draft` flag.

```bash
# If PR_CREATOR_DRAFT=true, use: gh pr create --draft --title ...
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

**Note**: The multi-commit NOTE block should only be included when there are 2 or more commits (see section 8).

**Draft PRs**: Check for the environment variable `PR_CREATOR_DRAFT`. If it is set to `true`, add the `--draft` flag to create the PR as a draft:

```bash
gh pr create --draft --title "TW-1234 short description" --body "..."
```

### 8. Linking Issues

If a Jira ticket is referenced:
- Add the ticket link to the PR description: `https://transferwise.atlassian.net/browse/<ticket-id>`

## Example Workflow

When a user says "create a PR for my changes":

1. **FIRST: Read `~/.claude/settings.json`** - Check for `PR_CREATOR_DRAFT` and `PR_CREATOR_SKIP_USER_PROMPTS`. Store these values.
2. Check `git status` for changes
3. Check if there's a local `PULL_REQUEST_TEMPLATE.md`
4. If no local template, fetch org template
5. Create branch if needed
6. Commit with proper message format
7. Run repository's standard test/lint commands to ensure code quality
8. **Create PR using `gh pr create`** - Include `--draft` flag if `PR_CREATOR_DRAFT=true`
9. Return the PR URL to the user and open it in the browser using `open <PR_URL>`

**Common mistake to avoid**: Do NOT skip step 1. The settings MUST be read before any other action.

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

**IMPORTANT**: This section can be disabled by setting the environment variable `PR_CREATOR_SKIP_USER_PROMPTS=true` in Claude settings. Check for this variable before including the prompts section.

**Always include** a collapsible section at the end of the PR body (before the "Generated with Claude Code" line) containing all user prompts from the current session that led to the changes being submitted, **UNLESS** `PR_CREATOR_SKIP_USER_PROMPTS` is explicitly set to `true`.

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

## Configuration

The following environment variables can be set in Claude settings (`.claude/settings.json`) to customize the PR creator behavior:

- `PR_CREATOR_DRAFT`: Set to `true` to create PRs as drafts (default: `false`)
- `PR_CREATOR_SKIP_USER_PROMPTS`: Set to `true` to skip including user prompts history in PR descriptions (default: `false`)

**Example configuration in `.claude/settings.json`:**
```json
{
  "env": {
    "PR_CREATOR_DRAFT": "true",
    "PR_CREATOR_SKIP_USER_PROMPTS": "true"
  }
}
```

## Quality Checklist

Before submitting the PR, verify:
- [ ] User configuration was checked FIRST (`PR_CREATOR_DRAFT`, `PR_CREATOR_SKIP_USER_PROMPTS`)
- [ ] PR created as draft if `PR_CREATOR_DRAFT=true`
- [ ] Template is correctly filled out
- [ ] Description clearly explains the changes
- [ ] Jira ticket is linked (if applicable)
- [ ] Code quality checks pass
- [ ] Session prompts history is included (unless `PR_CREATOR_SKIP_USER_PROMPTS=true`)
