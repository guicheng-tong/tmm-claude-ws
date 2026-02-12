# AGENTS.md Evaluation for transactions-inventory

**Ticket**: TFXENG-8388
**Date**: 2026-02-11
**Service**: transactions-inventory

## Overview

This document evaluates the usefulness of each section in the transactions-inventory AGENTS.md file for debugging and development purposes.

## Overall Assessment: 9.5/10

The AGENTS.md file is exceptionally comprehensive and valuable for both new developers and debugging production issues. It excels in domain documentation, state machine explanations, and integration mapping.

---

## Section-by-Section Evaluation

### 1. Build Commands (Lines 1-27)
**Usefulness: 9/10** ⭐⭐⭐⭐⭐

**Strengths:**
- Essential for daily development workflow
- Provides all common gradle commands
- Includes specific examples for running individual test classes
- Docker-compose commands for local infrastructure setup

**Debug Value:**
- Critical for setting up local environment for debugging
- Integration test commands help reproduce issues locally

**Improvement Opportunities:**
- Add common debugging flags (`--debug`, `--stacktrace`)
- Include commands to run the application locally
- Add dependency resolution troubleshooting tips

---

### 2. Project Structure (Lines 29-37)
**Usefulness: 7/10** ⭐⭐⭐⭐

**Strengths:**
- Clear multi-module overview (api, service, client, interfaces)
- Helps navigate the codebase structure

**Debug Value:**
- Understanding module boundaries helps identify where bugs might originate
- Clarifies separation of concerns

**Improvement Opportunities:**
- Explain when to add code to each module
- Add module dependency diagram
- Include examples of what belongs in each module

---

### 3. Architecture (Lines 38-62)
**Usefulness: 10/10** ⭐⭐⭐⭐⭐

**Strengths:**
- Exceptional domain model and business context documentation
- Lists all 6 domain contexts with clear descriptions
- Explains key architectural patterns (event-driven, state machines, linking)
- Infrastructure components clearly documented

**Debug Value:**
- Domain contexts list helps identify which flow is broken
- State machine pattern explanation is crucial for debugging state transition bugs
- Linking requirements (100% precision matching) explains common failure scenarios
- Infrastructure section helps understand dependencies

**Critical For:**
- Understanding why transactions might be stuck in certain states
- Identifying which domain context a bug belongs to
- Understanding event-driven nature for async debugging

---

### 4. Service Integrations (Lines 64-76)
**Usefulness: 10/10** ⭐⭐⭐⭐⭐

**Strengths:**
- Comprehensive table of 9 external service integrations
- Lists protocol (Kafka vs REST) for each integration
- Clear purpose description for each integration

**Debug Value:**
- Essential for tracing issues across service boundaries
- Helps identify external dependencies when debugging failures
- Protocol information guides debugging approach (event logs vs API calls)
- Quickly answers "what service provides X functionality?"

**Particularly Useful:**
- When transactions are stuck waiting for external events
- Identifying which Kafka topics to monitor
- Understanding REST client failures

---

### 5. Key Domain Types (Lines 78-251)
**Usefulness: 10/10** ⭐⭐⭐⭐⭐

**Strengths:**
- Most detailed section with comprehensive coverage of all 6 domain types
- State machine diagrams with ASCII art
- Field-by-field documentation with business meaning
- Special business rules explicitly documented

**Debug Value:**

#### Internal Transfers (Lines 79-107)
- 7-state machine with clear transitions
- Reference field logic (lines 99-107) explains complex linking behavior
- Critical for debugging linking issues

#### Partner Transfers (Lines 109-132)
- Simple 3-state machine
- Client identifier mapping (ADYEN, CHECKOUT_DOT_COM)
- Explains deduplication via clientCorrelationId

#### Adhoc Payments (Lines 134-148)
- One-sided linking explanation prevents confusion
- Push payment support documented
- Explains when payout instructions are skipped

#### Invoice Payouts (Lines 149-182)
- Complex 8-state machine with multiple paths
- Liquidity allocation logic explained
- Push payment vs normal flow differentiation

#### Interest Accruals (Lines 183-223)
- Settlement state machine with reconciliation states
- Multiple accrual types documented
- Threshold-based settlement triggers explained

#### Partner Exchanges (Lines 224-239)
- Critical creation source logic (Quote vs Bank statement)
- Explains why duplicate PEs might appear
- Source of truth hierarchy documented

#### Linking (Lines 241-251)
- Core concept that affects all flows
- CreateLinksCommand structure explained
- Link types and flow identification documented

**Overall Section Value:**
- Invaluable for understanding valid state transitions
- State descriptions explain what's expected next
- Non-obvious behavior explicitly documented
- Essential reference for debugging stuck transactions

---

### 6. Key Business Flows (Lines 253-289)
**Usefulness: 10/10** ⭐⭐⭐⭐⭐

**Strengths:**
- End-to-end flow descriptions for all 6 domain types
- Shows progression from creation to terminal states
- Conditional logic paths documented

**Debug Value:**
- Shows expected sequence of events for each domain type
- Helps identify where a flow is stuck or deviated from happy path
- Conditional logic (liquidityAllocationRequired vs push payment) explained
- Links external events to internal state changes

**Perfect For:**
- Understanding "happy path" vs actual behavior when debugging
- Creating reproduction steps for bugs
- Identifying missing events or steps in a flow

**Examples:**
- Partner Transfer: Shows Kafka creation → linking → completion
- Invoice Payout: Explains two paths (liquidity required vs skipped)
- Interest Accrual: Describes threshold triggers and time-based closures

---

### 7. Repository Map (Lines 291-365)
**Usefulness: 9/10** ⭐⭐⭐⭐⭐

