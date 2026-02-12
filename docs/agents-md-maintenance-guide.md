# AGENTS.md Maintenance Guide

Quick reference for keeping AGENTS.md documentation up-to-date.

## TL;DR

1. **After adding service integration or state machine change**: Run `/update-agents-md`
2. **During PR**: Check if AGENTS.md needs updating (PR template checklist)
3. **Quarterly**: 30-minute team review

---

## When Does AGENTS.md Need Updating?

### ✅ Requires Update

| Change Type | Example | AGENTS.md Section |
|-------------|---------|-------------------|
| New service integration | Add `ReconciliationEventListener.java` | Service Integrations table |
| State machine change | Add `ARCHIVED` state to `OrderStatus` enum | Key Domain Types (state diagram) |
| New domain entity | Add `ExecutionGroup.java` | Key Domain Types |
| New domain context | Add "reconciliation" module | Architecture |
| New module | Add `reconciliation-api` module | Project Structure |

### ❌ Doesn't Require Update

| Change Type | Why |
|-------------|-----|
| Bug fixes | No architectural change |
| Refactoring | Same interfaces/contracts |
| Adding entity fields | Too detailed, becomes stale |
| Configuration changes | Environment-specific |
| Test improvements | Covered in Testing Strategy |

---

## How to Update: Three Methods

### Method 1: Use the Skill (Recommended) ⚡

```bash
# In any TMM repository
/update-agents-md
```

**What it does:**
1. Scans for new listeners, clients, state machines, domain entities
2. Compares with current AGENTS.md
3. Proposes specific updates
4. Applies changes after confirmation

**Time**: 2-3 minutes

### Method 2: Manual Update 📝

1. Open AGENTS.md in your repo
2. Find the relevant section (use templates below)
3. Add your changes following existing format
4. Keep alphabetical ordering

**Time**: 5-10 minutes

### Method 3: PR Template Checklist ✓

Every PR has an AGENTS.md checklist:
- [ ] N/A - This PR doesn't need AGENTS.md updates
- [ ] State Machines - Updated state diagrams
- [ ] Service Integrations - Added new Kafka/REST integrations
- [ ] Domain Types - Added new domain entities
- [ ] Architecture - Updated if new domain context
- [ ] Repository Map - Updated if significant new packages

**Time**: 1 minute to check

---

## Update Templates

### Template 1: Adding Service Integration

**Location**: Service Integrations section (around line 80-100)

**Format**:
```markdown
| service-name | Kafka/REST | Purpose description | High/Medium/Low |
```

**Example**:
```markdown
| reconciliation-service | Kafka | Trade reconciliation events | Medium |
```

**Criticality Levels**:
- **Critical**: Service downtime blocks core functionality
- **High**: Important but has fallbacks
- **Medium**: Supporting functionality
- **Low**: Nice-to-have (notifications, etc.)

### Template 2: Updating State Machine

**Location**: Key Domain Types section, find the relevant entity

**Format**:
```markdown
NEW → PENDING → COMPLETED
  ↓       ↓
CANCELLED ERROR
```

**Example** (adding ARCHIVED state):
```markdown
Before:
NEW → MARKET_PENDING → AWAITING_SETTLEMENT → SETTLED

After:
NEW → MARKET_PENDING → AWAITING_SETTLEMENT → SETTLED → ARCHIVED
```

### Template 3: Adding Domain Entity

**Location**: Key Domain Types section

**Format**:
```markdown
### EntityName

Brief description of purpose.

#### Key Fields
- `fieldId` - Description
- `status` - Description
- `relatedEntity` - Description
```

**Example**:
```markdown
### ExecutionGroup

Coordinates batch execution of multiple orders.

#### Key Fields
- `executionGroupId` - Unique identifier
- `orders` - List of orders in the group
- `status` - Execution status
```

### Template 4: Adding to Repository Map

**Location**: Repository Map section

**Format**:
```markdown
    packagename/                      # Purpose description
      KeyClass                        # What it does
      KeyService                      # What it does
```

**Example**:
```markdown
    reconciliation/                   # Trade reconciliation
      ReconciliationService           # Main reconciliation logic
      ReconciliationEventListener     # Kafka event handling
```

---

## The `/update-agents-md` Skill

### What It Detects

**Service Integrations:**
- `*Listener.java` (Kafka consumers)
- `*Consumer.java` (Kafka consumers)
- `*Client.java` (REST clients)
- `*FeignClient.java` (Feign clients)

**State Machines:**
- `*StateMachine.java`
- `*StateMachineConfig.java`
- Enum state changes

**Domain Entities:**
- New files in `domain/` packages
- New files in `model/` packages

**Repository Structure:**
- New significant packages
- New modules

### Example Run

