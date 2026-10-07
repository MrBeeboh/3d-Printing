# FULL UPGRADE AUDIT — Ender-3 V3 SE + Radxa Zero 3W (Klipper)

**Date:** 2026-08-19/20 · **Auditor:** subagent (live-verified over SSH + Moonraker API)
**Printer status at audit:** READY, bed clear, no print running. Host `radxa-zero3` online, Moonraker :7125, Fluidd :4408.

> This is the authoritative audit. It supersedes the optimistic "ALL DONE" handoff notes
> where they conflict with what is actually running on the machine. Every claim below was
> checked against the live config (`printer.cfg`, `macros.cfg`, `klippy.log`) unless noted.

---

## 1. LIVE STATE SNAPSHOT (verified)

| Check | Result |
|---|---|
| Host reachable | ✓ `radxa-zero3` = 192.168.0.18, ping OK |
| Klipper | ✓ ready, PID 600, config `/home/pi/printer_data/config/printer.cfg` |
| Moonraker | ✓ :7125, api 1.5.0, warnings `[]` |
| Fluidd | ✓ :4408 |
| **MCU firmware** | ⚠️ **STILL OLD `1.0.0-6-g6b495246` — `STEPPER_BOTH_EDGE=1`** (deprecation warning persists) |
| MCU serial link | ✓ `/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0` (CH340) |
| USB autosuspend fix | ✓ `usbcore.autosuspend=-1` in `/proc/cmdline`, 0 USB disconnects this boot |
| Auto-recovery timer | ✓ `klipper-recover.timer` enabled + active (30 s poll) |
| **Camera stream** | ⚠️ **DEAD** — config exists, `/dev/video0-8` present, but **no streamer binary/service installed**, :8080 refused |
| `max_accel` | ⚠️ **2500** (not the 5000 claimed in handoff) |
| **Pressure advance** | ⚠️ **PA = 0.0** — not configured |
| **Input shaping** | ⚠️ **NONE** — no `[input_shaper]`, no ADXL object |

---

## 2. COMPLETED & VERIFIED WORKING ✅

### Control / host
- ✅ Radxa Zero 3W Klipper host (unit D4E0H0) fully installed: Klipper fork `d74d36bb` + Moonraker + Fluidd.
- ✅ Serial perms (`pi` in `tty`/`dialout`), `[virtual_sdcard]`, `[exclude_object]`, `[pause_resume]` present.
- ✅ Console stuck-on-graphic bug FIXED: `ExecStartPre` serial-wait + `klipper-recover.timer` (proven by real power-cycle + forced M112 test).
- ✅ **MCU USB autosuspend incident RESOLVED (2026-08-19)** — root cause host-side (Radxa suspending USB bus dropped CH340 link), NOT hardware/endstop. Fix `usbcore.autosuspend=-1` + tmpfiles keep-on + print-aware recover timer. Verified: 0 disconnects this boot. (This was the CAMERA-MOUNT-001d 71.8-min end-gcode crash cause.)
- ✅ Moonraker `cors_domains` + Fluidd config OK.

### Calibration / tuning that IS persisted
- ✅ PID tuned + in config (extruder 27.142/1.371/134.351, bed 66.371/0.846/1301.702).
- ✅ Z-offset baked: `[bltouch] z_offset 1.70`, position_min -10.
- ✅ Y stepper `run_current 0.90` (fixed), X 0.60, Z 0.8.
- ✅ `max_extrude_cross_section: 5.0` (purge no longer silently skips).
- ✅ Printable-area/centering fixed in Orca user machine preset (110,110 centering).
- ✅ Adaptive bed mesh (`BED_MESH_CALIBRATE ADAPTIVE=1 ADAPTIVE_MARGIN=5`) in `PRINT_START` macro.
- ✅ `PRINT_START`/`PRINT_END` macros verified; temps owned by macro (bed 55 / nozzle 200 in splice).

