---
name: verify-docs
description: |
  Verify that CLAUDE.md, AGENTS.md, and agent_docs/ documentation is up to date with code changes on the current branch. Outputs a review file to .tmp/ for the pre-push hook.
---

# Documentation Verification

## Instructions

### 1. Resolve the target repository

- **If the current directory is inside a repository** (has a `.git` directory or is a git worktree): Use the current directory as the repository path.
- **If the current directory is the workspace root** (e.g., `claude-ws/`): List repositories in `tmm-repos/`, `relevant-repos/`, `infra-repos/` and ask the user which one to verify.

### 2. Compute the cache file path

- Get the repository name from the directory path
- Get the HEAD commit hash: `git -C <repo-path> rev-parse HEAD`
- Get the workspace root from `$CLAUDE_PROJECT_DIR` environment variable
- Cache file path: `<workspace>/.tmp/doc-review-<repo-name>-<HEAD-hash>.md`

### 3. Spawn the Documentation Reviewer

Spawn the **Documentation Reviewer** subagent with the following inputs:

- **`repo_path`**: The resolved repository path from Step 1.
- **`mode`**: `diff-aware`
- **`cache_file_path`**: The computed path from Step 2.

The subagent will:
1. Compute the branch diff
2. Verify all documentation against the codebase
3. Run gap analysis for code changes that need doc updates
4. Write the cache file for the pre-push hook
5. Present findings and ask if you'd like to apply them
