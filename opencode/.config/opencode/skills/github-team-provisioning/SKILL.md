---
name: github-team-provisioning
description: Provisions GitHub teams from IDP group requests via the GitHub API. Handles external group lookup, team creation, creator removal, and IDP linking. Use when a ticket mentions creating GitHub teams, provisioning IDP groups to GitHub, or group names matching the pattern "Team Name - GitHub - Permission Type".
compatibility: Requires GitHub CLI (gh) for token auth and curl/jq for API calls. Needs org admin access to the target GitHub org ($GITHUB_ORG).
metadata:
  author: ""
  version: "1.0"
allowed-tools: Bash Read
---

# GitHub Team Provisioning from IDP Groups

You provision GitHub teams linked to external IDP groups. This is a precise, multi-step API workflow — follow each step exactly.

## Detection

Look for ADO tickets assigned to you that mention:
- Adding/creating GitHub teams
- Provisioning IDP groups to GitHub
- Group names matching: `<Team Name> - GitHub - <Permission Type>`

When detected, proactively ask: "I see a ticket for GitHub team provisioning. Want me to handle this?"

## Naming Convention

| IDP Group Name | GitHub Team Name |
|---------------|-----------------|
| `Network Operations - GitHub - Developer` | `Network Operations - Developer` |
| `Network Operations - GitHub - Read Only` | `Network Operations - Read Only` |

- Strip `GitHub -` from the middle
- Team description = same as team name

## Workflow

**All steps use the GitHub API. Get a token first:**

```bash
TOKEN=$(gh auth token)
```

### Step 1: Find the External Group ID

```bash
curl -s -k -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/orgs/${GITHUB_ORG}/external-groups?per_page=100" \
  | jq '.groups[] | select(.group_name | test("<Team Name>"; "i"))'
```

Note the `group_id` from the output.

### Step 2: Create the GitHub Team

```bash
curl -s -k -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/orgs/${GITHUB_ORG}/teams \
  -d '{"name":"<Team Name> - <Permission Type>","description":"<Team Name> - <Permission Type>","privacy":"closed"}'
```

Note the team `slug` from the response.

### Step 3: Remove the Auto-Added Creator

The API auto-adds the authenticated user as a team member. This **must** be removed before IDP linking:

```bash
curl -s -k -X DELETE -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/orgs/${GITHUB_ORG}/teams/<team-slug>/memberships/${GITHUB_USERNAME}"
```

### Step 4: Link to External IDP Group

```bash
curl -s -k -X PATCH -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/orgs/${GITHUB_ORG}/teams/<team-slug>/external-groups" \
  -d '{"group_id": <GROUP_ID>}'
```

## After Provisioning

Close the ADO ticket in **one update**:
- State: Closed
- Story Points: 1 (simple provisioning)
- Application Name: `AI APPS`
- Resolution Summary: list the teams created with links
- One discussion comment tagging the ticket creator (use HTML mention format) — keep it brief

## Rules

- **Always complete all 4 steps** — a team without IDP linking is useless.
- **Always remove the creator** (step 3) before linking (step 4) — linking fails otherwise.
- **Confirm with the user** before executing if the ticket is ambiguous about which groups to provision.
- **Process multiple groups** if the ticket lists several — repeat steps 1-4 for each.
