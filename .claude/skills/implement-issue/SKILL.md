---
name: implement-issue
description: This skill should be used when the user wants to implement a GitHub issue. It reads the issue details, enters plan mode for thorough exploration and planning, then creates a feature branch using gitflow conventions. Trigger phrases include "implement issue #123", "implement #456", "work on issue #123", or similar patterns with an issue number.
---

# Implement Issue

## Overview

This skill provides a complete workflow for implementing a GitHub issue: reading the issue details, entering plan mode to design the implementation approach with user approval, and then creating a gitflow feature branch to begin work.

## Prerequisites

- The `gh` CLI must be installed and authenticated (`gh auth status` to verify)
- The current working directory must be inside a Git repository with a GitHub remote

## Workflow

### 1. Parse the Issue Number

Extract the issue number from the user's request. Supported formats:
- `implement issue #123`
- `implement #456`
- `work on issue 789`
- `implement issue 42`

### 2. Read the GitHub Issue

Fetch the issue details using the `gh` CLI:

```bash
gh issue view <issue-number>
```

This retrieves:
- Issue title
- Issue body/description
- Labels
- Assignees
- Comments (if any)

For more detailed information including comments:

```bash
gh issue view <issue-number> --comments
```

### 3. Summarize the Issue

Present a clear summary of the issue to the user, including:
- **Title**: The issue title
- **Type**: Inferred from labels (bug, feature, enhancement, etc.)
- **Description**: Key points from the issue body
- **Acceptance Criteria**: If specified in the issue
- **Related Context**: Any mentioned files, components, or dependencies

### 4. Enter Plan Mode

After summarizing the issue, enter plan mode using the `EnterPlanMode` tool. This allows for:
- Thorough codebase exploration to understand the relevant areas
- Designing an implementation approach
- Identifying affected files and components
- Considering architectural trade-offs
- Getting user approval before making changes

In plan mode:
1. Explore the codebase to understand relevant components
2. Identify files that need to be modified or created
3. Design the implementation approach
4. Document the plan with clear steps
5. Exit plan mode with `ExitPlanMode` to request user approval

### 5. Create Feature Branch (After Plan Approval)

Once the user approves the plan, create a gitflow feature branch:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/<issue-number>-<brief-description>
```

**Branch Naming Convention:**
- Pattern: `feature/<issue-number>-<brief-description>`
- Use lowercase letters and hyphens
- Keep description brief (2-4 words)
- Derive description from the issue title

Examples:
- Issue #123 "Add user authentication" → `feature/123-add-user-authentication`
- Issue #456 "Fix login redirect bug" → `feature/456-fix-login-redirect`
- Issue #789 "Update API rate limiting" → `feature/789-update-api-rate-limiting`

### 6. Begin Implementation

After creating the branch, begin implementing the plan. The task list from the plan can guide the implementation process.

## Example

**User request:** "implement issue #42"

**Workflow:**

1. **Parse**: Extract issue number `42`

2. **Read issue**:
   ```bash
   gh issue view 42 --comments
   ```

3. **Summarize**:
   > **Issue #42: Add dark mode support**
   >
   > **Type**: Feature (label: enhancement)
   >
   > **Description**: Users have requested a dark mode option to reduce eye strain. The feature should:
   > - Add a toggle in user settings
   > - Persist preference in local storage
   > - Support system preference detection
   >
   > **Mentioned components**: Settings page, theme system

4. **Enter plan mode**: Use `EnterPlanMode` tool to explore the codebase and design the implementation

5. **Plan and get approval**: Write plan, exit plan mode, wait for user approval

6. **Create branch** (after approval):
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/42-add-dark-mode
   ```

7. **Begin implementation**: Follow the approved plan

## Error Handling

**Issue not found:**
```
GraphQL: Could not resolve to an issue or pull request with the number of 999.
```
→ Inform the user that the issue number doesn't exist in this repository

**Not authenticated:**
```
gh: To get started with GitHub CLI, please run: gh auth login
```
→ Instruct user to run `gh auth login`

**Not in a git repository:**
```
fatal: not a git repository
```
→ Instruct user to navigate to a repository directory
