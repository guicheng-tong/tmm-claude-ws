---
name: add-doc-validation
description: |
  Add documentation validation scripts to a repository and wire them into CI.
  Use this when documentation is brittle but important enough to keep.
---

# Add Documentation Validation Scripts

Add validation scripts that detect drift between documentation and code, and wire them into CI so builds fail on stale docs.

## When to Use

Use this after `/init-ai-docs` or `/verify-docs` identifies documentation that is high-brittleness but high-helpfulness — meaning it goes stale easily but is too valuable to remove. Typical candidates:
- Repository maps (package directory trees)
- Enum value lists
- Integration point inventories (Kafka topics, REST endpoints)
- Config-derived tables (FIX versions, feature flags, market lists)

## Script Contract

All validation scripts live in `agent_docs/validation_scripts/` and follow a common contract:

| Exit code | Meaning |
|-----------|---------|
| 0 | Documentation matches code |
| 1 | Drift detected |
| 2 | Setup error (missing files/directories) |

Each script accepts an optional repo root path as its first argument, defaulting to two levels up from the script's location.

## Writing a Validation Script

```bash
#!/bin/bash
set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "$0")/../.." && pwd)}"
```

The script should:

1. **Define what to compare.** Identify the source of truth in code (directories, config files, enum values) and the corresponding documentation file.
2. **Extract reality.** Use `find`, `grep`, or similar to get the actual state from code.
3. **Parse documentation.** Use `awk` or `grep` to extract the documented state from the markdown. This is the fragile part — keep the markdown format simple so parsing stays simple.
4. **Compare.** `comm` on sorted lists works for set comparisons. `diff` works for ordered content.
5. **Report actionable drift.** Messages should say what's missing or extra and what to do about it.
6. **Exit with the correct code.**

Validation scripts should check one thing. If you need to validate multiple aspects of documentation, write separate scripts.

## Registering in Gradle

Root `build.gradle` — one `Exec` task per script:

```groovy
tasks.register('validateSomething', Exec) {
	description = 'Validates agent_docs/something.md matches actual state'
	group = 'verification'
	workingDir = rootDir
	commandLine 'bash', 'agent_docs/validation_scripts/validate-something.sh'
}
```

`service/build.gradle` — add to `check` dependencies:

```groovy
check.dependsOn rootProject.tasks.named('validateSomething')
```

Tasks are defined at root level because they operate on `agent_docs/`. The dependency is on `service:check` because that's what CI runs.

## Verification

After adding a new script:

1. Run it standalone: `./agent_docs/validation_scripts/validate-something.sh`
2. Run it via Gradle: `./gradlew validateSomething`
3. Introduce deliberate drift and confirm the build fails with an actionable message.
4. Run the full build: `./gradlew check`

## Reference Implementation

See `transactions-inventory` and `market-connector` for working examples of `validate-repository-map.sh`.

## Process

1. Ask the user which repository and which documentation they want to validate.
2. Read the documentation file and the corresponding source of truth in code.
3. Write the validation script following the contract above.
4. Make it executable (`chmod +x`).
5. Run it standalone to verify it passes.
6. Introduce deliberate drift to verify it fails with actionable output.
7. Register the Gradle task and wire it into `check`.
8. Run `./gradlew check` to verify end-to-end.
