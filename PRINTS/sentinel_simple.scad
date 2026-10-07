// Sentinel SIMPLE — TWO PARTS, both print flat, zero supports
// Ender-3 V3 SE left end cap. Cap screws stay 40 mm. No hubs.
//
// PLATE: Zero 3W + two standoff pads growing UP (cap side).
// CAM:   camera face on the bed. 35° wedge. 2× M3 onto the plate.
//        Looks at the PRINT BED, not the wall.
//
// part = "plate" | "cam" | "preview"

part = "preview"; // [plate, cam, preview]

$fn = 48;

screw_spacing = 40.0;
standoff_h    = 9.0;
standoff_xy   = 16.0;
screw_clear   = 3.4;
head_d        = 6.2;
head_h        = 3.4;

plate_w = 90.0;
plate_h = 132.0;
plate_t = 5.0;

z3w_x = 65.0;
z3w_y = 30.0;
z3w_holes = [[3.55,3.60],[3.60,26.45],[61.40,3.60],[61.40,26.50]];
z3w_pilot = 2.1;

cam_grid  = 28.8;
lens_d    = 17.0;
cam_pilot = 1.7;
lean      = 35.0;
face_w    = 48.0;
face_h    = 48.0;
face_t    = 4.0;
flange_t  = 5.0;
flange_h  = 32.0;
mate_x    = 12.0;

screw0_y = 18.0;
z3w_y0   = 72.0;
cam_y0   = 100.0;
mate_y   = cam_y0 + 16.0;

module plate() {
    difference() {
        union() {
            translate([-plate_w/2, 0, 0])
                cube([plate_w, plate_h, plate_t]);
            for (sy = [screw0_y, screw0_y + screw_spacing])
                translate([-standoff_xy/2, sy - standoff_xy/2, plate_t])
                    cube([standoff_xy, standoff_xy, standoff_h]);
        }
        for (sy = [screw0_y, screw0_y + screw_spacing]) {
            translate([0, sy, -1])
                cylinder(d = screw_clear, h = plate_t + standoff_h + 2);
            translate([0, sy, -0.01])
                cylinder(d = head_d, h = head_h);
        }
        for (hxy = z3w_holes)
            translate([hxy[0] - z3w_x/2, z3w_y0 + hxy[1], -1])
                cylinder(d = z3w_pilot, h = plate_t + 2);
        for (px = [-mate_x, mate_x])
            translate([px, mate_y, -1])
                cylinder(d = screw_clear, h = plate_t + 2);
    }
}

// CAM prints camera-face DOWN (48×48 on the bed). Wedge grows up.
// Flange is 35° from vertical — that face bolts to the plate.
module cam() {
    difference() {
        union() {
            translate([-face_w/2, -face_h/2, 0])
                cube([face_w, face_h, face_t]);
            hull() {
                translate([-face_w/2, -face_h/2, face_t - 1])
                    cube([face_w, face_h, 1]);
                // flange: rotate about X so it stands 35° from vertical
                translate([-face_w/2, 8, face_t])
                    rotate([90 - lean, 0, 0])
                        cube([face_w, flange_t, flange_h]);
            }
        }
        // lens + 4 M2 pilots through the face (print Z)
        translate([0, 0, -1])
            cylinder(d = lens_d, h = face_t + 3);
        for (sx = [-cam_grid/2, cam_grid/2], sy = [-cam_grid/2, cam_grid/2])
            translate([sx, sy, -1])
                cylinder(d = cam_pilot, h = face_t + 3);
        // ribbon out the -Y edge of the face
        translate([-9, -face_h/2 - 1, -1])
            cube([18, 8, face_t + 3]);
        // M3 through the flange
        translate([0, 8, face_t]) rotate([90 - lean, 0, 0])
            for (px = [-mate_x, mate_x])
                translate([px, -1, 16]) rotate([-90, 0, 0])
                    cylinder(d = screw_clear, h = flange_t + 4);
    }
}

if (part == "plate") plate();
if (part == "cam")   cam();
if (part == "preview") {
    // exploded: both parts as they PRINT (flat). Assembly: 2× M3
    // through the cam flange into the two holes at the top of the plate.
    color([0.12, 0.12, 0.13]) plate();
    color([0.92, 0.92, 0.90])
        translate([80, 50, 0]) cam();
}
