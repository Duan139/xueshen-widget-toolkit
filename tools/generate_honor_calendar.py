#!/usr/bin/env python3
"""SZPU Timetable to RFC 5545 Calendar (.ics) Generator.

Generates a standards-compliant .ics file with:
- Deterministic UIDs (re-importing updates existing events instead of duplicating)
- Standard VTIMEZONE + TZID=Asia/Shanghai
- RFC 5545 text escaping and 75-octet line folding
- Single/double week (weekType: "odd" / "even" / "all") support
- 15-minute pre-class VALARM reminder

Usage:
    python3 generate_honor_calendar.py [courses_json] [output.ics]
"""
import datetime
import hashlib
import json
import os
import sys

TIME_TABLE = {
    1: ("08:30", "09:15"),
    2: ("09:15", "10:00"),
    3: ("10:20", "11:05"),
    4: ("11:05", "11:50"),
    5: ("14:00", "14:45"),
    6: ("14:45", "15:30"),
    7: ("15:50", "16:35"),
    8: ("16:35", "17:20"),
    9: ("19:00", "19:45"),
    10: ("19:45", "20:30"),
    11: ("20:30", "21:15"),
}


def format_ics_date(dt: datetime.datetime) -> str:
    return dt.strftime("%Y%m%dT%H%M%S")


def escape_ics_text(value: str) -> str:
    """Escape text value per RFC 5545 Section 3.3.11."""
    return (
        value.replace("\\", "\\\\")
        .replace(";", "\\;")
        .replace(",", "\\,")
        .replace("\r\n", "\\n")
        .replace("\n", "\\n")
    )


def fold_ics_line(line: str, limit: int = 75) -> str:
    """Fold content lines longer than 75 UTF-8 octets per RFC 5545 Section 3.1."""
    raw = line.encode("utf-8")
    if len(raw) <= limit:
        return line
    chunks = []
    current = bytearray()
    max_bytes = limit
    for ch in line:
        encoded = ch.encode("utf-8")
        if len(current) + len(encoded) > max_bytes:
            chunks.append(current.decode("utf-8"))
            current = bytearray(b" " + encoded)
            max_bytes = limit
        else:
            current.extend(encoded)
    if current:
        chunks.append(current.decode("utf-8"))
    return "\r\n".join(chunks)


def resolve_weeks(course: dict) -> list[int]:
    """Return filtered teaching weeks supporting odd/even weekType."""
    weeks = course.get("weeks") or list(range(1, 17))
    week_type = str(course.get("weekType") or "all").lower()
    if week_type in ("odd", "单", "单周", "1"):
        weeks = [w for w in weeks if int(w) % 2 == 1]
    elif week_type in ("even", "双", "双周", "2"):
        weeks = [w for w in weeks if int(w) % 2 == 0]
    return [int(w) for w in weeks]


