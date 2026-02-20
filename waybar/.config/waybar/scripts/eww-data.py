#!/usr/bin/env python3
"""EWW data helper for poll commands and actions.

Replaces all inline Python in eww.yuck defpolls and eww-helpers.sh.
Usage: eww-data.py <command> [args...]

Data commands (for defpoll):
  github-status-indicator    - prints status indicator (none/minor/major/critical)
  github-status-description  - prints status description
  github-incidents-count     - prints number of active incidents
  github-unread-count        - prints number of unread stories
  github-unread-json         - prints cleaned unread JSON array
  weather-temp               - prints temperature string
  weather-feels              - prints feels-like string
  weather-desc               - prints weather description
  weather-icon               - prints weather emoji icon
  weather-humidity           - prints humidity value
  weather-wind               - prints wind string
  weather-pressure           - prints pressure string
  weather-uv                 - prints UV index string
  weather-cloud              - prints cloud cover string
  weather-last-update        - prints last update time
  spc-active                 - prints true/false
  spc-label                  - prints SPC risk label
  spc-full                   - prints SPC full risk name
  spc-color                  - prints SPC risk color hex
  md-count                   - prints MD count
  md-items-json              - prints MD items JSON
  hwo-active                 - prints true/false
  hwo-summary                - prints HWO summary
  hwo-issued                 - prints HWO issued time
  forecast-json              - prints forecast JSON with dayName
  watches-json               - prints watches JSON
  warnings-json              - prints warnings JSON
  advisories-json            - prints advisories JSON
  watches-count              - prints watch count
  warnings-count             - prints warning count
  advisories-count           - prints advisory count

Action commands:
  mark-read <story-id>       - remove story from unread
  mark-all-read              - clear all unread
  open-and-mark <id> <url>   - open URL and mark read
"""

import html
import json
import os
import re
import subprocess
import sys
from datetime import datetime

GITHUB_CACHE = os.path.expanduser("~/.cache/waybar/github-news")
WEATHER_CACHE = os.path.expanduser("~/.cache/waybar/weather")
UNREAD_FILE = os.path.join(GITHUB_CACHE, "unread.json")


def load_json(path, default=None):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return default if default is not None else {}


def github_status():
    return load_json(os.path.join(GITHUB_CACHE, "status.json"), {})


def weather_data():
    return load_json(os.path.join(WEATHER_CACHE, "weather.json"), {})


def cmd_github_status_indicator():
    d = github_status()
    print(d.get("status", {}).get("indicator", "none"))


def cmd_github_status_description():
    d = github_status()
    print(d.get("status", {}).get("description", "Unknown"))


def cmd_github_incidents_count():
    d = load_json(os.path.join(GITHUB_CACHE, "incidents.json"), [])
    print(len(d))


def cmd_github_unread_count():
    d = load_json(UNREAD_FILE, [])
    print(len(d))


def cmd_github_unread_json():
    d = load_json(UNREAD_FILE, [])
    for item in d:
        desc = item.get("description", "")
        desc = re.sub(r"<[^>]+>", "", desc)
        desc = html.unescape(desc)
        desc = desc.replace('"', "'")
        item["description"] = desc[:150]
    print(json.dumps(d))


def cmd_weather_temp():
    d = weather_data()
    t = d.get("current", {}).get("temperature")
    print(f"{t}\u00b0F" if t is not None else "...")


def cmd_weather_feels():
    d = weather_data()
    t = d.get("current", {}).get("feelsLike")
    print(f"{t}\u00b0F" if t is not None else "...")


def cmd_weather_desc():
    d = weather_data()
    print(d.get("current", {}).get("description", "Unknown"))


def cmd_weather_icon():
    d = weather_data()
    print(d.get("current", {}).get("icon", "\u2601"))


def cmd_weather_humidity():
    d = weather_data()
    print(d.get("current", {}).get("humidity", 0))


def cmd_weather_wind():
    c = weather_data().get("current", {})
    print(f"{c.get('windSpeed', 0)} mph {c.get('windDirectionStr', '')}")


def cmd_weather_pressure():
    d = weather_data()
    p = d.get("current", {}).get("pressure", 0)
    print(f"{int(p)} hPa")


def cmd_weather_uv():
    d = weather_data()
    uv = d.get("current", {}).get("uvIndex", 0)
    levels = {
        0: "Low",
        1: "Low",
        2: "Low",
        3: "Mod",
        4: "Mod",
        5: "Mod",
        6: "High",
        7: "High",
        8: "V.High",
        9: "V.High",
        10: "V.High",
    }
    level = levels.get(uv, "Extreme" if uv > 10 else "Low")
    print(f"{uv} ({level})")


def cmd_weather_cloud():
    d = weather_data()
    print(f"{d.get('current', {}).get('cloudCover', 0)}%")


def cmd_weather_last_update():
    d = weather_data()
    ts = d.get("lastUpdate", "")
    if ts:
        try:
            dt = datetime.fromisoformat(ts)
            print(dt.strftime("%I:%M %p").lstrip("0"))
            return
        except Exception:
            pass
    print("Never")


