# AGENTS.md — Creality 3D Printer project conventions

> **ANY AI (Hermes, Grok, Claude, Codex): start at `AI-QUICKSTART.md`** — the self-contained
> "print over WiFi" guide (connect/slice/splice/upload/start/monitor/cancel/calibrate).
> Then read `docs/PRINT-OPERATIONS.md` (full workflow) and this file (conventions).

## Scope

This folder covers the **Ender-3 V3 SE** printer, its **Radxa Zero 3W** Klipper host, and **Fusion CAD for print parts**.
Do **not** mix drone-build BOMs, firmware, or parameters (F450-Sentinel, Altus-VTOL) into this project.
Do **not** mix **Atom Chat** (`/home/mike/atom-chat`) or **Atom-Code** into this project.

**GitHub:** `https://github.com/MrBeeboh/3d-Printing`  
**Local:** `/home/mike/Documents/3d_Printing`

Hive / ZERO 3W case files live in `PRINTS/` (print tomorrow) and `cad/radxa-zero-3w-case/` (measured tray). Start at `PRINTS/START-HERE.md`.

## PRINTING — READ THIS FIRST (any AI)

This folder is the hub for all AI-driven 3D printing (Hermes, Grok, Claude, etc.).
**Before touching the printer or slicing anything, read `docs/PRINT-OPERATIONS.md` and `docs/ORCA.md`** —
it is the canonical workflow: Moonraker endpoints, slicer status (OrcaSlicer 2.4.2
WORKS — use it; PrusaSlicer rejected by the operator), the mandatory `PRINT_START` gcode header splice,
orientation verification, cancel-broken/emergency-stop workaround, and the one-shot
script `PRINTS/slice_print.py`.

Rules that are non-negotiable:
- **ALL prints go through the slicer.** No hand-written gcode, no hand-decided geometry.
- **THE SLICER DECIDES ORIENTATION.** Do not pre-rotate STLs by "reasoning" — let the slicer auto-orient, or verify the slicer's chosen orientation in the first-layer footprint before printing. (2026-08-16: a hand-chosen rotation produced a garbage print; the slicer flagged it and we ignored the warning. Never again.)
- **THE SLICER DECIDES SUPPORTS.** Never disable/override supports by hand. Use `--support-material-auto` with breakaway interface: `--support-material-interface-layers=3 --support-material-contact-distance=0.3 --support-material-interface-contact-loops --support-material-buildplate-only`. (2026-08-16: default-interface supports welded to the part and couldn't be removed.)
- **Never start a print without the operator's explicit go.**
- **Never auto-chain parts** — each part gets its own approval.
- **Never print a part whose first-layer footprint you haven't verified.**
- **Never upload unspliced slicer output** (slicer temps kill the print; the
  `PRINT_START` macro owns heating).
- Printer API: `http://192.168.0.18:7125` (Moonraker) / Fluidd `:4408`.
  Host is not always powered — check reachability first.

**Filament on the shelf:** 2× black PLA, 2× white PLA. The SE is single-extruder — one color per job. Renders must use those colors (black base / white lid), not OpenSCAD’s blue/orange preview scheme.

## Fusion CAD (Cursor MCP)

Fusion does **not** run on HAL2026 (Linux). Live modeling uses the **KAMRUI Pinova P2** (Windows 11, Ryzen 3 7330U, 16 GB) plus an SSH tunnel to Fusion MCP port **27182**.

Read `docs/fusion-mcp-setup.md` before any Fusion/MCP work. Continue Fusion work in a chat whose workspace is this folder, not atom-chat.

## Hardware facts (verified)

- Ender-3 V3 SE on the **stock board**.
- MCU variants: **C13 = GD32F303**, **C14 = STM32F401**. Firmware binaries are MCU-specific — never flash a C14 bin on a C13 board or vice versa.
- Stock board runs Klipper via the **jpcurti** fork `ender3-v3-se-klipper-with-display` (github.com/jpcurti/ender3-v3-se-klipper-with-display). Official Creality Klipper firmware targets their Pad only; official stock firmware (V1.1.0) is Marlin.
- Klipper host: Radxa Zero 3W unit **D4E0H0** (4GB, no eMMC, no header), hostname `radxa-zero3.local`, Klipper + Moonraker + Fluidd on port **7125**. Unit **D2E0H1** (2GB, header) is the spare.
  - Zero 3W SKU decode: `Dx` = RAM, `E0` = no eMMC, `H0`/`H1` = no/yes header.
- The Zero 3W is **not always connected** — check reachability before assuming the API is up.

## Paths

- Klipper fork source + its official docs (`e3v3se_docs/`): `~/Downloads/zero3-flash/ender3-v3-se-klipper-with-display/`
- Zero 3W maskrom flash toolkit + Debian image: `~/Downloads/zero3-flash/`
- Known-good firmware binary: `firmware/e3v3se_klipper_with_display_C13.bin` (in this folder)

## Working rules

- Any firmware/config change gets documented in `docs/` before it's treated as done.
- If a hardware or pin conflict blocks something, present alternatives (other pins, rewiring, workaround) — don't just quit.
- No API keys/secrets apply to this project.
