// Twnzl Y-axis mount — M12 camera insert
// Vendor: Twnzl "Ender3 V3 SE Raspberry Pi zero 2w with camera mount"
//   Printables #1499753, CC BY-SA 4.0 (remix of bioxz + DotNetWorker).
//
// Stock camera mouth is a 29 x 25 mm CS window in a 44 x 44 mm face.
// No 28.8 grid. Our 36 x 36 M12 would rattle; 17 mm lens is lost in 29 x 25.
// Vendor mesh is not CGAL-valid — do not boolean it. Two parts:
//   mount = vendor STL as-is
//   cam   = flange + plug (this file). Prints camera-face on the bed.
//
// part = "cam" | "preview"

part = "preview"; // [cam, preview]

vendor_stl = "vendor/twnzl-149975/piZeroEnderMountV3C.stl";

$fn = 48;

// Measured 2026-08-17 on vendor STL (vendor coords)
face_x   = 11.73;          // +X camera face
win_y0   =  5.60;
win_y1   = 30.60;          // 25 mm
win_z0   = -21.34;
win_z1   =  7.66;          // 29 mm
win_cy   = (win_y0 + win_y1) / 2;   // 18.10
win_cz   = (win_z0 + win_z1) / 2;   // -6.84

// Shop camera
board     = 36.0;
grid      = 28.8;
lens_w    = 20.0;          // peephole
lens_h    = 12.0;
cam_pilot = 1.7;
flange    = 48.0;
flange_t  = 4.0;
boss_clr  = 0.8;           // total slop in the 25 x 29 window
boss_h    = 4.0;
ribbon_w  = 33.0;          // connector + FPC
ribbon_d  = 13.0;          // from plate edge, through full thickness

boss_y = (win_y1 - win_y0) - boss_clr;   // 24.2
boss_z = (win_z1 - win_z0) - boss_clr;   // 28.2

// ---- print coords: camera face on Z=0, features grow +Z ----
module cam() {
    difference() {
        union() {
            translate([-flange/2, -flange/2, 0])
                cube([flange, flange, flange_t]);
            // plug into the 29 x 25 window. Local: Y->vendor Y, X->vendor Z
            translate([-boss_z/2, -boss_y/2, flange_t])
                cube([boss_z, boss_y, boss_h]);
        }
        translate([-lens_w/2, -lens_h/2, -1])
            cube([lens_w, lens_h, flange_t + boss_h + 2]);
        for (sx = [-grid/2, grid/2], sy = [-grid/2, grid/2])
            translate([sx, sy, -1])
                cylinder(d = cam_pilot, h = flange_t + boss_h + 2);
        // ribbon + connector: 33 x 13 from -Y edge, through the plate
        translate([-ribbon_w/2, -flange/2 - 1, -1])
            cube([ribbon_w, ribbon_d + 1, flange_t + boss_h + 2]);
    }
}

// vendor preview: move insert onto the +X face, lens +X
module insert_on_mount() {
    // Ry(90): +Z print -> -X vendor. Outer face sits at face_x + flange_t.
    translate([face_x + flange_t, win_cy, win_cz])
        rotate([0, 90, 0])
            cam();
}

module dummy_cam() {
    // 36x36 + M12 barrel sitting on the outer face
    color([0.15, 0.45, 0.18])
        translate([face_x + flange_t, win_cy - board/2, win_cz - board/2])
            cube([1.6, board, board]);
    color([0.22, 0.22, 0.25])
        translate([face_x + flange_t + 1.6, win_cy, win_cz])
            rotate([0, 90, 0])
                cylinder(d = 14, h = 12);
}

if (part == "cam") cam();
if (part == "preview") {
    color([0.10, 0.10, 0.11])
        import(vendor_stl, convexity = 12);
    color([0.92, 0.92, 0.90])
        insert_on_mount();
    dummy_cam();
}
