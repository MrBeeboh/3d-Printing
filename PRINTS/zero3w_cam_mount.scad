// Sentinel — Zero 3W + Arducam 36x36 mount for Ender-3 V3 SE
// Mounts to Y-axis wheel cover (2 screws, reuses cover threads).
// Concept credit: bioxz "Ender-3 V3 SE Pi Zero & Camera Mount" (CC BY-SA).
// Geometry: Radxa v1.11 DXF (board) + measured camera (36x36, 28.8 grid).
//
// Coordinates: +Y = toward printer bed. Shoe sits on wheel cover at origin.
// part = "frame" | "arm" | "preview"

part = "preview"; // [frame, arm, preview]

/* [Wheel cover interface — MEASURED ON PRINTER] */
screw_spacing = 40.0;   // MEASURED 2026-08-16   // center-to-center of the 2 cover screws (X)
cover_w       = 44.0;   // cover top width  (X, left-right)
cover_d       = 24.0;   // cover top depth  (Y, front-back)

/* [Hardware] */
m3_clear   = 3.4;    // M3 clearance
m3_nut_d   = 7.4;    // M3 nut across-corners + clearance (hex pocket)
cam_pilot  = 1.7;    // M2 self-tap pilot (camera posts)
z3w_pilot  = 2.1;    // M2.5 self-tap pilot (Hive-proven)

/* [Zero 3W — Radxa v1.11 DXF] */
z3w_x = 65.0; z3w_y = 30.0;
z3w_holes = [[3.55,3.60],[3.60,26.45],[61.40,3.60],[61.40,26.50]];

/* [Camera — measured] */
cam_grid = 28.8; lens_d = 17.0;   // 36x36 board, 28.8 hole grid

/* [Structure] */
shoe_t  = 4.0;
spine_w = 30.0;
spine_d = 10.0;
spine_h = 112.0;   // shoe bottom -> hub center
hub_d   = 24.0;
hub_t   = 7.0;
serr_d  = 20.0; serr_n = 24; serr_amp = 0.7; serr_h = 1.2;
plate_t = 4.0;

spine_y0 = cover_d/2 + 4 - spine_d;           // spine front (-Y) face
hub_y1   = spine_y0 + spine_d + hub_t;        // hub +Y face (serration side)
board_z0 = 62.0;                              // board bottom edge on cradle

// ---------------------------------------------------------------
module serration_ring(d, n, amp, h) {
    pts = [for (i = [0 : 2*n - 1])
        let(a = 360*i/(2*n), r = (i % 2 == 0) ? d/2 : d/2 - amp)
        [r*cos(a), r*sin(a)]];
    linear_extrude(h) polygon(pts);
}

// ---------------------------------------------------------------
module frame() {
    difference() {
        union() {
            translate([-cover_w/2 - 4, -cover_d/2 - 4, 0])
                cube([cover_w + 8, cover_d + 8, shoe_t]);       // shoe
            translate([-spine_w/2, spine_y0, 0])
                cube([spine_w, spine_d, spine_h + hub_d/2]);    // spine
            translate([0, spine_y0 + spine_d - 1, spine_h])
                rotate([-90, 0, 0])
                    cylinder(d = hub_d, h = hub_t + 1);         // hub (+Y)
            translate([-z3w_x/2 - 3, spine_y0 - plate_t, board_z0 - 4])
                cube([z3w_x + 6, plate_t + 2, z3w_y + 8]);      // cradle plate (2mm into spine)
            for (hxy = z3w_holes)                               // bosses
                translate([hxy[0] - z3w_x/2, spine_y0 - plate_t + 1,
                           board_z0 + hxy[1]])
                    rotate([90, 0, 0]) cylinder(d = 5, h = 4.5);
        }
        for (sx = [-screw_spacing/2, screw_spacing/2])          // shoe slots
            translate([sx, 0, -1]) hull() {
                translate([0, -1.5, 0]) cylinder(d = m3_clear, h = shoe_t + 2);
                translate([0,  1.5, 0]) cylinder(d = m3_clear, h = shoe_t + 2);
            }
        for (hxy = z3w_holes)                                   // boss pilots
            translate([hxy[0] - z3w_x/2, spine_y0 - plate_t + 2,
                       board_z0 + hxy[1]])
                rotate([90, 0, 0]) cylinder(d = z3w_pilot, h = 6);
        translate([0, spine_y0 + spine_d - 2, spine_h])         // hub bore
            rotate([-90, 0, 0]) cylinder(d = m3_clear, h = hub_t + 4);
        translate([-3.2, hub_y1 - 4.5, spine_h])                // top-entry nut slot
            cube([6.4, 4.5, hub_d/2 + 1]);
        for (z = [22 : 20 : 42])                                // lightening
            translate([0, spine_y0 - 1, z])
                rotate([-90, 0, 0]) cylinder(d = 16, h = spine_d + 2, $fn = 6);
    }
    translate([0, hub_y1 - 0.5, spine_h])                       // serrations
        rotate([-90, 0, 0]) serration_ring(serr_d, serr_n, serr_amp, serr_h + 0.5);
}

// ---------------------------------------------------------------
// ARM — modeled ASSEMBLED (same axes as frame). Plate hangs below hub,
// faces +Y (bed). Tilt about the M3 axle, serration-locked.
// ---------------------------------------------------------------
boss_y  = hub_y1 + serr_h - 0.5;            // arm boss -Y start (ring sinks in)
plate_y = boss_y + hub_t + 2;               // camera plate -Y face
cam_zc  = spine_h - 21;                     // camera board center height

module arm_assembled() {
    difference() {
        union() {
            translate([0, boss_y, spine_h])                   // boss
                rotate([-90, 0, 0]) cylinder(d = hub_d, h = hub_t + 0.5);
            translate([-5, boss_y, spine_h - 26])             // web to plate
                cube([10, plate_y - boss_y + plate_t, 28]);
            translate([-24, plate_y, spine_h - 46])           // camera plate
                cube([48, plate_t, 48]);
            for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
                translate([sx, plate_y + 1, cam_zc + sz])     // posts (-Y face)
                    rotate([90, 0, 0]) cylinder(d = 4.5, h = 5.5);
        }
        translate([0, boss_y - 1, spine_h])                   // M3 through-bore
            rotate([-90, 0, 0]) cylinder(d = m3_clear, h = hub_t + plate_t + 12);
        translate([0, plate_y - 5, cam_zc])                   // lens hole
            rotate([-90, 0, 0]) cylinder(d = lens_d, h = plate_t + 10);
        for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
            translate([sx, plate_y + 2, cam_zc + sz])         // post pilots
                rotate([90, 0, 0]) cylinder(d = cam_pilot, h = 7);
        translate([-9, plate_y - 1, spine_h - 48])            // ribbon slot
            cube([18, plate_t + 2, 8]);
    }
    translate([0, boss_y - serr_h + 0.5, spine_h])            // serrations
        rotate([-90, 0, 0]) serration_ring(serr_d, serr_n, serr_amp, serr_h + 0.5);
}

// print orientation: rotX(-90) maps Y->-Z; plate +Y face becomes build-plate
// side, posts point up, serrations end up on TOP. Shift so min z = 0.
arm_lift = plate_y + plate_t;   // max y in assembled coords -> becomes -z

module arm() {
    translate([0, 0, arm_lift]) rotate([-90, 0, 0]) arm_assembled();
}

// ---------------------------------------------------------------
if (part == "frame") frame();
if (part == "arm")   arm();
if (part == "preview") {
    color([0.1, 0.1, 0.11]) frame();
    color([0.95, 0.95, 0.93]) arm_assembled();
}
