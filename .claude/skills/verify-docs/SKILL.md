---
name: verify-docs
description: |
  Verify that CLAUDE.md, AGENTS.md, and agent_docs/ documentation is up to date with code changes on the current branch. Outputs a review file to .tmp/ for the pre-push hook.
---

# Documentation Verification

Spawn the **Documentation Reviewer** subagent in **diff-aware mode** for the current repository.

The subagent will:
1. Compute the branch diff
2. Verify all documentation against the codebase
3. Run gap analysis for code changes that need doc updates
4. Write the cache file to `.tmp/doc-review-<repo>-<HEAD>.md` for the pre-push hook
5. Present findings and ask if you'd like to apply them
