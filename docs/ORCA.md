# OrcaSlicer — shop notes (wiki + HAL2026)

Official wiki: https://www.orcaslicer.com/wiki/  
Skill (full CLI/support table): Hermes `orcaslicer`.

**Slicer of record:** OrcaSlicer 2.4.2 AppImage. Not PrusaSlicer. Not OctoPrint.
**New AIs: start with `AI-QUICKSTART.md`** (self-contained) — this file is the shop-depth slicer notes.

## TPU

When the spool is TPU, use `docs/TPU.md` — process `0.20mm TPU @Ender-3 V3 SE` + filament `Overture TPU @Ender-3 V3 SE`. Do not pair TPU with the PLA speed process.

## Layout is the slicer’s job

```
--orient 1 --arrange 1 --allow-rotations --ensure-on-bed
```

Pass every STL on one command. Do not hand-stack parts and call it “layout.”

## After every slice

Read `result.json` → `sliced_plates[].warning_message`.  
Floating regions = act (re-orient, enable supports in process JSON, or operator override). Never “just a label.”

## G-code

Wiki start-gcode uses `G90` + `M83`. This Klipper has no `relative_extrusion`. Splice **must** keep `M83` or first layer starves.

Temps: `PRINT_START BED=55 EXTRUDER=200` only. Strip slicer `M104/M109/M140/M190`.

## Layer height (wiki, 0.4 mm)

20–80% of nozzle. Max 0.32. First layer ~0.25. Draft 0.28 is legal.

## Supports

JSON only (`enable_support`, `support_type` = `tree(auto)` not bare `tree`).  
PLA: build-plate only + 3 interface layers + 0.3 mm gap + interface loops.

## 8. Wave overhangs (support-free steep printing) — video learnings

Orca's **wave overhang** feature prints steep/near-vertical overhangs **support-free** with a
wavy toolpath instead of solid supports (bowls, trays, cups, steep walls). Key settings/gotchas:
- `instead_of_bridges = 1` (wave replaces bridge toolpaths too)
- Hilbert floor for clean internal fill on wave regions
- **Verify `WAVE_OVERHANG` markers appear in the gcode** for the overhang regions — absent
  markers = wave NOT applied (needs supports or will sag)
- Test on small coupons first; if a wavy layer bridges across empty space, lower wave angle/re-add support.
- **Status (2026-08-19):** recent slices had NO `WAVE_OVERHANG` markers → wave mode not in use.

## 9. Skirts

`skirt_loops: 1`, `skirt_distance: 4` = first-layer adhesion insurance. The best print yet
(2026-08-19) used a skirt. Large flat disks still need a **brim / mouse ears + bed 60 °C** to
avoid edge-lift (2026-08-16 RTK tray lesson).

## 10. Calibration order (wiki)

Temp → volumetric → PA → flow → retraction → cornering → input shaping → VFA.  
Already done here: PA 0.033, shaping 72.8 / 48.4. Don’t redo mid-print.
