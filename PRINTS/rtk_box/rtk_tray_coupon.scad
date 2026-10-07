// F450 Sentinel — RTK Box tray FIT-CHECK COUPON
// Same pocket geometry as rtk_tray_v1.scad (single source of truth via use),
// cut to a flat plate covering all three board pockets + center cable slot.
// Purpose: operator physically drops UM980 / LicheeRV Nano / LR900 into the
// pockets to verify fit BEFORE committing to the full tray print.
// No legs, no flip: pockets are cut from the TOP (z = tray_t - 0.8), so the
// plate prints flat, pockets facing up, exactly like the tray's disk face.

// Constants mirrored from rtk_tray_v1.scad (OpenSCAD `use` does NOT export
// variables — keep these in sync with the tray file).
tray_t = 3.0;
pocket_d = 0.6;
um980_w = 26 + 1.5;   um980_l = 38 + 1.5;
nano_w  = 22.86 + 1.5; nano_l = 35.56 + 1.5;
lr900_w = 25.8 + 1.5;  lr900_l = 43.4 + 1.5;
um_x = -30;  nano_x = 30;  lr_x = 0;

module rounded_sq(w, l, r = 2) {
    offset(r = r) square([w - 2*r, l - 2*r], center = true);
}

plate_x = 100;   // covers x -50..50 (UM980 -49.75..-10.25, Nano 17.8..42.2)
plate_y = 66;    // covers y -20..46  (Nano -18.5..18.5, LR900 14.35..41.65)
plate_yc = 13;   // plate center offset so the rectangle spans y -20..46

module coupon() {
    cut_z = tray_t - (pocket_d + 0.2);   // 3.0 - 0.8 = 2.2: cut from top, 0.8 deep
    difference() {
        // plate
        translate([0, plate_yc, 0])
            linear_extrude(tray_t)
                rounded_sq(plate_x, plate_y, 4);
        // center cable bundle slot
        translate([0, 0, cut_z])
            linear_extrude(pocket_d + 0.3)
                rounded_sq(34, 14, 3);
        // UM980 pocket (left)
        translate([um_x, 0, cut_z])
            linear_extrude(pocket_d + 0.3)
                rounded_sq(um980_l, um980_w, 2);
        // Nano pocket (right, long axis along Y)
        translate([nano_x, 0, cut_z])
            linear_extrude(pocket_d + 0.3)
                rounded_sq(nano_l, nano_w, 2);
        // LR900 pocket (center-top, long axis along X)
        translate([lr_x, 28, cut_z])
            linear_extrude(pocket_d + 0.3)
                rounded_sq(lr900_l, lr900_w, 2);
    }
}

coupon();
