# AI-QUICKSTART — Print to the Ender-3 V3 SE (self-contained)

> **For ANY AI agent (Hermes, Grok, Claude, Codex, etc.).** Read this file top-to-bottom
> and you can safely slice, upload, start, monitor, and cancel a print over WiFi with zero
> prior knowledge. This file is self-contained — every command and value you need is inline.
>
> **Hard rule: NEVER start a print without the operator's explicit "go".**
> **NEVER auto-chain parts — each part gets its own approval.**
>
> **OPERATOR'S CANONICAL WORKFLOW (agreed 2026-08-20):**
> 1. **PREVIEW in OrcaSlicer FULL GUI** — open a part, slice, and present the real Orca
>    3D preview (layout, orientation, supports) for the operator to SEE before anything prints.
>    Local desktop → open the actual window. Remote → send Orca preview screenshots.
>    NEVER present a silent headless slice as "the preview."
> 2. **OPERATOR APPROVES** (explicit "go"). Never auto-start.
> 3. **START the print** via Moonraker.
> 4. **PRESENT Fluidd** (:4408) + live camera (:8080) so the operator monitors in near real time.
>
> Canonical deep-dives: `docs/PRINT-OPERATIONS.md` (full workflow), `docs/ORCA.md` + the
> `orcaslicer` Hermes skill (slicer specifics), `docs/sd-flashing-guide.md` (firmware).
> Last verified: 2026-08-19 (printer ONLINE, `state: ready`).

---

## 0. Current stack (verified 2026-08-19, evening)

| Thing | Value |
|---|---|
| Printer | **Creality Ender-3 V3 SE**, stock board, MCU **C13 / GD32F303** |
| Firmware | **Klipper** via jpcurti fork `ender3-v3-se-klipper-with-display` (display FW baseline 1.0.6) |
| Klipper host | **Radxa Zero 3W** (unit D4E0H0), hostname `radxa-zero3.local` = **192.168.0.18** (WiFi) |
| Moonraker API | **`http://192.168.0.18:7125`** (trusted LAN, no auth) |
| Fluidd UI | **`http://192.168.0.18:4408`** (needs Moonraker `cors_domains: *`, already set) |
| SSH | `root@radxa-zero3.local` (key auth from this machine; host sudo pw in `~/.hermes/.env` as `SUDO_PASSWORD`) |
| Slicer | **OrcaSlicer 2.4.2** — `~/Applications/OrcaSlicer.AppImage`. NOT PrusaSlicer. |
| Filament | Black or white **PLA only** (single extruder → one color per job). Shelf: 2× black, 2× white. |
| Print volume | 220 × 220 × 250 mm, 0.4 mm nozzle |
| Presets | Quality: 0.20 / 3 walls / 20% gyroid. Fast: 0.28 / 2 walls / 15% rectilinear. Temps **200/55**. |
|| Calibration | Z-offset **1.70** baked. PA and input shaping **NOT present in live config** (per 2026-08-19 audit; claimed in handoffs but lost during config rebuilds — verify/re-apply before claiming). |

**The host is NOT always powered.** Check reachability before anything else:

```bash
curl -s --max-time 5 http://192.168.0.18:7125/printer/info | head -c 200
# expect: {"result":{"state":"ready", ...}}
```

If it hangs, the Zero 3W is off — power it on (or tell the operator) before proceeding.

---

## 1. The workflow — PREVIEW FIRST, then one-shot print

**Step 0 — PREVIEW (mandatory, operator-driven):** Before anything prints, present the part in
**OrcaSlicer's full GUI** so the operator can SEE layout, orientation, and supports.
- **Local desktop:** launch the real Orca window with the part loaded + sliced + 3D preview
  open: `~/Applications/OrcaSlicer.AppImage /path/to/part.stl` (then slice in the GUI).
- **Remote:** slice (GUI-equivalent view) and send the operator **Orca 3D preview screenshots**
  (top/side/isometric) showing orientation + supports.
- Wait for the operator's explicit "go". **NEVER present a silent headless slice as the preview.**

**Step 1 — slice + splice + upload + (start):**
Everything below is wrapped in `PRINTS/slice_print.py`:

```bash
cd ~/Documents/3d_Printing/PRINTS
python3 slice_print.py --stl part.stl --name my_part [--fast] [--supports] [--start]
```

- `--fast` → fast profile; omit for quality.
- `--supports` → inject breakaway support settings into a temp process preset.
- `--start` → auto-start after upload. **Only with operator's go.** Without it, the script
  uploads and STOPS for approval (it prints `STAGED only. Operator approval required`).

