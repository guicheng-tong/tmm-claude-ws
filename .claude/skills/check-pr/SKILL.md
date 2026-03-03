---
name: check-pr
description: |
  Check the status of the current PR including review comments and CI health.
  Use this skill when users say "check PR", "review PR status", "check PR comments",
  "PR checks", "CI status", or any variation requesting PR status information.
---

# PR Status Checker

This skill checks the current PR's review comments and CI status, summarising actionable items.

## Instructions

### 1. Detect the Current PR

- Get the current branch and find associated PRs:
  ```bash
  gh pr list --head "$(git branch --show-current)" --json number,title,url,state
  ```
- **No PRs found**: Inform the user that no PR exists for the current branch and stop.
- **One PR found**: Use it automatically.
- **Multiple PRs found**: Present the list and ask the user to pick one.

### 2. Poll CI and Comments (until both are settled)

Poll in a loop until **all CI checks have reached a terminal state** AND **review comments have stabilised** (no new comments appearing between consecutive polls).

#### Polling loop

1. Fetch CI checks:
   ```bash
   gh pr checks <number>
   ```
2. Fetch review comments and reviews:
   ```bash
   gh pr view <number> --json comments,reviews
   ```
3. Parse CI output. Each check will be in one of these states: `pass`, `fail`, `pending`, or `running` (in-progress).
4. Track the **comment count** (total number of comments + reviews) from the current poll.
5. Determine whether to keep polling:
   - **CI not done**: any checks are `pending` or `running`.
   - **Comments not settled**: the comment count increased compared to the previous poll (or this is the first poll).
   - If **either** condition is true:
     - Log a brief status update, e.g. *"3/7 checks complete, 2 comments so far — waiting…"*
     - Wait 30 seconds:
       ```bash
       sleep 30
       ```
     - Go back to step 1.
   - If **both** CI is done and comment count is stable (unchanged for two consecutive polls), exit the loop and proceed.

#### Analyse CI results

- **All checks pass**: Report success.
- **Failures present**:
  1. Get the PR's changed files:
     ```bash
     gh pr diff <number> --name-only
     ```
  2. Get the repository owner and name:
     ```bash
     gh repo view --json owner,name --jq '.owner.login + "/" + .name'
     ```
  3. For each failing check, retrieve the run ID and job details:
     ```bash
     gh run view <run_id> --json jobs --jq '.jobs[] | select(.conclusion == "failure") | {name, steps: [.steps[] | select(.conclusion == "failure")]}'
     ```
  4. Compare failing test paths against the PR's changed files:
     - **Unrelated failure** (failing tests do not overlap with changed files — likely flaky):
       - Re-run the failed jobs:
         ```bash
         gh run rerun <run_id> --failed
         ```
       - Notify the user that unrelated failures were re-triggered.
       - **After re-running**: Go back to the **Polling loop** above and wait for the re-triggered jobs to complete before reporting final results.
     - **Related failure** (failing tests correspond to changed files):
       - Flag to the user with the file path correlation so they can investigate.

#### Summarise Review Comments

Using the final comment data from the last poll:

- Build a markdown table:

  | # | Comment | Author | Changes needed? | Suggested response |
  |---|---------|--------|----------------|--------------------|

- For each comment or review, classify using your judgment:
  - **Changes needed = Yes**: The reviewer is requesting a code change. Leave "Suggested response" blank — this is an action item for the user.
  - **Changes needed = No**: The comment is informational, a question, or praise. Suggest a brief response the user could post.
- Truncate long comments to ~120 characters in the table, preserving the key point.
- End the table with a summary line: **"X comments requiring changes, Y informational"**

### 3. Present Results

Combine everything into a single summary:

1. **PR Info**: Title, URL, and state
2. **Review Comments**: The markdown table from the comment summary above, plus the summary count
3. **CI Status**: Pass/fail status, any actions taken (re-runs triggered), and any related failures requiring attention
