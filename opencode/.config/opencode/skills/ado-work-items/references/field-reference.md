# ADO Work Item Field Reference

## Work Item Types & States

| Type | States |
|------|--------|
| **Epic** | New → Active → Closed |
| **Feature** | New → Active → Closed |
| **User Story** | New → Active → Resolved → Closed |
| **Task** | To Do → In Progress → Done |
| **Bug** | New → Active → Resolved → Closed |

## Required Fields (All Stories)

| Display Name | API Field | Type | Notes |
|-------------|-----------|------|-------|
| Title | `System.Title` | String | Required on create |
| State | `System.State` | String | `New`, `Active`, `Resolved`, `Closed` |
| Assigned To | `System.AssignedTo` | Identity | Default: `${ADO_USER_EMAIL}` |
| Area Path | `System.AreaPath` | TreePath | Check existing story for correct value |
| Iteration Path | `System.IterationPath` | TreePath | Select based on current date |
| Story Points | `Microsoft.VSTS.Scheduling.StoryPoints` | Double | Required before close. Scale: 1/2/3/5/8/13 |
| Application Name | `Custom.ParentApplication` | String | Required. Values: `AI APPS`, `JAK`, `TECHMATE` |

## Other Useful Fields

| Display Name | API Field | Type | Notes |
|-------------|-----------|------|-------|
| Priority | `Microsoft.VSTS.Common.Priority` | Integer | 1 (critical) through 4 (low) |
| Tags | `System.Tags` | String | Semicolon-separated values |
| Description | `System.Description` | HTML | Body/details of the work item |
| Changed Date | `System.ChangedDate` | DateTime | Last modified timestamp |
| Created Date | `System.CreatedDate` | DateTime | Creation timestamp |

## Fields Used on Close

| Display Name | API Field | Notes |
|-------------|-----------|-------|
| Resolution Summary | `Custom.ResolutionSummary` | HTML allowed. Tag opener. Short sentence + bullet list. |

## Story Point Scale

| Points | Size | Examples |
|--------|------|----------|
| 1 | Trivial | Config change, simple team provisioning |
| 2-3 | Small | Script update, single-file fix |
| 5 | Medium | New feature, multi-file change |
| 8 | Large | Cross-repo work, significant feature |
| 13+ | Extra large | Multi-sprint epic work |

## Application Name Values

| Value | When to Use |
|-------|-------------|
| `AI APPS` | GitHub/DevOps work, AI platform, general infra |
| `JAK` | JAK-specific features |
| `TECHMATE` | TECHMATE-specific features |

If unclear, ask the user before creating/updating.

## User Mention HTML Format

```html
<a href="#" data-vss-mention="version:2.0,{originId}">@Display Name</a>
```

- `originId` comes from `az devops user list` → `.items[].user.originId`
- Works in: descriptions, resolution summaries, discussion comments
- Plain `@Name` text is silently ignored by the API

## Common az boards Commands

```bash
# Get a work item
az boards work-item show --id <id> --org "https://dev.azure.com/${ADO_ORG}"

# Update fields
az boards work-item update --id <id> --org "https://dev.azure.com/${ADO_ORG}" \
  --fields "Field.Name=value" "Another.Field=value"

# Add a comment
az boards work-item update --id <id> --org "https://dev.azure.com/${ADO_ORG}" \
  --discussion "<html comment>"

# Query work items
az boards query --wiql "SELECT [System.Id] FROM WorkItems WHERE [System.AssignedTo] = @me AND [System.State] = 'Active'" \
  --org "https://dev.azure.com/${ADO_ORG}"
```

## WIQL Tips

- Always filter by `[System.TeamProject]` to scope to the correct project
- Use `ASOF '<date>'` clause for point-in-time queries
- Tags are semicolon-separated: `[System.Tags] CONTAINS 'AI'`
- Date filters: `[System.ChangedDate] >= '2026-01-01'`
- Date macros: `@today`, `@startOfWeek`, `@startOfMonth`
- Assigned to current user: `[System.AssignedTo] = @me`
- Area path hierarchy: `[System.AreaPath] UNDER 'Project\Parent'` matches all children

## Common WIQL Queries

### All active stories assigned to me

```wiql
SELECT [System.Id], [System.Title], [System.State], [System.AssignedTo]
FROM WorkItems
WHERE [System.TeamProject] = 'Process'
  AND [System.WorkItemType] = 'User Story'
  AND [System.State] <> 'Closed'
  AND [System.AssignedTo] = @me
ORDER BY [System.ChangedDate] DESC
```

### Stories changed this week

```wiql
SELECT [System.Id], [System.Title], [System.State]
FROM WorkItems
WHERE [System.TeamProject] = 'Process'
  AND [System.WorkItemType] = 'User Story'
  AND [System.ChangedDate] >= @startOfWeek
ORDER BY [System.ChangedDate] DESC
```

### Blocked items (by tag)

```wiql
SELECT [System.Id], [System.Title], [System.State], [System.AssignedTo]
FROM WorkItems
WHERE [System.TeamProject] = 'Process'
  AND [System.Tags] CONTAINS 'Blocked'
  AND [System.State] <> 'Closed'
```

### All open items under an area path

```wiql
SELECT [System.Id], [System.Title], [System.State], [System.AssignedTo], [Microsoft.VSTS.Scheduling.StoryPoints]
FROM WorkItems
WHERE [System.TeamProject] = 'Process'
  AND [System.AreaPath] UNDER 'Process\AI DevOps'
  AND [System.State] <> 'Closed'
ORDER BY [System.ChangedDate] DESC
```