def cmd_spc_active():
    d = weather_data()
    o = d.get("spcOutlook")
    if o and o.get("label", "") not in ("", "TSTM"):
        print("true")
    else:
        print("false")


def cmd_spc_label():
    d = weather_data()
    o = d.get("spcOutlook")
    print(o.get("label", "") if o else "")


def cmd_spc_full():
    d = weather_data()
    o = d.get("spcOutlook")
    print(o.get("full", "") if o else "")


def cmd_spc_color():
    d = weather_data()
    o = d.get("spcOutlook")
    print(o.get("color", "#888888") if o else "#888888")


def cmd_md_count():
    d = weather_data()
    print(len(d.get("mesoscaleDiscussions", [])))


def cmd_md_items_json():
    d = weather_data()
    print(json.dumps(d.get("mesoscaleDiscussions", [])))


def cmd_hwo_active():
    d = weather_data()
    print("true" if d.get("hwo", {}).get("active", False) else "false")


def cmd_hwo_summary():
    d = weather_data()
    print(d.get("hwo", {}).get("summary", ""))


def cmd_hwo_issued():
    d = weather_data()
    print(d.get("hwo", {}).get("issuedTime", ""))


def cmd_forecast_json():
    d = weather_data()
    forecasts = d.get("forecast", [])
    for item in forecasts:
        dt_str = item.get("date", "")
        if dt_str:
            try:
                dt = datetime.strptime(dt_str, "%Y-%m-%d")
                item["dayName"] = dt.strftime("%a")
            except Exception:
                item["dayName"] = "---"
        else:
            item["dayName"] = "---"
    print(json.dumps(forecasts))


def cmd_watches_json():
    print(json.dumps(weather_data().get("watches", [])))


def cmd_warnings_json():
    print(json.dumps(weather_data().get("warnings", [])))


def cmd_advisories_json():
    print(json.dumps(weather_data().get("advisories", [])))


def cmd_watches_count():
    print(len(weather_data().get("watches", [])))


def cmd_warnings_count():
    print(len(weather_data().get("warnings", [])))


def cmd_advisories_count():
    print(len(weather_data().get("advisories", [])))


# ========== ACTION COMMANDS ==========


def cmd_mark_read(story_id):
    d = load_json(UNREAD_FILE, [])
    d = [i for i in d if i.get("id") != story_id]
    with open(UNREAD_FILE, "w") as f:
        json.dump(d, f, indent=2)


def cmd_mark_all_read():
    with open(UNREAD_FILE, "w") as f:
        f.write("[]")


def cmd_open_and_mark(story_id, url):
    subprocess.Popen(
        ["xdg-open", url], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    cmd_mark_read(story_id)


# ========== DISPATCH ==========

COMMANDS = {
    "github-status-indicator": cmd_github_status_indicator,
    "github-status-description": cmd_github_status_description,
    "github-incidents-count": cmd_github_incidents_count,
    "github-unread-count": cmd_github_unread_count,
    "github-unread-json": cmd_github_unread_json,
    "weather-temp": cmd_weather_temp,
    "weather-feels": cmd_weather_feels,
    "weather-desc": cmd_weather_desc,
    "weather-icon": cmd_weather_icon,
    "weather-humidity": cmd_weather_humidity,
    "weather-wind": cmd_weather_wind,
    "weather-pressure": cmd_weather_pressure,
    "weather-uv": cmd_weather_uv,
    "weather-cloud": cmd_weather_cloud,
    "weather-last-update": cmd_weather_last_update,
    "spc-active": cmd_spc_active,
    "spc-label": cmd_spc_label,
    "spc-full": cmd_spc_full,
    "spc-color": cmd_spc_color,
    "md-count": cmd_md_count,
    "md-items-json": cmd_md_items_json,
    "hwo-active": cmd_hwo_active,
    "hwo-summary": cmd_hwo_summary,
    "hwo-issued": cmd_hwo_issued,
    "forecast-json": cmd_forecast_json,
    "watches-json": cmd_watches_json,
    "warnings-json": cmd_warnings_json,
    "advisories-json": cmd_advisories_json,
    "watches-count": cmd_watches_count,
    "warnings-count": cmd_warnings_count,
    "advisories-count": cmd_advisories_count,
    "mark-read": None,  # handled separately (takes args)
    "mark-all-read": None,
    "open-and-mark": None,
}


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <command> [args...]", file=sys.stderr)
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "mark-read" and len(sys.argv) >= 3:
        cmd_mark_read(sys.argv[2])
    elif cmd == "mark-all-read":
        cmd_mark_all_read()
    elif cmd == "open-and-mark" and len(sys.argv) >= 4:
        cmd_open_and_mark(sys.argv[2], sys.argv[3])
    elif cmd in COMMANDS and COMMANDS[cmd] is not None:
        COMMANDS[cmd]()
    else:
        print(f"Unknown command: {cmd}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
