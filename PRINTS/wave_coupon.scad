// Wave Overhang test coupon — 30 mm horizontal 90° shelf, support-free target
// Base column supports the shelf root; the shelf extends 30 mm into open air.
// Every shelf layer past the base is an overhang -> wave pattern should fill it.
// Print flat on the bed, shelf pointing +X. Verify gcode has WAVE_OVERHANG_START.
$fn = 64;

base_l = 40;   // X depth of the supported column
base_w = 40;   // Y width
base_h = 12;   // Z height of column
shelf_l = 30;  // X overhang distance past the base
shelf_w = 40;  // Y width of shelf (same as base)
shelf_t = 8;   // Z thickness of the horizontal shelf (the wave block)

module coupon() {
    // supported column
    translate([0, 0, 0])
        cube([base_l, base_w, base_h]);
    // horizontal shelf, cantilevered +X, resting on the column top
    translate([base_l, 0, base_h])
        cube([shelf_l, shelf_w, shelf_t]);
}
coupon();
