---
name: github-issue
description: This skill should be used when the user wants to create a GitHub issue. It supports bug reports, feature requests, documentation issues, and general issues. Trigger phrases include "create an issue", "open a GitHub issue", "file a bug", "report a bug", "request a feature", or similar.
---

# GitHub Issue

## Overview

This skill creates GitHub issues from the current repository using the `gh` CLI. It supports all issue types (bugs, features, docs, general) with a generic format that works across repositories.

## Prerequisites

- The `gh` CLI must be installed and authenticated (`gh auth status` to verify)
- The current working directory must be inside a Git repository with a GitHub remote

## Workflow

### 1. Gather Issue Information

To create an effective issue, collect the following information from the user or context:

**Required:**

- **Title**: Clear, concise summary (imperative form preferred, e.g., "Add dark mode support")
- **Type**: Bug report, feature request, documentation, or general issue

**For Bug Reports:**

- Steps to reproduce
- Expected behavior
- Actual behavior
- Environment details (OS, browser, version) if relevant
- Error messages or logs if available

**For Feature Requests:**

- Problem or use case being addressed
- Proposed solution
- Alternatives considered (optional)

**For Documentation Issues:**

- What documentation is missing or incorrect
- Suggested improvements

### 2. Verify Repository Context

Before creating the issue, verify the repository:

```bash
gh repo view --json nameWithOwner -q '.nameWithOwner'
```

This confirms authentication and identifies the target repository.

### 3. Create the Issue

Use `gh issue create` with the gathered information:

```bash
gh issue create --title "Issue title" --body "Issue body"
```

**Adding Labels** (if the user specifies or context suggests):

```bash
gh issue create --title "Issue title" --body "Issue body" --label "bug"
```

Common labels: `bug`, `enhancement`, `documentation`, `question`, `help wanted`, `good first issue`

**Adding Assignees:**

```bash
gh issue create --title "Issue title" --body "Issue body" --assignee "@me"
```

### 4. Format the Issue Body

Structure the issue body based on type:

**Bug Report Template:**

```markdown
## Description

[Brief description of the bug]

## Steps to Reproduce

1. [First step]
2. [Second step]
3. [...]

## Expected Behavior

[What should happen]

## Actual Behavior

[What actually happens]

## Environment

- OS: [e.g., Ubuntu 22.04]
- Version: [e.g., v1.2.3]

## Additional Context

[Any other relevant information, screenshots, or logs]
```

**Feature Request Template:**

```markdown
## Problem

[Describe the problem or use case]

## Proposed Solution

[Describe what you'd like to happen]

## Alternatives Considered

[Any alternative solutions or features you've considered]

## Additional Context

[Any other context or screenshots]
```

**Documentation Issue Template:**

```markdown
## Description

[What documentation is missing or needs improvement]

## Location

[URL or file path if known]

## Suggested Improvement

[How it should be improved]
```

**General Issue Template:**

```markdown
## Description

[Clear description of the issue or question]

## Context

[Any relevant background information]

## Additional Information

[Supporting details, links, or references]
```

### 5. Confirm Creation

After successful creation, `gh` returns the issue URL. Share this with the user to confirm the issue was created.

## Examples

**User request:** "Create an issue for the login button not working on mobile"

**Actions:**

1. Verify repo with `gh repo view`
2. Create bug report:

```bash
gh issue create --title "Fix login button not responding on mobile devices" --body "## Description
The login button does not respond to taps on mobile devices.

## Steps to Reproduce
1. Open the app on a mobile device
2. Navigate to the login page
3. Tap the login button

## Expected Behavior
The login form should submit and authenticate the user.

## Actual Behavior
Nothing happens when tapping the button.

## Environment
- Tested on iOS Safari and Android Chrome" --label "bug"
```

**User request:** "I want to request a dark mode feature"

**Actions:**

1. Verify repo with `gh repo view`
2. Create feature request:

```bash
gh issue create --title "Add dark mode support" --body "## Problem
The current light-only theme can cause eye strain during extended use, especially in low-light environments.

## Proposed Solution
Add a dark mode option that users can toggle in settings, with automatic detection based on system preferences.

## Alternatives Considered
- Browser extension for dark mode (less integrated experience)
- Manual CSS override (not user-friendly)" --label "enhancement"
```

## Error Handling

**Not authenticated:**

```
gh: To get started with GitHub CLI, please run:  gh auth login
```

→ Instruct user to run `gh auth login`

**Not in a git repository:**

```
fatal: not a git repository
```

→ Instruct user to navigate to a repository directory

**No GitHub remote:**

```
none of the git remotes configured for this repository point to a known GitHub host
```

→ Instruct user to add a GitHub remote or specify the repo with `--repo owner/repo`
