// Sentinel L-bracket — ONE-PIECE, ZERO-SUPPORT mount for Ender-3 V3 SE
// 2026-08-17 v3 — direction-corrected (all horizontal cylinders point +Y).
//   * ONE part, prints as-is: shelf flat on bed, wall rises, camera face
//     is a 35 deg bend at the top (under the 45 deg overhang limit).
//   * NO horizontal cylinders, NO hubs, NO joints: standoffs are chamfered
//     blocks (sloped underside = ~35 deg from vertical), posts are tiny.
// INSTALL: +Y faces the bed. Chamfered blocks bolt to the cap's two screws
// (40 mm apart vertical). Replace stock cap screws with M3x25.
// NOTE: rotate([-90,0,0]) maps +Z -> +Y (forward, toward the bed).

// ================= PARAMETERS =================
shelf_w  = 90.0;   // shelf width (X)
shelf_d  = 40.0;   // shelf depth (Y)
shelf_t  = 5.0;    // shelf thickness (Z)
wall_t   = 5.0;    // wall thickness (Y)
wall_h   = 112.0;  // wall height above shelf (Z)
bend_z   = 100.0;  // bend height (Z) — camera face leans from here
lean_deg = 35.0;   // camera face lean from vertical (deg)
lean_len = 52.0;   // lean slab length along its face
cam_zc   = 21.0;   // camera center, local Z on lean face
cam_grid = 28.8;   // camera hole grid (mm)
lens_d   = 17.0;   // lens bore
boss_h   = 4.5;    // Zero 3W boss height
z3w_x = 65.0; z3w_y = 30.0;
z3w_holes = [[3.55,3.60],[3.60,26.45],[61.40,3.60],[61.40,26.50]];
board_y0 = 8.0;    // board port edge Y on shelf (toward wall)
cap_z  = [30.0, 70.0];  // cap screw heights (40 mm apart)
screw_pilot = 3.4;      // M3 clearance
cam_pilot   = 1.7;      // M2 self-tap
z3w_pilot   = 2.1;      // M2.5 self-tap

// ================= STANDOFF BLOCK =================
// Chamfered block on the wall back face: cap-side landing at y=-9 is flat;
// underside slopes ~55 deg from horizontal (34.7 deg from vertical) so it
// prints clean with NO support. zz = offset so screws land at cap_z.
module standoff_block(zz) {
    hull() {
        translate([-14, -9, zz + 26]) cube([28, 9, 8]);   // cap-side landing
        translate([-14, 0,  zz + 13]) cube([28, 1, 21]);  // wall-side bite
    }
}

// ================= BRACKET =================
module bracket() {
    difference() {
        union() {
            // shelf — flat on the bed
            translate([-shelf_w/2, 0, 0]) cube([shelf_w, shelf_d, shelf_t]);
            // wall — rises from shelf back edge
            translate([-shelf_w/2, 0, 0]) cube([shelf_w, wall_t, shelf_t + wall_h]);
            // standoff blocks (chamfered undersides, no horizontal faces)
            standoff_block(0);
            standoff_block(40);
            // Zero 3W bosses on shelf top (ports toward wall)
            for (hxy = z3w_holes)
                translate([hxy[0] - z3w_x/2, board_y0 + (z3w_y - hxy[1]), shelf_t])
                    cylinder(d = 5, h = boss_h);
            // upper wall: 35 deg bend toward +Y, embedded 30 mm below bend
            translate([-shelf_w/2, 0, shelf_t + bend_z]) rotate([-lean_deg, 0, 0])
                translate([0, 0, -30]) cube([shelf_w, wall_t, lean_len + 30]);
            // camera posts on lean face (+Y side), stick OUT from the face
            translate([-shelf_w/2, 0, shelf_t + bend_z]) rotate([-lean_deg, 0, 0])
                for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
                    translate([shelf_w/2 + sx, wall_t, cam_zc + sz])
                        rotate([-90,0,0]) cylinder(d = 4.5, h = 5.5);
        }
        // cap screw holes through blocks + wall (front face y=5 -> cap y=-9)
        for (sz = cap_z)
            translate([0, -2, sz]) rotate([-90,0,0]) cylinder(d = screw_pilot, h = 16);
        // screw head pockets on FRONT face (y=5, 4 mm deep)
        for (sz = cap_z)
            translate([0, wall_t, sz]) rotate([-90,0,0]) cylinder(d = 6.0, h = 4);
        // Zero 3W boss pilots
        for (hxy = z3w_holes)
            translate([hxy[0] - z3w_x/2, board_y0 + (z3w_y - hxy[1]), shelf_t - 1])
                cylinder(d = z3w_pilot, h = boss_h + 2);
        // lens bore through lean face (perpendicular, centered on face)
        translate([-shelf_w/2, 0, shelf_t + bend_z]) rotate([-lean_deg, 0, 0])
            translate([shelf_w/2, -2, cam_zc]) rotate([-90,0,0]) cylinder(d = lens_d, h = 16);
        // camera post pilots (from face into slab)
        translate([-shelf_w/2, 0, shelf_t + bend_z]) rotate([-lean_deg, 0, 0])
            for (sx = [-cam_grid/2, cam_grid/2], sz = [-cam_grid/2, cam_grid/2])
                translate([shelf_w/2 + sx, wall_t - 1, cam_zc + sz])
                    rotate([-90,0,0]) cylinder(d = cam_pilot, h = 7);
        // ribbon slot — through lean face + wall, low (x centered on camera)
        translate([-shelf_w/2, 0, shelf_t + bend_z]) rotate([-lean_deg, 0, 0])
            translate([-9, -1, -8]) cube([18, 7, 8]);
    }
}

// ===============================================================
// PRINT ORIENTATION: lay the WALL face flat on the bed (largest face
// down). The wall is 90x117; this puts the part ~45mm tall instead of
// 148mm. The camera lean (35 deg) and standoff chamfers ride up.
if (part == "bracket") bracket();
if (part == "print_flat") rotate([90, 0, 0]) bracket();
if (part == "preview") color([0.1, 0.1, 0.11]) bracket();
