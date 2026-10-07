# Slicer status — UPDATED 2026-08-17

**STALE-ALERT: This file previously said "No slicer configured on HAL2026." That is WRONG.**

## The truth

| Slicer | Status | Location |
|---|---|---|
| **OrcaSlicer 2.4.2** | ✅ **WORKING — USE THIS** | `~/Applications/OrcaSlicer.AppImage`, headless CLI verified 2026-08-17 (`--slice 0 --outputdir ... --load-settings proc;machine --load-filaments`) |
| PrusaSlicer 2.7.2 | ❌ Do NOT use | `/usr/bin/prusa-slicer` — rejected by operator; `--rotate` full-vector form silently ignored |

**Full workflow: `docs/PRINT-OPERATIONS.md`** — slicer recipe, mandatory gcode splice,
Moonraker upload/start/monitor, orientation verification, cancel workaround.
One-shot script: `PRINTS/slice_print.py`.

## Known slicer pitfalls (learned the hard way)

- OrcaSlicer 2.4.2: verified working 2026-08-17 — the CLI command in `docs/PRINT-OPERATIONS.md` §2.
- Orca emits `M104/M109/M140/M190` — **strip them all**; the Klipper `PRINT_START` macro owns temps.
- PrusaSlicer 2.7.2: do NOT use (operator rejected).

## Profiles in use

- Quality (show parts): 0.20 mm / 3 walls / 20% gyroid / outer 60 inner 90 infill 180
- Fast (functional parts): 0.28 mm / 2 walls / 15% rectilinear / outer 90 infill 200
- Temps: 200/55 (owned by `PRINT_START BED=55 EXTRUDER=200`), retraction 0.8mm @ 30
- Printer: Ender-3 V3 SE 220×220×250, 0.4 nozzle, Klipper flavor (Marlin-compatible)