It slices with Orca, splices in the `PRINT_START` header, uploads to Moonraker, and (with
`--start`) does the 15 s bed-target verification. Use it unless you need to hand-drive each step.

**But read §2–§7 once so you understand what it's doing and can verify it.**

---

## 2. How to connect (Moonraker)

| What | How |
|---|---|
| Reachability check | `curl -s --max-time 5 http://192.168.0.18:7125/printer/info` → expect `state: ready` |
| Printer state | `curl -s http://192.168.0.18:7125/printer/objects/query?print_stats=state` |
| Object temp/pressure info | `curl -s "http://192.168.0.18:7125/printer/objects/query?extruder=temperature,target&heater_bed=temperature,target"` |
| All files on printer | `curl -s "http://192.168.0.18:7125/server/files/list?root=gcodes"` |
| Operator's GUI | Fluidd at `http://192.168.0.18:4408` |

**Always check `state == "ready"` and the bed target BEFORE starting.** If bed target is `0`
right after start, the file is NOT spliced — stop immediately (this exact bug burned us twice).

---

## 3. How to slice (OrcaSlicer CLI)

```bash
~/Applications/OrcaSlicer.AppImage /tmp/part.stl --slice 0 --outputdir /tmp/out \
  --orient 1 --arrange 1 --allow-rotations --ensure-on-bed \
  --load-settings "/tmp/v3se_0.28_draft.json;/home/mike/.config/OrcaSlicer/user/default/machine/Ender-3 V3 SE (Klipper).json" \
  --load-filaments "/home/mike/.config/OrcaSlicer/system/Creality/filament/Creality Generic PLA @Ender-3V3-all.json"
```

- `--slice 0` = slice all plates; output is `*_1.gcode` + `result.json` in `/tmp/out`.
- `--load-settings` = process preset **then** machine preset, separated by `;`.
- `--orient 1 --arrange 1 --allow-rotations --ensure-on-bed` = let Orca orient + pack the bed.
- `--load-filaments` = Creality Generic PLA.
- **Do NOT pass Prusa flags** (`--support-material`, `--export-gcode`) — Orca rejects them.

