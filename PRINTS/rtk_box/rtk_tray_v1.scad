// F450 Sentinel — RTK Box internal tray (replaces Thingiverse tang1)
// Fits de_duoi bowl interior (cavity dia ~171). Simple flat disk + 4 legs.
// Boards mount with hook-and-loop (Art3d strips, already in BOM) into
// shallow pockets so they don't slide. Cable pass-throughs in the center.
// Power bank (92x60x22) sits on the bowl floor below this tray.
// Material: PETG. 0.2mm layers, 3 perimeters.

tray_d = 155;
tray_t = 3.0;
leg_h  = 28;        // floor ring top ~Z3; disk plane at Z~31 clears 22mm-tall power bank below
leg_w  = 9;
pocket_d = 0.6;   // recess depth — velcro pad sits in here

// Board footprints + 1.5mm clearance
um980_w = 26 + 1.5;   um980_l = 38 + 1.5;
nano_w  = 22.86 + 1.5; nano_l = 35.56 + 1.5;
lr900_w = 25.8 + 1.5;  lr900_l = 43.4 + 1.5;

$fn = 80;

module rounded_sq(w, l, r = 2) {
    offset(r = r) square([w - 2*r, l - 2*r], center = true);
}

// Layout on the disk (X = long axis of UM980, Y = width)
um_x = -30;   // center of UM980 pocket
nano_x = 30;  // center of Nano pocket (rotated 90: long axis along Y)
lr_x = 0;     // LR900 center (long axis along X)

module pocket(w, l, x, y, rot = 0) {
    translate([x, y, 0])
        rotate([0, 0, rot])
            linear_extrude(pocket_d)
                rounded_sq(w, l, 2);
}

module tray() {
    difference() {
        union() {
            linear_extrude(tray_t)
                circle(d = tray_d);
            for (a = [45, 135, 225, 315])
                rotate([0, 0, a])
                    translate([tray_d/2 - 6, 0, -leg_h])
                        linear_extrude(leg_h)
                            rounded_sq(10, leg_w, 1.5);
        }
        // NOTE (2026-08-16): the as-exported STL prints LEGS-DOWN -> the slicer
        // would bridge the 155mm disk across 4 pillars = guaranteed fail.
        // Export is Z-flipped before slicing so the DISK sits on the bed and
        // the legs print as vertical towers. Keep the flip in the pipeline
        // (see rtk_tray_v1_flat.stl generation) or re-export flipped.
        // center cable bundle slot (SMA + power + UART)
        translate([0, 0, -0.1])
            linear_extrude(tray_t + 0.2)
                rounded_sq(34, 14, 3);
        // UM980 pocket (left)
        translate([um_x, 0, -0.1])
            linear_extrude(pocket_d + 0.2)
                rounded_sq(um980_l, um980_w, 2);
        // Nano pocket (right, long axis along Y)
        translate([nano_x, 0, -0.1])
            linear_extrude(pocket_d + 0.2)
                rounded_sq(nano_l, nano_w, 2);
        // LR900 pocket (center-top, long axis along X)
        translate([lr_x, 28, -0.1])
            linear_extrude(pocket_d + 0.2)
                rounded_sq(lr900_l, lr900_w, 2);
    }
}

tray();
