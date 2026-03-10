#!/bin/bash
# PreToolUse hook: blocks bash commands that chain with && or ||.
# Forces Claude to run each command as a separate Bash tool call.
# Pipes (|) are allowed since they are useful and hard to avoid.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Skip empty commands
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Remove heredoc bodies to avoid false positives on commit messages etc.
# Strips from any <<DELIM line through the matching DELIM closing line.
SANITIZED=$(echo "$COMMAND" | awk '
  /<<-?\\?\047?[A-Za-z_]+\047?/ {
    # Extract delimiter name (strip <<, -, \, and single quotes)
    d = $0
    sub(/.*<<-?\\?\047?/, "", d)
    sub(/\047.*/, "", d)       # strip trailing single-quote and everything after
    sub(/[^A-Za-z_].*/, "", d) # keep only the delimiter word
    delim = d
    if (delim == "") next      # skip if extraction failed
    in_heredoc = 1
    next
  }
  in_heredoc {
    # Check if this line is the closing delimiter (possibly followed by ) or whitespace)
    line = $0
    sub(/^[[:space:]]+/, "", line)
    sub(/[[:space:]]*\)?[[:space:]]*"?\)?$/, "", line)
    if (line == delim) { in_heredoc = 0 }
    next
  }
  { print }
')

# Remove single-quoted strings
SANITIZED=$(echo "$SANITIZED" | sed "s/'[^']*'//g")
# Remove double-quoted strings
SANITIZED=$(echo "$SANITIZED" | sed 's/"[^"]*"//g')

# Check for &&
if echo "$SANITIZED" | grep -q '&&'; then
  jq -n '{
    decision: "block",
    reason: "Do NOT chain bash commands with &&. Run each command as a separate Bash tool call. Split this into individual commands."
  }'
  exit 0
fi

# Check for ||
if echo "$SANITIZED" | grep -q '||'; then
  jq -n '{
    decision: "block",
    reason: "Do NOT chain bash commands with ||. Run each command as a separate Bash tool call. Split this into individual commands."
  }'
  exit 0
fi

# Command is fine — allow it
exit 0
