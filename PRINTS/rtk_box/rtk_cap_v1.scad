// F450 Sentinel — RTK Box top cap (replaces Thingiverse Untitled) v3
// PRINT ORIENTATION-FIXED (2026-08-16): plate on the BED, pedestal + walls
// growing UP. v2 was a cup standing on its rim — the top plate had to
// bridge the 175mm bore = guaranteed fail. This model prints with zero
// bridges and zero supports:
//   - Z 0..top_t      : top plate (full disk, on the bed)
//   - Z top_t..+ped_h : Q39 pedestal (center boss)
//   - Z top_t..cap_h  : wall ring (bore opens at the top of the print)
// Assembly: flip the printed cap over, bore faces down over the bowl rim.
// Features:
//   - Q39 helix antenna pedestal (center): Ø46 boss, SMA-F bulkhead hole Ø6.5
//   - TWO LR900 whip exits: SMA bulkhead holes on opposite sides (180 deg apart)
// No OLED window (operator: skip it — 2026-08-16).
// Material: PETG. 0.2mm, 3 perimeters.

cap_od   = 186.8;   // outer diameter (R 93.4, matches bowl outer)
bore_r   = 87.5;    // inner bore radius -> slides over bowl rim (87.4)
cap_h    = 32;      // wall height (grips bowl rim; 10mm overlap in assembly)
top_t    = 3.0;     // top plate thickness (this is the bed face)

q39_ped_r = 23.0;   // pedestal radius (Q39 base Ø44.3 + clearance)
q39_ped_h = 10.0;   // pedestal height above plate
sma_d     = 6.6;    // SMA bulkhead hole diameter (F type body ~6.35 + clearance)

$fn = 100;

module cap_body() {
    difference() {
        union() {
            // top plate — full disk on the bed
            linear_extrude(top_t)
                circle(d = cap_od);
            // wall ring above the plate edge
            translate([0, 0, top_t])
                difference() {
                    cylinder(h = cap_h - top_t, r = cap_od/2);
                    translate([0, 0, -0.1])
                        cylinder(h = cap_h - top_t + 0.2, r = bore_r);
                }
            // Q39 pedestal on top of the plate, center
            translate([0, 0, top_t])
                cylinder(h = q39_ped_h, r = q39_ped_r);
        }
        // SMA pass-through through pedestal + plate
        translate([0, 0, -0.1])
            cylinder(h = q39_ped_h + top_t + 0.2, d = sma_d);
        // LR900 whip SMA exits: two, on opposite sides, through the wall.
        // Bore axis = radial (along X at angle 0/180), through the wall
        // ring (R 87.5..93.4) at mid-height.
        for (sx = [1, -1])
            translate([sx * 90, 0, top_t + 10])
                rotate([0, 90, 0])
                    cylinder(h = 40, d = sma_d, center = true);
    }
}

cap_body();
