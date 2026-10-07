# FRED Klipper playbook — Ender-3 V3 SE (this shop)

**Audience:** any operator / AI sending jobs to Fred.  
**Verified live:** 2026-09-02 ~13:10 PT (20:10 UTC). Do **not** start a print from this doc.  
**Do not edit `printer.cfg` unless explicitly asked.** Source of truth is the host file, not HAL copies.

| | |
|---|---|
| Printer | Creality Ender-3 V3 SE, stock board, MCU **C13 / GD32F303** |
| Firmware | Klipper **jpcurti** `ender3-v3-se-klipper-with-display` (display FW baseline 1.0.6) |
| Host | Radxa Zero 3W D4E0H0, `192.168.0.18`, SSH `root@192.168.0.18` from HAL |
| UI / API | Fluidd `:4408` · Moonraker `:7125` · camera `:8080` |
| Data | `/home/pi/printer_data/` · live cfg `/home/pi/printer_data/config/printer.cfg` |
| Slicer | **OrcaSlicer 2.4.2** only. Preview in the **full GUI**. Operator **go** required. |

---

## 1. Live config numbers (host, 2026-09-02)

Pulled from `/home/pi/printer_data/config/printer.cfg` + Moonraker `toolhead`/`extruder`. Includes: `macros.cfg`, `prtouch.cfg`.

| Key | Live value | Notes |
|---|---|---|
| `max_velocity` | **250** mm/s | |
| `max_accel` | **2500** mm/s² | **Not 5000.** Older docs that say “Klipper owns 5000” are wrong for this box. |
| `square_corner_velocity` | **5.0** mm/s | Keep. Raising it rings on a bedslinger. |
| `max_z_velocity` / `max_z_accel` | 5 / 100 | |
| `pressure_advance` | **0.0** (unset) | Claimed 0.033 was **lost** in config rebuilds. Do not claim PA is tuned. |
| `input_shaper` | **absent** | Claimed 72.8 / 48.4 Hz **not in live cfg**. Do not claim IS is on. |
| `z_offset` (`[bltouch]`) | **1.70** | Coupon-baked 2026-08-19. Re-bake after any reflash. |
| Probe XY offset | X **-23.0**, Y **-14.5** | CR Touch as `[bltouch]`, `probe_with_touch_mode: True` |
| TMC `run_current` | X **0.60** · Y **0.90** · Z **0.80** | Y is **0.90** live (stock sample cfg is 0.60). |
| `bed_mesh` | 5×5 bicubic, `mesh_min` 30,30 · `mesh_max` 207,215.5 | Adaptive mesh every `PRINT_START`. |
| Build volume | 220×220×250 advertised; `position_max` 230/230/250 | Usable print area is **inside** the mesh, not the full 230. |
| `[exclude_object]` | present | Adaptive purge reads object polygons. Keep slicer `EXCLUDE_OBJECT*` comments. |
| `[pause_resume]` | present (empty section) | Moonraker **cancel was historically broken**. Proven stop = `emergency_stop`. |
| `[prtouch]` | included | Load-cell helper (`PRTOUCH_PROBE_ZOFFSET`, `NOZZLE_CLEAR`). Not a substitute for CR Touch mesh. |

Idle Moonraker at check: `webhooks.state=ready`, bed ~41 °C / target 0, nozzle ~58 °C / target 0, `absolute_extrude=true` (so **M83 is mandatory** in job gcode).

---

## 2. PRINT_START contract

Live macro (`macros.cfg`) — defaults if you omit params are **BED=60 EXTRUDER=220**. **Never omit params.** Shop PLA call:

```
PRINT_START BED=55 EXTRUDER=200
```

Body (verbatim order):

1. `CLEAR_PAUSE`
2. `M190 S{bed}` — heat bed, wait
3. `M104 S150` — nozzle preheat
4. `G28` — home (CR Touch Z)
5. `M104 S{extruder}`
6. `BED_MESH_CALIBRATE ADAPTIVE=1 ADAPTIVE_MARGIN=5`
7. `G0 X1 Y1 Z1 F5000`
8. `M109 S{extruder}` — wait nozzle
9. `ADAPTIVE_LINE_PURGE` (uses `[exclude_object]` polygons; `M83` during purge, then restores)

