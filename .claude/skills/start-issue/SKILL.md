---
name: start-issue
description: This skill should be used when the user wants to start working on a new issue or feature. It follows gitflow conventions by checking out the develop branch, pulling the latest changes, and creating a new feature branch. Trigger phrases include "start issue", "start working on", "begin issue", "new feature branch", or similar.
---

# Start Issue

## Overview

This skill prepares the local git repository for working on a new issue by following gitflow conventions. It ensures the develop branch is up to date and creates a properly named feature branch.

## Workflow

To start working on an issue:

1. **Checkout develop branch**

   ```bash
   git checkout develop
   ```

2. **Pull latest changes**

   ```bash
   git pull origin develop
   ```

3. **Create and checkout a new feature branch**
   ```bash
   git checkout -b feature/<issue-number>-<brief-description>
   ```

## Branch Naming Convention

Feature branches follow the pattern: `feature/<issue-number>-<brief-description>`

Examples:

- `feature/123-add-user-authentication`
- `feature/456-fix-login-redirect`
- `feature/789-update-api-endpoints`

Guidelines:

- Use lowercase letters and hyphens
- Keep the description brief (2-4 words)
- Include the issue number if available
- If no issue number exists, use a descriptive name like `feature/add-dark-mode`

## Usage

When the user says something like:

- "Start working on issue #123"
- "Begin issue 456 for adding user auth"
- "Create a feature branch for the new login flow"

Execute the workflow above, prompting for a branch name if not provided.
