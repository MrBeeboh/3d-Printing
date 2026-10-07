# RTK Box — session save (2026-08-16 night, updated post-coupon-attempt)

## Status: PAUSED — fit-check deferred (operator: teardown too big for a coupon)

The RTK tray fit-check coupon attempt ended with EDGE LIFTING (155mm flat disk
warp — cable-slot stress riser + no brim). Operator decided the fit check
itself costs a full workstation teardown, so the whole effort is parked until
that teardown is worth doing. Resume when convenient — everything below is
saved and current.

## What exists (current files — v2 is authoritative)

- **Thingiverse shell** (RTK Box by AlexDo123, thing:7321589, CC BY-SA): `stl/`
  - RTK_base.stl (full body Ø187x123)
  - de_duoi.stl (bowl, Ø187x86.4) — prints as-exported + NEEDS SUPPORTS (interior floor ring, 41mm radial bridge)
  - Untitled.stl (stock cap) — NOT used; replaced by custom cap
  - tang1.stl (stock tray) — NOT used; replaced by custom tray
- **Custom parts** (OpenSCAD in this folder):
  - `rtk_tray_v2.scad` — Ø155 tray, **5 pockets with MOUNTING HOLES**:
    UM980 (26×38, 4× M2 @3mm inset) · OLED 0.96" (4× M2 @2mm inset) ·
    2× LR900-F/P (43.4×25.8, zip-strap slots — vendor doesn't publish holes) ·
    LicheeRV Nano (22.86×35.56, 4× M2 @2mm inset — VERIFY vs physical board).
    Cable bundle slot 34×14 bottom edge. `coupon_mode=true` at file bottom
    emits the flat fit-check disk (Z-flipped so pockets face UP); flip to
    `false` + re-export for the full leged tray, then Z-flip per old pipeline.
  - `rtk_tray_coupon_v2.stl` — current fit-check export (Ø155×3.0, pockets up).
  - `slices/rtk_tray_coupon_v2.gcode` — 0.28mm fast slice, **FAILED print
    (edge lift)**. DO NOT reprint as-is: re-slice with **6mm brim + mouse ears
    at the cable slot + bed 60°C**.
  - `rtk_cap_v1.scad` (v3 build) → `stl/rtk_cap_v3.stl` — top cap, plate-on-bed
    orientation. Q39 pedestal + SMA pass-through, TWO LR900 whip exits opposite
    sides, NO OLED window. `slices/rtk_cap_v3.gcode` = 3h55m draft.
  - Bowl slice WITH tree supports: `slices/rtk_bowl_support.gcode` = 13h50m.

## Hardware dims (verified 2026-08-16 — from internet, not guesses)

- UM980 carrier **26×38×7.6** (locked BOM; 4× M2 @3mm inset per manifest)
- LicheeRV Nano **22.86×35.56** (Sipeed official; hole positions NOT published — verify physical)
- **2× LR900-F/P: 43.4×25.8×11** (MicoAir official — replaces the manifest's
  unverified 55×28×10; the F/P family shares one body)
- OLED 0.96" SSD1306 **~27×27** (standard 4× M2 @corners; verify ELEGOO unit)
- Q39 Ø44.3×40.8 (helix, no ground plane needed) | Anker A1263 92×60×22

## To resume

1. Bed clear + operator approval per part (NO auto-chain — hard rule)
2. If fit-check first: re-slice coupon with brim/mouse-ears/60°C, preview, print
3. Print order after fit passes: tray (1h51) → cap (3h55) → bowl+supports (13h50 overnight)
4. After bowl prints: verify tray legs land on bowl floor ring (R 52.6-86.5 at Z 0-5)

## Hard lessons logged in skill (klipper-host-operations/orcaslicer-headless-cli.md)

- Parse result.json `warning_message` after EVERY slice
- Largest flat face on bed + geometric overhang scan
- CLI ignores support JSON patches unless support_type is `tree(auto)`
- Flip STLs must fix triangle winding
- **Large flat disks lift at edges — brim/mouse-ears are mandatory defense, not optional** (2026-08-16)