After the macro, spliced header must still set:

```
M220 S100
M221 S100
M106 S255
G90
G21
M83          ; CRITICAL — Klipper has no relative_extrusion override
```

`PRINT_END` presents the bed (`G0 X0 Y220`), kills fan/heaters, `M84`.

Use `PRINTS/slice_print.py` (or the documented splice). Upload **only** the spliced file. Verify 10–15 s after start: `print_stats.state=printing` **and** `heater_bed.target==55`. Target 0 = unspliced file → **emergency stop now**.

---

## 3. What to NEVER strip from gcode

| Keep | Why |
|---|---|
| `PRINT_START BED=… EXTRUDER=…` | Owns heat / home / adaptive mesh / purge. |
| **`M83`** | Without it first layer starves / mid-line retracts (2026-08-17). |
| `EXCLUDE_OBJECT_DEFINE` / `EXCLUDE_OBJECT_*` | Adaptive purge + cancel-object. Missing → purge at origin. |
| `M220` / `M221` (if present) | Feed/flow overrides. |
| Skirt / first-layer moves | Do not “clean up” early `G1` lines. |

**Must strip** (macro owns these; slicer copies fight the contract):

- `M104` `M109` `M140` `M190` anywhere in the body
- `SET_VELOCITY_LIMIT ACCEL=5000` (or any cap above live **2500**) — skips Y belts. **Keep** L1 `SET_VELOCITY_LIMIT ACCEL=500` (and outer-wall 1000) for 0.4 mm text. Blanket-strip is how letters smeared on 2026-09-02.
- Do **not** strip `M83` while stripping `M10x`/`M19x`

End of file may re-add `M104 S0` / `M140 S0` / `M84` (or call `PRINT_END`).

---

## 4. Host-reboot risk (today, 2026-09-02)

**What happened (evidence, not folklore):**

| Clock | Event |
|---|---|
| 12:16:32 PT / 19:16:32 UTC | Job `ESP32-32E-both-bed.gcode` started (`00002D`) |
| 13:01:04 PT / 20:01:04 UTC | Moonraker: **`klippy_shutdown`** after **~41 min** print time (not 16) |
| 13:01:13–13:02:23 PT | `klipper-recover`: `klippy=shutdown print=paused` → **correctly refused** `FIRMWARE_RESTART` |
| 13:02:28 PT / 20:02:28 UTC | Kernel: **CH340 `/dev/ttyUSB0` USB disconnect** |
| 13:02:32 PT / 20:02:32 UTC | USB re-enumerate, then journal **ends with no shutdown** |
| 13:03:10 PT / 20:03:10 UTC | Host back (boot 0). FAT boot partition: *“not properly unmounted”* |

**The “19:33 UTC reboot ~16 min in” timestamp is a clock lie.** This Zero 3W has **no useful RTC**. On the 20:03 boot, `systemd-timesyncd` restored the last saved clock (`19:33:07 UTC`), so `last`, `who -b`, and systemd “Active since” show 19:33. Real death is **20:02 UTC**. There is **one** hard reboot in `journalctl --list-boots`, not two. `/tmp/klippy.log` does **not** survive reboot (empty pstore).

**Class:** unclean power/host crash, **not** the 2026-08-19 USB-autosuspend bug. Autosuspend fix is still live (`usbcore.autosuspend=-1` in cmdline). Recover timer is healthy and print-aware.

**Operational meaning:**

- A host death mid-print looks like a **layer-shift dump** (steppers lose sync when 5V USB/klippy die).
- Do **not** trust host uptime/`last` until NTP has been up several minutes.
- Long unattended prints are **no-go** until this power path is proven (PSU/strip, SD integrity, no repeat 20:02-style death).
- After any host blip: wait `webhooks.state=ready`, confirm `/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0`, then operator inspects the bed before the next job.
- Stop a print: `POST http://192.168.0.18:7125/printer/emergency_stop` then wait ~30 s for recover. Do not rely on `/printer/print/cancel`.

---

## 5. First-layer accel / speed — 0.4 mm nozzle **text**

Live motion cap is **2500 / 250 / SCV 5**. PA=0 and **no input shaper** → small letters ghost and corners blob if you print them at body speed.

