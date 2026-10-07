// Full-thickness Twnzl shoe+truss + pad. Same outline as the 3 mm sketch.
// 16 mm = original shoe depth (M3x16). Lattice is through-holes in the plate.
// Zero 3W pilots through the pad. Camera 3M-tapes the other face.

arm_stl = "stl/twnzl_truss_arm_only.stl";

$fn = 32;
thick = 16.0;
m3 = 3.4;
z3w_pilot = 2.1;

module silhouette() {
    translate([-8, 46, 0]) {
        projection(cut = false)
            multmatrix([[0, 1, 0, 0],
                        [0, 0, 1, 0],
                        [1, 0, 0, 0],
                        [0, 0, 0, 1]])
                import(arm_stl, convexity = 8);
        translate([8, -46, 0])
            square([38, 70]);
    }
}

difference() {
    linear_extrude(thick)
        silhouette();
    translate([94.4 - 8, 14.61 + 46, -1])
        cylinder(d = m3, h = thick + 2);
    translate([94.4 - 8, 54.53 + 46, -1])
        cylinder(d = m3, h = thick + 2);
    // Zero 3W M2.5 pilots, pad 38 x 70 centered
    for (xy = [[7.60, 6.05], [30.45, 6.05], [7.60, 63.90], [30.45, 63.90]])
        translate([xy[0], xy[1], -1])
            cylinder(d = z3w_pilot, h = thick + 2);
}
