// Zero 3W + OV5647 camera mount for Ender 3 V3 SE
// Holds the Radxa Zero 3W board and the Arducam OV5647 + UC-376 adapter
// so the camera views the print bed / nozzle area.
// Mounts to the printer frame (Y rail or side extrusion).
//
// Designed for PLA, 0.2mm layers, 3+ perimeters, 20% infill.
// Print with camera holder face down.
//
// part = "sbc_holder" | "cam_holder" | "preview"

part = "preview"; // [sbc_holder, cam_holder, preview]

$fn = 48;

// Dimensions (approx from datasheets + similar Zero boards)
sbc_w = 65;
sbc_d = 30;
sbc_h = 8;

hole_d = 2.5;
hole_spacing_x = 58;
hole_spacing_y = 23;

cam_board_w = 25;
cam_board_d = 25;
lens_d = 14;
lens_h = 15;

wall = 3;
screw_d = 3.2;
frame_thickness = 20;

// SBC tray
module sbc_holder() {
    difference() {
        union() {
            cube([sbc_w + 2*wall, sbc_d + 2*wall, wall]);
            cube([sbc_w + 2*wall, wall, wall + sbc_h]);
            translate([0, sbc_d + wall, 0])
                cube([sbc_w + 2*wall, wall, wall + sbc_h]);
            cube([wall, sbc_d + 2*wall, wall + sbc_h]);
        }
        translate([wall, wall, wall])
            cube([sbc_w, sbc_d, sbc_h + 1]);

        hx = (sbc_w + 2*wall - hole_spacing_x) / 2;
        hy = (sbc_d + 2*wall - hole_spacing_y) / 2;
        for (x = [0, hole_spacing_x], y = [0, hole_spacing_y]) {
            translate([hx + x, hy + y, -1])
                cylinder(d = hole_d, h = wall + 2);
        }

        for (x = [wall + 5, sbc_w + wall - 5]) {
            translate([x, wall/2, -1])
                cylinder(d = screw_d, h = wall + 2);
        }
    }
}

// Camera cradle - single connected body, tilted
module cam_holder() {
    tilt = 25; // tilt down toward bed
    cradle_w = cam_board_w + 6;
    cradle_d = cam_board_d + 6;
    cradle_h = 12;

    // Build as one union then difference
    difference() {
        union() {
            // flat base
            cube([cradle_w, cradle_d, wall]);

            // tilted section attached at the base edge
            translate([0, 0, wall])
                rotate([tilt, 0, 0])
                    cube([cradle_w, cradle_d, cradle_h]);
        }

        // lens clearance
        translate([cradle_w/2, cradle_d/2 + 3, -2])
            cylinder(d = lens_d + 2, h = wall + cradle_h + 10);

        // board pocket
        translate([3, 3, wall - 2])
            cube([cam_board_w, cam_board_d, 5]);

        // mount holes
        for (x = [5, cradle_w-5]) {
            translate([x, 5, -2])
                cylinder(d = screw_d, h = wall + cradle_h + 5);
        }
    }
}

module preview() {
    color([0.2, 0.2, 0.2]) sbc_holder();
    color([0.9, 0.8, 0.2])
        translate([sbc_w + 15, 5, 15])
            rotate([0, -90, 0])
                cam_holder();

    // dummy frame
    color([0.4, 0.4, 0.4])
        translate([-15, -5, -frame_thickness])
            cube([15, 80, frame_thickness]);
}

if (part == "sbc_holder") sbc_holder();
if (part == "cam_holder") cam_holder();
if (part == "preview") preview();