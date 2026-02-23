---
name: ado-work-items
description: Creates, updates, and closes Azure DevOps work items (user stories) via the Azure CLI. Handles required fields, user tagging, iteration selection, and resolution summaries. Use when the user asks to create a story, close a ticket, update a work item, or manage ADO tasks.
compatibility: Requires Azure CLI (az) with Azure DevOps extension. Requires jq for user lookups.
metadata:
  author: ""
  version: "1.0"
allowed-tools: Bash Read
---

# ADO Work Items

You manage Azure DevOps work items via `az boards`. Every create, update, or close operation must follow the rules below.

## Organization Defaults

- **Org:** `https://dev.azure.com/${ADO_ORG}`
- **Project:** `Process`
- **Default assignee:** `${ADO_USER_EMAIL}`

## Workflows

### Creating a Story

1. **Check an existing story first** to get the correct Area Path (e.g., `Process\AI DevOps`).
2. **Select the iteration dynamically** based on the current date and ADO iteration date ranges.
3. **Ask which Application Name to use** if not obvious from context.
4. **Create:**

   ```bash
   az boards work-item create \
     --type "User Story" \
     --title "<title>" \
      --org "https://dev.azure.com/${ADO_ORG}" \
      --project "Process" \
      --area "Process\\AI DevOps" \
      --iteration "<select dynamically>" \
      --fields "System.State=Active" \
        "Microsoft.VSTS.Scheduling.StoryPoints=<points>" \
        "System.AssignedTo=${ADO_USER_EMAIL}" \
       "Custom.ParentApplication=<AI APPS|JAK|TECHMATE>" \
     --description "<description>"
   ```

### Updating a Story

Before any update, verify these required fields are set (fill in if blank):

| Field | API Name | Rules |
|-------|----------|-------|
| Story Points | `Microsoft.VSTS.Scheduling.StoryPoints` | 1 = trivial, 2-3 = small, 5 = medium, 8+ = large |
| Application Name | `Custom.ParentApplication` | `AI APPS`, `JAK`, or `TECHMATE`. Ask if unclear. |
| Assigned To | `System.AssignedTo` | Default to the configured user unless specified otherwise |

### Closing a Story

1. **Check required fields** (above).
2. **Write a Resolution Summary** (`Custom.ResolutionSummary`) — short, friendly sentence + bulleted list of deliverables/links. Tag the story opener in the summary.
3. **Close in one update:**

   ```bash
    az boards work-item update --id <id> \
      --org "https://dev.azure.com/${ADO_ORG}" \
     --state "Closed" \
     --fields "Custom.ResolutionSummary=<summary>"
   ```

4. **Add one discussion comment** tagging the creator. Keep it brief.

### Tagging Users

Plain `@Name` does NOT work in the API. You must use HTML mentions:

1. **Look up the user's ID:**

   ```bash
    az devops user list --org "https://dev.azure.com/${ADO_ORG}" --top 3839 -o json \
     | jq -r '.items[] | select(.user.displayName | test("NAME"; "i")) | "\(.user.displayName) | \(.user.originId)"'
   ```

2. **Use HTML format** in descriptions, resolution summaries, and comments:

   ```html
   <a href="#" data-vss-mention="version:2.0,{userID}">@Display Name</a>
   ```

## Rules

- **Always assign to the configured user** unless told otherwise.
- **Always set Application Name** — ask if unclear.
- **Always set Story Points** before closing.
- **Tag users with HTML mentions** — plain @Name is silently ignored.
- **Close in one API call** — don't set state and fields in separate updates.

For field reference and valid values, see [references/field-reference.md](references/field-reference.md).
