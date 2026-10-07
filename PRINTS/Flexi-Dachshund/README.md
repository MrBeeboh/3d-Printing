# Flexi-Dachshund — Super Flexi Dachshund (print-in-place articulated)

**Status: SLICED + STAGED on the printer as `flexi_dachshund.gcode`. NOT STARTED.**
Blocked on: printer board powered off (no CH340 USB device on the Klipper host → Klipper `shutdown`).

## Source / attribution

| Field | Value |
|---|---|
| Model | **Super Flexi Dachshund** by **Martin Rigatoni** |
| Page | https://www.printables.com/model/506817-super-flexi-dachshund |
| Published | 2023-06-23 (from the model's own PDF, `model-docs.pdf`) |
| License | **CC BY-NC-SA 4.0** — attribution required, non-commercial, share-alike |
| Remix of | "CGAL-Cleaned (Dachshund)" by gringer |
| Downloads / likes | 9,462 / 1,920 (Printables, captured 2026-09-11) |

Fetched 2026-09-11. Printables' web UI and CDN paths are Cloudflare-gated and the file path
contains a per-file UUID, but the CDN itself serves files anonymously. Path recovered from the
Wayback CDX index (`files.printables.com/media/prints/<id>/*`), then pulled live:

```
https://files.printables.com/media/prints/506817/stls/4111911_a1474fd4-678a-4a9b-aeed-95b92026b882/flexi-dachshund.stl
```

Verified: 4,736,184 bytes; binary STL; 94,722 triangles; `84 + 94722*50 == 4736184` exact.

## Geometry (measured, not estimated)

- 8 separate shells = the print-in-place segments (1 body/head 74,520 tris + legs, tail, ears).
- Author bounding box: **71.4 (X) × 148.4 (Y) × 55.5 (Z) mm**.
- **Bed axis is Z as authored** — 1,403 mm² of downward-facing area lies exactly on the
  bottom plane; all 8 shells have z_min identical (0.00 mm gap). No floating segments.
- No rotation applied. Slicer auto-orient/arrange preserved the authored pose:
  first-layer model footprint **70.9 × 110.2 mm** matches the authored 71.4 × 111.6 mm.

## Print settings used

| Setting | Value |
|---|---|
| Slicer | OrcaSlicer 2.4.2 (AppImage), headless via `PRINTS/slice_print.py` |
| Process | 0.20 mm Standard @Creality Ender3V3SE 0.4, 3 walls, 20% gyroid |
| Filament | Creality Generic PLA (black or white — single extruder) |
| Supports | **YES — required by the author** ("support under the snout and ears") |
| Support style | `support_type: normal(auto)`, `support_style: organic`, buildplate-only, 3 interface layers, 0.3 mm gap, loop pattern |
| Support markers in gcode | `;TYPE:Support` ×342, `;TYPE:Support interface` ×240 (breakaway verified) |
| Spliced header | `PRINT_START BED=55 EXTRUDER=200` + `M220/M221/M106/G90/G21/M83` |
| Slicer estimate | **3h 55m 32s** |
| Gcode | 692,612 lines / 15.9 MB (spliced); staged as `flexi_dachshund.gcode` |
| Bed fit | model Y max 185.2, support Y max 188.5 — inside 220 × 220 |

## Files here

| File | What |
|---|---|
| `Flexi_Dachshund.stl` | the model (current live version, 4.7 MB) |
| `model-docs.pdf` | author's Printables page export (summary, licence, settings) |
| `flexi_dachshund.gcode` | **spliced, print-ready** gcode (this is what was uploaded) |
| `preview-model.png` | shaded TOP / ISO / SIDE render of the STL |
| `preview-layout.png` | gcode-derived bed map: part dark, supports red, full print + first layer |

## Support-key bug found while doing this (fixed)

`PRINTS/slice_print.py --supports` carried **PrusaSlicer** key names in the Orca process preset:
`support_type: "normal"` (invalid — Orca wants `normal(auto)`), `support_angle`,
`support_buildplate_only`. Orca does **not error** on a bad enum — it silently generated
**zero supports**, and the first slice still came out clean-looking with only a
"floating regions … or enable support generation" note in `result.json`.

Fixed in `PRINTS/slice_print.py` + documented in `docs/PRINT-OPERATIONS.md` §5.
**Rule: count `;TYPE:Support` and `;TYPE:Support interface` lines before claiming supports are on.**
