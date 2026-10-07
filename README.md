# Creality 3D Printer — Ender-3 V3 SE (AI printing hub)

Local + GitHub repo for the **Ender-3 V3 SE**: hardware facts, firmware, Klipper host, slicer
profiles, and print files (including the Radxa ZERO 3W Hive case).

**Repo:** https://github.com/MrBeeboh/3d-Printing  ·
**Local:** `~/Documents/3d_Printing`  ·  Do **not** put this in Atom Chat or Atom-Code.

---

## 🚀 For ANY AI agent (Hermes, Grok, Claude, Codex…) — START HERE

**Read `AI-QUICKSTART.md` first.** It is self-contained: connect → slice → splice → upload →
start → monitor → cancel, plus first-layer verification, skirts, wave overhangs, firmware
flash, strength tests, calibration, and every pitfall we've paid for. It answers the standard
questions (how to connect / slice / upload / monitor / cancel / calibrate) inline.

Then, in order: `AGENTS.md` (project conventions) → `docs/PRINT-OPERATIONS.md` (full workflow).

**Hard rules (non-negotiable):**
- ALL prints go through the slicer (OrcaSlicer). No hand-written gcode.
- **The slicer decides orientation AND supports.** Never pre-rotate STLs by "reasoning";
  always verify the first-layer footprint. (2026-08-16: hand-rotation → garbage print.)
- Never start a print without the operator's explicit **go**. Never auto-chain parts.
- Splice every gcode (`PRINT_START` header, strip slicer temps, keep `M83`).
- Flash firmware with a **small SD card only (≤8 GB)**, unique 8.3 name per attempt.

### Current working stack (verified 2026-08-19)

- **Printer:** Ender-3 V3 SE, stock board, MCU **C13 / GD32F303** (jpcurti Klipper display fork).
- **Host:** Radxa Zero 3W D4E0H0 at **192.168.0.18** (WiFi). Moonraker `:7125`, Fluidd `:4408`, SSH key auth.
- **Slicer:** **OrcaSlicer 2.4.2** (`~/Applications/OrcaSlicer.AppImage`), headless CLI. Not PrusaSlicer.
- **Workflow:** Slice → splice with `PRINT_START` header → upload to Moonraker → start.
- **Filament:** Black or white **PLA** only (single extruder → one color per job).
- **Calibration:** PA 0.033 · shaping X 72.8 / Y 48.4 · Z-offset **1.70**.

### Status snapshot (2026-08-19, evening)

- **READY.** Bed clear, no print running. Coupon calibration **DONE** — don't re-verify bed/first layer.
- **MCU USB-drop incident RESOLVED** — root cause was Zero 3W USB autosuspend, fixed host-side
  (`usbcore.autosuspend=-1`, USB keep-on, print-aware `klipper-recover.timer`). See
  `docs/MCU-USB-AUTOSUSPEND-INCIDENT-2026-08-19.md`.
- **Print quality:** best print yet visually (a **skirt** helped the first layer), but the user
  said it "still seems fragile" / "stuck together" — workflow feels fragile (flash, wave application, one-command reliability). Print itself looked great.
  (see `AI-QUICKSTART.md` §10). No `WAVE_OVERHANG` markers in recent slices → wave mode not used.
- **Firmware:** MCU still reports old `1.0.0-6` in logs — a prior flash likely didn't take because
  a **32 GB card** was used. Re-flash with a **small (≤8 GB) card only** (see §Firmware + `docs/sd-flashing-guide.md`).

### Quick print (any AI)

```bash
# Reachability FIRST (host is not always powered)
curl -s --max-time 5 http://192.168.0.18:7125/printer/info | head -c 120
# One-shot slice → splice → upload → (start only with operator go)
cd ~/Documents/3d_Printing/PRINTS
python3 slice_print.py --stl part.stl --name my_part [--fast] [--supports] [--start]
# Monitor
curl -s "http://192.168.0.18:7125/printer/objects/query?print_stats=state&virtual_sdcard=progress&heater_bed=temperature,target"
```

### WiFi / access

- Fluidd UI: **http://192.168.0.18:4408**
- Moonraker API: **http://192.168.0.18:7125** (trusted LAN, no auth)
- SSH: `root@radxa-zero3.local` / `192.168.0.18` (key auth)

---

## Key docs (read in this order)

