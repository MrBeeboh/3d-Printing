# Monitor + Rock 5C Holder — NEXT_STEPS

Parametric 3D-printed holder integrating the **HMTECH 7" 800x480 screen** with a
**Radxa Rock 5C** (86×56mm) mounted on the back.

## Status: DESIGN READY, NOT PRINTED

Parts are manifold-verified (1 shell, 0 degenerate, 0 edges fixed). **Nothing
has been printed.** Per project rules, printing requires operator approval and
each part gets its own go-ahead.

## The one open unknown: the screen's real mounting holes

The Rock 5C footprint (86×56mm) is **verified**. The HMTECH screen outer dims
(~165×104mm) are from the listing, but the **corner hole positions
(`sc_hole_inset`, default 6mm) are a GENERIC placeholder** — these boards vary
by revision. **Measure the physical screen before the bezel/backplate are
trusted.** All dimensions are variables at the top of
`monitor-rock5c-holder.scad`.

## Files

| File | What it is |
|---|---|
| `monitor-rock5c-holder.scad` | Parametric source. `PART = coupon/backplate/bezel/preview` |
| `stl/coupon.stl` | Fit coupon — verify screen + Rock 5C drop in before anything else |
| `stl/backplate.stl` | Back shell: screen cavity + Rock 5C pocket + cable pass-throughs |
| `stl/bezel.stl` | Front frame: active-area window + screen screw holes |
| `preview-two-tone.scad` / `preview/*.png` | Black backplate + white bezel render |

## Hardware

- **Screen:** HMTECH 7" 800×480 HDMI (non-touch) — must be measured
- **SBC:** Radxa Rock 5C — 4× M2 through-board into standoffs
- **Backplate standoffs:** M2.5 thread-forming into 2.1mm pilots (Hive convention),
  6–8mm pan/button head
- **Bezel:** screen screws through the board's 4 corner holes into the frame

## Print order (each approved separately)

1. **`coupon.stl`** (~15 min) — drop the real screen and Rock 5C into the two
   pockets. If screen corner holes don't match, measure and update
   `sc_hole_inset` / `sc_w` / `sc_h`, re-render, re-print coupon.
2. **`backplate.stl`** — black PLA
3. **`bezel.stl`** — white PLA (two-tone: black base / white lid per shelf stock)

## Slice defaults (Ender-3 V3 SE, 0.4mm nozzle)

Layer 0.20 · Walls 3 · Infill 20% gyroid · Supports via slicer auto if needed
(overhangs on the cable pass-throughs / pocket). Do not print until the slicer
layer view looks right.

## Verify before print

```bash
cd PRINTS/monitor-rock5c-holder
for p in coupon backplate bezel; do
  admesh stl/$p.stl 2>&1 | grep -iE "Number of parts|Degenerate|Edges fixed"
done   # expect: 1 part, 0, 0
```
