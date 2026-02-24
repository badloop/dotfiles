---
name: meeting-transcript
description: Fetches and summarizes Microsoft Teams meeting transcripts via the Microsoft Graph API. Use when the user asks to review, summarize, or catch up on a Teams meeting they missed, or when transcript content is needed during the daily briefing routine.
compatibility: Requires Python 3 and graph_auth.py (discovered via GRAPH_AUTH_DIR or ~/code/work/today/tools). Needs Microsoft Graph token with OnlineMeetings.Read and OnlineMeetingTranscript.Read.All scopes.
metadata:
  author: Aaron Dunlap
  version: "2.0"
allowed-tools: Bash Read
---

# Meeting Transcript

You are a Teams meeting transcript assistant. Fetch meeting transcripts from Microsoft Graph and produce concise, actionable summaries.

## Authentication

All Graph API calls use the `graph_auth.py` helper:

```python
import os, sys, urllib.request

graph_dir = os.environ.get("GRAPH_AUTH_DIR", os.path.expanduser("~/code/work/today/tools"))
sys.path.insert(0, graph_dir)

from graph_auth import authenticate, call_graph
token = authenticate()
```

## Workflow: Fetch a Meeting Transcript

### Step 1: Find the online meeting

You need the `joinWebUrl` from the Outlook calendar event. If you already have it from a calendarView fetch, skip ahead. Otherwise:

```python
events = call_graph(token, "https://graph.microsoft.com/v1.0/me/calendarView?startDateTime=<DATE>T00:00:00Z&endDateTime=<DATE>T23:59:59Z&$select=subject,start,end,onlineMeeting&$filter=isOnlineMeeting eq true")
```

Then look up the online meeting by its joinWebUrl:

```python
meetings = call_graph(token, "https://graph.microsoft.com/v1.0/me/onlineMeetings?$filter=joinWebUrl eq '<JOIN_WEB_URL>'")
meeting_id = meetings["value"][0]["id"]
```

### Step 2: List transcripts and pick the right one

```python
transcripts = call_graph(token, f"https://graph.microsoft.com/v1.0/me/onlineMeetings/{meeting_id}/transcripts")
```

Each transcript has `id`, `createdDateTime`, and `transcriptContentUrl`. Match by `createdDateTime` for the target date. The list is ordered most recent first.

**Do not use `$filter` or `$orderby`** on the transcripts endpoint — they return 400.

### Step 3: Fetch transcript content (VTT)

**Critical**: The content endpoint returns WebVTT plain text, not JSON. `call_graph()` will crash with `JSONDecodeError`. Use a raw fetch instead:

```python
content_url = transcript["transcriptContentUrl"] + "?$format=text/vtt"
req = urllib.request.Request(content_url)
req.add_header("Authorization", f"Bearer {token}")
with urllib.request.urlopen(req) as resp:
    vtt_text = resp.read().decode("utf-8")
print(vtt_text)
```

### Step 4: Summarize

Parse the VTT content (speakers are in `<v Name>...</v>` tags) and produce:

1. **Meeting duration** — first to last timestamp
2. **Attendees** — unique speaker names
3. **Per-person summary** — what each person discussed, grouped by topic
4. **Decisions and action items** — anything requiring follow-up
5. **Items relevant to the user** — mentions of them, their team, or projects
6. **Assessment** — does anything need immediate attention?

## Rules

- **All Graph URLs must include `/v1.0/`** — e.g., `.../v1.0/me/onlineMeetings`, never `.../me/onlineMeetings`
- **Never fetch transcript content with `call_graph()`** — it parses JSON; VTT will crash it
- **Never use `$filter`/`$orderby` on the transcripts endpoint** — filter client-side by `createdDateTime`
- **Re-authenticate on 401** — tokens are short-lived (~1 hour)

## call_graph() Signature

```python
call_graph(token, url, method="GET", body=None, content_type="application/json")
```

Returns parsed JSON, or `None` for 204. `body` accepts a dict or bytes.

For endpoint details, error codes, and the VTT format reference, see [references/graph-transcript-api.md](references/graph-transcript-api.md).
