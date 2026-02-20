#!/usr/bin/env python3
"""Weather bar module for Waybar.

Fetches NWS observations, forecast, alerts, HWO, SPC outlook, MDs.
Outputs Waybar JSON: {"text": "...", "tooltip": "...", "class": "..."}
"""

import json
import os
import re
import subprocess
import sys
import xml.etree.ElementTree as ET
from datetime import datetime

CACHE_DIR = os.path.expanduser("~/.cache/waybar/weather")
WEATHER_CONFIG = os.path.expanduser("~/.local/share/weather/config")
UA = "User-Agent: (waybar-weather, contact@example.com)"


def load_weather_config():
    """Load location config from ~/.local/share/weather/config."""
    if not os.path.exists(WEATHER_CONFIG):
        print(
            f"ERROR: Weather config not found at {WEATHER_CONFIG}\n"
            "Create it with the following keys:\n"
            "  LAT=<latitude>        # e.g. 37.97\n"
            "  LON=<longitude>       # e.g. -87.56\n"
            "  STATION=<station_id>  # e.g. KEVV (NWS observation station)\n"
            "  OFFICE=<office_code>  # e.g. PAH (NWS forecast office)\n"
            "  GRIDPOINT=<x,y>       # e.g. 167,97 (NWS grid coordinates)\n"
            "\n"
            "Find your values:\n"
            "  - Station list: https://www.weather.gov/media/documentation/docs/current_stationlist.txt\n"
            "  - Office/grid:  curl https://api.weather.gov/points/<LAT>,<LON>",
            file=sys.stderr,
        )
        sys.exit(1)

    cfg = {}
    with open(WEATHER_CONFIG) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" in line:
                key, val = line.split("=", 1)
                cfg[key.strip()] = val.strip()

    missing = [
        k for k in ("LAT", "LON", "STATION", "OFFICE", "GRIDPOINT") if k not in cfg
    ]
    if missing:
        print(
            f"ERROR: Missing keys in {WEATHER_CONFIG}: {', '.join(missing)}",
            file=sys.stderr,
        )
        sys.exit(1)

    return cfg


WEATHER_CFG = load_weather_config()
LAT = float(WEATHER_CFG["LAT"])
LON = float(WEATHER_CFG["LON"])
STATION = WEATHER_CFG["STATION"]
OFFICE = WEATHER_CFG["OFFICE"]
GRIDPOINT = WEATHER_CFG["GRIDPOINT"]

os.makedirs(CACHE_DIR, exist_ok=True)


def load_json(path):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return None


def save_json(path, data):
    with open(path, "w") as f:
        json.dump(data, f, indent=2)


def curl_fetch_to_file(url, path, headers=None, timeout=10):
    """Fetch URL to file with curl. Returns the subprocess.Popen object."""
    cmd = ["curl", "-sf", "--max-time", str(timeout)]
    if headers:
        for h in headers:
            cmd.extend(["-H", h])
    cmd.extend(["-o", path, url])
    return subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def map_nws_forecast(text):
    """Map NWS forecast text to a weather emoji."""
    t = (text or "").lower()
    if "thunder" in t:
        return "\u26c8"  # ⛈
    if "snow" in t:
        return "\U0001f328"  # 🌨
    if "sleet" in t or "ice" in t:
        return "\U0001f328"  # 🌨
    if "freezing" in t:
        return "\U0001f327"  # 🌧
    if "rain" in t or "showers" in t:
        return "\U0001f327"  # 🌧
    if "drizzle" in t:
        return "\U0001f327"  # 🌧
    if "fog" in t:
        return "\U0001f32b"  # 🌫
    if "cloudy" in t and "partly" in t:
        return "\u26c5"  # ⛅
    if "cloudy" in t and "mostly" in t:
        return "\U0001f325"  # 🌥
    if "cloudy" in t or "overcast" in t:
        return "\u2601"  # ☁
    if "sunny" in t and "mostly" in t:
        return "\U0001f324"  # 🌤
    if "sunny" in t or "clear" in t:
        return "\u2600"  # ☀
    return "\u2601"  # ☁


def get_wind_direction(degrees):
    directions = [
        "N",
        "NNE",
        "NE",
        "ENE",
        "E",
        "ESE",
        "SE",
        "SSE",
        "S",
        "SSW",
        "SW",
        "WSW",
        "W",
        "WNW",
        "NW",
        "NNW",
    ]
    idx = round(degrees / 22.5) % 16
    return directions[idx]


