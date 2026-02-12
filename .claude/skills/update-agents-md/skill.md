---
name: update-agents-md
description: |
  Updates AGENTS.md documentation based on recent code changes. Analyzes the codebase to detect changes that need documentation updates (new service integrations, state machine changes, domain entities, etc.) and intelligently updates the relevant sections.
---

# Update AGENTS.md Documentation

This skill helps keep AGENTS.md files accurate by analyzing code changes and proposing specific documentation updates.

## When to Use This Skill

Use this skill when:
- After adding new service integrations (Kafka listeners, REST clients)
- After modifying state machines (new states, transitions)
- After adding new domain entities or contexts
- After adding significant new packages or modules
- During quarterly documentation reviews
- When a PR review identifies outdated documentation

## What This Skill Does

1. **Analyzes Recent Changes** - Scans git history or current working directory for relevant changes
2. **Identifies Affected Sections** - Determines which AGENTS.md sections need updates
3. **Proposes Specific Updates** - Suggests exact changes with proper formatting
4. **Updates AGENTS.md** - Makes precise edits following existing style and structure

## Skill Behavior

### Analysis Phase

The skill will:
1. Identify the repository (tmm-repos/ subdirectory)
2. Check if AGENTS.md exists (if not, suggest creating one)
3. Scan for recent changes:
   - New files matching patterns (StateMachine, Listener, Consumer, Client, domain entities)
   - Modified state machine files
   - New packages or modules
4. Compare against current AGENTS.md content
5. Identify gaps and outdated information

### Detection Patterns

**Service Integrations:**
- New Kafka listeners: `*Listener.java`, `*Consumer.java`, `*EventHandler.java`
- New REST clients: `*Client.java`, `*FeignClient.java`
- Check if already documented in Service Integrations table

**State Machines:**
- Modified files: `*StateMachine.java`, `*StateMachineConfig.java`
- Check state enum changes (compare with documented states)
- Identify new states or transitions

**Domain Entities:**
- New domain objects in `domain/` or `model/` packages
- Check if documented in Key Domain Types section

**Architecture Changes:**
- New top-level packages (potential new domain contexts)
- Changes to core architectural patterns

**Repository Structure:**
- New significant packages
- New modules (in multi-module projects)

### Update Phase

For each detected change, the skill will:

1. **Locate the relevant section** in AGENTS.md
2. **Propose specific update** with exact text and formatting
3. **Show before/after** for user review
4. **Apply updates** using Edit tool for precise changes

### Sections Updated

The skill can update these AGENTS.md sections:

1. **Build Commands** (rarely needs updates)
2. **Project Structure** (new modules)
3. **Architecture** (new domain contexts, patterns)
4. **Service Integrations** (NEW: most common update)
5. **Key Domain Types** (new entities, state machine changes)
6. **Key Business Flows** (new flows)
7. **Repository Map** (new packages)
8. **Testing Strategy** (new test patterns)

## Instructions for Claude

When this skill is invoked, follow these steps:

### Step 1: Context Detection

1. Determine current working directory
2. Identify which TMM repository (liquidity-planner, order-management, market-connector, etc.)
3. Check if AGENTS.md exists in the current repository
4. If not found, offer to create one or search tmm-repos/ subdirectories

### Step 2: Change Analysis

Analyze recent changes in the repository:

**Scan for these patterns using Glob and Grep tools:**

```bash
# Service Integrations - Kafka listeners
Glob: service/src/**/*Listener.java
Glob: service/src/**/*Consumer.java
Glob: service/src/**/*EventHandler.java

# Service Integrations - REST clients
Glob: service/src/**/*Client.java
Glob: service/src/**/*FeignClient.java

# State Machines
Glob: service/src/**/*StateMachine*.java

# Domain Entities
Glob: service/src/main/java/**/domain/*.java
Glob: service/src/main/java/**/model/*.java
```

**Focus on:**
- Files added in last 5-10 commits
- Recently modified files (state machines)
- Untracked files (git status)

### Step 3: Gap Analysis

For each detected file:

1. **Service Integrations:**
   - Extract service name from class (e.g., `OrderManagementEventListener` → `order-management`)
   - Read AGENTS.md Service Integrations table
   - Check if service already documented
   - If missing: Propose adding row with format:
     ```
     | service-name | Kafka/REST | Purpose description | High/Medium/Low |
     ```

2. **State Machines:**
   - Read the state machine file to extract enum states
   - Read AGENTS.md state machine diagram for that entity
   - Compare states
   - If different: Propose updating the ASCII diagram

3. **Domain Entities:**
   - Check if entity class name appears in Key Domain Types section
   - If missing and significant: Propose adding brief description

4. **Repository Map:**
   - Check if new packages appear in Repository Map
   - If significant package: Propose adding

### Step 4: Propose Updates

For each identified gap:

1. Show the detected change:
   ```
   ✅ Detected: New Kafka listener
   File: service/src/main/java/ee/tw/oms/reconciliation/ReconciliationEventListener.java
   ```

2. Show current AGENTS.md section (relevant excerpt using Read tool)

3. Propose specific update:
   ```
   📝 Proposed update to Service Integrations table:

   Add after line 85:
   | reconciliation-service | Kafka | Trade reconciliation events | Medium |
   ```

4. Ask for confirmation before making changes

### Step 5: Apply Updates

For confirmed updates:

