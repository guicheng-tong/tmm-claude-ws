---
name: create-plan
description: |
  Establish a process for planning changes.
---

# Planning

This skill helps with the planning process.

## Behaviour

Always ask questions when unclear, flag any contradictions, and point out mistakes.

## Input

The caller may provide any of the following before invoking this skill. If not provided, the skill gathers them interactively.

- **`prior_context`** (optional): Pre-supplied goals, assumptions, and additional context. If provided, Step 1 presents these for confirmation instead of gathering from scratch.
- **`output_directory`** (optional): Directory path where the plan file should be saved. Default: `plans/` in the workspace root.

## Output

The skill produces a plan markdown file saved to the output directory and returns the file path.

## Instructions
When helping user to plan for changes, follow these steps:

### 1. Clarification

**If prior context was provided:** Present the supplied goals, assumptions, and context as a summary. Ask the user to confirm or amend each part before proceeding.

**If no prior context:** Clarify user goals in this change, any assumptions they would like to verify, and any context they would like to add. Make sure that each of the above is clear and agreed by the user. Ask questions if any part is unclear.

Provide a summary of user goals, verified assumptions, and additional context at the end of this stage.

### 2. Create verification process
Using the user goals, establish a process so that changes can be objectively verified to be correct and working.
This will mainly come in the form of tests.
Provide a summary of the verification process.

### 3. Scoping
Look into the code of relevant services and come up with a plan on how to implement changes. Ensure that changes are correct and in line with current code logic.
If there are too many changes, divide them up into different phases, ensuring that the implementation process will cause minimal disruption to existing functionality.
This is an iterative process, after providing the scoped plan, show a summary to the user and ask for feedback.
If any assumptions are made, clarify them with the user.

### 4. Section-by-section review

Before writing the plan file, present the draft plan to the user one section at a time:

1. **Goals & Assumptions** (from Step 1)
2. **Verification Process** (from Step 2)
3. **Implementation Steps** (from Step 3)
4. **Decisions & Trade-offs** (any architectural decisions or trade-offs surfaced during planning)

For each section, ask the user to either:
- **Approve** and continue to the next section
- **Provide feedback** to modify the section

Iterate on any section until the user approves it before moving to the next.

### 5. Finalisation
Once all sections are approved, create a md file for the plan.

**Location:**
Save to the `output_directory` if one was provided. Otherwise, save to the `plans/` directory in the workspace root.

**Naming:**
- Use descriptive kebab-case names (e.g., `backend-implementation.md`, `phase1-dealer-access.md`)
- For multi-phase projects, include phase number in the name

**Content:**
The plan file should contain the four approved sections from Step 4:
- Goals and assumptions
- Verification process
- Scoped implementation steps
- Decisions and trade-offs
