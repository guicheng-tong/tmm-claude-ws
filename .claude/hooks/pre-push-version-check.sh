#!/bin/bash
# Pre-push library version check hook for TMM Java repos
# Ensures library module versions are bumped (semver increment) when source files change.
# On failure, outputs structured instructions for Claude to auto-fix and retry.

# Extract the git push command from ARGUMENTS
cmd=$(echo "$ARGUMENTS" | jq -r '.command')

# Check if this is a git push command
if ! echo "$cmd" | grep -q '^git push'; then
  exit 0
fi

# Get current working directory
cwd=$(pwd)

# Check if we're in a TMM repo
if ! echo "$cwd" | grep -q '/claude-ws/tmm-repos/'; then
  exit 0
fi

# Check if this is a Gradle project
if [ ! -f ./gradlew ]; then
  exit 0
fi

# Find the base branch to diff against
base_branch=""
if git rev-parse --verify origin/main >/dev/null 2>&1; then
  base_branch="origin/main"
elif git rev-parse --verify origin/master >/dev/null 2>&1; then
  base_branch="origin/master"
else
  # Can't determine base branch, allow push
  exit 0
fi

# Semver comparison: returns 0 if version $1 > $2, 1 otherwise
semver_gt() {
  local new="$1"
  local old="$2"

  local new_major new_minor new_patch old_major old_minor old_patch
  new_major=$(echo "$new" | cut -d. -f1)
  new_minor=$(echo "$new" | cut -d. -f2)
  new_patch=$(echo "$new" | cut -d. -f3)
  old_major=$(echo "$old" | cut -d. -f1)
  old_minor=$(echo "$old" | cut -d. -f2)
  old_patch=$(echo "$old" | cut -d. -f3)

  if [ "$new_major" -gt "$old_major" ] 2>/dev/null; then
    return 0
  fi
  if [ "$new_major" -eq "$old_major" ] && [ "$new_minor" -gt "$old_minor" ] 2>/dev/null; then
    return 0
  fi
  if [ "$new_major" -eq "$old_major" ] && [ "$new_minor" -eq "$old_minor" ] && [ "$new_patch" -gt "$old_patch" ] 2>/dev/null; then
    return 0
  fi

  return 1
}

# Auto-detect library modules: first-level subdirectories with version= in gradle.properties
library_modules=()
for props_file in */gradle.properties; do
  [ -f "$props_file" ] || continue
  if grep -q '^version=' "$props_file"; then
    module_dir=$(dirname "$props_file")
    library_modules+=("$module_dir")
  fi
done

if [ ${#library_modules[@]} -eq 0 ]; then
  exit 0
fi

# Check each library module
failures=()
failure_details=""

for module in "${library_modules[@]}"; do
  props_file="${module}/gradle.properties"

  # Get changed files in this module, excluding gradle.properties
  changed_files=$(git diff --name-only "${base_branch}"...HEAD -- "$module/" 2>/dev/null | grep -v "^${module}/gradle.properties$" || true)

  if [ -z "$changed_files" ]; then
    continue
  fi

  # Get current (HEAD) version
  head_version=$(grep '^version=' "$props_file" | cut -d= -f2 | tr -d '[:space:]')

  # Get base branch version
  base_version=$(git show "${base_branch}:${props_file}" 2>/dev/null | grep '^version=' | cut -d= -f2 | tr -d '[:space:]')

  # If no base version (new module), skip
  if [ -z "$base_version" ]; then
    continue
  fi

  # Compare versions: HEAD must be strictly greater
  if semver_gt "$head_version" "$base_version"; then
    continue
  fi

  # Version not bumped — record failure
  failures+=("$module")
  failure_details="${failure_details}
---
Module: ${module}/
  File: ${props_file}
  Version on ${base_branch}: ${base_version}
  Version on HEAD: ${head_version}
  Changed files:"

  while IFS= read -r f; do
    failure_details="${failure_details}
    - ${f}"
  done <<< "$changed_files"
done

if [ ${#failures[@]} -eq 0 ]; then
  exit 0
fi

# Output structured failure report
echo ""
echo "LIBRARY VERSION BUMP REQUIRED"
echo "================================================"
echo ""
echo "The following library modules have source changes but their"
echo "versions have not been incremented compared to ${base_branch}:"
echo "$failure_details"
echo ""
echo "================================================"
echo "ACTION REQUIRED:"
echo "1. Review the changed files for each module listed above"
echo "2. Determine the appropriate semver bump level:"
echo "   - patch: bug fixes, minor internal changes"
echo "   - minor: new features, added API methods/classes"
echo "   - major: breaking changes to existing API"
echo "3. Edit each module's gradle.properties to set the new version"
echo "4. Create a NEW commit with the version bump(s)"
echo "5. Retry git push"
echo ""
exit 1
