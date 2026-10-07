#!/usr/bin/env python3
"""Splice Orca output for the Ender-3 V3 SE / Klipper fork.

Shop rules (see docs/ORCA.md and PRINT-OPERATIONS.md):
- PRINT_START owns heat (BED=55 EXTRUDER=200). Strip slicer M104/M109/M140/M190.
- This Klipper has no relative_extrusion override -> KEEP M83 or first layer starves.
- Strip SET_VELOCITY_LIMIT (accel owned by Klipper/shaping).
- Keep M220/M221 flow/feed 100, fan M106, M83, G90/G21.
- Upload name: <base>.gcode
"""
import re, sys
from pathlib import Path

def splice(src: str) -> str:
    srcl = Path(src)
    if not srcl.exists():
        raise SystemExit(f"src not found: {src}")
    lines = srcl.read_text(errors="replace").splitlines()

    out = []
    for i, ln in enumerate(lines, 1):
        s = ln.strip()
        # strip slicer heat (after the header; PRINT_START owns it)
        if re.match(r'^M10[49]\b', ln) or re.match(r'^M14[09]\b', ln):
            continue
        # strip velocity-limit commands (accel owned by printer)
        if ln.startswith('SET_VELOCITY_LIMIT'):
            continue
        out.append(ln)
    return "\n".join(out) + "\n"

if __name__ == "__main__":
    src = sys.argv[1] if len(sys.argv) > 1 else "/tmp/zoff-coupon/out2/plate_1.gcode"
    dst = sys.argv[2] if len(sys.argv) > 2 else "/tmp/zoff-coupon/job.gcode"
    content = splice(src)
    Path(dst).write_text(content)
    print(f"spliced {Path(src).name} -> {dst} ({Path(dst).stat().st_size} bytes)")
    # verify
    heat = [i+1 for i,l in enumerate(content.splitlines()) if re.match(r'^M10[49]\b|^M14[09]\b', l.strip())]
    svl = [i+1 for i,l in enumerate(content.splitlines()) if l.startswith('SET_VELOCITY_LIMIT')]
    m83 = [i+1 for i,l in enumerate(content.splitlines()) if l.startswith('M83')]
    print("remaining slicer heat:", heat)
    print("remaining SET_VELOCITY_LIMIT:", svl)
    print("M83 at lines:", m83[:3], "M220:", [i+1 for i,l in enumerate(content.splitlines()) if l.startswith('M220')])
