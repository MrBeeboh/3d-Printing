# PRINT OPERATIONS — How any AI prints to the Ender-3 V3 SE

**Read this first. This is the canonical "send a file to the printer" workflow.**
Applies to any AI (Hermes, Grok, Claude, Codex) working from this repo.
**New AIs: start with `AI-QUICKSTART.md`** (self-contained) then come back here for detail.
Last verified: 2026-08-19 (printer ONLINE, `state: ready`; coupon printed clean 217 s).

---

## 1. The stack (facts, not folklore)

| Thing | Value |
|---|---|
| Printer | Creality Ender-3 V3 SE, **stock board**, MCU **C13 / GD32F303** |
| Firmware | Klipper via **jpcurti fork** (`ender3-v3-se-klipper-with-display`) |
| Host | Radxa Zero 3W, unit D4E0H0, `radxa-zero3.local` = **192.168.0.18** |
| Moonraker API | **http://192.168.0.18:7125** |
| Fluidd UI | **http://192.168.0.18:4408** (needs Moonraker `cors_domains: *` — already set, don't remove) |
| SSH | `root@radxa-zero3.local` (key auth from HAL2026; no password needed) |
| Printer data on host | `/home/pi/printer_data/` (config, gcodes, logs at `/tmp/klippy.log` symlink) |
| Sudo pw on host | in `~/.hermes/.env` as `SUDO_PASSWORD` (pipe `sudo -S`) |

The Zero 3W is **not always powered** — always check reachability first:
```bash
curl -s --max-time 5 http://192.168.0.18:7125/printer/info | head -c 200
```

> **2026-08-19 incident:** the host→MCU USB link (CH340, `/dev/ttyUSB0`) was dropping prints —
> root cause was Zero 3W **USB autosuspend**, fixed host-side (`usbcore.autosuspend=-1`,
> USB keep-on, print-aware `klipper-recover.timer`). MCU link now stable (0 disconnects).
> Full detail: `docs/MCU-USB-AUTOSUSPEND-INCIDENT-2026-08-19.md`. If the MCU link ever dies
> mid-print again, this is the first thing to check.

## 2. Slicer status — the honest truth

| Slicer | Status | CLI |
|---|---|---|
| **OrcaSlicer 2.4.2** | ✅ **USE THIS** | `~/Applications/OrcaSlicer.AppImage /tmp/part.stl --slice 0 --outputdir /tmp/out --load-settings "machine.json;/tmp/v3se_0.28_draft.json" --load-filaments "Creality Generic PLA @Ender-3V3-all.json"` — works headless. The operator's slicer of record. |
| PrusaSlicer 2.7.2 | ❌ Do NOT use | Operator rejected it. The `--rotate` CLI silently ignores the full-vector form (`--rotate=90,0,0`); only single-axis `--rotate-x N` works. |

Grok/other AIs: **use OrcaSlicer** with the command above. PrusaSlicer was documented here during an Orca-CLI issue in mid-Aug; that issue was resolved — this table is the current truth.

### OrcaSlicer CLI recipe (verified working 2026-08-17)

```bash
~/Applications/OrcaSlicer.AppImage /tmp/part.stl --slice 0 --outputdir /tmp/out \
  --load-settings "machine.json;/tmp/v3se_0.28_draft.json" \
  --load-filaments "Creality Generic PLA @Ender-3V3-all.json"
```

- Quality profile (show parts): `0.20 / 3 walls / 20% gyroid` — use the process preset json
- Fast profile (functional parts): `0.28 / 2 walls / 15% rectilinear` = `/tmp/v3se_0.28_draft.json`
- Temps are owned by the printer macro — do NOT bake them in the slicer (the Orca
  machine preset already calls `PRINT_START`; the splice normalizes it).
- Supports live in the process preset (`support.enable`, interface layers 3, contact
  distance 0.3, contact loops, buildplate-only) — the flags below are the Prusa
  equivalents for reference only, do NOT use PrusaSlicer itself:
  `--support-material --support-material-auto --support-material-angle=40`

## 3. The G-code header — CRITICAL (do not skip)

The printer's `PRINT_START` macro owns **everything**: bed heat (55), nozzle heat (200), homing, adaptive mesh, purge. The gcode must **call it, not replicate it**.