| Setting | Use this | Do not |
|---|---|---|
| First-layer height | **0.20 mm** | >0.28 on text |
| First-layer line width | **0.42–0.45 mm** | Hairline <0.35 |
| First-layer **speed** | **20–25 mm/s** (skirt same or slower) | ≥50 mm/s |
| First-layer **accel** | **500–800 mm/s²** | 2500, and **never slicer 5000** |
| First-layer flow | 100–105% if gaps; 95–100% if crushed | |
| Skirt | **1 loop, 4 mm** (shop lesson 2026-08-19) | No skirt on text plates |
| Later layers (text) | outer wall **30–40 mm/s**, accel **1000–1500** | Body 250 mm/s / 2500 accel on glyphs |
| Temps | **200 / 55** via `PRINT_START` | Slicer-baked 220 unless operator says so |
| Large flat plates | brim + mouse ears; bed **60** only if operator agrees | Edge-lift (RTK disk 2026-08-16) |

Stock **5000 accel skip:** Creality/Nebula profiles and some Orca machine presets emit `SET_VELOCITY_LIMIT ACCEL=5000`. On this SE that **skips Y belts / loses steps**. Live cfg is 2500 for a reason. Strip it.

---

## 6. Machine gotchas (this printer + this fork)

- **CR Touch vs PR Touch:** bed mesh / Z home is **CR Touch** (`[bltouch]`, `probe_with_touch_mode: True`, offsets −23 / −14.5). **PR Touch** (`prtouch.cfg`) is the load-cell helper for `PRTOUCH_PROBE_ZOFFSET` / nozzle wipe. Do not treat PR Touch as the mesh probe. Cold mesh is a lie — `PRINT_START` heats the bed **before** `G28`/`BED_MESH`.
- **220×220:** stay inside mesh 30–207 × 30–215. Probe cannot reach the far corner; edge prints crash or go unlevel.
- **jpcurti display:** stock screen works only on this fork (vanilla Klipper has no `e3v3se_display`). Display **cannot** set max speed/accel. Display FW baseline **1.0.6**.
- **C13 vs C14:** this board is **C13/GD32F303**. Never flash a C14/STM32F401 bin. SD flash only, **≤8 GB** card, unique 8.3 name. USB-C is serial, not DFU.
- **Belts / Y skip:** heavy bed + weak Y. Live Y current **0.90 A**. If a “layer shift” happens **while the host stays up**, check Y belt and drop accel — if the **host died**, it is not a belt.
- **Runout sensor:** hardware staged, **not installed**. Do not enable `SFS_ENABLE`.
- **Preview rule:** full Orca GUI (or screenshots). Never a silent headless slice. Never auto-chain.

---

## 7. Go / no-go before starting a print

**NO-GO if any fail. Do not start.**

- [ ] Operator gave an explicit **go** for **this** file (not a previous part).
- [ ] Host answers `curl -s --max-time 5 http://192.168.0.18:7125/printer/info` → `state: ready`.
- [ ] Host **uptime > 15 min** *after NTP* (do not trust a 19:33-style `last` timestamp). Repeat crash today = treat long jobs as no-go until power is trusted.
- [ ] MCU present: `/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0`. `usbcore.autosuspend=-1` still in `/proc/cmdline`.
- [ ] `klipper-recover.timer` active. Bed **physically clear**. No leftover dump from a killed job.
- [ ] Gcode **starts with** `PRINT_START BED=55 EXTRUDER=200` (or operator-approved temps). **M83** present. **No** `M104/M109/M140/M190` in the body. **No** `SET_VELOCITY_LIMIT ACCEL=5000`. **Keep** L1 `ACCEL=500` for text.
- [ ] First-layer XY extents match the intended footprint; Orca `result.json` warnings read (floating regions = act).
- [ ] Skirt on. Text/small glyphs: first layer **≤25 mm/s** and **≤800 accel**.
- [ ] Fluidd `:4408` + camera ready for the operator. After start: bed **target 55** within 15 s.

**If no-go:** stage the file (`slice_print.py` without `--start`), report the failed check, wait.

**After a host death:** do not resume the old file. Clear the bed, wait ready, new splice, new go.