def generate_ics(courses: list, term_start_date: datetime.date, out_path: str):
    """Generate RFC 5545 .ics file.

    term_start_date: Gregorian date of Monday of Week 1.
    """
    dtstamp = format_ics_date(datetime.datetime.now(datetime.timezone.utc)) + "Z"
    lines = [
        "BEGIN:VCALENDAR",
        "VERSION:2.0",
        "PRODID:-//SZPU//Timetable Calendar Sync//CN",
        "CALSCALE:GREGORIAN",
        "METHOD:PUBLISH",
        "X-WR-CALNAME:学深课表",
        "X-WR-TIMEZONE:Asia/Shanghai",
        "BEGIN:VTIMEZONE",
        "TZID:Asia/Shanghai",
        "BEGIN:STANDARD",
        "TZOFFSETFROM:+0800",
        "TZOFFSETTO:+0800",
        "TZNAME:CST",
        "DTSTART:19700101T000000",
        "END:STANDARD",
        "END:VTIMEZONE",
    ]

    for c in courses:
        name = str(c.get("courseName") or c.get("name") or "课程")
        place = str(c.get("place") or c.get("location") or "待定地点")
        teacher = str(c.get("teacher") or "")
        week_day = int(c.get("week") or 1)  # 1..7 (Mon..Sun)
        start_c = int(c.get("startCourse") or 1)
        end_c = int(c.get("endCourse") or 2)
        weeks = resolve_weeks(c)

        s_time_str = TIME_TABLE.get(start_c, ("08:30", "09:15"))[0]
        e_time_str = TIME_TABLE.get(end_c, ("20:30", "21:15"))[1]

        s_hour, s_min = map(int, s_time_str.split(":"))
        e_hour, e_min = map(int, e_time_str.split(":"))

        for w in weeks:
            days_delta = (w - 1) * 7 + (week_day - 1)
            event_date = term_start_date + datetime.timedelta(days=days_delta)

            dt_start = datetime.datetime(
                event_date.year, event_date.month, event_date.day, s_hour, s_min
            )
            dt_end = datetime.datetime(
                event_date.year, event_date.month, event_date.day, e_hour, e_min
            )

            uid_key = f"{term_start_date.isoformat()}-w{w}-d{week_day}-p{start_c}-{end_c}-{name}"
            uid_hash = hashlib.sha256(uid_key.encode("utf-8")).hexdigest()[:16]
            uid = f"szpu-{uid_hash}@szpu.edu.cn"

            summary = escape_ics_text(f"{name} (第{start_c}-{end_c}节)")
            location = escape_ics_text(place)
            desc = escape_ics_text(f"教师: {teacher}\n地点: {place}\n教学周: 第{w}周")
            alarm_desc = escape_ics_text(f"即将上课: {name} @ {place}")

            lines.extend([
                "BEGIN:VEVENT",
                f"UID:{uid}",
                f"DTSTAMP:{dtstamp}",
                f"DTSTART;TZID=Asia/Shanghai:{format_ics_date(dt_start)}",
                f"DTEND;TZID=Asia/Shanghai:{format_ics_date(dt_end)}",
                f"SUMMARY:{summary}",
                f"LOCATION:{location}",
                f"DESCRIPTION:{desc}",
                "STATUS:CONFIRMED",
                "BEGIN:VALARM",
                "TRIGGER:-PT15M",
                "ACTION:DISPLAY",
                f"DESCRIPTION:{alarm_desc}",
                "END:VALARM",
                "END:VEVENT",
            ])

    lines.append("END:VCALENDAR")
    folded = [fold_ics_line(line) for line in lines]
    with open(out_path, "w", encoding="utf-8", newline="") as f:
        f.write("\r\n".join(folded) + "\r\n")
    print(f"Calendar ICS generated: {out_path}")


if __name__ == "__main__":
    src_json = sys.argv[1] if len(sys.argv) > 1 else None
    out_file = sys.argv[2] if len(sys.argv) > 2 else "szpu_honor_aod_schedule.ics"

    if not src_json or not os.path.exists(src_json):
        sample_courses = [
            {
                "courseName": "经济学原理",
                "place": "留仙洞教学楼101",
                "teacher": "张教授",
                "week": 1,
                "startCourse": 1,
                "endCourse": 2,
                "weeks": [1, 2, 3, 4, 5, 6, 7, 8, 9],
                "weekType": "all",
            },
            {
                "courseName": "计算机网络",
                "place": "西丽湖实训楼B302",
                "teacher": "李老师",
                "week": 1,
                "startCourse": 5,
                "endCourse": 6,
                "weeks": [1, 2, 3, 4, 5, 6, 7, 8, 9],
                "weekType": "odd",
            },
            {
                "courseName": "人工智能导论",
                "place": "留仙洞知行楼404",
                "teacher": "王教授",
                "week": 2,
                "startCourse": 3,
                "endCourse": 4,
                "weeks": [1, 2, 3, 4, 5, 6, 7, 8, 9],
                "weekType": "even",
            },
        ]
    else:
        with open(src_json, "r", encoding="utf-8") as f:
            sample_courses = json.load(f)

    term_start = datetime.date(2026, 9, 7)
    generate_ics(sample_courses, term_start, out_file)
