# C2 — OrcaSlicer → ElegooSlicer cheat-sheet

Source: Planet 3DP — “How To Use OrcaSlicer: Complete Beginner Tutorial For 3D Printing”  
YouTube `yqV7lZU2uZk` · OrcaSlicer **2.3.0** · ~1:51 · saved 2026-09-08  

ElegooSlicer is an Orca fork. Most UI/tools map cleanly to Centauri Carbon 2 (`C2` @ `192.168.0.24`). Video demos **Centauri Carbon** (gen1), not specifically CC2 — verify plate type and nozzle/layer limits in your installed profile.

Companion note: `C2-PETG-preset.md` (Formfortis PETG knobs).

---

## UI map

| Area | What |
| --- | --- |
| Center | Model workspace |
| Top toolbar | Import, move, rotate, scale, cut, modify |
| Left panel | **Printer** · **Filament** · **Process** |
| Modes | **Home** (projects) · **Prepare** (setup/slice) · **Preview** (layers/G-code) · **Device** (monitor/control) · **Project** (metadata) |

### Preferences (recommended)

- Units: **metric**
- Startup page: **Prepare**
- View: **Orthographic** (not perspective)
- Auto-backup: **on**
- Modified G-code warning: **on**
- Advanced mode: leave **off** until comfortable
- System presets = safest start; orange values = changed from system

---

## Hotkeys

| Key | Tool |
| --- | --- |
| `M` | Move |
| `R` | Rotate |
| `S` | Scale |
| `C` | Cut |
| `T` | Text / emboss |
| `U` | Measure |
| `P` | Seam paint |

Rotate snap: **5°** increments; inner ring ≈ **45°**.  
Shift-drag = multi-select; Ctrl-click = add objects.

---

## Beginner workflow

1. Import model  
2. Check **active plate**  
3. Center / **lay-on-face** (max flat contact)  
4. Confirm **CC2** printer profile + nozzle + plate type  
5. Pick filament  
6. Choose quality / layer height  
7. Skim process (walls, infill, supports, brim)  
8. **Slice** → Preview  
9. **Print / Upload** (LAN)

Prefer saving as **3MF** (keeps settings, supports, variable LH, colors). Also supports STL / G-code / preset-bundle export.

---

## Prepare tips

- Up to **36** plates  
- Auto-orient helps; manually verify complex parts  
- Arrange spacing **0** = let slicer choose spacing  
- Avoid “allow multiple materials on same plate” unless needed (big time hit)  
- After Y-axis alignment, re-check slice — can sometimes slow the print  

### Cut

- **Planar** = clean straight cut  
- **Dovetail** = stronger glue joint, more visible seam (depth / width / flap / groove angles)  
- Optional connectors; cut height settable in mm  

### Text / emboss

- Add primitive → select → `T`  
- Height = font size; depth = thickness  
- **Use surface** = conform to model; **Per glyph** = better on curves  
- Ops: **Join** (separate object) · **Cut** (recessed) · **Modifier**  

### Measure / assemble

- Edges, planes, distances, angles  
- Select both objects to measure between them  
- Escape = back one step / exit  
- Assemble: face-to-face or point-to-point (align first)

---

## Printer / nozzle

- Common: **0.4 mm** nozzle  
- **0.2 mm** = finer, slower  
- **0.8 mm+** = large/fast parts  
- Video’s Centauri example LH bands (approx): **0.28–0.20 mm** @ 0.4; **0.14–0.08 mm** @ 0.2  
- Do **not** pick a larger-nozzle preset unless that nozzle is installed  
- Missing bed type → enable multi-bed types in printer profile, save user copy, then select plate  

---

## Filament

- Generic PETG is a workable starting profile in the video  
- Filament pane: nozzle/bed/chamber temps, cooling, retraction  
- Save custom filament as **user preset** (all projects) or **inside project** only  
- For PETG starting knobs on C2, use `C2-PETG-preset.md`  
- Flushing-volume too low → color bleed (multi-color only)

---

## Process defaults worth remembering

### Quality / walls / seams

- Smaller layer height = more detail, more time  
- First-layer height ≥ normal LH for adhesion  
- Seam default **Aligned**; **Back** hides toward rear of plate  
- Precise wall usually off; on for dimensional accuracy  
- Walls: **2** decorative; **≥4**, often **6** for strong/large parts  
- Increase top shells if tops look thin/incomplete  

### Infill

| Use | Rough range |
| --- | --- |
| Decorative / toys | ~**10–20%** (toys often ~10%) |
| Structural | **25–40%** |

Patterns: honeycomb/gyroid = strength; rectilinear/grid = speed; concentric/zigzag = curved look.

### Supports

- Enable supports before tuning  
- **Normal** = simple overhangs; **Tree** = less material / easier remove on complex parts  
- Demo: normal ~40% time / 114 g vs tree ~38% / 46 g (**−68 g**)  
- Threshold angle starts ~**30°**; **45°** = more supports; **0°** ≈ full overlap  
- “On build plate only” reduces internal supports (may leave overhangs)  
- Paint: LMB support, RMB blocker; smart-fill angles demos 70° / 20° / 4°  

### Skirt / brim / prime

- Skirt loops → **0** on modern printers (presenter preference)  
- Auto brim = good beginner default; outer brim width demo **5**  
- Mouse ears = small adhesion pads at risk spots  
- Prime tower: start with slicer default volume; PLA needs less purge than PETG/silk; short-print brim ~**3**, tall ~**8**; widen if tower wobbles  

### First layer

- Slow first layer + brim for adhesion  
- First-layer fan shown **0%**, then higher afterward  

---

## Preview / Device

Preview color modes: line type, filament, speed, LH, line width, flow, layer time, fan, temperature.  
Add pause for filament swap or inserts. Custom G-code = advanced.

Device tab (Centauri-style): status, axes, fans, lights, speeds, temps, camera, files, history, time-lapse — labels may differ slightly on CC2 / ElegooSlicer.

---

## Ignore (Bambu / cloud)

- MakerWorld / Bambu Cloud login  
- AMS / ACE multi-material cloud workflows  
- Bambu calibration page, Flow Dynamics, send-to-multi-device  

Not needed for single-spool Elegoo C2 LAN printing.

## Calibration gap

This video does **not** walk flow / PA / temp-tower calibration. It only notes custom filaments can be calibrated. Use separate calibration prints + the PETG note for material knobs.
