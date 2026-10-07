// Sentinel V2 — Zero 3W + Arducam 36x36 mount for Ender-3 V3 SE
// FIRST PRINCIPLES REWORK (2026-08-17):
//   - bolts to the two VERTICALLY stacked cap screws (40mm o/c, left end cap)
//   - standoff bosses create a clean vertical mount plane off the irregular cap
//   - Zero 3W mounts flat on the plate, ports UP (USB-C/HDMI/CSI exit top edge)
//   - 2-axis arm: swing (crane) at plate top + camera tilt at arm end,
//     radial-serration clamps (M3 + nut). All serration faces VERTICAL ->
//     prints with NO supports and NO fused scaffolding.
//
// ASSEMBLY (how the three parts connect):
//   BASE hub  (top of plate, axis X, disc faces +/-Y): serrations on +Y face
//   ARM  boss (swing end, axis X): serrations on -Y face, mates base hub +Y
//        bolt #1: M3x20 through arm boss -> base hub, nut in base hub pocket
//        arm extends +Y to the tilt hub (axis X): serrations on +Y face
//   CAM  boss (tilt end, axis X): serrations on -Y face, mates arm hub +Y
//        bolt #2: M3x20 through cam boss -> arm hub, nut in cam boss pocket
//   CAM plate hangs below, faces +Y (toward bed), lens bore + 4 posts (28.8 grid)
//
// Coordinates: +Y = toward bed. Plate lies in X-Z plane at Y=0.
// part = "base" | "arm" | "cam" | "preview"

part = "preview"; // [base, arm, cam, preview]

/* [Cap interface — MEASURED 2026-08-16/17] */
screw_spacing = 40.0;   // cap screws, VERTICAL, one above the other
standoff     = 9.0;     // plate back -> cap face (clears irregular cap)
screw_pilot  = 3.4;     // M3 clearance

/* [Hardware] */
m3_clear  = 3.4;
m3_nut_d  = 7.4;        // M3 nut across-corners + clearance
cam_pilot = 1.7;        // M2 self-tap (camera posts)
z3w_pilot = 2.1;        // M2.5 self-tap (Zero 3W bosses)

/* [Zero 3W — Radxa v1.11 DXF] */
z3w_x = 65.0; z3w_y = 30.0;
z3w_holes = [[3.55,3.60],[3.60,26.45],[61.40,3.60],[61.40,26.50]];

/* [Camera — measured] */
cam_grid = 28.8; lens_d = 17.0;

/* [Structure] */
plate_t = 5.0;          // plate thickness (Y)
plate_w = 84.0;         // plate width (X)
plate_h = 140.0;        // plate height (Z)
boss_h  = 4.0;          // Zero 3W boss height
hub_d   = 26.0;         // serration hub diameter
hub_t   = 7.0;          // hub thickness (along X)
serr_d  = 22.0; serr_n = 24; serr_amp = 0.7; serr_h = 1.2;

z0     = 44.0;          // board bottom edge height (above lower screw)
hub_z  = 128.0;         // hub center height
arm_len = 62.0;         // swing arm length (Y, hub center to hub center)
cam_zc = hub_z - 22;    // camera board center height

// X-axis cylinder: axis along X (used for all hubs/bores)
module xcyl(d, h) { rotate([0,90,0]) cylinder(d=d, h=h); }

module serration_ring(d, n, amp, h) {
    pts = [for (i = [0 : 2*n - 1])
        let(a = 360*i/(2*n), r = (i % 2 == 0) ? d/2 : d/2 - amp)
        [r*cos(a), r*sin(a)]];
    linear_extrude(h) polygon(pts);
}

// ===============================================================
// BASE: standoffs + plate + Zero 3W cradle + swing hub (axis X)
// ===============================================================
module base() {
    difference() {
        union() {
            translate([-plate_w/2, 0, 0]) cube([plate_w, plate_t, plate_h]);
            // standoff bosses on -Y face (toward cap), at z=0 and z=40
            for (sz = [0, screw_spacing])
                translate([0, -standoff, sz]) rotate([-90,0,0])
                    cylinder(d = 11, h = standoff);
            // swing hub at plate top: axis X, centered (0,0,hub_z)
            translate([0, 0, hub_z]) xcyl(d=hub_d, h=hub_t);
            // Zero 3W bosses on +Y face, ports UP
            for (hxy = z3w_holes)
                translate([hxy[0]-z3w_x/2, plate_t, z0 + (z3w_y - hxy[1])])
                    rotate([-90,0,0]) cylinder(d=5, h=boss_h);
        }
        // standoff screw holes (M3 through standoff+plate)
        for (sz = [0, screw_spacing])
            translate([0, -standoff - 1, sz])
                rotate([-90,0,0]) cylinder(d = screw_pilot, h = standoff + plate_t + 2);
        // screw head pockets on +Y face (M3 socket head ~5.5x3)
        for (sz = [0, screw_spacing])
            translate([0, plate_t - 3.5, sz])
                rotate([-90,0,0]) cylinder(d = 6.0, h = 3.6);
        // Zero 3W boss pilots
        for (hxy = z3w_holes)
            translate([hxy[0]-z3w_x/2, plate_t - 1, z0 + (z3w_y - hxy[1])])
                rotate([-90,0,0]) cylinder(d = z3w_pilot, h = boss_h + 2);
        // hub bore along X (M3) + nut pocket on the -X end
        translate([-1, 0, hub_z]) xcyl(d = m3_clear, h = hub_t + 2);
        translate([-4.5, 0, hub_z]) xcyl(d = m3_nut_d, h = 4.5, $fn=6);
        // lightening windows
        for (zz = [52, 78, 104])
            translate([0, -1, zz]) rotate([-90,0,0])
                cylinder(d = 22, h = plate_t + 2, $fn = 6);
    }
    // serration ring on hub +Y face (vertical face -> prints clean)
    translate([0, hub_t - 0.01, hub_z]) rotate([90,0,0])
        serration_ring(serr_d, serr_n, serr_amp, serr_h + 0.5);
}

