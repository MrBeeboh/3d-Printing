// First-layer Z-offset verification coupon
// A big flat 60x40x0.3 plate. Prints one layer. Exists ONLY to confirm the
// nozzle squishes and lays down a continuous first layer at the baked z_offset.
// 0.3mm tall so a 0.2 or 0.28 first-layer slice drops a proper single skin.
module z_coupon() {
    linear_extrude(height = 0.3)
        square([60, 40]);
}
z_coupon();