def point_in_polygon(x, y, polygon):
    n = len(polygon)
    inside = False
    j = n - 1
    for i in range(n):
        xi, yi = polygon[i]
        xj, yj = polygon[j]
        if ((yi > y) != (yj > y)) and (x < (xj - xi) * (y - yi) / (yj - yi) + xi):
            inside = not inside
        j = i
    return inside


def get_val(obj):
    if obj is None:
        return None
    return obj.get("value")


# ========== FETCH ALL DATA IN PARALLEL ==========


def fetch_all():
    procs = [
        curl_fetch_to_file(
            f"https://api.weather.gov/stations/{STATION}/observations/latest",
            os.path.join(CACHE_DIR, "observations.json"),
            headers=[UA],
        ),
        curl_fetch_to_file(
            f"https://api.weather.gov/gridpoints/{OFFICE}/{GRIDPOINT}/forecast",
            os.path.join(CACHE_DIR, "forecast_raw.json"),
            headers=[UA],
        ),
        curl_fetch_to_file(
            f"https://api.weather.gov/alerts/active?point={LAT},{LON}",
            os.path.join(CACHE_DIR, "alerts_raw.json"),
            headers=[UA],
        ),
        curl_fetch_to_file(
            f"https://api.weather.gov/products/types/HWO/locations/{OFFICE}",
            os.path.join(CACHE_DIR, "hwo_list.json"),
            headers=[UA],
        ),
        curl_fetch_to_file(
            "https://www.spc.noaa.gov/products/outlook/day1otlk_cat.lyr.geojson",
            os.path.join(CACHE_DIR, "spc_raw.json"),
        ),
        curl_fetch_to_file(
            "https://www.spc.noaa.gov/products/spcmdrss.xml",
            os.path.join(CACHE_DIR, "md_rss.xml"),
        ),
    ]
    for p in procs:
        p.wait()


# ========== PROCESS OBSERVATIONS ==========


def process_observations():
    obs_data = load_json(os.path.join(CACHE_DIR, "observations.json"))
    if not obs_data:
        return {}

    props = obs_data.get("properties", {})

    temp_c = get_val(props.get("temperature"))
    temp_f = round(temp_c * 9 / 5 + 32) if temp_c is not None else None

    wc = get_val(props.get("windChill"))
    feels_f = round(wc * 9 / 5 + 32) if wc is not None else temp_f

    humidity = get_val(props.get("relativeHumidity"))
    humidity = round(humidity) if humidity is not None else 0

    pressure_pa = get_val(props.get("barometricPressure"))
    pressure = round(pressure_pa / 100, 1) if pressure_pa is not None else 0

    wind_kmh = get_val(props.get("windSpeed"))
    wind_mph = round(wind_kmh * 0.621371) if wind_kmh is not None else 0

    wind_dir = get_val(props.get("windDirection")) or 0
    vis_m = get_val(props.get("visibility"))
    vis_miles = round(vis_m / 1609.34, 1) if vis_m is not None else 10

    desc = props.get("textDescription", "Unknown")
    icon = map_nws_forecast(desc)

    return {
        "temperature": temp_f,
        "feelsLike": feels_f,
        "humidity": humidity,
        "pressure": pressure,
        "windSpeed": wind_mph,
        "windDirection": wind_dir,
        "windDirectionStr": get_wind_direction(wind_dir) if wind_dir else "N/A",
        "visibility": vis_miles,
        "description": desc,
        "icon": icon,
        "uvIndex": 0,
        "cloudCover": 0,
    }


# ========== PROCESS FORECAST ==========


def process_forecast():
    fcst_data = load_json(os.path.join(CACHE_DIR, "forecast_raw.json"))
    if not fcst_data:
        return []

    periods = fcst_data.get("properties", {}).get("periods", [])
    forecast = []

    # Skip to first daytime period, skip "Today"/"This Afternoon"
    i = 0
    while i < len(periods) and not periods[i].get("isDaytime", True):
        i += 1
    if i < len(periods) and "This" in periods[i].get("name", ""):
        i += 1
        if i < len(periods):
            i += 1

    days_collected = 0
    while i < len(periods) - 1 and days_collected < 3:
        day = periods[i]
        night = periods[i + 1] if i + 1 < len(periods) else None
        if day.get("isDaytime", False):
            start = day.get("startTime", "")
            date = start[:10] if start else ""
            forecast.append(
                {
                    "date": date,
                    "high": day.get("temperature", 0),
                    "low": night.get("temperature", 0) if night else 0,
                    "icon": map_nws_forecast(day.get("shortForecast", "")),
                    "description": day.get("shortForecast", ""),
                }
            )
            days_collected += 1
            i += 2
        else:
            i += 1

    return forecast


