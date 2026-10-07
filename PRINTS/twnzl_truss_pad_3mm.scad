// Twnzl Y-mount, real boot, 3 mm body.
// Boot + truss outline = TRUE projection of the original vendor mesh (Y>=41.5),
// so the irregular foot contour that mates the printer is preserved.
// Pad 38x70 for Zero 3W (65x30) + tape camera. M3 40 mm. M2.5 pilots.

arm_stl = "stl/twnzl_truss_arm_only.stl";

$fn = 32;
thick = 3.0;
m3 = 3.4;
z3w_pilot = 2.1;

module silhouette() {
    translate([-8, 46, 0]) {
        // vendor (X,Y,Z) -> (Y,Z,X): YZ lands on XY
        projection(cut = false)
            multmatrix([[0, 1, 0, 0],
                        [0, 0, 1, 0],
                        [1, 0, 0, 0],
                        [0, 0, 0, 1]])
                import(arm_stl, convexity = 8);
        translate([8, -46, 0])
            square([38, 70]); // pad
    }
}

difference() {
    linear_extrude(thick)
        silhouette();
    // M3 clearance, 40 mm apart, through the boot
    translate([94.4 - 8, 14.61 + 46, -1])
        cylinder(d = m3, h = thick + 2);
    translate([94.4 - 8, 54.53 + 46, -1])
        cylinder(d = m3, h = thick + 2);
    // Zero 3W M2.5 pilots, pad 38 x 70 centered
    for (xy = [[7.60, 6.05], [30.45, 6.05], [7.60, 63.90], [30.45, 63.90]])
        translate([xy[0], xy[1], -1])
            cylinder(d = z3w_pilot, h = thick + 2);
}