| Doc | What it's for |
|---|---|
| **`AI-QUICKSTART.md`** | ⭐ **The self-contained entry point for ANY AI.** End-to-end print workflow + FAQ. Start here. |
| `AGENTS.md` | Project conventions + hard rules (orientation, supports, approvals, paths, hardware facts). |
| `docs/PRINT-OPERATIONS.md` | ⭐ **THE canonical print workflow** — Orca recipe, gcode splice, Moonraker upload/start, first-layer verify, cancel workaround, wave notes. Read before printing. |
| `docs/ORCA.md` | OrcaSlicer shop notes (CLI, supports, layer heights, calibration order). |
| `docs/sd-flashing-guide.md` | Firmware flash — **small card only**, 8.3 filename, exact sequence. |
| `docs/PRINTER-STATUS.md` | Live status (current/ready). |
|| `docs/MCU-USB-AUTOSUSPEND-INCIDENT-2026-08-19.md` | USB-drop root cause + fix (host autosuspend). |
|| `PRINTS/slice_print.py` | One-shot slice→splice→upload→start script (read its docstring). |
|| `docs/hermes-bot-mode-tutorial.md` | **How to use the bot team** (spawning experts, overnight autonomous work, Telegram, kanban). Read this to manage the crew. |
| `docs/upgrade-plan.md` | Master capability upgrade plan (Radxa Zero 3W → V3 SE). |
| `docs/klipper-host.md` | Zero 3W host, Moonraker/Fluidd access, flash toolkit. |
| `docs/firmware.md`, `docs/printer-hardware.md` | Which firmware / board + C13-vs-C14 MCU split. |
| `docs/tips-troubleshooting.md` | Tips + pointers to the fork's official docs. |
| `docs/fusion-mcp-setup.md` | Fusion CAD on Pinova P2 + Cursor MCP from HAL2026. |
| `configs/` | Staged Klipper configs (printer.cfg, prtouch, macros) + deploy steps. |
| `PRINTS/START-HERE.md` | Hive case for the Radxa ZERO 3W (coupon → base + lid). |
| `survivor-logs/` | Operational logs (e.g. 2026-08-19 Qwen speed investigation — not print-related). |

## Hardware inventory

| Item | Detail | Status |
|---|---|---|
| Printer | Creality Ender-3 V3 SE, **stock board** | In use |
| MCU | GD32F303 (**C13** variant) — see `docs/printer-hardware.md` | Flashing needed (small card) |
| Klipper host | Radxa Zero 3W **D4E0H0** (4GB, no eMMC, no header) → **192.168.0.18** | **ONLINE** — Moonraker `:7125` + Fluidd `:4408` |
| Spare host | Radxa Zero 3W **D2E0H1** (2GB, header) | Spare |
| Firmware | jpcurti `ender3-v3-se-klipper-with-display` fork | See `docs/firmware.md` |
| Slicer | **OrcaSlicer 2.4.2** (`~/Applications/OrcaSlicer.AppImage`) | The working headless slicer |
| Filament | Black / white PLA (2× each on shelf) | Single extruder, one color/job |

## Firmware — quick note (full: `docs/sd-flashing-guide.md`)

- SD card only; **≤8 GB / FAT32 / 4096-alloc / empty** — **do NOT use the Zero's 32 GB card**.
- **8.3 filename**, and it **must differ from the last flash** (rename on every retry).
- Known-good bin: `firmware/e3v3se_klipper_with_display_C13.bin` (C13 only).
- Sequence: power off → insert → power on → wait ~2 min → Klipper display (Marlin = didn't take) → power off → remove card.

## External reference paths

- Klipper fork source (jpcurti): `~/Downloads/zero3-flash/ender3-v3-se-klipper-with-display/` (official docs in `e3v3se_docs/`)
- Zero 3W flash toolkit: `~/Downloads/zero3-flash/` (rkdeveloptool, maskrom loaders, Debian image)
- OrcaSlicer wiki (cached): `docs/orcaslicer-wiki/`

## Overnight work (2026-08-19)
User clarified: recent print looks great. "Fragile/stuck together" means the **workflow** (flash reliability, wave application, agent handoffs, one-command printing).

See `docs/OVERNIGHT-STATUS-2026-08-19.md` for what the team is fixing while you sleep.

Bots running: wave overhangs expert + full workflow audit.
Bot tutorial + graphics + audio delivered to `docs/`.