# ========== PROCESS ALERTS ==========


def process_alerts():
    alerts_data = load_json(os.path.join(CACHE_DIR, "alerts_raw.json"))
    watches, warnings, advisories, all_alerts = [], [], [], []

    if not alerts_data:
        return watches, warnings, advisories, all_alerts

    for feature in alerts_data.get("features", []):
        p = feature.get("properties", {})
        params = p.get("parameters", {})

        # Build alert URL
        awips_list = params.get("AWIPSidentifier", [])
        alert_url = ""
        if awips_list and len(awips_list[0]) >= 6:
            awips = awips_list[0]
            product = awips[:3]
            wfo = awips[3:6]
            alert_url = f"https://forecast.weather.gov/product.php?site={wfo}&issuedby={wfo}&product={product}"
        if not alert_url:
            aid = p.get("id", "")
            if aid:
                alert_url = f"https://alerts.weather.gov/search?id={aid}"

        desc_text = p.get("description", "")
        alert_obj = {
            "id": p.get("id", ""),
            "event": p.get("event", "Unknown Alert"),
            "headline": p.get("headline", ""),
            "description": desc_text[:500] + "..."
            if len(desc_text) > 500
            else desc_text,
            "severity": p.get("severity", "Unknown"),
            "urgency": p.get("urgency", "Unknown"),
            "url": alert_url,
            "expires": p.get("expires", ""),
        }
        all_alerts.append(alert_obj)

        event = p.get("event", "").lower()
        if "watch" in event:
            watches.append(alert_obj)
        elif "warning" in event:
            warnings.append(alert_obj)
        else:
            advisories.append(alert_obj)

    return watches, warnings, advisories, all_alerts


# ========== PROCESS HWO ==========


def process_hwo():
    hwo = {"active": False, "summary": "", "issuedTime": ""}
    hwo_list = load_json(os.path.join(CACHE_DIR, "hwo_list.json"))
    if not hwo_list:
        return hwo

    products = hwo_list.get("@graph", [])
    if not products:
        return hwo

    product_id = products[0].get("id", "")
    issued_time = products[0].get("issuanceTime", "")
    if not product_id:
        return hwo

    try:
        import urllib.request

        req = urllib.request.Request(
            f"https://api.weather.gov/products/{product_id}",
            headers={"User-Agent": "(waybar-weather, contact@example.com)"},
        )
        with urllib.request.urlopen(req, timeout=10) as resp:
            product_data = json.load(resp)

        text = product_data.get("productText", "")
        day_one_match = re.search(
            r"\.DAY ONE[^.]*\.\s*(.+?)(?=\.DAYS TWO|\.SPOTTER|\$\$)",
            text,
            re.DOTALL | re.IGNORECASE,
        )
        if day_one_match:
            day_one_text = day_one_match.group(1).strip()
            no_hazard_phrases = [
                "no hazardous weather",
                "no hazards expected",
                "no hazards are expected",
                "none expected",
                "no significant weather",
            ]
            has_no_hazards = any(p in day_one_text.lower() for p in no_hazard_phrases)
            if not has_no_hazards and len(day_one_text) > 20:
                hwo["active"] = True
                summary = re.sub(r"\s+", " ", day_one_text).strip()[:200]
                if len(summary) == 200:
                    summary = summary.rsplit(" ", 1)[0] + "..."
                hwo["summary"] = summary

        if issued_time:
            try:
                dt = datetime.fromisoformat(issued_time.replace("Z", "+00:00"))
                hwo["issuedTime"] = dt.strftime("%I:%M %p %Z").lstrip("0")
            except Exception:
                hwo["issuedTime"] = issued_time
    except Exception as e:
        print(f"HWO fetch error: {e}", file=sys.stderr)

    return hwo


# ========== PROCESS SPC OUTLOOK ==========


