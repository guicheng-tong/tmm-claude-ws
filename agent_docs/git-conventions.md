# Git Conventions

Read this before any git commit or push.

## Commit Hygiene

- **Split logical changes into separate commits.** Each commit should represent one coherent change. Don't bundle unrelated modifications into a single commit.
- **Write meaningful commit messages.** First line is imperative mood, under 72 characters (e.g., "Add retry logic for flaky CI tests"). Add a blank line then a body explaining *why*, not just *what*.
- **Stage files explicitly.** Use `git add <file>...` with specific paths. Avoid `git add -A` or `git add .` which can catch unintended files.
- **Never commit secrets.** Check for `.env`, credentials, tokens, or API keys before staging.

## Commit Message Format

```
<ticket-id> <imperative summary> (max 72 chars total)

<optional body explaining why the change was made>

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

- Include the Jira ticket ID at the start of the summary line (e.g., `TFXENG-1234 Add retry logic for flaky CI tests`)
- If no ticket applies, omit the prefix and start with the imperative summary

Use a HEREDOC when passing commit messages to avoid quoting issues:
```bash
git commit -m "$(cat <<'EOF'
TFXENG-1234 Add retry logic for flaky CI tests

Retries up to 3 times to handle transient CI failures.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

## Branch Safety

- Never force push (`--force`) unless the user explicitly requests it.
- Never force push to `main` or `master` — warn the user if they ask for this.
- Never run destructive commands (`reset --hard`, `checkout .`, `clean -f`, `branch -D`) unless explicitly requested.
- Never skip hooks (`--no-verify`) unless explicitly requested.
- Always create new commits rather than amending, unless the user explicitly asks to amend.

## Worktrees

- Worktree naming: `{repository-name}-TFXENG{ticket-number}-{short-description}`
- Keep the main repository checkout on `main`/`master` and up to date.
