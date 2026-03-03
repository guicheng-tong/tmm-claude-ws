---
name: create-plan
description: |
  Establish a process for planning changes. This skill MUST be used when users mention any changes to be made to the codebase. This includes implementing new features, fixing bugs, or any other changes to the codebase.
---

# Planning

This skill helps with the planning process. 

## Behaviour

Always ask questions when unclear, flag any contradictions, and point out mistakes. 

## Instructions
When helping user to plan for changes, follow these steps:
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
Once the plan is finalised, create a md file for the plan with a relevant name. Use the `plans` folder in the current `claude-ws` directory.


