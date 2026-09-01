// Rock 5C + 2.8" yellow ILI9341 SPI display — two-part stacked case
// Dimensions verified from Radxa official DXF/metal-case spec + LCDWiki MSP2806/2807 size drawing
//
// Parts: coupon (fit test) | base (board tray + posts) | panel (display bezel)
//   openscad --export-format asciistl -D 'part="coupon"' -o stl/rock5c-coupon.stl rock5c_2.8_case.scad
//   openscad --export-format asciistl -D 'part="base"'   -o stl/rock5c-base.stl   rock5c_2.8_case.scad
//   openscad --export-format asciistl -D 'part="panel"'  -o stl/rock5c-panel.stl  rock5c_2.8_case.scad
//
// Hardware: 4x M2.5 (board to bosses, thread-forming) + 4x M3 (panel to posts)
// Filament: black PLA base, white PLA panel (or both black)

part = "base";  // "coupon" | "base" | "panel"

// ---------- Rock 5C (from Radxa official docs / DXF) ----------
board_x = 86;           // long edge
board_y = 56;           // short edge
board_th = 1.6;         // PCB thickness (standard)
board_holes = [         // [x, y] from board corner, M2.5
    [3.5, 3.5], [82.5, 3.5],
    [3.5, 52.5], [82.5, 52.5]
];
m25_pilot = 2.0;        // thread-forming pilot in PLA

// ---------- 2.8" display MSP2806/2807 (from LCDWiki size drawing) ----------
disp_x = 86;            // module long edge (same as board)
disp_y = 50;            // module short edge
disp_th = 4.4;          // total thickness excl. header
aa_w = 57.6;            // active area length along X (long axis, 320px)
aa_h = 43.2;            // active area width across Y (short axis, 240px)
aa_off_x = 3.0;         // AA top offset from module +X edge (per size drawing)
aa_off_y = 3.4;         // AA side offset: (50 - 43.2)/2 = 3.4, centered
win_margin = 1.2;       // bezel window margin beyond AA

// ---------- Case ----------
wall = 2.0;             // wall thickness
floor = 2.0;            // base floor
clear = 0.5;            // component clearance
base_outer_x = board_x + 2*(wall + clear);   // 91
base_outer_y = board_y + 2*(wall + clear);   // 61
post_h = 16;            // post height: clears GPIO header (~8.5mm) + cabling
post_d = 8;             // room for M3 pilot + wall
post_inset = 4.5;       // post center inset from outer edges (stays inside footprint)
post_pilot = 2.5;       // M3 thread-forming pilot in PLA
panel_m3_clear = 3.2;   // M3 clearance through panel
boss_h = 5;             // board boss height above base floor
bezel = 2.0;            // panel front wall (between display and outside)
back_wall = 1.6;        // panel back wall
panel_th = bezel + disp_th + clear + back_wall;   // 2.0+4.4+0.5+1.6 = 8.5

// display pocket position (centered in panel, clear on all sides)
pocket_x = disp_x + 2*clear;   // 87
pocket_y = disp_y + 2*clear;   // 51
pocket_off_x = (base_outer_x - pocket_x)/2;   // 2.0
pocket_off_y = (base_outer_y - pocket_y)/2;   // 5.0

// AA window through bezel (front face z=0..bezel)
win_x = aa_w + 2*win_margin;   // 45.6
win_y = aa_h + 2*win_margin;   // 60.0
win_off_x = pocket_off_x + clear + aa_off_x - win_margin;  // 2.0+0.5+3.4-1.2 = 4.7
win_off_y = pocket_off_y + clear + aa_off_y - win_margin;  // 5.0+0.5+3.0-1.2 = 7.3

module board_bosses() {
    for (h = board_holes) {
        translate([wall + clear + h[0], wall + clear + h[1], 0])
            cylinder(d = 8, h = boss_h, $fn = 32);
    }
}

module board_pilots() {
    for (h = board_holes) {
        translate([wall + clear + h[0], wall + clear + h[1], -1])
            cylinder(d = m25_pilot, h = boss_h + 2, $fn = 24);
    }
}

module base_shell() {
    difference() {
        cube([base_outer_x, base_outer_y, floor + boss_h]);
        translate([wall, wall, floor])
            cube([base_outer_x - 2*wall, base_outer_y - 2*wall, boss_h + 1]);
    }
}

module posts() {
    for (i = [0:1], j = [0:1]) {
        px = i ? base_outer_x - post_inset : post_inset;
        py = j ? base_outer_y - post_inset : post_inset;
        translate([px, py, floor + boss_h])
            cylinder(d = post_d, h = post_h, $fn = 32);
    }
}

module post_pilots() {
    for (i = [0:1], j = [0:1]) {
        px = i ? base_outer_x - post_inset : post_inset;
        py = j ? base_outer_y - post_inset : post_inset;
        translate([px, py, -1])
            cylinder(d = post_pilot, h = floor + boss_h + post_h + 2, $fn = 24);
    }
}

module base() {
    difference() {
        union() {
            base_shell();
            board_bosses();
            posts();
        }
        board_pilots();
        post_pilots();
    }
}

// ---------- Display panel ----------
// Front (z=0) = bezel with AA window. Behind bezel: display pocket (open at back).
// Back wall closes the pocket; display drops in from the inside (case side).
// Cable slot at the header end of the display (long edge, Y = pocket end).

module panel_body() {
    difference() {
        cube([base_outer_x, base_outer_y, panel_th]);
        // AA window through bezel
        translate([win_off_x, win_off_y, -1])
            cube([win_x, win_y, bezel + 1]);
        // display pocket: from z=bezel, depth disp_th+clear, open through back
        translate([pocket_off_x, pocket_off_y, bezel - 0.01])
            cube([pocket_x, pocket_y, disp_th + clear + 1]);
        // cable slot at the header end of the pocket (long edge, near +Y end)
        translate([pocket_off_x + 8, pocket_off_y + pocket_y - 6, bezel - 0.01])
            cube([pocket_x - 16, 6, disp_th + clear + 1]);
        // M3 clearance holes at the four post positions
        for (i = [0:1], j = [0:1]) {
            px = i ? base_outer_x - post_inset : post_inset;
            py = j ? base_outer_y - post_inset : post_inset;
            translate([px, py, -1])
                cylinder(d = panel_m3_clear, h = panel_th + 2, $fn = 24);
        }
        // counterbore for M3 heads on the back (z=panel_th side)
        for (i = [0:1], j = [0:1]) {
            px = i ? base_outer_x - post_inset : post_inset;
            py = j ? base_outer_y - post_inset : post_inset;
            translate([px, py, panel_th - 2.0])
                cylinder(d = 6.0, h = 2.2, $fn = 24);
        }
    }
}

module panel() {
    panel_body();
}

// ---------- Fit coupon: board bosses + display window check ----------
module coupon() {
    difference() {
        union() {
            cube([base_outer_x, base_outer_y, 3]);
            board_bosses();
        }
        board_pilots();
        // display window marker (cut through so you can sight the AA)
        translate([win_off_x, win_off_y, -1])
            cube([win_x, win_y, 5]);
        // pocket outline marker
        translate([pocket_off_x, pocket_off_y, -0.5])
            cube([pocket_x, pocket_y, 0.5]);
    }
}

if (part == "coupon") coupon();
if (part == "base") base();
if (part == "panel") panel();
