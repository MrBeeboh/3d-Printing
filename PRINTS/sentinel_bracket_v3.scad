// Sentinel V3 — ONE-PIECE, ZERO-SUPPORT bracket for Ender-3 V3 SE
// FIRST PRINCIPLES, take three (2026-08-17):
//   - The only reason V2 needed supports was horizontal hub cylinders.
//     V3 eliminates every long horizontal feature:
//       * plate = vertical wall (prints free)
//       * camera face = 35° lean (< 45° overhang limit -> prints free)
//       * standoffs/board bosses/camera posts = all <= 9mm stubs
//   - Result: the slicer generates NO supports. Nothing to break away.
//   - Camera aim is FIXED (35° down) — wide M12 FOV covers the bed.
//
// INSTALL: +Y faces the bed. Plate bolts to the two cap screws (40mm o/c
// vertical, left end cap) via standoff bosses on the -Y face. Zero 3W
// mounts flat on the +Y face (ports UP). Camera mounts on the lean face
// at the top, looking down at the bed.
//
// part = "bracket" | "preview"

part = "bracket"; // [bracket, preview]

/* [Cap interface — MEASURED 2026-08-16/17] */
screw_spacing = 40.0;   // cap screws, VERTICAL, one above the other
standoff     = 9.0;     // plate back -> cap face (clears irregular cap)
screw_pilot  = 3.4;     // M3 clearance

/* [Hardware] */
cam_pilot = 1.7;        // M2 self-tap (camera posts)
z3w_pilot = 2.1;        // M2.5 self-tap (Zero 3W bosses)

/* [Zero 3W — Radxa v1.11 DXF] */
z3w_x = 65.0; z3w_y = 30.0;
z3w_holes = [[3.55,3.60],[3.60,26.45],[61.40,3.60],[61.40,26.50]];

/* [Camera — measured] */
cam_grid = 28.8; lens_d = 17.0;
cam_lean = 35.0;        // camera face lean from vertical (deg) — <45 => no support

/* [Structure] */
plate_t = 5.0;          // plate thickness (Y)
plate_w = 90.0;         // plate width (X)
plate_h = 112.0;        // vertical plate height (Z)
boss_h  = 4.5;          // Zero 3W boss height (+Y from plate face)
z0      = 56.0;         // board bottom edge height (above upper screw + pocket)

// ===============================================================
module bracket() {
    difference() {
        union() {
            // vertical plate (prints as a wall)
            translate([-plate_w/2, 0, 0]) cube([plate_w, plate_t, plate_h]);
            // standoff bosses on -Y face, at z=0 and z=40 (cap screws)
            for (sz = [0, screw_spacing])
                translate([0, -standoff, sz]) rotate([-90,0,0])
                    cylinder(d = 11, h = standoff);
            // camera lean face assembly: slab + posts, all in ONE transform
            // so the posts actually connect to the slab (fixes 6-shell bug)
            translate([0, plate_t - 6, plate_h - 8]) rotate([-cam_lean, 0, 0]) {
                translate([-24, 0, 0]) cube([48, 4, 52]);   // the lean slab, CENTERED on local X
                for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
                    translate([sx, 4.5, 26 + sz]) rotate([90,0,0])
                        cylinder(d = 4.5, h = 5.5);      // posts bite 4mm into slab
            }
            // Zero 3W bosses on +Y face (ports UP)
            for (hxy = z3w_holes)
                translate([hxy[0]-z3w_x/2, plate_t, z0 + (z3w_y - hxy[1])])
                    rotate([-90,0,0]) cylinder(d=5, h=boss_h);
        }
        // standoff screw holes (M3 through standoff+plate, vertical in print)
        for (sz = [0, screw_spacing])
            translate([0, -standoff - 1, sz])
                rotate([-90,0,0]) cylinder(d = screw_pilot, h = standoff + plate_t + 2);
        // Zero 3W boss pilots
        for (hxy = z3w_holes)
            translate([hxy[0]-z3w_x/2, plate_t - 1, z0 + (z3w_y - hxy[1])])
                rotate([-90,0,0]) cylinder(d = z3w_pilot, h = boss_h + 2);
        // lens bore through the lean face (local slab coords)
        translate([0, plate_t - 6, plate_h - 8]) rotate([-cam_lean,0,0])
            translate([0, -6, 26]) rotate([90,0,0])
                cylinder(d = lens_d, h = 16);
        // camera post pilots (local slab coords)
        translate([0, plate_t - 6, plate_h - 8]) rotate([-cam_lean,0,0])
            for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
                translate([sx, -1.5, 26 + sz]) rotate([90,0,0])
                    cylinder(d = cam_pilot, h = 7);
        // ribbon slot through lean face bottom edge
        translate([0, plate_t - 6, plate_h - 8]) rotate([-cam_lean,0,0])
            translate([-9, -2, -2]) cube([18, 8, 8]);
        // lightening windows (hexes through plate)
        for (zz = [30, 56, 82])
            translate([0, -1, zz]) rotate([-90,0,0])
                cylinder(d = 20, h = plate_t + 2, $fn = 6);
    }
}

// ===============================================================
if (part == "bracket") bracket();
if (part == "print")  rotate([0, 90, 0]) bracket();   // plate FACE flat on bed (rotY90)
if (part == "preview") {
    color([0.1, 0.1, 0.11]) bracket();
}
