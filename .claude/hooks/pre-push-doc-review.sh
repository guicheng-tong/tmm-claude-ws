#!/bin/bash
# Pre-push documentation review hook for TMM repos
# Checks if documentation (CLAUDE.md, AGENTS.md, agent_docs/) needs updating
# before allowing git push.
#
# Uses a review cache file in .tmp/ written by the /verify-docs skill.
# Review file format: first line is 0 (docs up to date) or 1 (updates needed),
# rest of file contains suggested updates if 1.

# Read tool input from stdin (Claude Code PreToolUse sends JSON on stdin)
INPUT=$(cat)
cmd=$(echo "$INPUT" | jq -r '.tool_input.command')

# Check if this is a git push command (handles flags between git and push, e.g. git -c ... push)
if ! echo "$cmd" | grep -qE '^git\b.*\bpush\b'; then
  exit 0
fi

# Get current working directory
cwd=$(pwd)

# Check if we're in a TMM repo
if ! echo "$cwd" | grep -q '/claude-ws/tmm-repos/'; then
  exit 0
fi

# Extract workspace root and repo name
workspace=$(echo "$cwd" | sed 's|\(/claude-ws\)/.*|\1|')
repo_name=$(echo "$cwd" | sed 's|.*/tmm-repos/||' | cut -d'/' -f1)

# Check if the repo has any documentation files
has_docs=false
[ -f "CLAUDE.md" ] && has_docs=true
[ -f "AGENTS.md" ] && has_docs=true
[ -d "agent_docs" ] && has_docs=true

if [ "$has_docs" = false ]; then
  exit 0
fi

# Find the remote tracking branch to diff against
remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null)
if [ -z "$remote_branch" ]; then
  # No upstream set, try origin/main or origin/master
  if git rev-parse --verify origin/main >/dev/null 2>&1; then
    remote_branch="origin/main"
  elif git rev-parse --verify origin/master >/dev/null 2>&1; then
    remote_branch="origin/master"
  else
    # Can't determine base branch, allow push
    exit 0
  fi
fi

# Get list of changed files
changed_files=$(git diff --name-only "$remote_branch"...HEAD 2>/dev/null)

# If no changes, allow push
if [ -z "$changed_files" ]; then
  exit 0
fi

# Get HEAD commit hash
head_hash=$(git rev-parse HEAD)

# Check for review cache file
review_file="$workspace/.tmp/doc-review-${repo_name}-${head_hash}.md"

if [ -f "$review_file" ]; then
  first_line=$(head -1 "$review_file")
  if [ "$first_line" = "0" ]; then
    # Docs verified as up to date
    exit 0
  elif [ "$first_line" = "1" ]; then
    # Docs need updates - show the suggestions
    echo ""
    echo "Documentation updates needed before push"
    echo "================================================"
    echo ""
    tail -n +2 "$review_file"
    echo ""
    echo "================================================"
    echo "Apply the suggested documentation updates above,"
    echo "commit the changes, then retry git push."
    echo ""
    exit 1
  fi
fi

# No review file found - block push and request verification
echo ""
echo "Documentation review required before push"
echo "================================================"
echo "Repository: $repo_name"
echo "Branch: $(git rev-parse --abbrev-ref HEAD)"
echo "HEAD: $head_hash"
echo ""
echo "Files changed:"
echo "$changed_files" | sed 's/^/  /'
echo ""
echo "Documentation files in this repo:"
[ -f "CLAUDE.md" ] && echo "  CLAUDE.md"
[ -f "AGENTS.md" ] && echo "  AGENTS.md"
if [ -d "agent_docs" ]; then
  find agent_docs -name '*.md' -type f | sed 's/^/  /'
fi
echo ""
echo "================================================"
echo "Run /verify-docs to check if documentation needs"
echo "updating, then retry git push."
echo ""
exit 1