1. Use Edit tool for precise changes
2. Maintain existing formatting and style
3. Keep tables aligned
4. Preserve line breaks and structure
5. Follow alphabetical ordering where applicable

### Step 6: Summary

Provide a summary:
```
✅ AGENTS.md Updated

Changes made:
- Added 2 service integrations to Service Integrations table
- Updated Order state machine diagram (added ARCHIVED state)
- Added ReconciliationRequest to Key Domain Types

Sections unchanged:
- Build Commands
- Project Structure
- Architecture
- Business Flows
- Repository Map
- Testing Strategy

Next steps:
- Review the changes: git diff AGENTS.md
- Commit: git add AGENTS.md && git commit -m "Update AGENTS.md documentation"
```

## Quality Guidelines

When updating AGENTS.md:

### Follow Existing Style
- Match table formatting (alignment, spacing)
- Use same heading levels
- Maintain ASCII diagram style for state machines
- Keep concise descriptions (one line for service purposes)

### Maintain Conciseness
- ❌ Don't add field-by-field entity descriptions
- ✅ Do add state machines, key relationships, critical business rules
- ❌ Don't document every class
- ✅ Do document key architectural classes

### Preserve Stability Focus
- Focus on architectural information that rarely changes
- Avoid implementation details
- Document the "what" and "why", not the "how"

### Alphabetical Ordering
- Service Integrations table: alphabetical by service name
- Keep consistency with existing sections

### State Machine Format
Use ASCII diagrams:
```
NEW → PENDING → COMPLETED
  ↓       ↓
CANCELLED ERROR
```

### Service Integration Table Format
```
| Service | Protocol | Purpose | Criticality |
|---------|----------|---------|-------------|
| service-name | Kafka/REST | Brief description | High/Medium/Low |
```

## Examples

### Example 1: Adding Service Integration

**Detected:**
```java
// service/src/main/java/ee/tw/lp/event/ReconciliationEventListener.java
@KafkaListener(topics = "reconciliation.events")
public class ReconciliationEventListener {
    // ...
}
```

**Current AGENTS.md (line 75-85):**
```markdown
| order-management (OMS) | Kafka | Market order lifecycle events |
| payin-service | Kafka | Payin lifecycle events |
```

**Proposed Update:**
```markdown
| order-management (OMS) | Kafka | Market order lifecycle events |
| payin-service | Kafka | Payin lifecycle events |
| reconciliation-service | Kafka | Trade reconciliation events |
```

### Example 2: Updating State Machine

**Detected:**
```java
// Modified: service/src/main/java/ee/tw/oms/order/OrderStateMachine.java
public enum OrderStatus {
    NEW,
    MARKET_PENDING,
    AWAITING_SETTLEMENT,
    SETTLED,
    ARCHIVED,  // NEW STATE ADDED
    CANCELLED,
    REJECTED
}
```

**Current AGENTS.md:**
```markdown
NEW → MARKET_PENDING → AWAITING_SETTLEMENT → SETTLED
  ↓         ↓                ↓
CANCELLED REJECTED        CANCELLED
```

**Proposed Update:**
```markdown
NEW → MARKET_PENDING → AWAITING_SETTLEMENT → SETTLED → ARCHIVED
  ↓         ↓                ↓
CANCELLED REJECTED        CANCELLED
```

### Example 3: Adding Domain Entity

**Detected:**
```java
// New file: service/src/main/java/ee/tw/oms/domain/ExecutionGroup.java
public class ExecutionGroup {
    // Batch order execution coordination
}
```

**Proposed Update to Key Domain Types:**
```markdown
### ExecutionGroup

Coordinates batch execution of multiple orders.

#### Key Fields
- `executionGroupId` - Unique identifier
- `orders` - List of orders in the group
- `status` - Execution status
```

## Error Handling

### AGENTS.md Not Found
```
⚠️ AGENTS.md not found in current repository.

Checked: /path/to/current/repo/AGENTS.md

Would you like me to:
1. Search tmm-repos/ subdirectories for AGENTS.md
2. Create a new AGENTS.md using the standard template
3. Cancel
```

### No Changes Detected
```
✅ AGENTS.md appears up-to-date

No recent changes detected that require documentation updates.

Analysis:
- No new service integrations found
- No state machine modifications detected
- No new domain entities identified
- No significant package changes found

Files scanned: 156 Java files in service/src

To force a manual review, let me know what specific section needs updating.
```

### Ambiguous Changes
```
⚠️ Detected change that may need documentation:

File: service/src/main/java/ee/tw/oms/reconciliation/ReconciliationService.java
Type: Service class (not clearly a Listener or Client)

Should this be documented in AGENTS.md?
- Yes - Add to Service Integrations
- Yes - Add to Repository Map
- No - Not significant enough

Please clarify what action to take.
```

## Integration with Other Skills

This skill works well with:

- **create-pr**: After updating AGENTS.md, use `/create-pr` to commit and create pull request
- **create-plan**: During planning, check if changes affect documentation
- **audit-anti-patterns**: Ensure documentation quality

## Notes

- This skill is **non-destructive** by default (shows proposals first)
- Always review changes before committing
- Skill respects existing AGENTS.md structure and style
- Focuses on **high-value updates** (service integrations, state machines)
- Ignores low-value updates (minor refactors, test files)
- Uses Claude Code's native tools (Glob, Grep, Read, Edit) for analysis
