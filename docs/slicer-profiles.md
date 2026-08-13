# Slicer profiles

## Status

**No slicer configured on HAL2026 yet.** No Cura / PrusaSlicer / OrcaSlicer configs were found in `~/.config/` (checked 2026-08-11).

## Plan

When a slicer is chosen, record here:

- Slicer + version
- Printer profile (Ender-3 V3 SE — 220×220×250 mm, direct drive)
- Material profiles (PLA/PETG/… — temps, speeds, retraction)
- Start/end G-code (must match the Klipper setup — no `M84` fights, correct homing sequence)

## Candidates

- OrcaSlicer (actively maintained, good Klipper support)
- PrusaSlicer (solid defaults)
- Creality Print / Cura (Creality-native, meh)

Don't invent profile values — measure/verify on the machine, then document.
