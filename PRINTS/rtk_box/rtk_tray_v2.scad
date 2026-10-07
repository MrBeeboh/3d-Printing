// F450 Sentinel — RTK Box internal tray v2 (replaces rtk_tray_v1)
// Fits de_duoi bowl interior (cavity dia ~171). Flat disk + 4 legs.
// Hardware layout (verified dims from internet 2026-08-16):
//   2x LR900-F/P (43.4 x 25.8 x 11, MicoAir official) — zip-strap slots
//   1x UM980 carrier (26 x 38 x 7.6, locked BOM)       — 4x M2 @ 3mm inset
//   1x OLED 0.96" SSD1306 (~27 x 27)                   — 4x M2 @ 2mm inset
//   1x LicheeRV Nano (22.86 x 35.56, Sipeed official)  — 4x M2 @ 2mm inset (verify)
// Boards sit in shallow pockets (+1.5mm clearance) and screw/strap down.
// Power bank (92x60x22) sits on the bowl floor below this tray.
// Material: PETG final; PLA for coupon/fit-check. 0.2mm layers, 3 perimeters.

tray_d = 155;
tray_t = 3.0;
leg_h  = 28;        // floor ring top ~Z3; disk plane at Z~31 clears 22mm power bank
leg_w  = 9;
pocket_d = 1.0;     // recess depth (0.6 in v1; 1.0 gives boards a firmer seat)
clear = 1.5;        // board clearance per axis

// Board footprints (verified)
lr900_w = 25.8 + clear;  lr900_l = 43.4 + clear;
um980_w = 26 + clear;    um980_l = 38 + clear;
nano_w  = 22.86 + clear; nano_l = 35.56 + clear;
oled_w  = 27 + clear;    oled_l = 27 + clear;

// Mounting holes: M2 clearance = 2.5mm (prints ~2.3, M2 screw passes)
m2 = 2.5;

$fn = 80;

module rounded_sq(w, l, r = 2) {
    offset(r = r) square([w - 2*r, l - 2*r], center = true);
}

// Layout on the disk (X = long axis of UM980 / LR900)
um_x   = -45;   // UM980 center (left)
oled_x =  45;   // OLED center (right)
lr1_y  =  38;   // LR900 #1 center (top)
lr2_y  = -38;   // LR900 #2 center (bottom)
nano   = [0, 0]; // Nano center

module pocket(w, l, x, y, rot = 0) {
    translate([x, y, -0.1])
        linear_extrude(pocket_d + 0.2)
            rotate([0, 0, rot])
                rounded_sq(w, l, 2);
}

// Mounting holes: 4x M2 through the pocket floor.
module mount_holes(x, y, hx, hy) {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([x + sx * hx, y + sy * hy, -0.1])
            linear_extrude(tray_t + 0.2)
                circle(d = m2, $fn = 24);
}

// Zip-strap slots for radios: 4x6mm, two per radio, straddling the body.
module strap_slots(x, y, half_span) {
    for (sx = [-1, 1])
        translate([x + sx * half_span, y, -0.1])
            linear_extrude(tray_t + 0.2)
                rounded_sq(4, 7, 1);
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
        // NOTE (2026-08-16): as-exported STL prints LEGS-DOWN -> the slicer
        // bridges the 155mm disk across 4 pillars = guaranteed fail.
        // Export is Z-flipped before slicing so the DISK sits on the bed and
        // legs print as vertical towers. Coupon export omits legs.
        // center cable bundle slot (SMA + power + UART), bottom edge
        translate([0, -52, -0.1])
            linear_extrude(tray_t + 0.2)
                rounded_sq(34, 14, 3);
        // --- UM980 pocket + 4x M2 (3mm inset from 26x38 edges: ±(16, 11)) ---
        pocket(um980_l, um980_w, um_x, 0);
        mount_holes(um_x, 0, 16, 11);
        // --- OLED pocket + 4x M2 (2mm inset on 27x27: ±12) ---
        pocket(oled_l, oled_w, oled_x, 0);
        mount_holes(oled_x, 0, 12, 12);
        // --- LR900 #1 + #2, zip-strap slots at ±16 from center ---
        pocket(lr900_l, lr900_w, 0, lr1_y);
        strap_slots(0, lr1_y, 16);
        pocket(lr900_l, lr900_w, 0, lr2_y);
        strap_slots(0, lr2_y, 16);
        // --- Nano pocket + 4x M2 (2mm inset on 22.86x35.56: ±(9.4, 15.8)) ---
        pocket(nano_l, nano_w, nano[0], nano[1]);
        mount_holes(nano[0], nano[1], 9.4, 15.8);
    }
}

module coupon() {
    difference() {
        linear_extrude(tray_t)
            circle(d = tray_d);
        // same cuts as tray, minus legs
        translate([0, -52, -0.1])
            linear_extrude(tray_t + 0.2)
                rounded_sq(34, 14, 3);
        pocket(um980_l, um980_w, um_x, 0);
        mount_holes(um_x, 0, 16, 11);
        pocket(oled_l, oled_w, oled_x, 0);
        mount_holes(oled_x, 0, 12, 12);
        pocket(lr900_l, lr900_w, 0, lr1_y);
        strap_slots(0, lr1_y, 16);
        pocket(lr900_l, lr900_w, 0, lr2_y);
        strap_slots(0, lr2_y, 16);
        pocket(nano_l, nano_w, nano[0], nano[1]);
        mount_holes(nano[0], nano[1], 9.4, 15.8);
    }
}

// coupon=true -> flat fit-check disk (no legs), pockets up, print as-is
// The coupon body is built with pocket cuts from the bottom face (z=-0.1..1.1),
// same as the tray. Flip about Z so the pocket OPENINGS face up when printed,
// identical to the flipped tray orientation (rtk_tray_v1_flat.stl pipeline).
coupon_mode = true;
module coupon_flipped() {
    translate([0, 0, tray_t])
        scale([1, 1, -1])
            coupon();
}
if (coupon_mode) coupon_flipped(); else tray();
