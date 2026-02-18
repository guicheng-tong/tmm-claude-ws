#!/bin/bash
# PermissionRequest hook: auto-denies bash commands that have native Claude Code tool alternatives.
# Returns a denial reason guiding Claude to use the native tool instead.
# Commands not matched are allowed through to the normal permission dialog.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Extract the base command (first word, ignoring env vars and paths)
BASE_CMD=$(echo "$COMMAND" | sed 's/^[A-Z_]*=[^ ]* //' | awk '{print $1}' | xargs basename 2>/dev/null)

case "$BASE_CMD" in
  grep|rg|ag)
    REASON="Use the native Grep tool instead of bash $BASE_CMD. It supports -A/-B/-C context, glob filters, and doesn't need permissions."
    ;;
  cat|head|tail|less|more)
    REASON="Use the native Read tool instead of bash $BASE_CMD. It supports offset and limit parameters."
    ;;
  find)
    REASON="Use the native Glob tool instead of bash find. It supports patterns like **/*.java."
    ;;
  sed|awk)
    REASON="Use the native Edit tool instead of bash $BASE_CMD for file modifications."
    ;;
  *)
    # Not a command with a native alternative — let normal permission dialog show
    exit 0
    ;;
esac

# Return deny decision with reason
jq -n --arg reason "$REASON" '{
  hookSpecificOutput: {
    hookEventName: "PermissionRequest",
    decision: {
      behavior: "deny",
      reason: $reason
    }
  }
}'