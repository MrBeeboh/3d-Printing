// Preview only — original Twnzl 3D shoe+truss (vendor mesh, not flattened).
// Pad is 3 mm. Four Zero 3W M2.5 pilots through the pad.
// Use F5 (preview). F6 drops the vendor mesh — it is not CGAL-closed.

vendor_arm = "stl/twnzl_truss_arm_only.stl";

$fn = 36;

pad_x0 = 2.13;
pad_t  = 3.0;
pad_y0 = 8.0;   pad_y1 = 46.0;
pad_z0 = -46.0; pad_z1 = 24.0;
z3w_pilot = 2.1;

// Official DXF holes, board 65 along Z / 30 along Y, centered on pad.
z3w_yz = [
    [15.60, -39.95],
    [38.45, -39.90],
    [15.60,  17.90],
    [38.50,  17.90]
];

module arm() {
    color([0.10, 0.10, 0.11])
        import(vendor_arm, convexity = 12);
}

module pad() {
    color([0.12, 0.12, 0.13])
        difference() {
            translate([pad_x0, pad_y0, pad_z0])
                cube([pad_t, pad_y1 - pad_y0, pad_z1 - pad_z0]);
            for (yz = z3w_yz)
                translate([pad_x0 - 1, yz[0], yz[1]])
                    rotate([0, 90, 0])
                        cylinder(d = z3w_pilot, h = pad_t + 2);
        }
}

module dummy_z3w() {
    // 65 x 30 x 1.6 ghost on the pad face
    color([0.15, 0.45, 0.18, 0.45])
        translate([pad_x0 + pad_t, 12.0, -43.5])
            cube([1.6, 30, 65]);
}

arm();
pad();
dummy_z3w();
