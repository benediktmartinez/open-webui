---
name: create-pr
description: This skill should be used when the user has completed work on a feature branch and wants to create a pull request to the develop branch. It follows gitflow conventions by pushing the current branch and creating a PR targeting develop, then switching back to develop. Trigger phrases include "create pr", "create pull request", "finish feature", "submit pr", "pr to develop", or similar.
---

# Create PR

## Overview

This skill finalizes work on a feature branch by creating a pull request to the develop branch following gitflow conventions. After the PR is created, it switches the local repository back to the develop branch.

## Prerequisites

- The `gh` CLI must be installed and authenticated (`gh auth status` to verify)
- The current working directory must be inside a Git repository with a GitHub remote
- Work must be completed on a feature branch (not on develop or main)

## Workflow

### 1. Verify Current State

Before creating the PR, verify the repository state:

```bash
# Check current branch and status
git branch --show-current
git status
```

Confirm:
- Not on develop or main branch
- All changes are committed (working tree clean)

If there are uncommitted changes, prompt the user to commit or stash them first.

### 2. Push the Feature Branch

Push the current branch to the remote:

```bash
git push -u origin $(git branch --show-current)
```

### 3. Analyze Changes for PR

Gather information about the changes:

```bash
# Get all commits unique to this branch
git log develop..HEAD --oneline

# Get the full diff against develop
git diff develop...HEAD --stat
```

### 4. Create the Pull Request

Use `gh pr create` to create the PR targeting develop:

```bash
gh pr create --base develop --title "PR title" --body "$(cat <<'EOF'
## Summary
- Brief description of changes

## Test plan
- [ ] Manual testing steps
- [ ] Automated tests pass

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

**PR Title Guidelines:**
- Keep under 70 characters
- Use imperative form (e.g., "Add user authentication" not "Added user authentication")
- Reference issue number if applicable (e.g., "Add login flow (#123)")

**PR Body Guidelines:**
- Summarize the changes in 1-3 bullet points
- Include a test plan with specific steps
- Reference related issues if applicable

### 5. Switch to Develop Branch

After the PR is created, switch back to develop:

```bash
git checkout develop
git pull origin develop
```

### 6. Confirm Completion

Report to the user:
- The PR URL
- Confirmation that the local repo is now on develop branch

## Example

**User request:** "Create a PR for my changes"

**Actions:**
1. Verify on feature branch with clean working tree
2. Push branch: `git push -u origin feature/123-add-auth`
3. Analyze commits and changes
4. Create PR:
```bash
gh pr create --base develop --title "Add user authentication (#123)" --body "$(cat <<'EOF'
## Summary
- Add login/logout functionality
- Implement JWT token handling
- Add protected route middleware

## Test plan
- [ ] Verify login with valid credentials
- [ ] Verify login fails with invalid credentials
- [ ] Verify protected routes redirect unauthenticated users

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```
5. Switch to develop: `git checkout develop && git pull origin develop`
6. Report PR URL and confirm on develop branch

## Error Handling

**On develop or main branch:**
→ Inform user they need to be on a feature branch to create a PR

**Uncommitted changes:**
→ Prompt user to commit or stash changes first

**Not authenticated with gh:**
```
gh: To get started with GitHub CLI, please run: gh auth login
```
→ Instruct user to run `gh auth login`

**PR already exists:**
```
a]pull request for branch "feature/xxx" into branch "develop" already exists
```
→ Inform user and provide link to existing PR

**No commits ahead of develop:**
→ Inform user there are no changes to create a PR for