### Slicer workflow
- ✅ **OrcaSlicer 2.4.2 is the operator's slicer of record** (PrusaSlicer rejected — CLI `--rotate` broken). Headless CLI verified.
- ✅ Canonical print workflow documented in `docs/PRINT-OPERATIONS.md` + `docs/ORCA.md`.
- ✅ Mandatory gcode splice (strip M104/M109/M140/M190/SET_VELOCITY_LIMIT, prepend `PRINT_START`, keep `M83` relative extrusion) documented.
- ✅ Preview-before-print rule enforced (operator hard requirement).

### Prints
- ✅ `zoff_coupon.gcode` printed clean (217 s) — thin, consistent, well-adhered pad with skirt. **Coupon calibration DONE.**
- ✅ CAMERA-MOUNT-001 printed clean layers to 71.8 min (crash at end-gcode was the now-fixed MCU link, not the print).

### Docs / repo
- ✅ `Documents/3d_Printing` restructured as the AI hub: AGENTS.md + README.md landing pages, PRINT-OPERATIONS, ORCA, PRINTER-STATUS, MCU incident log, sd-flashing-guide, firmware.md, upgrade-plan, thursday-run-sheet, orcaslicer-wiki (strength/speed/material reference dump).
- ✅ Git repo `MrBeeboh/3d-Printing`; known-good C13 bin kept in-tree.

---

## 3. INCOMPLETE / SKIPPED / BROKEN ⚠️

### 3.1 Firmware flash — the big one ⚠️
- **MCU is STILL running old build `1.0.0-6-g6b495246` with `STEPPER_BOTH_EDGE=1`.**
- This is the deprecated build that emits the `STEPPER_STEP_BOTH_EDGE` warning and was the suspected speed/stepcompress crash contributor (3 crashes on 08-15 at high step rates).
- A fresh no-both-edge build **was compiled** on the host (`/home/pi/klipper/out/klipper.bin`, 40588 B, matches `firmware/e3v3se_klipper_with_display_C13_fresh.bin` md5 `9d84e1…`) but **was never flashed to the MCU** — `/home/pi/firmware/` doesn't even exist on the host, and the MCU still reports the old version.
- **Net:** the "reflash to kill both_edge" task from upgrade-audit #4 is OPEN. Deprecation warning persists.

### 3.2 Camera stream — BROKEN ⚠️
- Camera hardware present and healthy (`/dev/video0-8`; OV5647 exposure fixed today: gain 160→700, CPU 61%→15%).
- `moonraker.conf` has a `[webcam printer]` entry pointing at `mjpegstreamer` :8080.
- **BUT no streamer binary is installed** (no `mjpeg-streamer`, `camera-streamer`, `ustreamer` on PATH) and **no camera service exists** — `systemctl list-unit-files` shows zero camera units. Port 8080 refused.
- **Net:** webcam config is a dangling reference. No live view, no snapshot, no timelapse — the whole §7/§16 monitoring promise is unrealized.

### 3.3 Slicer toolchain mismatch ⚠️
- Docs say **use OrcaSlicer**, but the one-shot script `PRINTS/slice_print.py` still shells out to **`prusa-slicer`** (and `--load config.ini` unreliable). A user/AI running `slice_print.py` today gets Prusa, not the operator's chosen Orca. Contradiction.
- Orca user process profile dir has only `V3SE Speed.json`; the wave/draft profiles referenced in docs (`/tmp/v3se_0.28_draft.json`) are not persisted.

