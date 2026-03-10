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

### 1. Identify Which PR to Check

**First**, determine if the context makes it clear which PR to check:
- User provided a PR number or URL in their message
- Currently working in a repository subdirectory with an active feature branch (not `main` or `master`)
- Recent conversation context indicates focus on a specific PR

**If context is clear** (e.g., on a feature branch in a specific repo):
- Get the current branch and find associated PRs:
  ```bash
  gh pr list --head "$(git branch --show-current)" --json number,title,url,state
  ```
- **No PRs found**: Inform the user that no PR exists for the current branch and stop.
- **One PR found**: Use it automatically.
- **Multiple PRs found**: Present the list and ask the user to pick one.

**If context is NOT clear** (e.g., on `main` branch, in meta-repo root, or no specific PR mentioned):
- Use AskUserQuestion to ask the user for the PR number or URL
- Accept formats like: `123`, `#123`, `https://github.com/owner/repo/pull/123`, or `owner/repo#123`
- Once provided, use that PR for the rest of the checks

### 2. Poll CI and Comments (until both are settled)

Poll in a loop until **all CI checks have reached a terminal state** AND **review comments have stabilised** (no new comments appearing between consecutive polls).

#### Polling loop

1. Fetch CI checks:
   ```bash
   gh pr checks <number>
   ```
2. Fetch review comments, reviews, and review threads (including nested comments):
   ```bash
   gh pr view <number> --json comments,reviews
   ```
   ```bash
   gh api graphql -f query='
   query {
     repository(owner: "OWNER", name: "REPO") {
       pullRequest(number: NUMBER) {
         reviewThreads(first: 50) {
           nodes {
             id
             isResolved
             comments(first: 20) {
               nodes {
                 id
                 body
                 author { login }
                 createdAt
                 path
                 line
               }
             }
           }
         }
       }
     }
   }'
   ```
   Replace `OWNER`, `REPO`, and `NUMBER` with actual values from the PR URL or context.
3. Parse CI output. Each check will be in one of these states: `pass`, `fail`, `pending`, or `running` (in-progress).
4. Track the **comment count** (total number of unresolved comments + reviews + review thread comments) from the current poll.
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

- **Filter out resolved threads**: Only include review threads where `isResolved` is `false`. Skip any resolved threads entirely.
- **Include all comments in unresolved threads**: For each unresolved review thread, include ALL comments in that thread (the original comment and any replies).
- **Filter bot summary comments only**: Exclude automated *summary* comments (general PR comments, not inline code reviews) from bots like `github-actions`, `platon-github-app-production`, `wise-sonarqube-pr-decorator`. **Do NOT filter bot inline code review comments** — these often contain useful suggestions (e.g., from `copilot-pull-request-reviewer`). Treat bot code review comments the same as human comments: include them in the table, classify them, and present them for interactive resolution.
- Build a markdown table:

  | # | Comment | Author | File:Line | Changes needed? | Suggested response |
  |---|---------|--------|-----------|-----------------|-------------------|

- For each comment or review thread, classify using your judgment:
  - **Changes needed = Yes**: The reviewer is requesting a code change, improvement, or fix. Leave "Suggested response" blank — this is an action item for the user.
  - **Changes needed = No**: The comment is informational, a question, acknowledgment, or praise. Suggest a brief response the user could post.
- For inline code review comments, include the file path and line number in the "File:Line" column (e.g., `script.sh:35`).
- For general PR comments, leave "File:Line" blank or use "-".
- Truncate long comments to ~120 characters in the table, preserving the key point.
- End the table with a summary line: **"X comments requiring changes, Y informational, Z resolved (hidden)"**

**Interactive comment resolution**:
- After presenting the table, for each unaddressed comment (both those requiring changes and informational ones):
  1. Show the comment details (author, file:line if applicable, full comment text)
  2. For comments requiring changes: Propose possible actions (e.g., "Fix the issue", "Mark as resolved with explanation", "Discuss further")
  3. For informational comments: Show the suggested response from the table
  4. Use AskUserQuestion to ask what action to take:
     - For comments requiring changes: Options like "I'll fix this", "Mark as won't fix (explain why)", "Need clarification", "Skip for now"
     - For informational comments: Options like "Post suggested response", "Write custom response", "Skip"
  5. If user chooses to post a response, use the GitHub CLI to add the comment:
     ```bash
     gh pr comment <number> --body "response text"
     ```
     For inline comments on specific lines, use:
     ```bash
     gh api repos/{owner}/{repo}/pulls/<number>/comments -f body="response text" -f commit_id="<commit_sha>" -f path="<file_path>" -F line=<line_number>
     ```
  6. Continue through all unaddressed comments until user chooses to skip or all are addressed

### 3. Present Results

Combine everything into a single summary:

1. **PR Info**: Title, URL, and state
2. **Review Comments**: The markdown table from the comment summary above, plus the summary count
3. **CI Status**: Pass/fail status, any actions taken (re-runs triggered), and any related failures requiring attention
