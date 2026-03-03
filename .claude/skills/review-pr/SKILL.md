---
name: review-pr
description: |
  Organise PR changes and optimise for review experience.
---

# Review PR
Confirm with the user which PR they would like to review. This skill is used to help the user have a better PR review experience.

## Objectives
Read through PR description and commit descriptions to form an idea of what the objective of the PR is. Present this objective to the user

## Logical groupings
The goal of this step is to provide the user a broad idea of how the objective of the PR is achieved with the code changes.
Check if the PR is organized into individual commits with good git commit hygiene. If so, you can take each commit as a logical grouping

If not, organize the PR into individual changes and note which code edits are related to each individual change. Each individual change will be a logical grouping.

For each logical grouping, provide a summary of the changes and what files were impacted.

## Individual changes
Now, start with the first logical grouping. Show the summary of changes again, but this time also show the exact diff for each file in the grouping. 

Wait for the user to approve each grouping before moving on to the next one. The user may ask questions or request clarification from the original PR author when reviewing each grouping.



