---
name: ms-teams-messaging
description: Sends and reads Microsoft Teams chat and channel messages via the Microsoft Graph API. Use when the user asks to send a Teams message, read Teams chats, check Teams activity, reply to someone on Teams, or post to a Teams channel.
compatibility: Requires Python 3 and graph_auth.py (discovered via GRAPH_AUTH_DIR or ~/code/work/today/tools). Needs Microsoft Graph token with Chat and ChatMessage scopes.
metadata:
  author: ""
  version: "2.0"
allowed-tools: Bash Read
---

# MS Teams Messaging

You are a Microsoft Teams messaging assistant. Send and read Teams chat messages on behalf of the user via Microsoft Graph API.

## Authentication

All Graph API calls use the `graph_auth.py` helper. Locate and authenticate:

```python
import os, sys

# Discover graph_auth location
graph_dir = os.environ.get("GRAPH_AUTH_DIR", os.path.expanduser("~/code/work/today/tools"))
sys.path.insert(0, graph_dir)

from graph_auth import authenticate, call_graph
token = authenticate()
```

- Token is short-lived (~1 hour). Re-authenticate on 401.
- `authenticate()` tries silent refresh first; only opens a browser when needed.

## Workflows

### Send a Chat Message (1:1 or Group)

1. **Find the chat** — list recent chats with members:

   ```python
   chats = call_graph(token, "https://graph.microsoft.com/v1.0/me/chats?$top=50&$expand=members")
   ```

2. **Identify the correct chat** by matching member `displayName` values (exclude the authenticated user). For group chats, match on multiple members or the `topic` field.

3. **Show the user what will be sent** — display the recipient(s) and message content. **Wait for explicit confirmation before sending.**

4. **Send**:

   ```python
   body = {"body": {"content": "Your message here"}}
   call_graph(token, f"https://graph.microsoft.com/v1.0/me/chats/{chat_id}/messages", method="POST", body=body)
   ```

### Read Chat Messages

1. **List chats** (same as above).
2. **Fetch messages**:

   ```python
   messages = call_graph(token, f"https://graph.microsoft.com/v1.0/me/chats/{chat_id}/messages?$top=10")
   ```

3. **Present** with sender name, local timestamp, and content.

### Send a Channel Message

1. **List joined teams**:

   ```python
   teams = call_graph(token, "https://graph.microsoft.com/v1.0/me/joinedTeams")
   ```

2. **List channels**:

   ```python
   channels = call_graph(token, f"https://graph.microsoft.com/v1.0/teams/{team_id}/channels")
   ```

3. **Show the user what will be posted** — display channel name, team name, and message content. **Wait for explicit confirmation.**

4. **Post**:

   ```python
   body = {"body": {"content": "Your message here"}}
   call_graph(token, f"https://graph.microsoft.com/v1.0/teams/{team_id}/channels/{channel_id}/messages", method="POST", body=body)
   ```

### Read Channel Messages

```python
messages = call_graph(token, f"https://graph.microsoft.com/v1.0/teams/{team_id}/channels/{channel_id}/messages?$top=10")
```

## Rules

- **Confirm before sending.** Always show recipients + message content and get explicit "yes" before any POST.
- **Never guess a chat ID.** Always list chats and match by member names or topic.
- **Use `body=`** (not `data=`) for POST/PATCH payloads to `call_graph()`.
- **Meeting chats** have `chatType: "meeting"` — identify by `topic`, not `displayName`.
- **HTML content**: Use `"contentType": "html"` in the body object for rich formatting.
- **Timestamps**: Convert all UTC timestamps to the user's local timezone before displaying.
- **Pagination**: Follow `@odata.nextLink` if present in responses.

## call_graph() Signature

```python
call_graph(token, url, method="GET", body=None, content_type="application/json")
```

Returns parsed JSON, or `None` for 204 responses. `body` accepts a dict (auto-serialized) or bytes.

For endpoint details, scopes, field schemas, and error codes, see [references/graph-api-reference.md](references/graph-api-reference.md).