// ===============================================================
// ARM: swing boss (serrations -Y, mates base +Y) + bar + tilt hub (serr +Y)
// ===============================================================
module arm() {
    difference() {
        union() {
            // swing boss: axis X, centered (0,0,hub_z)
            translate([0, 0, hub_z]) xcyl(d = hub_d, h = hub_t + serr_h);
            // bar from swing boss to tilt hub (along +Y)
            translate([-5, hub_t, hub_z - 3.5]) cube([10, arm_len - hub_t - hub_t, 7]);
            // tilt hub at arm end: axis X
            translate([0, arm_len - hub_t, hub_z]) xcyl(d = hub_d, h = hub_t);
        }
        // swing bore along X + nut pocket on -X end
        translate([-1, 0, hub_z]) xcyl(d = m3_clear, h = hub_t + serr_h + 2);
        translate([-4.5, 0, hub_z]) xcyl(d = m3_nut_d, h = 4.5, $fn=6);
        // tilt bore along X
        translate([arm_len - hub_t - 1, 0, hub_z]) xcyl(d = m3_clear, h = hub_t + 2);
    }
    // swing serrations on -Y face (mates base hub +Y)
    translate([0, -serr_h + 0.01, hub_z]) rotate([-90,0,0])
        serration_ring(serr_d, serr_n, serr_amp, serr_h);
    // tilt serrations on +Y face (mates cam boss -Y)
    translate([0, arm_len - hub_t - 0.01, hub_z]) rotate([90,0,0])
        serration_ring(serr_d, serr_n, serr_amp, serr_h + 0.5);
}

// ===============================================================
// CAM: tilt boss (serrations -Y) + web + camera plate facing +Y
// ===============================================================
module cam() {
    plate_y = hub_t + serr_h + 2;         // camera plate -Y face
    difference() {
        union() {
            // tilt boss: axis X
            translate([0, 0, hub_z]) xcyl(d = hub_d, h = hub_t + serr_h);
            // web down to camera plate
            translate([-4, hub_t, cam_zc - 8]) cube([8, plate_y - hub_t + plate_t, 20]);
            // camera plate (vertical, X-Z plane) facing +Y
            translate([-24, plate_y, cam_zc - 24]) cube([48, plate_t, 48]);
            // camera posts on -Y face
            for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
                translate([sx, plate_y - 3.5, cam_zc + sz])
                    rotate([-90,0,0]) cylinder(d = 4.5, h = 4.5);
        }
        // tilt bore along X + nut pocket on -X end
        translate([-1, 0, hub_z]) xcyl(d = m3_clear, h = hub_t + serr_h + 2);
        translate([-4.5, 0, hub_z]) xcyl(d = m3_nut_d, h = 4.5, $fn=6);
        // lens hole
        translate([0, plate_y - 5, cam_zc]) rotate([-90,0,0])
            cylinder(d = lens_d, h = plate_t + 10);
        // camera post pilots
        for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
            translate([sx, plate_y - 4.5, cam_zc + sz])
                rotate([-90,0,0]) cylinder(d = cam_pilot, h = 5.5);
        // ribbon slot through plate bottom
        translate([-9, plate_y - 1, cam_zc - 26]) cube([18, plate_t + 2, 8]);
    }
    // tilt serrations on -Y face (mates arm tilt hub +Y)
    translate([0, -serr_h + 0.01, hub_z]) rotate([-90,0,0])
        serration_ring(serr_d, serr_n, serr_amp, serr_h);
}

// ===============================================================
if (part == "base")  base();
if (part == "arm")   arm();
if (part == "cam")   cam();
if (part == "preview") {
    color([0.1, 0.1, 0.11]) base();
    color([0.95, 0.95, 0.93]) arm();
    color([0.7, 0.7, 0.7])
        translate([0, arm_len - hub_t, 0]) cam();
}
