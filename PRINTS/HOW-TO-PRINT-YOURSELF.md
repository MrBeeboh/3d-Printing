# Print a job yourself (no bot) — Rock 5C case / any model

Printer: **ready**, bed **clear**, Z-offset **1.70 confirmed** (2026-08-19 coupon).
Use these exact steps. Do NOT use EasyPrint/Prusa gcode — Orca only.

## 1. Get the model
The case STL/3MF. (EasyPrint `.gcode` is NOT a model — you slice from the mesh.)
- Rock 5C case → drop the STL here or paste the URL.

## 2. Slice in OrcaSlicer (`~/Applications/OrcaSlicer.AppImage`)
1. File → Import → add the STL
2. **Auto-orient** (Process → orient): flat large face down
3. Filament: **Creality Generic PLA** (bulk blue spool)
4. Process: **`V3SE Speed`** (Ender-3 V3 SE)
5. Check **no supports** unless the model genuinely overhangs
6. **Slice + export** gcode

## 3. Splice it (NON-NEGOTIABLE)
Open the exported `.gcode` in a text editor. Keep header:
```
M83                  ; relative extrusion - Klipper has no relative_extrusion override
M106 S0              ; fan off layer 1
```
Keep these near the top (Orca emits them):
```
M220 S100
M221 S100
PRINT_START BED=55 EXTRUDER=200
G90
G21
M83
```
**DELETE every line** that is:
- `M104 S…` (nozzle temp — PRINT_START owns it)
- `M109 S…` (wait nozzle)
- `M140 S…` (bed temp)
- `M190 S…` (wait bed)
- `SET_VELOCITY_LIMIT …` (accel is Klipper's)

Fast way: `grep -vE '^M10[49]|^M14[09]|^SET_VELOCITY_LIMIT' in.gcode > job.gcode`

## 4. Verify first layer (before printing)
The gcode's first-layer XY box = the big flat face, centered near **(110,110)**, NOT off the left edge (X<0) and NOT a thin shoe. If it stands on a small edge, re-orient.

## 5. Print from Fluidd
1. Open `http://192.168.0.18:4408`
2. Upload the **spliced** `job.gcode`
3. Start it
4. **Watch first layer**: smooth squished skin, no floating ridges, no nozzle drag

## Trouble
- **No filament on bed** → extruder gear grind/starve. Try a manual purge (M83 / G1 E8 F60 at 200C) first.
- **Nozzle drags / crust** → Z too low. Raise `z_offset` ~0.1, re-test.
- **Ridges/gaps** → Z too high. Lower `z_offset` ~0.1.
- Re-bake Z to **1.70** after ANY Klipper/reflash.
