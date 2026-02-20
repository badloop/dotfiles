#!/usr/bin/env python3
"""GitHub News + Status bar module for Waybar.

Fetches GitHub platform status + changelog RSS feed.
Outputs Waybar JSON: {"text": "...", "tooltip": "...", "class": "..."}
"""

import json
import os
import subprocess
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from email.utils import parsedate_to_datetime
import random
import time

CACHE_DIR = os.path.expanduser("~/.cache/waybar/github-news")
UNREAD_FILE = os.path.join(CACHE_DIR, "unread.json")
LASTCHECK_FILE = os.path.join(CACHE_DIR, "lastcheck.json")
STATUS_FILE = os.path.join(CACHE_DIR, "status.json")
INCIDENTS_FILE = os.path.join(CACHE_DIR, "incidents.json")
RSS_URL = "https://github.blog/changelog/feed/"

os.makedirs(CACHE_DIR, exist_ok=True)


def load_json(path, default=None):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return default


def save_json(path, data):
    with open(path, "w") as f:
        json.dump(data, f, indent=2)


def curl_fetch(url, timeout=10):
    """Fetch a URL with curl, return stdout or None on failure."""
    try:
        result = subprocess.run(
            ["curl", "-sf", "--max-time", str(timeout), url],
            capture_output=True,
            text=True,
            timeout=timeout + 5,
        )
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout
    except Exception:
        pass
    return None


def fetch_status():
    """Fetch GitHub platform status."""
    raw = curl_fetch("https://www.githubstatus.com/api/v2/status.json")
    if raw:
        try:
            data = json.loads(raw)
            save_json(STATUS_FILE, data)
            indicator = data.get("status", {}).get("indicator", "none")
            description = data.get("status", {}).get("description", "Unknown")
            return indicator, description
        except json.JSONDecodeError:
            pass
    return "none", "Unknown"


def fetch_incidents():
    """Fetch active GitHub incidents."""
    raw = curl_fetch("https://www.githubstatus.com/api/v2/incidents.json")
    if raw:
        try:
            data = json.loads(raw)
            active = [
                i
                for i in data.get("incidents", [])
                if i.get("status") in ("investigating", "identified", "monitoring")
            ]
            save_json(INCIDENTS_FILE, active)
            return active
        except json.JSONDecodeError:
            pass
    save_json(INCIDENTS_FILE, [])
    return []


def fetch_rss_and_update_unread():
    """Fetch RSS feed and update unread list."""
    unread = load_json(UNREAD_FILE, [])

    try:
        last_data = load_json(LASTCHECK_FILE, {})
        last_check_str = last_data.get("lastCheck", "1970-01-01T00:00:00+00:00")
        last_check = datetime.fromisoformat(last_check_str.replace("Z", "+00:00"))
    except Exception:
        last_check = datetime(1970, 1, 1, tzinfo=timezone.utc)

    raw = curl_fetch(RSS_URL, timeout=15)
    if not raw:
        return unread

    try:
        root = ET.fromstring(raw)
    except ET.ParseError:
        return unread

    existing_urls = {s.get("url") for s in unread}
    new_stories = []

    for item in root.findall(".//item")[:50]:
        title_el = item.find("title")
        link_el = item.find("link")
        pub_el = item.find("pubDate")
        desc_el = item.find("description")

        if title_el is None or link_el is None:
            continue

        title = title_el.text or ""
        url = link_el.text or ""
        pub_date = pub_el.text if pub_el is not None else ""
        desc = (desc_el.text or "") if desc_el is not None else ""
        if len(desc) > 200:
            desc = desc[:200] + "..."

        if url in existing_urls:
            continue

        try:
            pub_time = parsedate_to_datetime(pub_date)
            if pub_time <= last_check:
                continue
        except Exception:
            continue

        new_stories.append(
            {
                "id": f"{int(time.time())}_{random.randint(1000, 9999)}",
                "title": title,
                "url": url,
                "pubDate": pub_date,
                "description": desc,
                "addedAt": datetime.now().isoformat(),
            }
        )

    if new_stories:
        unread = new_stories + unread

    save_json(UNREAD_FILE, unread)
    save_json(LASTCHECK_FILE, {"lastCheck": datetime.now().isoformat()})
    return unread


def main():
    # Fetch all data
    status_indicator, status_desc = fetch_status()
    incidents = fetch_incidents()
    unread = fetch_rss_and_update_unread()
    unread_count = len(unread)

    # Override status based on incident impact
    incident_title = ""
    if incidents:
        incident_title = incidents[0].get("name", "")
        incident_impact = incidents[0].get("impact", "minor")
        if status_indicator == "none":
            status_indicator = incident_impact

    # CSS class
    css_classes = {
        "critical": "critical",
        "major": "major",
        "minor": "minor",
    }
    css_class = css_classes.get(status_indicator, "ok")

    # Build text: GitHub icon + optional incident title + optional unread badge
    # U+E709 = nf-dev-github_badge, rendered via Nerd Font at 18px to match QuickShell sizing
    # Pango size is in 1024ths of a point; 18 * 1024 = 18432
    gh_icon = (
        '<span font_family="JetBrainsMono Nerd Font Mono">\ue709</span>'
    )
    text = gh_icon

    if incident_title:
        if len(incident_title) > 30:
            incident_title = incident_title[:27] + "..."
        text += f" {incident_title}"

    if unread_count > 0:
        text += f"  {unread_count}"

    # Tooltip
    tooltip_lines = [f"GitHub: {status_desc}"]
    if unread_count > 0:
        tooltip_lines.append(f"{unread_count} unread changelog items")
    if incident_title:
        tooltip_lines.append(f"Active: {incident_title}")
    tooltip = "\\n".join(tooltip_lines)

    print(json.dumps({"text": text, "tooltip": tooltip, "class": css_class}))


if __name__ == "__main__":
    main()
