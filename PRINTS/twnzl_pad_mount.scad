// Y-axis pad mount — Ender-3 V3 SE
// Keeps Twnzl/bioxz 40 mm vertical M3 pair (CC BY-SA concept).
// Drops the Pi Zero box. Solid shoe + truss + pad.
// One face: Zero 3W (65 x 30, M2.5 pilots). Other face: 3M-tape camera.
//
// PRINT: whole part is a 6 mm plate, large face on the bed. No lattice.
// part = "print" | "preview"

part = "preview"; // [print, preview]

$fn = 48;

screw_spacing = 40.0;
m3_clear      = 3.4;
t             = 6.0;

shoe_w = 22.0;
shoe_h = 52.0;

truss_w = 16.0;
truss_l = 70.0;

pad_w = 72.0;   // along truss (X)
pad_h = 42.0;   // across (Y)

z3w_x = 65.0;
z3w_y = 30.0;
z3w_holes = [[3.55,3.60],[3.60,26.45],[61.40,3.60],[61.40,26.50]];
z3w_pilot = 2.1;

// print coords: Z = thickness. Holes along Y. Truss +X.
// shoe centered on origin.
pad_x0 = shoe_w/2 + truss_l;
pad_cx = pad_x0 + pad_w/2;
pad_cy = 0;

module plate() {
    difference() {
        union() {
            translate([-shoe_w/2, -shoe_h/2, 0])
                cube([shoe_w, shoe_h, t]);
            translate([shoe_w/2 - 0.1, -truss_w/2, 0])
                cube([truss_l + 0.2, truss_w, t]);
            translate([pad_x0, -pad_h/2, 0])
                cube([pad_w, pad_h, t]);
        }
        for (sy = [-screw_spacing/2, screw_spacing/2])
            translate([0, sy, -1])
                cylinder(d = m3_clear, h = t + 2);
        // Zero 3W pilots through the pad (either face)
        for (hxy = z3w_holes)
            translate([
                pad_cx - z3w_x/2 + hxy[0],
                pad_cy - z3w_y/2 + hxy[1],
                -1
            ])
                cylinder(d = z3w_pilot, h = t + 2);
    }
}

module dummy_z3w() {
    color([0.15, 0.45, 0.18])
        translate([pad_cx - z3w_x/2, pad_cy - z3w_y/2, t])
            cube([z3w_x, z3w_y, 1.6]);
}

module dummy_cam() {
    // 36x36 on the bed face (other side), 3M tape
    color([0.22, 0.22, 0.25])
        translate([pad_cx - 18, pad_cy - 18, -1.6])
            cube([36, 36, 1.6]);
}

if (part == "print") plate();
if (part == "preview") {
    color([0.10, 0.10, 0.11]) plate();
    dummy_z3w();
    dummy_cam();
}