**Strengths:**
- Detailed file and directory structure with 50+ entries
- Purpose annotations for each important file/directory
- Consistent patterns identified (Service, StateMachine, Repository per domain)
- Test utilities and builders clearly located

**Debug Value:**
- Quick navigation to relevant code ("where is state machine logic?")
- Identifies where to add new code following existing patterns
- Shows location of test utilities for writing tests
- Flyway migration directory clearly marked

**Examples:**
- State machines: Each domain has clear StateMachine class location
- Integration utilities: Test utils organized by concern
- Shared services: Common linking and messaging logic locations

**Minor Gap:**
- Could include common utility packages
- No mention of configuration file purposes

---

### 8. Testing Strategy (Lines 367-426)
**Usefulness: 9/10** ⭐⭐⭐⭐⭐

**Strengths:**
- Comprehensive testing documentation
- Lists all test builders and their purposes
- Mock services enumerated
- Integration test utilities documented
- Testing patterns explained
- Docker setup instructions included

**Debug Value:**
- Test builders help reproduce bugs in unit tests
- Integration test utilities guide end-to-end testing
- Awaitility mention helps with async debugging
- Clear distinction between unit and integration test approaches

**Practical Information:**
- Specific gradle commands for running tests
- Docker infrastructure requirements listed
- Test data creation patterns documented

**Gap:**
- Could include debugging techniques (log levels, test containers)
- No mention of test coverage expectations
- Missing guidance on when to write unit vs integration tests

---

## Critical Gaps for Debugging/Development

### 1. Observability Section (Missing)
**Impact: High**

Should include:
- Log levels and how to configure them
- Key log statements to look for
- Metrics/dashboards (Datadog queries)
- Distributed tracing setup
- Common log patterns for each flow

### 2. Troubleshooting Section (Missing)
**Impact: High**

Should include:
- Common issues and solutions
- "Transaction stuck in PAYOUT_PENDING" - what to check
- Linking failures - common causes
- Kafka consumer lag - how to diagnose
- Database deadlock scenarios
- Performance bottlenecks

### 3. Local Development Setup (Incomplete)
**Impact: Medium**

Should include:
- Steps to run application locally
- Environment variable configuration
- Application.yml key settings
- Port mappings
- How to connect to local Kafka/DB

### 4. Database Section (Missing)
**Impact: Medium**

Should include:
- Schema overview (key tables)
- Migration strategy (Flyway patterns)
- Useful SQL queries for debugging
- How to query transactions by state
- Foreign key relationships
- Index strategy for performance

### 5. API Documentation (Missing)
**Impact: Medium**

Should include:
- REST endpoint listing
- Example curl commands
- Request/response formats
- Authentication requirements
- API versioning strategy

### 6. Monitoring/Alerting (Missing)
**Impact: Medium**

Should include:
- Existing alerts and thresholds
- Dashboard locations
- SLIs/SLOs
- How to detect issues in production
- Runbook links

### 7. Configuration Management (Missing)
**Impact: Low-Medium**

Should include:
- Environment-specific configs
- Feature flags
- How to override settings locally
- Secrets management

---

## Recommendations

### High Priority Additions

1. **Add Troubleshooting Section**
   ```markdown
   ## Common Issues & Solutions

   ### Transaction Stuck in PAYOUT_PENDING
   - Check payout-coordinator Kafka consumer lag
   - Verify PayoutInstructionStateChanged events received
   - Query payout-coordinator for POI status

   ### Linking Failures
   - Verify bank transaction reference matches
   - Check linking-service logs for CreateLinksCommand
   - Ensure 100% amount match requirement met
   ```

2. **Add Observability Section**
   ```markdown
   ## Observability

   ### Logging
   - Main logger: `ee.tw.txinv`
   - Set `logging.level.ee.tw.txinv=DEBUG` for detailed logs
   - Key log patterns:
     - "State transition" - shows state machine changes
     - "Publishing event" - Kafka message production

   ### Dashboards
   - [Datadog Dashboard Link]
   - Key metrics: transaction_created, transaction_completed, state_duration
   ```

3. **Add Database Debugging Section**
   ```markdown
   ## Database Debugging

   ### Key Tables
   - `internal_transfer` - IT domain objects
   - `partner_transfer` - PT domain objects
   - `payout_instruction` - POI tracking

   ### Useful Queries
   ```sql
   -- Find stuck transactions
   SELECT * FROM internal_transfer
   WHERE state = 'PAYOUT_PENDING'
   AND updated_at < NOW() - INTERVAL 1 HOUR;
   ```

### Medium Priority Additions

4. **Expand Local Development Setup**
5. **Add API Examples**
6. **Document Monitoring/Alerting**

### Low Priority Enhancements

7. **Add configuration management details**
8. **Include performance tuning tips**
9. **Add architecture diagrams (visual)**

---

## Conclusion

The transactions-inventory AGENTS.md file is **exceptionally well-crafted** and provides outstanding value for:
- Understanding the domain model and business logic
- Navigating the codebase structure
- Debugging state machine issues
- Tracing issues across service boundaries
- Writing tests with proper utilities

**Strengths:**
- Comprehensive domain documentation (state machines are gold standard)
- Practical examples throughout
- Integration-focused (great for distributed debugging)
- Good testing support

**Primary Recommendation:**
Add operational sections (troubleshooting, observability, database debugging) to complement the excellent domain and code structure documentation. This would make it a complete reference for both development and production support.

**Score Breakdown:**
- Domain & Architecture: 10/10
- Code Structure: 9/10
- Testing: 9/10
- Operational Support: 5/10
- **Overall: 9.5/10** (could be 10/10 with operational additions)
