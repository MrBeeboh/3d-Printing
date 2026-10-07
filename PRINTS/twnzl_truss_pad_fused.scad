// Twnzl truss pad — FUSED single body (Option A), uniform 3 mm, flat print.
// One watertight manifold: true projected vendor-arm silhouette unioned with
// the pad square AND a modest solid connector bridging them -> Volumes:1.
// Eccentric boot outline is an in-plane contour visible from top/bottom.
// M3 clearance 40 mm o/c through boot; four Zero-3W M2.5 pilots in the pad.

arm_stl = "stl/twnzl_truss_arm_only.stl";

$fn    = 32;
thick   = 3.0;      // uniform body thickness (Z) — Option A per operator choice
m3       = 3.4;     // M3 clearance diameter
z3w_pilot= 2.1;     // M2.5 self-tap pilot

// Shared XY frame: vendor arm projected onto build plane, pad square beside it.
module silhouette() {
    translate([-8, 46, 0]) {
        projection(cut = false)
            multmatrix([[0, 1, 0, 0],
                        [0, 0, 1, 0],
                        [1, 0, 0, 0],
                        [0, 0, 0, 1]])
                import(arm_stl, convexity = 8);
        translate([8, -46, 0])
            square([38, 70]);   // pad region (Zero-3W + taped camera)
    }
}

// Projected arm alone and pad alone as separate solids so we can bridge them.
module arm_solid() {
    linear_extrude(thick)
        translate([-8, 46, 0])
            projection(cut = false)
                multmatrix([[0, 1, 0, 0],
                            [0, 0, 1, 0],
                            [1, 0, 0, 0],
                            [0, 0, 0, 1]])
                    import(arm_stl, convexity = 8);
}

module pad_solid() {
    linear_extrude(thick)
        translate([-8 + 8, 46 - 46, 0])   // == [0, 0, 0] in shared frame
            square([38, 70]);
}

// --- One watertight body --------------------------------------------------
difference() {
    union() {
        arm_solid();
        pad_solid();
        // Modest connector: hull between the two overlaps them into one mass.
        hull() {
            translate([12, 30, 0]) square([6, 4]);   // point inside arm region
            translate([8,  -5, 0]) square([6, 4]);   // point inside pad region
        }
    }

    // M3 clearance holes through the boot, 40 mm apart (shared frame coords)
    translate([94.4 - 8, 14.61 + 46, -1]) cylinder(d = m3, h = thick + 2);
    translate([94.4 - 8, 54.53 + 46, -1]) cylinder(d = m3, h = thick + 2);

    // Zero-3W M2.5 pilots through the pad (pad is 38 x 70 centered in frame)
    for (xy = [[7.60, 6.05], [30.45, 6.05], [7.60, 63.90], [30.45, 63.90]])
        translate([xy[0] - 8 + 8, xy[1], -1]) cylinder(d = z3w_pilot, h = thick + 2);
}