### 3.4 Wave-overhang config — dead end (documented, closed) ⚠️
- Wave experiment **CLOSED**: fork `v0.4.0` has an upstream bug (issue #84, fixed in PR #92, unreleased). Three attempts failed: (1) my config error `instead_of_bridges=0`, (2) wave "stubs" not tracks — generator produced isolated single-point extrusions on the 30mm span, (3) large-span case documented as known-hard.
- `detect_overhang_wall=1` was on in base profiles, but the generator still failed. **Do NOT retest until post-#92 release.** No wave profile file is kept.

### 3.5 Strength verification — NOT DONE ❌
- User asked "is it good or stuck together" after the best-yet skirt print. **No strength/adhesion test was performed or recorded.** Only advisory physical-test guidance was given (flex/twist, light-load/drop test). No measured layer-bond or load result exists in `docs/` or `PRINTS/`.
- The skirt print was a **coupon calibration** pad, not a structural part — so "fragile?" was never actually answered.

### 3.6 RTK box — parked (operator's call, not a defect)
- Fit-check coupon Ø155 failed with edge lifting; fix defined (6mm brim + mouse ears + bed 60°C) but operator deferred full teardown. Tray v2 SCAD with corrected 5-pocket layout exists. See `PRINTS/rtk_box/NEXT_STEPS.md`. Resume only on operator's go.

### 3.7 Filament runout sensor — PENDING
- Config `btt_sfs_2.0.cfg` staged conceptually but **no `[filament_switch_sensor]` in live config**, sensor not installed, `SFS_ENABLE` NOT enabled (correct — do not enable until hardware wired to FILAM/PC15). Hardware ordered.

### 3.8 Cancel is still broken
- `POST /printer/print/cancel` still fails (`No registered callback for pause_resume/cancel`). Emergency stop (M112) + auto-recover remains the documented workaround. Open, low-priority.

---

## 4. HANDOFF VS REALITY — DISCREPANCIES (important)

The prior handoff claimed "input shaping 72.8/48.4, PA 0.033, accel 5000 — all verified." **Live state contradicts this:**

| Claimed | Live | Verdict |
|---|---|---|
| PA 0.033 | PA = **0.0** | ❌ NOT configured |
| Input shaping X 72.8 / Y 48.4 | **No `[input_shaper]`, no shaper objects** | ❌ NOT configured |
| accel 5000 | `max_accel: 2500` | ❌ Lower |
| Y current 0.90 | 0.90 | ✅ |
| PID tuned | present | ✅ |
| Z-offset 1.700 | 1.70 | ✅ |
| Adaptive mesh | present | ✅ |
| Speed gain ~28% (Hive 44m vs 1h01m) | plausible from motion-planning + mesh, but **no shaping/PA backing it** | ⚠️ unverified origin |

**Root cause of the gap:** the live `printer.cfg` (and both `.bak` files) contain NO input-shaper section and NO pressure-advance — these settings appear to have been either never written to config or **lost when the config was restored/rebuilt** (a `printer.cfg.bak` was created during the 08-19 zoff work). Whatever tuning produced the "72.8/48.4 / PA 0.033" figure is **not on the machine now.**

> **Action:** re-measure/verify tuning before claiming it. The "delivered ~60%" from upgrade-audit is overstated for PA/shaping — those are still pending.

---

## 5. GAINS DELIVERED vs PROMISED

| Promised capability | Status |
|---|---|
| Remote/WiFi printing + API + Fluidd | ✅ DONE |
| Macro system (PRINT_START, purge, screen macros) | ✅ DONE |
| Adaptive bed mesh | ✅ DONE |
| Screen/display macros (6) | ✅ DONE |
| SSH/remote config management | ✅ DONE |
| PID thermal tuning | ✅ DONE |
| Y-stepper current fix | ✅ DONE |
| Print centering fix | ✅ DONE |
| Auto-recovery (klipper-recover) | ✅ DONE |
| USB-link reliability (autosuspend fix) | ✅ DONE |
| **Input shaping** | ❌ NOT delivered (needs ADXL345 + config) |
| **Pressure advance** | ❌ NOT delivered (PA=0.0) |
| **Webcam / live view / timelapse** | ❌ NOT delivered (no streamer) |
| **Speed > stock (stepcompress crash-free)** | ⚠️ PARTIAL — 28% gain plausible, but capped at 2500 accel and still on both_edge firmware |
| Volumetric flow characterization | ⚠️ not measured |
| Spoolman / weight tracking | ❌ not done |

---

## 6. REMAINING TASKS (prioritized)

**P0 — correctness / safety**
1. **Reflash MCU to the no-both-edge build** (`firmware/e3v3se_klipper_with_display_C13_fresh.bin`, md5 `9d84e1…`). Confirms/flashes the fresh bin, kills the deprecation warning, removes a known stepcompress crash contributor. **Flash via SD per `docs/sd-flashing-guide.md`.**
2. **Verify tuning** — confirm whether PA/shaping was ever real; if yes, re-apply and SAVE_CONFIG; if the ADXL was never installed, list input shaping as pending-parts.

**P1 — monitoring**
3. **Install a camera streamer** (camera-streamer or mjpeg-streamer) + systemd unit on :8080, wire to the existing `[webcam printer]` Moonraker entry. Enables live view, snapshot, timelapse — the primary remote-monitoring value.

**P2 — workflow hardening**
4. **Align `PRINTS/slice_print.py` to OrcaSlicer** (the operator's slicer of record) or delete it to avoid an AI accidentally using Prusa.
5. Persist the draft/wave process profiles so docs and CLI match.
6. Install filament runout sensor when it arrives (FILAM/PC15) + enable `[filament_switch_sensor]` + live pull test.

**P3 — characterization**
7. Input shaping via ADXL345 (toolhead X / bed Y mounts; needs `libopenblas-base` on host). Expected Y ~34–35 Hz.
8. Pressure advance tower per filament.
9. Volumetric flow limit measurement (>30 mm³/s expected).

---

## 7. RISKS

### 7.1 32 GB microSD card for the flash — HIGH ⚠️
- The SD-flashing guide requires **FAT32, 4096-byte allocation, ≤8 GB preferred**, and warns that **large cards (>32 GB) and SDHC/SDXC can be rejected** by the bootloader; a brand-new card may ship exFAT/unformatted.
- If the only card on hand is a **32 GB** card, it is at the upper boundary of what the bootloader tolerates. **Mitigation:** reformat to FAT32/4096 explicitly, use a different ≤8.3 filename than last flash (`fw.bin` etc.), rename on every retry, and **power-cycle with card out afterward** (leaving it in causes MCU-connect failure on next boot). The card that shipped with the printer is the known-safe choice.
- **Filename rules (the #1 gotcha):** must be ≤8.3, must **differ from last flashed name**, rename each retry. Use the stock printer SD card if available.

### 7.2 Firmware/display version mismatch
- Fork targets display FW **1.0.6**. If Creality shipped a newer screen FW, display re-mapping may be needed (`TJC_SET` downgrade already used once).

### 7.3 C13 vs C14 cross-flash
- Never flash a C14 bin on a C13 board. This board is C13/GD32F303. Verify before any flash.

### 7.4 Host power / USB reliability (residual)
- Fixed, but the Zero 3W USB bus was the failure vector. A powered USB hub for the printer serial is still recommended by the plan and remains UNKNOWN if in place.

### 7.5 Uncommitted docs
- `AGENTS.md`, `README.md`, `docs/slicer-profiles.md` are modified but **uncommitted**; new docs (`upgrade-audit`, `hermes-bot-mode-tutorial`, whole `orcaslicer-wiki/`) are **untracked**. If the repo is the source of truth, commit these — the README currently overstates tuning that isn't in the config.

---

## 8. CONCLUSION

The **infrastructure is solid**: Klipper host, Moonraker/Fluidd, macros, PID, Z-offset, Y-current, adaptive mesh, auto-recovery, and the USB-autosuspend fix are all real and verified. The workflow is well documented and the coupon calibration passed. That is the majority of the promised value.

The **gaps** are concentrated in three honest misses:
1. **MCU firmware was never reflashed** to the fixed build — old `1.0.0-6` + both_edge is still running (the recurring deprecation warning).
2. **Input shaping + pressure advance are NOT actually configured** despite the handoff claiming otherwise — the config was rebuilt and lost them (or they were never persisted).
3. **The camera has hardware but no streamer** — the webcam is a config-only ghost; the monitoring/vision promise is unfulfilled.

Strength of the recent skirt print is **unverified** — it was a calibration coupon, and no load/adhesion test was done. None of these are blocking basic printing (coupon proved that), but they are the difference between "printer runs" and "the upgrade as promised."

**DoD for "fully delivered":** reflash MCU → verify no both_edge warning → re-apply/confirm PA + shaping (or list as parts-pending) → get the camera streaming → align slicer script to Orca → commit docs.
