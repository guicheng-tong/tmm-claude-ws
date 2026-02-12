# Update AGENTS.md Skill

This skill automatically detects code changes that need AGENTS.md documentation updates and proposes specific edits.

## Quick Start

```bash
# In any TMM repository
/update-agents-md
```

The skill will:
1. Scan for recent code changes (new listeners, clients, state machines, domain entities)
2. Compare with existing AGENTS.md content
3. Propose specific updates with before/after previews
4. Apply changes after confirmation

## What It Detects

### Service Integrations (Most Common)
- ✅ New Kafka listeners (`*Listener.java`, `*Consumer.java`)
- ✅ New REST clients (`*Client.java`, `*FeignClient.java`)
- Proposes adding row to Service Integrations table

### State Machine Changes
- ✅ Modified state machine files (`*StateMachine.java`)
- ✅ New states added to enums
- Proposes updating ASCII state diagram

### Domain Entities
- ✅ New domain objects in `domain/` or `model/` packages
- Proposes adding to Key Domain Types section

### Repository Structure
- ✅ New significant packages
- Proposes adding to Repository Map

## Example Output

```
Analyzing liquidity-planner for AGENTS.md updates...

✅ Detected: New Kafka listener
File: service/src/main/java/ee/tw/liquidity/planner/event/ReconciliationEventListener.java

📝 Proposed update to Service Integrations table:

Current (line 85-90):
| order-management (OMS) | Kafka | Market order lifecycle events | High |
| payin-service | Kafka | Payin lifecycle events | Medium |

After:
| order-management (OMS) | Kafka | Market order lifecycle events | High |
| payin-service | Kafka | Payin lifecycle events | Medium |
| reconciliation-service | Kafka | Trade reconciliation events | Medium |

Apply this update? (y/n)
```

## When to Use

**After development work:**
- ✅ Added new service integration (Kafka/REST)
- ✅ Modified state machine (added/removed states)
- ✅ Added new domain entity
- ✅ Added significant new package

**During reviews:**
- ✅ PR review identifies outdated docs
- ✅ Quarterly documentation review
- ✅ Onboarding feedback suggests updates needed

**When NOT needed:**
- ❌ Bug fixes (no architectural changes)
- ❌ Refactoring (same interfaces)
- ❌ Adding fields to existing entities
- ❌ Configuration changes

## How It Works

### 1. Detection Phase
Uses Claude Code tools to scan:
```bash
Glob: service/src/**/*Listener.java      # Kafka listeners
Glob: service/src/**/*Client.java        # REST clients
Glob: service/src/**/*StateMachine*.java # State machines
Glob: service/src/**/domain/*.java       # Domain entities
```

### 2. Analysis Phase
- Reads AGENTS.md sections
- Compares with detected files
- Identifies gaps (missing documentation)

### 3. Proposal Phase
- Shows what was detected
- Displays current vs proposed changes
- Asks for confirmation

### 4. Update Phase
- Uses Edit tool for precise changes
- Maintains formatting and style
- Preserves alphabetical ordering

## Quality Standards

The skill follows these guidelines:

### Conciseness
- One-line service purpose descriptions
- State machines without excessive detail
- Focus on architectural information

### Consistency
- Matches existing formatting
- Follows alphabetical ordering
- Uses standard table format

### Stability
- Documents patterns, not implementation
- Focuses on what rarely changes
- Avoids volatile details

## Testing the Skill

Try these tests:

### Test 1: Add a Fake Listener
```bash
# Create temporary file
touch service/src/main/java/ee/tw/test/TestListener.java

# Run skill
/update-agents-md

# Should detect the new listener and propose adding to Service Integrations

# Clean up
rm service/src/main/java/ee/tw/test/TestListener.java
```

### Test 2: No Changes
```bash
# In a repo with up-to-date AGENTS.md
/update-agents-md

# Should output: "✅ AGENTS.md appears up-to-date"
```

### Test 3: Real Change
```bash
# After actually adding a new Kafka listener
/update-agents-md

# Should detect and propose update
```

## Integration with Other Skills

**Workflow example:**

1. Develop feature (add new Kafka listener)
2. Run `/update-agents-md` to update documentation
3. Review changes: `git diff AGENTS.md`
4. Run `/create-pr` to commit and create pull request

## Troubleshooting

### "AGENTS.md not found"
- You're not in a TMM repository root
- Navigate to: `cd tmm-repos/liquidity-planner` (or other repo)

### "No changes detected"
- AGENTS.md is already up-to-date ✅
- Or the changes don't need documentation (refactoring, bug fixes)

### False positives
- Skill might suggest updates for internal/test classes
- Review proposals carefully before accepting
- You can decline updates that aren't significant

### Missing detection
- If skill misses a change, you can manually update AGENTS.md
- Report the pattern to improve the skill

## Future Enhancements

Potential improvements:
- Parse git commit messages for better context
- Analyze PR diffs directly
- Suggest criticality levels (High/Medium/Low) based on code analysis
- Auto-commit after successful update
- Integration with PR template checklist

## Maintenance

Update this skill when:
- New detection patterns are needed
- False positive/negative rates are high
- AGENTS.md structure changes
- Team feedback suggests improvements

## Feedback

If you notice:
- ✅ Missed changes that should be documented
- ⚠️ False positives (suggests updates not needed)
- 💡 Improvement ideas

Please update the skill.md file or create a GitHub issue.

---

**Created**: 2026-02-12
**Last Updated**: 2026-02-12
**Version**: 1.0
**Status**: Active
