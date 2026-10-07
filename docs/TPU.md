# TPU on the Ender-3 V3 SE

Shop default when the filament is TPU (Overture ~95A). PLA jobs stay on the PLA presets.

**Orca GUI:** process `0.20mm TPU @Ender-3 V3 SE` + filament `Overture TPU @Ender-3 V3 SE`.  
Do **not** pair TPU filament with `0.20mm Standard` / `V3SE Speed` — that is what stringed the backpack (60/90/180 mm/s, 0.4 mm spiral Z-hop, 100% fan).

**CLI:**

```
--load-settings "configs/process_0.20mm_tpu_v3se.json;~/.config/OrcaSlicer/user/default/machine/Ender-3 V3 SE (Klipper).json"
--load-filaments "configs/filament_overture_tpu_v3se.json"
```

`PRINTS/slice_print.py --tpu` selects these and splices TPU temps.

## Numbers

| | TPU | PLA (shop) |
|---|---|---|
| Nozzle | 220 first / 215 rest (`PRINT_START … EXTRUDER=220`) | 200 / 195 |
| Bed | 40 | 55 |
| Walls / infill | 30 / 30 mm/s | 60 / 180 |
| Travel | 120 | 150 |
| Retract | 0.5 mm @ 25 mm/s | printer default |
| Z-hop | **off** | 0.4 spiral on stock Creality machine |
| Wipe | **off** | on |
| Fan | 0 on L1–2, then 35–40% | 100% |
| Volumetric cap | 3.2 mm³/s (~38 mm/s @ 0.42×0.2) | 18 |
| PA | 0.02 in filament start; restored to 0.033 at end | 0.033 in printer.cfg |

Direct drive on this SE. Dry the spool 60–65 °C / 4–6 h if it sat open. Wet TPU strings even with this profile.

Spliced header (fan **off** on layer 1 — do not copy the PLA `M106 S255`):

```
PRINT_START BED=40 EXTRUDER=220
M220 S100
M221 S100
M106 S0
G90
G21
M83
```