**A printable gcode MUST:**
1. Begin with: `PRINT_START BED=55 EXTRUDER=200`
2. Contain **NO** `M104/M109/M140/M190` lines anywhere (the macro sets temps)
3. Contain **NO** `SET_VELOCITY_LIMIT` (Klipper owns motion: 5000 accel)
4. Have proper Z positioning before the first extrusion (lift → retract → drop to first layer → travel → extrude)

Slicer output does NOT do this on its own. **Run every sliced gcode through the splice** (script below) or write the header by hand. The working splice pattern:

```python
# cut at first "G1 " line, prepend:
#   ; header
#   PRINT_START BED=55 EXTRUDER=200
#   M220 S100
#   M221 S100
#   M106 S255
#   G90  G21  M83     <-- M83 CRITICAL: slicer E-values are RELATIVE.
#                       Without it Klipper reads them absolute and the first
#                       layer under-extrudes/retracts mid-line (2026-08-17).
# strip: ^M104, ^M109, ^M140, ^M190, ^SET_VELOCITY_LIMIT
# end: M104 S0 / M140 S0 / M84
```

Working script: `PRINTS/slice_print.py` — see §6. **Upload ONLY the spliced file.**

The `PRINT_START` macro (verified on host) does:
```
M190 S55  → bed heat + wait
M104 S150 → preheat nozzle
G28       → home
M104 S200 → final nozzle temp
BED_MESH_CALIBRATE ADAPTIVE=1
M109 S200 → wait nozzle
ADAPTIVE_LINE_PURGE
```

## 4. Upload + start + monitor (Moonraker API)

```bash
# Upload (filename= controls the name on the printer — use it or you get the wrong name!)
curl -s -F "file=@/tmp/sentinel_frame.gcode;filename=sentinel_frame.gcode" \
  "http://192.168.0.18:7125/server/files/upload?overwrite=true"

# Start
curl -s -X POST "http://192.168.0.18:7125/printer/print/start?filename=sentinel_frame.gcode"

# Monitor (state, progress, temps)
curl -s "http://192.168.0.18:7125/printer/objects/query?print_stats=state,print_duration&virtual_sdcard=progress&heater_bed=temperature,target&extruder=temperature,target"
```

**Verify after start (10–15s):** `print_stats.state == "printing"`, `heater_bed.target == 55`, and bed temp climbing. If the bed target is 0, the file is NOT the spliced one — stop immediately (that exact bug burned us twice).

**Fluidd connect for the operator:** http://192.168.0.18:4408 → Add Printer → API URL `http://192.168.0.18:7125` → Save.

## 5. Orientation & supports — the slicer decides (MANDATORY)

**ALL prints go through the slicer. The slicer decides orientation. The slicer decides supports.**
This rule exists because 2026-08-16 taught it twice:
1. A hand-chosen STL rotation produced a garbage orientation — the slicer even flagged it
   ("Detected print stability issues") and the warning was ignored. Never again.
2. Supports sliced with default interface settings welded to the part — they would not
   come off. The fix is the breakaway interface (below).

Rules:
- Never pre-rotate STLs by reasoning. If you must rotate (to put the largest face down),
  ALWAYS verify the slicer's first-layer footprint in the gcode before printing.
- Never disable or hand-design supports. Use the slicer's auto supports WITH the
  breakaway interface flags:
  ```bash
  --support-material --support-material-auto --support-material-angle=40 \
  --support-material-interface-layers=3 \
  --support-material-contact-distance=0.3 \
  --support-material-interface-contact-loops \
  --support-material-buildplate-only
  ```
  These four settings are what make supports *release*: 3 lattice interface layers, a
  0.3mm air gap, small contact dots instead of solid lines, and no support-on-part.
- Verify the gcode has `;TYPE:Support material interface` sections (not just
  `;TYPE:Support material`) — interface sections are the breakaway mechanism.

**ALWAYS verify what actually touches the bed BEFORE starting a long print.**

```bash
python3 -c "
import trimesh
m = trimesh.load('part.stl')
b = m.bounds
print('bbox X%.1f Y%.1f Z%.1f' % (b[1][0]-b[0][0], b[1][1]-b[0][1], b[1][2]-b[0][2]))
sec = m.section(plane_origin=[0,0,0.1], plane_normal=[0,0,1])
print('first layer bounds:', sec.bounds.round(1).tolist() if sec else 'N/A')
"
```

