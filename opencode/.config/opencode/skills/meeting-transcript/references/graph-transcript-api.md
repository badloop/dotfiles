# Graph Transcript API Reference

## Endpoints

| Operation | Method | URL | Returns |
|-----------|--------|-----|---------|
| List online meetings | GET | `/v1.0/me/onlineMeetings` | JSON (meeting objects) |
| Find meeting by joinWebUrl | GET | `/v1.0/me/onlineMeetings?$filter=joinWebUrl eq '{url}'` | JSON (filtered meetings) |
| List transcripts | GET | `/v1.0/me/onlineMeetings/{meetingId}/transcripts` | JSON (transcript metadata) |
| Get transcript metadata | GET | `/v1.0/me/onlineMeetings/{meetingId}/transcripts/{transcriptId}` | JSON (single transcript) |
| Get transcript content | GET | `{transcriptContentUrl}?$format=text/vtt` | **WebVTT plain text** |

## Meeting Object (key fields)

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Meeting ID (base64-encoded, used in URL paths) |
| `subject` | string | Meeting title |
| `joinWebUrl` | string | Teams join URL (used for lookup) |
| `startDateTime` | string | ISO 8601 UTC start time |
| `endDateTime` | string | ISO 8601 UTC end time |

## Transcript Object (key fields)

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Transcript ID (base64-encoded) |
| `createdDateTime` | string | ISO 8601 UTC creation time |
| `endDateTime` | string | ISO 8601 UTC end time |
| `transcriptContentUrl` | string | Full URL to fetch VTT content |
| `meetingId` | string | Parent meeting ID |

## WebVTT Format

Transcript content uses the WebVTT format with speaker identification:

```
WEBVTT

00:00:09.432 --> 00:00:10.752
<v Speaker Name>Spoken text here.</v>

00:00:15.912 --> 00:00:21.672
<v Another Speaker>Their spoken text.</v>
```

- Timestamps are relative to the meeting start
- Speaker names are in `<v Name>...</v>` voice tags
- Overlapping timestamps are normal (multiple speakers at once)
- Parse speakers with regex: `<v ([^>]+)>(.*?)</v>`

## Required Scopes

| Scope | Type | Purpose |
|-------|------|---------|
| `OnlineMeetings.Read` | Delegated | List and read meeting metadata |
| `OnlineMeetingTranscript.Read.All` | Delegated | Read transcript content |

## Known Limitations

| Limitation | Details |
|------------|---------|
| No `$filter` on transcripts | `/transcripts?$filter=...` returns 400. Filter client-side. |
| No `$orderby` on transcripts | Same — not supported. Results are ordered most-recent-first by default. |
| No `$filter` by `chatType` on chats | Returns 400 if attempted. |
| Content is not JSON | `transcriptContentUrl` returns VTT. Must use raw HTTP fetch, not `call_graph()`. |
| Meeting ID encoding | IDs contain special characters (`*`, `/`). URL-encode if constructing URLs manually. |

## Error Codes

| HTTP Code | Cause | Resolution |
|-----------|-------|------------|
| 400 | Unsupported `$filter`/`$orderby` on transcripts | Remove query params, filter client-side |
| 401 | Token expired | Re-authenticate with `authenticate()` |
| 403 | Missing scope consent | Need admin consent for `OnlineMeetingTranscript.Read.All` |
| 404 | Missing `/v1.0/` in path, or bad meeting/transcript ID | Always include `/v1.0/`; re-fetch IDs if stale |
| JSONDecodeError | Fetched VTT with `call_graph()` | Use raw `urllib.request` fetch instead |
