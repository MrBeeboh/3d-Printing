// Sentinel V3B — TWO-PIECE, ZERO-SUPPORT bracket for Ender-3 V3 SE
// 2026-08-17. Split from V3 because the one-piece lean slab cantilevered
// 40mm past the plate top (Orca: "floating cantilever"). Two pieces:
//
//   PLATE  — vertical plate, standoff bosses (cap screws 40mm o/c vertical),
//            Zero 3W cradle on the face, 2 locating pins + 2 M3 pilots near
//            the top for the wedge. Prints FLAT (rotY? no — rotX: see below).
//   WEDGE  — foot (screws to plate top) + 35° lean slab carrying the camera
//            face (36x36 board, 28.8 grid, lens bore). Prints flat, lean is
//            35° from vertical (< 45°) => zero supports.
//
// INSTALL: +Y faces the bed. Plate bolts to cap via standoffs. Wedge foot
// laps the plate face, 2x M3 self-tap into pilots, 2 locating pins align.
// Camera board on the lean face, ports/ribbon run down to the Zero 3W.
//
// part = "plate" | "wedge" | "print_plate" | "print_wedge" | "preview"

part = "preview"; // [plate, wedge, print_plate, print_wedge, preview]

/* [Cap interface — MEASURED 2026-08-16/17] */
screw_spacing = 40.0;   // cap screws, VERTICAL, one above the other
standoff     = 9.0;     // plate back -> cap face
screw_pilot  = 3.4;     // M3 clearance

/* [Hardware] */
cam_pilot = 1.7;        // M2 self-tap (camera posts)
z3w_pilot = 2.1;        // M2.5 self-tap (Zero 3W bosses)
wedge_screw = 2.5;      // M3 self-tap pilot in plate (wedge foot)

/* [Zero 3W — Radxa v1.11 DXF] */
z3w_x = 65.0; z3w_y = 30.0;
z3w_holes = [[3.55,3.60],[3.60,26.45],[61.40,3.60],[61.40,26.50]];

/* [Camera — measured] */
cam_grid = 28.8; lens_d = 17.0;
cam_lean = 35.0;        // < 45 => prints without support

/* [Structure] */
plate_t = 5.0;          // plate thickness (Y)
plate_w = 90.0;         // plate width (X)
plate_h = 112.0;        // plate height (Z)
boss_h  = 4.5;          // Zero 3W boss height
z0      = 56.0;         // board bottom edge height

// wedge geometry
foot_w  = 48.0;         // foot width (X)
foot_h  = 36.0;         // foot height (Z, laps the plate face)
foot_t  = 5.0;          // foot thickness (Y)
slab_len = 52.0;        // lean slab length along its face
slab_t  = 4.0;          // slab thickness
cam_zc_local = 26.0;    // camera center along slab face
wedge_screw_z = 20.0;   // screw height up the foot (local)

// ===============================================================
module plate() {
    difference() {
        union() {
            translate([-plate_w/2, 0, 0]) cube([plate_w, plate_t, plate_h]);
            for (sz = [0, screw_spacing])
                translate([0, -standoff, sz]) rotate([-90,0,0])
                    cylinder(d = 11, h = standoff);
            for (hxy = z3w_holes)
                translate([hxy[0]-z3w_x/2, plate_t, z0 + (z3w_y - hxy[1])])
                    rotate([-90,0,0]) cylinder(d=5, h=boss_h);
            // locating pins for the wedge (2x, 4mm, at foot top corners)
            for (px = [-16, 16])
                translate([px, plate_t, plate_h - 8]) rotate([-90,0,0])
                    cylinder(d = 4, h = 4);
        }
        for (sz = [0, screw_spacing])
            translate([0, -standoff - 1, sz])
                rotate([-90,0,0]) cylinder(d = screw_pilot, h = standoff + plate_t + 2);
        for (hxy = z3w_holes)
            translate([hxy[0]-z3w_x/2, plate_t - 1, z0 + (z3w_y - hxy[1])])
                rotate([-90,0,0]) cylinder(d = z3w_pilot, h = boss_h + 2);
        // wedge M3 self-tap pilots (2x at x=+-20, z=plate_h-... local foot)
        for (px = [-20, 20])
            translate([px, plate_t - 1, plate_h - 22]) rotate([-90,0,0])
                cylinder(d = wedge_screw, h = 5);
        // lightening windows
        for (zz = [30, 56, 82])
            translate([0, -1, zz]) rotate([-90,0,0])
                cylinder(d = 20, h = plate_t + 2, $fn = 6);
    }
}

// ===============================================================
module wedge() {
    // foot: vertical plate laps the main plate face (Y 0..foot_t),
    // X -foot_w/2.., Z 0..foot_h. Pins/screws on the -Y face.
    difference() {
        union() {
            translate([-foot_w/2, 0, 0]) cube([foot_w, foot_t, foot_h]);
            // lean slab from foot top edge, leaning +Y at cam_lean
            translate([-foot_w/2, foot_t - 2, foot_h - 6]) rotate([-cam_lean, 0, 0])
                translate([0, 0, 0]) cube([foot_w, slab_t, slab_len]);   // bites 2mm into foot
            // camera posts on slab -Y face (lens side faces +Y/down at bed)
            translate([-foot_w/2, foot_t - 2, foot_h - 6]) rotate([-cam_lean, 0, 0])
                for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
                    translate([foot_w/2 + sx, 4.5, cam_zc_local + sz]) rotate([90,0,0])
                        cylinder(d = 4.5, h = 5.5);   // bite 4mm into slab
        }
        // pin holes on foot -Y face (align to plate pins)
        for (px = [-16, 16])
            translate([px, -1, foot_h - 8]) rotate([-90,0,0])
                cylinder(d = 4.2, h = 5);
        // screw clearance through foot (M3)
        for (px = [-20, 20])
            translate([px, -1, wedge_screw_z]) rotate([-90,0,0])
                cylinder(d = 3.4, h = foot_t + 2);
        // lens bore through the lean slab
        translate([-foot_w/2, foot_t - 2, foot_h - 6]) rotate([-cam_lean,0,0])
            translate([foot_w/2, -6, cam_zc_local]) rotate([90,0,0])
                cylinder(d = lens_d, h = slab_t + 12);
        // camera post pilots
        translate([-foot_w/2, foot_t - 2, foot_h - 6]) rotate([-cam_lean,0,0])
            for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
                translate([foot_w/2 + sx, 6, cam_zc_local + sz]) rotate([90,0,0])
                    cylinder(d = cam_pilot, h = 8);
        // ribbon slot through slab bottom edge
        translate([-foot_w/2, foot_t - 2, foot_h - 6]) rotate([-cam_lean,0,0])
            translate([foot_w/2 - 9, -2, -2]) cube([18, 8, 8]);
    }
}

// ===============================================================
if (part == "plate") plate();
if (part == "wedge") wedge();
if (part == "print_plate") rotate([90, 0, 0]) plate();   // plate FACE flat on bed
if (part == "print_wedge") rotate([90, 0, 0]) wedge();   // foot FACE flat on bed
if (part == "preview") {
    color([0.1, 0.1, 0.11]) plate();
    color([0.95, 0.95, 0.93])
        translate([0, plate_t, plate_h - foot_h]) wedge();
}