def process_spc():
    spc_data = load_json(os.path.join(CACHE_DIR, "spc_raw.json"))
    if not spc_data:
        return None

    RISK_ORDER = {"TSTM": 0, "MRGL": 1, "SLGT": 2, "ENH": 3, "MDT": 4, "HIGH": 5}
    RISK_COLORS = {
        "TSTM": "#55BB55",
        "MRGL": "#66A366",
        "SLGT": "#FFE066",
        "ENH": "#FFA500",
        "MDT": "#FF0000",
        "HIGH": "#FF00FF",
    }
    RISK_FULL = {
        "TSTM": "General Thunderstorms",
        "MRGL": "Marginal Risk",
        "SLGT": "Slight Risk",
        "ENH": "Enhanced Risk",
        "MDT": "Moderate Risk",
        "HIGH": "High Risk",
    }

    highest_risk_level = -1
    spc_outlook = None

    for feature in spc_data.get("features", []):
        geom = feature.get("geometry", {})
        props = feature.get("properties", {})
        label = props.get("LABEL", "")
        coords = geom.get("coordinates", [])

        if geom.get("type") == "MultiPolygon":
            for polygon_group in coords:
                for polygon in (
                    polygon_group
                    if isinstance(polygon_group[0][0], list)
                    else [polygon_group]
                ):
                    if point_in_polygon(LON, LAT, polygon):
                        risk_level = RISK_ORDER.get(label, -1)
                        if risk_level > highest_risk_level:
                            highest_risk_level = risk_level
                            spc_outlook = {
                                "label": label,
                                "full": RISK_FULL.get(label, label),
                                "color": props.get(
                                    "fill", RISK_COLORS.get(label, "#888888")
                                ),
                            }

    return spc_outlook


# ========== PROCESS MESOSCALE DISCUSSIONS ==========


def process_mds():
    mds = []
    md_rss_path = os.path.join(CACHE_DIR, "md_rss.xml")
    if not os.path.exists(md_rss_path):
        return mds

    try:
        with open(md_rss_path) as f:
            xml_content = f.read()
        if not xml_content.strip():
            return mds

        root = ET.fromstring(xml_content)
        for item in root.findall(".//item"):
            title_elem = item.find("title")
            desc_elem = item.find("description")
            if title_elem is None or desc_elem is None:
                continue

            title = title_elem.text or ""
            description = desc_elem.text or ""

            md_match = re.search(r"(?:SPC )?MD\s*(\d+)", title)
            if not md_match:
                md_match = re.search(r"Mesoscale Discussion (\d+)", title)
            if not md_match:
                continue

            md_number = md_match.group(1).zfill(4)

            # Parse LAT...LON polygon
            match = re.search(
                r"LAT\.\.\.LON\s+([\d\s]+?)(?=\n\n|\n[A-Z]|$)",
                description,
                re.DOTALL,
            )
            if not match:
                continue

            numbers = re.findall(r"\d+", match.group(1))
            coord_list = []
            for num in numbers:
                if len(num) >= 7:
                    lat_raw = int(num[:4])
                    lon_raw = int(num[4:])
                    lat = lat_raw / 100.0
                    lon = -lon_raw / 100.0
                    if 20 <= lat <= 55 and -130 <= lon <= -60:
                        coord_list.append((lon, lat))
            if not coord_list:
                continue

            if point_in_polygon(LON, LAT, coord_list):
                summary = re.sub(
                    r"LAT\.\.\.LON.*", "", description, flags=re.DOTALL
                ).strip()
                summary = re.sub(r"\s+", " ", summary)[:200]
                if len(summary) == 200:
                    summary = summary.rsplit(" ", 1)[0] + "..."
                mds.append(
                    {
                        "number": md_number,
                        "title": title,
                        "summary": summary,
                        "url": f"https://www.spc.noaa.gov/products/md/md{md_number}.html",
                    }
                )
    except Exception as e:
        print(f"MD parse error: {e}", file=sys.stderr)

    return mds


# ========== BUILD WAYBAR OUTPUT ==========

# SPC risk label -> text color (matching quickshell: black text for lighter badges)
SPC_TEXT_COLORS = {
    "MRGL": "#000000",
    "SLGT": "#000000",
    "ENH": "#FFFFFF",
    "MDT": "#FFFFFF",
    "HIGH": "#FFFFFF",
}