```
$ /update-agents-md

Analyzing liquidity-planner for AGENTS.md updates...

✅ Detected: New Kafka listener
File: service/src/main/java/ee/tw/lp/event/ReconciliationEventListener.java

📝 Proposed update to Service Integrations table:

Current (line 85-90):
| order-management (OMS) | Kafka | Market order lifecycle events | High |
| payin-service | Kafka | Payin lifecycle events | Medium |

After:
| order-management (OMS) | Kafka | Market order lifecycle events | High |
| payin-service | Kafka | Payin lifecycle events | Medium |
| reconciliation-service | Kafka | Trade reconciliation events | Medium |

Apply this update? (y/n) y

✅ Applied update to Service Integrations

✅ AGENTS.md Updated

Changes made:
- Added 1 service integration to Service Integrations table

Next steps:
- Review: git diff AGENTS.md
- Commit: git add AGENTS.md && git commit -m "Update AGENTS.md documentation"
```

---

## Quarterly Review Process

**Frequency**: Every 3 months (Q1, Q2, Q3, Q4)

**Time**: 30 minutes for entire team

**Agenda**:
1. Review AGENTS.md for each TMM repo (5 min per repo)
2. Identify outdated sections
3. Assign quick fixes
4. Discuss improvements

**Checklist per repo**:
```markdown
## Q1 2026 AGENTS.md Review - liquidity-planner

- [ ] Architecture section accurate?
- [ ] All service integrations listed?
- [ ] State machines current?
- [ ] Repository map reflects major packages?
- [ ] Build commands still work?
- [ ] Any new domain contexts?

**Action Items:**
- [ ] @dev1: Add missing reconciliation-service integration
- [ ] @dev2: Update SignalEntry state machine (new ARCHIVED state)
```

---

## PR Process Integration

### Step 1: Development
- Implement feature (e.g., add new Kafka listener)

### Step 2: Documentation
- Run `/update-agents-md`
- Review proposed changes
- Apply updates

### Step 3: PR Creation
- Commit AGENTS.md changes
- Create PR
- PR template shows AGENTS.md checklist

### Step 4: PR Review
- Reviewer verifies AGENTS.md updated if needed
- GitHub Actions may warn if update needed

---

## Common Scenarios

### Scenario 1: Added New Kafka Listener

**Detection**: Skill finds `*Listener.java` file
**Section**: Service Integrations
**Action**: Add row to table
**Time**: 2 minutes

### Scenario 2: Modified State Machine

**Detection**: Skill finds changed `*StateMachine.java`
**Section**: Key Domain Types (state diagram)
**Action**: Update ASCII diagram
**Time**: 3 minutes

### Scenario 3: Added New Domain Entity

**Detection**: Skill finds new file in `domain/`
**Section**: Key Domain Types
**Action**: Add entity description (if significant)
**Time**: 5 minutes

### Scenario 4: Refactoring (No Update Needed)

**Detection**: Skill finds no new patterns
**Output**: "✅ AGENTS.md appears up-to-date"
**Action**: None
**Time**: 30 seconds

---

## Troubleshooting

### "I don't know if my change needs AGENTS.md update"

**Ask yourself:**
1. Did I add a new service integration? → **Yes** = Update needed
2. Did I change a state machine? → **Yes** = Update needed
3. Did I add a new domain entity? → **Maybe** = Run `/update-agents-md`
4. Did I refactor existing code? → **No** = No update needed

**Or just run**: `/update-agents-md` - it will tell you!

### "The skill suggested an update I don't think is needed"

You can decline the update. The skill errs on the side of caution.

**Common false positives:**
- Internal/test classes
- Minor utility classes
- Temporary implementations

### "The skill missed something I changed"

Manually update AGENTS.md using the templates above.

Then consider:
- Is this a pattern we should add to the skill?
- Report it for skill improvement

### "I updated AGENTS.md but it feels stale anyway"

This might happen if:
- Business context changed (rare)
- Architecture shifted (rare)
- Integrations changed protocols (rare)

**Solution**: Flag for quarterly review or immediate update if critical.

---

## Maintenance Metrics

Track these to measure success:

### Quantitative
1. **Staleness incidents**: < 2 per repo per year
2. **Update coverage**: 80%+ of PRs that need updates have them
3. **Time to update**: < 10 minutes average

### Qualitative
4. **Developer satisfaction**: "AGENTS.md is helpful and accurate" > 4.0/5
5. **Onboarding feedback**: New devs find it valuable

---

## Quick Reference Card

| Task | Command | Time |
|------|---------|------|
| Check for updates | `/update-agents-md` | 1 min |
| Add service integration | Use template, add table row | 3 min |
| Update state machine | Edit ASCII diagram | 3 min |
| Add domain entity | Use template, add section | 5 min |
| Quarterly review | Team session | 30 min |

---

## Resources

- **Skill README**: `.claude/skills/update-agents-md/README.md`
- **Full Strategy**: `plans/agents-md-maintenance-strategy.md`
- **Example AGENTS.md**: `tmm-repos/transactions-inventory/AGENTS.md` (9.5/10 quality)
- **Templates**: This guide (sections above)

---

## Questions?

- **Slack**: #tmm-team channel
- **Documentation Champion**: Rotating role (check team calendar)
- **Quarterly Review**: Next scheduled date in team calendar

---

**Last Updated**: 2026-02-12
**Version**: 1.0
