# Microsoft Graph API Reference for Teams Messaging

## Available Scopes

| Scope | Capability |
|-------|-----------|
| `Chat.Read` | List chats and read chat message content |
| `Chat.ReadBasic` | List chats (metadata only, no message content) |
| `ChatMessage.Read` | Read Teams chat (1:1 and group) messages |
| `ChatMessage.Send` | Send Teams chat messages |
| `Channel.ReadBasic.All` | List Teams channels |
| `ChannelMessage.Read.All` | Read Teams channel messages |
| `ChannelMessage.Send` | Post to Teams channels |
| `Team.ReadBasic.All` | List Teams teams |
| `User.Read` | Read user profile |

## Chat Endpoints

### List Recent Chats

```
GET /v1.0/me/chats?$top=50&$expand=members
```

Returns chats with embedded member info. Key fields per chat:

| Field | Description |
|-------|-------------|
| `id` | Chat ID (use for message operations) |
| `chatType` | `oneOnOne`, `group`, or `meeting` |
| `topic` | Chat topic (group/meeting chats only) |
| `members` | Array of member objects with `displayName` and `email` |
| `lastMessagePreview` | Preview of last message (if using `$expand=lastMessagePreview`) |

### Get Chat Messages

```
GET /v1.0/me/chats/{chat-id}/messages?$top=10
```

Returns messages ordered by creation time (newest first). Key fields per message:

| Field | Description |
|-------|-------------|
| `id` | Message ID |
| `body.content` | Message text (may contain HTML) |
| `body.contentType` | `text` or `html` |
| `from.user.displayName` | Sender's display name |
| `createdDateTime` | ISO 8601 timestamp (UTC) |
| `messageType` | `message`, `systemEventMessage`, etc. |

### Send Chat Message

```
POST /v1.0/me/chats/{chat-id}/messages
```

**Request body:**

```json
{
  "body": {
    "content": "Hello, this is a message"
  }
}
```

For HTML content:

```json
{
  "body": {
    "contentType": "html",
    "content": "<p>Hello, this is <strong>formatted</strong></p>"
  }
}
```

## Channel Endpoints

### List Joined Teams

```
GET /v1.0/me/joinedTeams
```

Key fields: `id`, `displayName`, `description`.

### List Team Channels

```
GET /v1.0/teams/{team-id}/channels
```

Key fields: `id`, `displayName`, `description`, `membershipType`.

### Get Channel Messages

```
GET /v1.0/teams/{team-id}/channels/{channel-id}/messages?$top=10
```

Same message schema as chat messages.

### Post to Channel

```
POST /v1.0/teams/{team-id}/channels/{channel-id}/messages
```

Same request body format as chat messages.

## Chat Identification Tips

- **1:1 chats** (`chatType: "oneOnOne"`): Identify by the other member's `displayName` (exclude the authenticated user).
- **Group chats** (`chatType: "group"`): Identify by `topic` field or by listing all member names.
- **Meeting chats** (`chatType: "meeting"`): Identify by `topic` field (typically the meeting subject). These are group chats auto-created from calendar meetings.

## Filtering and Pagination

- Use `$top=N` to limit results.
- Use `$filter` for server-side filtering (limited support on chat messages).
- Use `$orderby=createdDateTime desc` where supported.
- Follow `@odata.nextLink` for additional pages.
- All timestamps are in UTC; convert to local time for display.

## Error Handling

| Status | Meaning | Action |
|--------|---------|--------|
| 401 | Token expired | Re-authenticate with `authenticate()` |
| 403 | Insufficient permissions | Check required scopes |
| 404 | Chat/channel not found | Verify the ID exists |
| 429 | Throttled | Wait and retry (check `Retry-After` header) |
