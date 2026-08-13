# AGENTS.md — Creality 3D Printer project conventions

## Scope

This folder covers the **Ender-3 V3 SE** printer, its **Radxa Zero 3W** Klipper host, and **Fusion CAD for print parts**.
Do **not** mix drone-build BOMs, firmware, or parameters (F450-Sentinel, Altus-VTOL) into this project.
Do **not** mix **Atom Chat** (`/home/mike/atom-chat`) or **Atom-Code** into this project.

**GitHub:** `https://github.com/MrBeeboh/3d-Printing`  
**Local:** `/home/mike/Documents/3d_Printing`

Hive / ZERO 3W case files live in `PRINTS/` (print tomorrow) and `cad/radxa-zero-3w-case/` (measured tray). Start at `PRINTS/START-HERE.md`.

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
