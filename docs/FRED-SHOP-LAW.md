# FRED SHOP LAW — break these, you ruin a print

Ender-3 V3 SE · Klipper on `192.168.0.18` · **OrcaSlicer 2.4.2 only** (`~/Applications/OrcaSlicer.AppImage`).
**Not PrusaSlicer. Not EasyPrint gcode. Not OctoPrint.** One color per job (single extruder). Shelf: black/white PLA.

Operator workflow (2026-08-20): **Orca full-GUI preview → explicit "go" → start via Moonraker → Fluidd `:4408` + camera `:8080`.** Never start a print in this file.

---

## If you break these, you ruin a print

1. **Preview-first.** Open the real Orca window, slice, show the 3D preview (layout / orientation / supports). Remote: Orca screenshots (top/side/iso). **A silent headless slice is not a preview.**
2. **No auto-start. No auto-chain.** Omit `--start` until the operator says "go". Each part is its own job and its own "go".
3. **`PRINT_START` contract.** Printable gcode **must** begin `PRINT_START BED=55 EXTRUDER=200` (TPU: `BED=40 EXTRUDER=220`). Strip every `M104/M109/M140/M190`. Macro owns heat / home / adaptive mesh / purge. Bed target `0` 15 s after start = unspliced file → **emergency stop now**.
4. **Keep `M83`.** This Klipper has no `relative_extrusion`. Strip `M83` → first layer starves / retracts mid-line.
5. **Quality vs fast.** Quality (show parts, **this job**): **0.20 mm / 3 walls / 20% gyroid**, omit `--fast`. Fast (functional): `--fast` → 0.28 / 2 walls / 15% rectilinear. Do not mix.
6. **TPU is a different stack.** `--tpu` → process `0.20mm TPU @Ender-3 V3 SE` + `Overture TPU` + header fan **`M106 S0`**. Never pair TPU filament with PLA/Speed process. `--tpu` and `--fast` are mutually exclusive.
7. **Z-offset coupon is DONE (2026-08-19).** Live offset **1.70**. Do **not** re-run bed-level / first-layer coupons / `PROBE_CALIBRATE` before the next job. Re-bake 1.70 only after a reflash.
8. **After a real start:** present Fluidd `http://192.168.0.18:4408` and camera `http://192.168.0.18:8080/?action=stream`. Cancel is broken — `POST /printer/emergency_stop`, wait ~30 s for `webhooks.state == ready`.
9. **Slicer decides supports** (breakaway in process JSON: 3 interface layers, 0.3 mm gap, interface loops, build-plate only). No Prusa CLI flags (`--support-material`, `--export-gcode`). Read `result.json` `warning_message` — floating regions are not a label.
10. **Orientation (operator override 2026-09-02).** Other bots got "slicer decides orientation" because they ignored bridging. Fred **may pre-rotate** when the large **supported** face is on the bed and there are **no giant bridges**, then **must still prove L1 in gcode**. Do **not** use `--orient 1 --allow-rotations` as a substitute. `slice_print.py` always passes those flags — don't use it blindly for trays.
11. **Skirt** (`skirt_loops: 1`, `skirt_distance: 4`) is first-layer insurance. Upload **only** the spliced file, with `;filename=`. Host is not always on — `curl -s --max-time 5 http://192.168.0.18:7125/printer/info` first.

---

## Naive-agent traps (this shop already paid for these)

