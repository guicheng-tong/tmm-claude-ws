#!/bin/bash
# Pre-push test hook for TMM repos
# Runs appropriate tests based on project type before allowing git push

# Extract the git push command from ARGUMENTS
cmd=$(echo "$ARGUMENTS" | jq -r '.command')

# Check if this is a git push command
if ! echo "$cmd" | grep -q '^git push'; then
  exit 0  # Not a push command, allow it
fi

# Get current working directory
cwd=$(pwd)

# Check if we're in a TMM repo
if ! echo "$cwd" | grep -q '/claude-ws/tmm-repos/'; then
  exit 0  # Not in TMM repos, skip tests
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