Then confirm the first-layer extents match the *intended* footprint (e.g. the shoe = 52×32). The gcode's first `G1 X/Y` moves must fall inside that footprint. **If a rotation was applied, check the ROTATED first layer, not the original** — `--rotate` plus auto-lift produced a garbage orientation that looked fine in theory (2026-08-16 incident).

Rules of thumb:
- Print the part the way it mounts on the machine (functional interface flat on bed).
- Overhangs >45° need supports: the breakaway interface flags above.
- NEVER start a print without operator confirmation. NEVER auto-chain parts — each part gets its own go.

## 6. The one-shot script (use this)

`PRINTS/slice_print.py` — slice → splice → upload → (optionally start) → report:

```bash
cd ~/Documents/3d_Printing/PRINTS
python3 slice_print.py --stl part.stl --name part_name --fast [--supports] [--rotate "-90,0,0"] [--start]
```

It prints the estimate, the spliced header, upload result, and (if `--start`) the 15s verification: state, bed target, progress. **Do not start without the operator's go** — drop `--start` and report first.

## 7. Cancel is BROKEN — emergency stop is the workaround

`POST /printer/print/cancel` fails with `No registered callback for path 'pause_resume/cancel'` (fork's pause_resume module not registered). To stop a print:

```bash
curl -s -X POST "http://192.168.0.18:7125/printer/emergency_stop"   # = M112
# wait ~30s — klipper-recover.timer auto-FIRMWARE_RESTARTs
curl -s "http://192.168.0.18:7125/printer/objects/query?webhooks=state"  # expect "ready"
```

After emergency stop, **wait for `webhooks.state == "ready"`** before starting anything (auto-recovery is proven, ~30s).

## 8. Current project state (2026-08-19)

- **READY.** Bed clear, no print running. Coupon calibration **DONE** (thin, consistent, well-adhered pad with a skirt, 217 s). Do NOT re-verify bed level / first-layer before the next job.
- **Z-offset 1.70 confirmed** (2026-08-19 coupon). Re-bake to 1.70 after ANY Klipper/reflash.
- **MCU USB-drop resolved** — see §1 note + `docs/MCU-USB-AUTOSUSPEND-INCIDENT-2026-08-19.md`.
- **Mount (Sentinel):** `zero3w_cam_mount.scad` — CAMERA-MOUNT-001 printed clean to 71.8 min then crashed at end-gcode in the (now fixed) MCU drop. Camera exposure fixed (gain 160→700).
- **Runout sensor:** hardware staged but **NOT installed** — do NOT enable `SFS_ENABLE` until wired (FILAM port, PC15).
- **RTK box:** paused (operator's call) — `PRINTS/rtk_box/NEXT_STEPS.md`. The Ø155 fit-check disk **edge-lifted**; re-slice with **6 mm brim + mouse ears at the cable slot + bed 60 °C** before any reprint.

## 9. Skirts & first-layer adhesion (2026-08-19 lesson)

The **best print yet used a skirt** (`skirt_loops: 1`, `skirt_distance: 4`) — it primes the
nozzle and stabilizes the first layer. Make a skirt the default for the first layer, not an afterthought.

- **Skirt = adhesion insurance** (not structural). Recommended: `skirt_loops: 1`, `skirt_distance: 4`.
- **Brim / mouse ears = mandatory** for large flat disks that tend to lift at edges (2026-08-16
  RTK tray edge-lift). A 155 mm flat disk warped at the cable-slot stress riser — brim + mouse
  ears + bed 60 °C is the defense, not optional.
- First-layer verification still rules: check the gcode's first `G1 X/Y` extents against the
  intended footprint (§5) before any long print.

## 10. Wave overhangs (support-free steep printing) — video learnings

Orca's **wave overhang** feature prints steep/near-vertical overhangs **support-free** with a
wavy toolpath instead of solid supports. Ideal for bowls, trays, cups, and steep-walled parts —
removes the support-removal weld problem. **Test on small coupons first.**

- `instead_of_bridges = 1` — wave replaces bridge toolpaths too, not just plain overhangs.
- Hilbert floor for clean internal fill on wave regions.
- **Verify `WAVE_OVERHANG` markers are present in the gcode** for the overhang regions. Missing
  markers = wave NOT applied → those areas need supports or will sag.
- If a wavy layer looks like it's bridging across empty space, lower the wave angle or re-add support.
- **Status (2026-08-19):** recent slices had NO `WAVE_OVERHANG` markers → wave mode not in use.
  It's an available lever; enable per-part and confirm markers before printing.

## 11. Physical strength tests (before calling a part done)

A print can look perfect yet be weak (2026-08-19 note: "still seems fragile" / "stuck together").
**Never assume strength from appearance — test it:**

| Test | What to do | Pass |
|---|---|---|
| Flex | Bend the thinnest loaded section a few degrees | No crack / no opening stress bands |
| Twist | Clamp one end, rotate the other ~10–20° | Springs back, no permanent set |
| Load | Squeeze vertically / press the primary load path | No sudden collapse or delamination |
| Layer adhesion | Pry a seam with a fingernail / flat screwdriver | Layers don't peel |
| Fit | Mating parts seat without force or rocking | Snug, no forcing |

**On failure:** add walls (2→3+), raise infill % or use gyroid, lower layer height, or slow down.
Iterate on a **coupon**, not the full part. **"Stuck together"** = dimensional oversize → adjust
tolerances/mating faces, not layer strength.

## 12. Firmware flash — SMALL CARD ONLY

> Board already runs Klipper — you likely don't need this. Re-flash only if the MCU reports a
> stale version or a re-flash is explicitly required. Full: `docs/sd-flashing-guide.md`.

- **SD card ONLY** (USB-C is the host→MCU serial link, not a flashing port).
- **MCU:** this board is **C13 / GD32F303**. Never flash a C14/STM32F401 bin.
- **SMALL card only: ≤8 GB, FAT32, 4096-alloc, empty.** Bootloader rejects large/SDHC/SDXC.
  **Do NOT use the Zero 3W's 32 GB card.**
- **8.3 filename** (e.g. `firmw.bin`) that **differs from the last flash**; rename on every retry.
- Sequence: power off → insert → power on → wait ~2 min → Klipper display (old Marlin = didn't
  take → rename, retry) → power off → **remove card**.
- Known-good bin: `firmware/e3v3se_klipper_with_display_C13.bin`. Verify: `grep -i "Loaded MCU" ~/printer_data/logs/klippy.log`.
- **Status (2026-08-19):** MCU still reports `1.0.0-6` — prior flash likely failed due to a
  **32 GB card**. Re-flash with a small card when you do it.

## 13. Typical AI questions (quick answers)

| "How do I…" | Answer |
|---|---|
| Connect? | `curl http://192.168.0.18:7125/printer/info` → `state: ready`. Fluidd `:4408`. |
| Slice? | OrcaSlicer CLI (§2) → read `result.json` warnings. |
| Upload? | `curl -F "file=@job.gcode;filename=job.gcode" http://192.168.0.18:7125/server/files/upload?overwrite=true` |
| Start? | `curl -X POST "http://192.168.0.18:7125/printer/print/start?filename=job.gcode"` — only after operator "go". |
| Monitor? | `curl "http://192.168.0.18:7125/printer/objects/query?print_stats=state&virtual_sdcard=progress&heater_bed=temperature,target"` |
| Cancel? | `printer/emergency_stop` (cancel is broken), wait for `webhooks.state == ready`. |
| Calibrate? | Z-offset 1.70 (re-bake after reflash). PA 0.033, shaping 72.8/48.4 already tuned. Coupon done. |

## 14. Don'ts (each one cost us real time)

- Don't fight OrcaSlicer CLI. Use it — it is the operator's slicer of record.
- Don't upload gcode with slicer temps. Splice it.
- Don't assume the uploaded filename — pass `;filename=`.
- Don't skip the 15s bed-target verification.
- Don't rotate without checking the rotated first layer.
- Don't auto-start or auto-chain prints.
- Don't trust Fluidd's warning panel as machine state — check `/server/info` and `/printer/configfile` (both report 0 warnings on a healthy box).