| Naive move | Why it ruins the job |
|---|---|
| **`slice_print.py` always passes `--orient 1 --arrange 1 --allow-rotations`** | Orientation is **baked** into `ESP32-32E-Back-bed.stl` (letters **UP**, large face on bed, Z≈7.7 mm). Auto-orient stood `Back-print.stl` up to **92 mm**. Do **not** `--orient` / `--allow-rotations` on a baked STL. `--ensure-on-bed` only. |
| **Blanket-strip `SET_VELOCITY_LIMIT`** | Docs say Klipper owns accel, but Orca emits **L1 `SET_VELOCITY_LIMIT ACCEL=500`**. Deleting it slams layer 1 at printer max (live **2500**, folklore 5000) and wrecks adhesion. **Keep L1 ACCEL=500** (and outer-wall 1000). Strip slicer **temps**, not first-layer accel. |
| **Dual-part plate (`ESP32-32E-both*`, Front+Back together)** | One part per approval, one color per job. Front and Back are **two** jobs. Do not hand-stack. Do not `--slice` two STLs onto one plate. |
| **Headless slice as "the preview"** then `--start` | Operator never saw Orca GUI. That is how garbage orientation / welded supports / floating regions ship. |

Also: `slice_print.py`'s `QUALITY_PROC` (`0.20mm Standard @Creality Ender3V3SE 0.4.json`) is **2 walls / 15%**, not shop quality — **verify 3 walls / 20% gyroid in the GUI**. Part notes that say bed 60 °C, 0.16 mm, or redo Z **lose** to this file.

---

## Exact commands — back-only PLA **quality** (STAGED, no start)

STL of record: `PRINTS/ESP32-32E/ESP32-32E-Back-bed.stl` (minZ=0, ~56×92 first layer). **Not** Front. **Not** `*-both*`. **Not** `Back-print.stl` / `Back-flat.stl`.

```bash
# 0) host up?
curl -s --max-time 5 http://192.168.0.18:7125/printer/info | head -c 120

# 1) PREVIEW — full Orca GUI. Slice in the window. STOP until operator "go".
~/Applications/OrcaSlicer.AppImage \
  /home/mike/Documents/3d_Printing/PRINTS/ESP32-32E/ESP32-32E-Back-bed.stl
# GUI: Creality Generic PLA · 0.20 mm · 3 walls · 20% gyroid · skirt 1 · letters UP · no --fast · no TPU
```

Headless generate **only after** the GUI preview is approved. **No `--orient`, no `--start`, no Front:**

```bash
cd ~/Documents/3d_Printing/PRINTS
mkdir -p /tmp/esp32_back_quality
# optional: copy quality proc and force 3 walls / 20% gyroid / skirt 1 if GUI preset was verified
~/Applications/OrcaSlicer.AppImage \
  /home/mike/Documents/3d_Printing/PRINTS/ESP32-32E/ESP32-32E-Back-bed.stl \
  --slice 0 --outputdir /tmp/esp32_back_quality \
  --ensure-on-bed \
  --load-settings "/home/mike/.config/OrcaSlicer/system/Creality/process/0.20mm Standard @Creality Ender3V3SE 0.4.json;/home/mike/.config/OrcaSlicer/user/default/machine/Ender-3 V3 SE (Klipper).json" \
  --load-filaments "/home/mike/.config/OrcaSlicer/system/Creality/filament/Creality Generic PLA @Ender-3V3-all.json"

python3 -c "import json;print(json.load(open('/tmp/esp32_back_quality/result.json'))['sliced_plates'][0].get('warning_message','NONE'))"

# splice: PRINT_START + M83; strip M104/M109/M140/M190; KEEP L1 SET_VELOCITY_LIMIT ACCEL=500
# do NOT: python3 slice_print.py ... --start
# do NOT: python3 slice_print.py ... (auto --orient)
# upload only after splice, still no start:
# curl -s -F "file=@/tmp/esp32_back_quality/plate_1_fix.gcode;filename=esp32_32e_back.gcode" \
#   "http://192.168.0.18:7125/server/files/upload?overwrite=true"
```

Shop script equivalent **if** you must use it — **omit `--fast --tpu --supports --start`**, and **do not use it on this Back** unless auto-orient is patched: it will rotate a baked STL.

After a later "go": start `esp32_32e_back.gcode`, wait 15 s, confirm `heater_bed.target == 55`, then open Fluidd + camera. **Do not start from here.**