**ALWAYS read `result.json` warnings after slicing** (a "floating regions / floating
cantilever" warning is the slicer telling you orientation/supports are wrong — act on it):

```bash
python3 -c "import json;print(json.load(open('/tmp/out/result.json'))['sliced_plates'][0].get('warning_message','NONE'))"
```

Supports belong in the **process preset JSON**, not CLI flags. Breakaway defaults (what makes
them release): 3 interface layers, 0.3 mm contact gap, interface loops, build-plate only.

---

## 4. The gcode splice (CRITICAL — do not skip)

The printer's `PRINT_START` macro owns **everything**: heat, homing, adaptive mesh, purge.
Slicer output does NOT call it on its own — you must splice it in, and strip slicer temps.

**A printable gcode MUST:**
1. Begin with `PRINT_START BED=55 EXTRUDER=200`
2. Contain **NO** `M104 / M109 / M140 / M190` anywhere (macro sets temps)
3. Contain **NO** `SET_VELOCITY_LIMIT` (Klipper owns accel: 5000)
4. Keep **`M83`** (relative extrusion) — Klipper has no `relative_extrusion` override, so
   without it the first layer under-extrudes and retracts mid-line (2026-08-17 lesson)

The splice (cut at the first `G1 ` line, prepend header, strip temps):

```python
header = ["; spliced for E3V3SE/Klipper",
          "PRINT_START BED=55 EXTRUDER=200",
          "M220 S100", "M221 S100", "M106 S255",
          "G90", "G21", "M83"]          # M83 CRITICAL
# then the sliced body, minus any line matching ^M104, ^M109, ^M140, ^M190, ^SET_VELOCITY_LIMIT
# end with: M104 S0 / M140 S0 / M84
```

Fast manual equivalent: `grep -vE '^M10[49]|^M14[09]|^SET_VELOCITY_LIMIT' in.gcode > job.gcode` then prepend the header.
`PRINTS/slice_print.py` and `PRINTS/splice_zoff_coupon.py` do this automatically. **Upload ONLY the spliced file.**

---

## 5. Upload + start + monitor (Moonraker)

```bash
# Upload — pass ;filename= or the printer uses the wrong name
curl -s -F "file=@/tmp/my_part_fix.gcode;filename=my_part.gcode" \
  "http://192.168.0.18:7125/server/files/upload?overwrite=true"

# Start
curl -s -X POST "http://192.168.0.18:7125/printer/print/start?filename=my_part.gcode"

# Monitor (state, progress, temps)
curl -s "http://192.168.0.18:7125/printer/objects/query?print_stats=state,print_duration&virtual_sdcard=progress&heater_bed=temperature,target&extruder=temperature,target"
```

**Verify 10–15 s after start:** `print_stats.state == "printing"`, `heater_bed.target == 55`,
bed temp climbing. If bed target is `0` → wrong (unspliced) file → **emergency stop now**.

---

## 6. How to cancel (BROKEN — use emergency stop)

`POST /printer/print/cancel` **FAILS** with `No registered callback for path 'pause_resume/cancel'`
(the fork doesn't register `pause_resume`). To stop a print:

```bash
curl -s -X POST "http://192.168.0.18:7125/printer/emergency_stop"   # = M112
# wait ~30s — klipper-recover.timer auto-FIRMWARE_RESTARTs
curl -s "http://192.168.0.18:7125/printer/objects/query?webhooks=state"  # expect "ready"
```

**Wait for `webhooks.state == "ready"` (~30 s, auto-recovery proven)** before starting anything.

---

## 7. First-layer verification (MANDATORY before a long print)

**The slicer decides orientation. The slicer decides supports. Never pre-rotate STLs by
"reasoning"** — a hand-chosen rotation produced a garbage print on 2026-08-16 even though the
slicer flagged it. If you must rotate, verify the *rotated* first layer in the gcode.

1. **Print a skirt** (`skirt_loops: 1`) — the best print yet (2026-08-19) used one; it primes
   the nozzle and stabilizes the first layer. Cheap insurance.
2. **Check first-layer XY extents match the intended footprint:**
   ```bash
   python3 -c "
   import trimesh
   m = trimesh.load('part.stl'); b = m.bounds
   print('bbox X%.1f Y%.1f Z%.1f' % (b[1][0]-b[0][0], b[1][1]-b[0][1], b[1][2]-b[0][2]))
   sec = m.section(plane_origin=[0,0,0.1], plane_normal=[0,0,1])
   print('first layer bounds:', sec.bounds.round(1).tolist() if sec else 'N/A')"
   ```
3. The gcode's first `G1 X/Y` moves must fall inside that footprint.
4. **Never start without operator confirmation.** Show the operator: time estimate, Z height,
   first-layer footprint, and any slicer warnings.

---

## 8. How to calibrate (already done — don't redo mid-print)

- **Z-offset:** 1.70 confirmed (2026-08-19 coupon). Re-bake after ANY reflash. Too-low →
  nozzle drags/crust; too-high → ridges/gaps. Adjust in ±0.1 steps.
- **Bed mesh:** `PRINT_START` runs `BED_MESH_CALIBRATE ADAPTIVE=1` every print. Don't run it manually mid-job.
- **Input shaping:** X 72.8 / Y 48.4. **Pressure advance:** 0.033. Both already tuned.
- Coupon calibration is **DONE** (2026-08-19). Do NOT re-verify bed level / first layer before the next job.

---

## 9. Wave overhangs (support-free steep printing) — from video learnings

Orca's **wave overhang** feature prints steep/near-vertical overhangs **support-free** by using
a wavy toolpath instead of solid supports. Great for bowls, trays, cups, and any part with steep
walls — avoids the support-removal weld problem entirely. **Test on small coupons first.**

Key settings / gotchas (learned the hard way):
- `instead_of_bridges = 1` — wave replaces bridge toolpaths, not just normal overhangs.
- Hilbert floor (wave-adjacent toolpath ordering) for clean internal fill on wave regions.
- **Verify `WAVE_OVERHANG` markers appear in the gcode** for the overhang regions — if the
  markers are absent, wave mode was NOT applied and those areas need supports or will sag.
- When enabled, watch the overhang region on the first pass; if the wavy layer looks like it's
  bridging across empty space, drop the wave angle or add back support.

> Current status (2026-08-19): recent gcode slices did NOT contain `WAVE_OVERHANG` markers, so
> wave mode was NOT in use. It's an available lever — enable per-part and verify markers before printing.

---

## 10. Physical strength tests (do BEFORE calling a part done)

A print can look perfect yet be weak (recent 2026-08-19 note: "still seems fragile" / parts
"stuck together"). **Never assume strength from appearance — test it.**

| Test | What to do | Pass |
|---|---|---|
| Flex | Grip both ends, bend the thinnest loaded section a few degrees | No crack, no white stress bands that open |
| Twist | Clamp one end, rotate the other ~10–20° in each direction | Springs back, no permanent set |
| Load | Squeeze vertically / press on the primary load path | No sudden collapse or delamination |
| Layer adhesion | Pry at a seam with a fingernail / small flat screwdriver | Layers don't peel apart |
| Fit | Mating parts seat without excessive force or rocking | Snug, no forcing |

**If a part fails:** increase wall loops (2→3+), bump infill % or switch to gyroid, lower layer
height, or print slower. Re-print the coupon, not the whole part, when iterating strength.
**Parts "stuck together"** = dimensional oversize — check tolerances / re-scale mating faces,
not layer strength.

---

## 11. Firmware flash (SD card only, SMALL card) — when needed

> You almost certainly don't need this today (the board already runs Klipper). Do it only if the
> MCU reports a stale version or you need to re-flash. Full guide: `docs/sd-flashing-guide.md`.

- **Delivery is SD card ONLY.** The USB-C is the host→MCU serial link (CH340), not a flashing port.
- **MCU variant FIRST:** this board is **C13 / GD32F303** (`stm32f103xe` target). Never flash a
  C14/STM32F401 bin. Known-good bin: `firmware/e3v3se_klipper_with_display_C13.bin`
  (md5 `8dd5c57f2a77b567eec13ef91181c47e`).
- **SMALL card only (≤8 GB), FAT32, 4096-byte allocation, EMPTY.** The bootloader rejects
  large / SDHC / SDXC cards. **Do NOT use the Zero 3W's 32 GB card** (risk factor in the
  current stale-version situation).
- **8.3 filename** (e.g. `firmw.bin`), and **the name MUST differ from the last flash** — the
  bootloader skips a same-named file. Rename on every retry.
- **Sequence:** power OFF → insert card → power ON → wait ~2 min → Klipper display appears
  (old Marlin GUI = flash didn't take → power off, rename, retry) → power off → **remove card**
  (leaving it in causes MCU-connect failure on later boots).
- **Verify:** `grep -i "Loaded MCU" ~/printer_data/logs/klippy.log` on the host — the version
  string must match the flashed build.
- **Current status (2026-08-19):** MCU still reports `1.0.0-6` (stale) — a prior flash likely
  didn't take because a **32 GB card** was used. When re-flashing, use a **small card only**.

---

## 12. Common pitfalls (each one cost us real time)

| Pitfall | Symptom | Avoid |
|---|---|---|
| No splice / slicer temps left in gcode | Bed target 0, print dies | Splice header; strip `M104/M109/M140/M190` |
| Stripped `M83` | First layer starves / mid-line retracts | Keep `M83` |
| Hand-rotated STL, unverified first layer | Garbage orientation | Let slicer orient; verify rotated footprint |
| Supports welded to part | Can't remove them | Breakaway interface (3 layers, 0.3 gap, loops, buildplate-only) |
| Ignoring slicer "floating regions" warning | 148 mm tall failure | Read `result.json` warnings, act on them |
| Wrong upload name | File has wrong name / won't start | Pass `;filename=` |
| Assuming host is up | Nothing responds | `curl :7125/printer/info` first |
| Big SD card / same 8.3 name | Flash ignored | ≤8 GB, unique name each retry |
| Skip 15 s bed-target check | Print running unspliced | Verify bed target == 55 after start |
| Auto-start / auto-chain parts | Operator loses control | Each part gets its own explicit "go" |
| Cancel endpoint | Fails, nothing stops | `printer/emergency_stop`, wait for `ready` |

---

## 13. TL;DR workflow (copy-paste)

```bash
# 1. Reachability
curl -s --max-time 5 http://192.168.0.18:7125/printer/info | head -c 120
# 2. Slice + splice + upload + (start) — one shot
cd ~/Documents/3d_Printing/PRINTS
python3 slice_print.py --stl /tmp/part.stl --name my_part --fast --supports   # NO --start = staged
# 3. Operator approves → start it:
python3 slice_print.py --stl /tmp/part.stl --name my_part --fast --supports --start
# or: curl -s -X POST "http://192.168.0.18:7125/printer/print/start?filename=my_part.gcode"
# 4. Monitor
curl -s "http://192.168.0.18:7125/printer/objects/query?print_stats=state&virtual_sdcard=progress&heater_bed=temperature,target"
# 5. Cancel (if needed)
curl -s -X POST "http://192.168.0.18:7125/printer/emergency_stop"
```

**Golden rules:** preview in the FULL Orca GUI (never a silent headless slice) · operator approves each part · then start · then present Fluidd+camera · slicer decides orientation/supports · splice every gcode · verify bed target 55 · print a skirt · test strength · flash with a small card only · never auto-start without operator "go".