def build_module_output(module, cache):
    """Build waybar JSON for a single sub-module from cached data."""
    current = cache.get("current", {})
    watches = cache.get("watches", [])
    warnings = cache.get("warnings", [])
    advisories = cache.get("advisories", [])
    hwo = cache.get("hwo", {})
    spc_outlook = cache.get("spcOutlook")
    mds = cache.get("mesoscaleDiscussions", [])

    has_spc = spc_outlook is not None and spc_outlook.get("label", "") not in (
        "",
        "TSTM",
    )
    has_md = len(mds) > 0

    if module == "spc":
        if not has_spc:
            return {"text": "", "tooltip": "", "class": "hidden"}
        label = spc_outlook["label"]
        return {
            "text": label,
            "tooltip": f"SPC: {spc_outlook.get('full', label)}",
            "class": f"spc-{label.lower()}",
        }

    elif module == "md":
        if not has_md:
            return {"text": "", "tooltip": "", "class": "hidden"}
        text = f"MD {len(mds)}" if len(mds) > 1 else "MD"
        return {
            "text": text,
            "tooltip": f"Mesoscale Discussions: {len(mds)}",
            "class": "active",
        }

    elif module == "watches":
        if not watches:
            return {"text": "", "tooltip": "", "class": "hidden"}
        return {
            "text": f"\U000f0208 {len(watches)}",
            "tooltip": f"Watches: {len(watches)}",
            "class": "active",
        }

    elif module == "warnings":
        if not warnings:
            return {"text": "", "tooltip": "", "class": "hidden"}
        return {
            "text": f"\U000f0026 {len(warnings)}",
            "tooltip": f"Warnings: {len(warnings)}",
            "class": "active",
        }

    elif module == "advisories":
        if not advisories:
            return {"text": "", "tooltip": "", "class": "hidden"}
        return {
            "text": f"\U000f02fc {len(advisories)}",
            "tooltip": f"Advisories: {len(advisories)}",
            "class": "active",
        }

    elif module == "hwo":
        if not hwo.get("active"):
            return {"text": "", "tooltip": "", "class": "hidden"}
        return {
            "text": "HWO",
            "tooltip": "Hazardous Weather Outlook: Active",
            "class": "active",
        }

    elif module == "temp":
        icon = current.get("icon", "\u2601")
        temp = current.get("temperature")
        icon_markup = f'<span font_family="Noto Color Emoji">{icon}</span>'
        if temp is not None:
            text = f"{icon_markup} {temp}\u00b0F"
        else:
            text = f"{icon_markup} ..."

        # Tooltip with full weather info
        tooltip_lines = []
        if current.get("description"):
            tooltip_lines.append(current["description"])
        if temp is not None:
            tooltip_lines.append(
                f"Temp: {temp}\u00b0F (Feels like {current.get('feelsLike', temp)}\u00b0F)"
            )
            tooltip_lines.append(
                f"Humidity: {current.get('humidity', 0)}% | "
                f"Wind: {current.get('windSpeed', 0)} mph {current.get('windDirectionStr', '')}"
            )
        if has_spc:
            tooltip_lines.append(f"SPC: {spc_outlook['full']}")
        if has_md:
            tooltip_lines.append(f"Mesoscale Discussions: {len(mds)}")
        if watches:
            tooltip_lines.append(f"Watches: {len(watches)}")
        if warnings:
            tooltip_lines.append(f"Warnings: {len(warnings)}")
        if advisories:
            tooltip_lines.append(f"Advisories: {len(advisories)}")
        if hwo.get("active"):
            tooltip_lines.append("HWO: Active")
        tooltip = "\\n".join(tooltip_lines)

        return {"text": text, "tooltip": tooltip, "class": "normal"}

    return {"text": "", "tooltip": "", "class": "hidden"}


def main():
    module = None
    if len(sys.argv) > 2 and sys.argv[1] == "--module":
        module = sys.argv[2]

    if module is None:
        # Fetch mode: fetch all data, save cache, output nothing
        fetch_all()

        current = process_observations()
        forecast = process_forecast()
        watches, warnings, advisories, all_alerts = process_alerts()
        hwo = process_hwo()
        spc_outlook = process_spc()
        mds = process_mds()

        weather_cache = {
            "current": current,
            "forecast": forecast,
            "alerts": all_alerts,
            "watches": watches,
            "warnings": warnings,
            "advisories": advisories,
            "hwo": hwo,
            "spcOutlook": spc_outlook,
            "mesoscaleDiscussions": mds,
            "lastUpdate": datetime.now().isoformat(),
        }
        save_json(os.path.join(CACHE_DIR, "weather.json"), weather_cache)
        # Output empty hidden module (fetch module is invisible)
        print(json.dumps({"text": "", "tooltip": "", "class": "hidden"}))
    else:
        # Module mode: read cache and output JSON for one module
        cache = load_json(os.path.join(CACHE_DIR, "weather.json"))
        if not cache:
            print(json.dumps({"text": "", "tooltip": "", "class": "hidden"}))
            return
        output = build_module_output(module, cache)
        print(json.dumps(output))


if __name__ == "__main__":
    main()
