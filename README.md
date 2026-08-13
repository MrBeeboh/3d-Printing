# Creality 3D Printer — Ender-3 V3 SE

Local + GitHub repo for the Ender-3 V3 SE: hardware facts, firmware, Klipper host, slicer profiles, and print files (including the Radxa ZERO 3W Hive case).

**Repo:** https://github.com/MrBeeboh/3d-Printing  
**Local:** `~/Documents/3d_Printing`  
Do not put this in Atom Chat or Atom-Code.

## Hardware inventory

| Item | Detail | Status |
|---|---|---|
| Printer | Creality Ender-3 V3 SE, **stock board** | In use |
| MCU | GD32F303 (C13 variant — see `docs/printer-hardware.md`) | |
| Klipper host | Radxa Zero 3W, unit **D4E0H0** (4GB, no eMMC, no header), hostname `radxa-zero3.local` → **192.168.0.18** | **ONLINE** — Moonraker v0.10.0 (:7125) + Fluidd v1.37.4 (:4408); fork klipper running, waiting on config (printer arrives ~Aug 13) |
| Spare host | Radxa Zero 3W, unit **D2E0H1** (2GB, header) | Spare |
| Firmware | jpcurti `ender3-v3-se-klipper-with-display` fork (stock board needs this fork; official Klipper build is Pad-only) | See `docs/firmware.md` |

## Quick references

- `docs/upgrade-plan.md` — **master capability upgrade plan** (Radxa Zero 3W → V3 SE, staged strategy, performance characterization)
- `docs/research-digest-2026-08-11.md` — **pre-arrival research digest** (fork pitfalls, SBC risks, hardware limits, Thursday action list)
- `docs/thursday-run-sheet.md` — **Thursday arrival-day checklist** (phased: pre-arrival → unbox → flash → Z-offset → first print)
- `docs/printer-hardware.md` — board, MCU variants (C13 vs C14), what it means
- `docs/firmware.md` — which firmware, where the source lives, flash notes
- `docs/klipper-host.md` — Zero 3W host, Moonraker/Fluidd access, flashing toolkit
- `docs/printer-arrival.md` — **day-of checklist for when the printer arrives**
- `PRINTS/START-HERE.md` — **Hive case for Radxa ZERO 3W** (coupon, then base + lid STLs)
- `docs/fusion-mcp-setup.md` — **Fusion on Pinova P2 + Cursor MCP from HAL** (not Atom Chat)
- `docs/slicer-profiles.md` — slicer setup (none configured yet)
- `docs/tips-troubleshooting.md` — tips + pointers to the fork's official docs
- `firmware/e3v3se_klipper_with_display_C13.bin` — known-good firmware binary (kept in-tree so it survives Downloads cleanup)
- `configs/` — staged Klipper configs (printer.cfg, prtouch, macros) + deploy instructions

## External reference paths

- Klipper fork source (jpcurti): `~/Downloads/zero3-flash/ender3-v3-se-klipper-with-display/`
  - Official docs live in that repo under `e3v3se_docs/` (install, configuration, calibration, troubleshooting)
- Zero 3W flash toolkit: `~/Downloads/zero3-flash/` (rkdeveloptool, maskrom loaders, Debian image)
