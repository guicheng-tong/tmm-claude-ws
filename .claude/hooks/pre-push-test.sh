#!/bin/bash
# Pre-push test hook
# Runs appropriate tests based on project type before allowing git push.
# Activates in any git repository that has gradlew or package.json.

# Read tool input from stdin (Claude Code PreToolUse sends JSON on stdin)
INPUT=$(cat)
cmd=$(echo "$INPUT" | jq -r '.tool_input.command')

# Check if this is a git push command (handles flags between git and push, e.g. git -c ... push)
if ! echo "$cmd" | grep -qE '^git\b.*\bpush\b'; then
  exit 0  # Not a push command, allow it
fi

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

# Find the remote tracking branch to diff against
remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null)
if [ -z "$remote_branch" ]; then
  if git rev-parse --verify origin/main >/dev/null 2>&1; then
    remote_branch="origin/main"
  elif git rev-parse --verify origin/master >/dev/null 2>&1; then
    remote_branch="origin/master"
  fi
fi

# Skip tests if no changes or only documentation files changed
if [ -n "$remote_branch" ]; then
  changed_files=$(git diff --name-only "$remote_branch"...HEAD 2>/dev/null)
  if [ -z "$changed_files" ]; then
    echo "📄 No unpushed changes — skipping tests."
    exit 0
  fi
  non_doc_changes=$(echo "$changed_files" | grep -v -E '^(CLAUDE\.md|AGENTS\.md|agent_docs/)' || true)
  if [ -z "$non_doc_changes" ]; then
    echo "📄 Only documentation files changed — skipping tests."
    exit 0
  fi
fi

echo "🧪 Running tests before git push..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Detect project type and run appropriate tests
if [ -f ./gradlew ]; then
  # Java/Gradle project
  echo "📦 Detected Gradle project (running unit + integration tests)"
  ./gradlew check
  test_exit=$?
elif [ -f package.json ]; then
  # JavaScript/yarn project
  echo "📦 Detected JavaScript project"
  yarn build
  test_exit=$?
else
  # No test infrastructure found
  echo "⚠️  No test command found for this project"
  echo "Proceeding without running tests..."
  exit 0
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check test results
if [ $test_exit -ne 0 ]; then
  echo ""
  echo "❌ PUSH REJECTED: Tests failed!"
  echo ""
  echo "Fix the failing tests before pushing."
  echo "To skip this check (not recommended), use:"
  echo "  git push --no-verify"
  exit 1
fi

echo "✅ All tests passed! Proceeding with push..."
exit 0
