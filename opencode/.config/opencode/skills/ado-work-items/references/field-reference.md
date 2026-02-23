# ADO Work Item Field Reference

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
