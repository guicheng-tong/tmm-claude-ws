---
name: create-plan
description: |
  Establish a process for planning changes.
---

# Planning

This skill helps with the planning process. 

## Behaviour

Always ask questions when unclear, flag any contradictions, and point out mistakes. 

## Instructions
When helping user to plan for changes, follow these steps:

### 0. Determine Project Context
Before starting the planning process, determine where to organize the plan:

**Check for existing projects:**
- List contents of `projects/` directory (if it exists)
- Identify if any existing project folders relate to this work

**Ask the user to choose:**
- **Existing project**: Use an existing project folder (show list of available projects)
- **New project**: Create a new project folder using the `start-project` skill
- **No project (simple change)**: Create a single plan file in root `plans/` directory

**Decision criteria to guide the user:**
- Use "New project" for: multi-phase work, multiple PRs, cross-repository changes
- Use "Existing project" for: continuing work on an established feature or initiative
- Use "No project" for: simple changes, bug fixes, single-PR features

Wait for user selection before proceeding.
### 1. Clarification
Clarify user goals in this change, any assumptions they would like to verify, and any context they would like to add.
Make sure that each of the above is clear and agreed by the user. Ask questions if any part is unclear, and provide a summary of user goals, verified assumptions, and additional context at the end of this stage

### 2. Create verification process
Using the user goals, establish a process so that changes can be objectively verified to be correct and working.
This will mainly come in the form of tests.
Provide a summary of the verification process 

### 3. Scoping
Look into the code of relevant services and come up with a plan on how to implement changes. Ensure that changes are correct and in line with current code logic. 
If there are too many changes, divide them up into different phases, ensuring that the implementation process will cause minimal disruption to existing functionality.
This is an iterative process, after providing the scoped plan, show a summary to the user and ask for feedback.
If any assumptions are made, clarify them with the user.

### 4. Finalisation
Once the plan is finalised, create a md file for the plan with a relevant name.

**Location:**
- If working within a project folder (check for `projects/{project-name}/`), save to `projects/{project-name}/plans/`
- Otherwise, fall back to the root `plans/` directory in `claude-ws`

**Naming:**
- Use descriptive kebab-case names (e.g., `backend-implementation.md`, `phase1-dealer-access.md`)
- For multi-phase projects, include phase number in the name

**Content:**
The plan should include:
- Goals and assumptions (from Step 1)
- Verification process (from Step 2)
- Scoped implementation steps (from Step 3)
- Any architectural decisions or trade-offs

After creating the plan, update the project's `PROJECT.md` (if it exists) to:
- Mark "Create implementation plan" as complete under the Planning section
- Add a link to the plan file in the "Links" section


