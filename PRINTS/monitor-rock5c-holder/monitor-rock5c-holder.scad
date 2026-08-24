// monitor-rock5c-holder.scad
// Integrated monitor holder + Radxa Rock 5C enclosure
// Parametric so measured screen holes drop straight in.
// part = "coupon" | "backplate" | "bezel" | "preview"
//
// Verified: Rock 5C board 86 x 56mm.
// Screen (HMTECH 7" 800x480): outer ~165 x 104mm, active ~154x86.
//   Outer dims / corner hole positions are GENERIC placeholders pending
//   physical measurement of the actual board.

PART = "preview";          // "coupon" | "backplate" | "bezel" | "preview"

// ---------- Screen (7" HMTECH 800x480) ----------
sc_w  = 165;               // board outer width  (VERIFY against real board)
sc_h  = 104;               // board outer height (VERIFY against real board)
sc_t  = 7;                 // LCD+PCB thickness
sc_hole_d = 2.4;           // board mounting hole dia (M2 screw, generic)
sc_hole_inset = 6;         // hole center inset from board corner (VERIFY)
sc_active_w = 154;         // active display width
sc_active_h = 86;          // active display height

// ---------- Rock 5C ----------
rk_w = 86;
rk_h = 56;
rk_t = 1.6;                // PCB thickness
rk_standoff_h = 6;         // standoff height above backplate floor
rk_screw_d = 2.4;          // M2 through board

// ---------- Enclosure ----------
wall   = 2.8;
bezel_w = 6;               // bezel frame lip around screen edge
total_t = sc_t + wall;     // backplate floor to bezel front

// Clearances
fit = 0.4;                 // general fit gap for parts that drop in

// ---------- Rock 5C pocket (on backplate) ----------
pkt_inset_x = 6;           // pocket position on backplate (from screen bottom edge)
pkt_w = rk_w + fit*2;
pkt_h = rk_h + fit*2;
pkt_depth = rk_t + rk_standoff_h;
// Pocket sits fully inside the plate: its bottom edge aligns at wall,
// so the whole 56.8mm-tall pocket (and its standoffs) stay in-bounds.
pkt_cx = wall + (sc_w - pkt_w)/2;
pkt_cy = wall + pkt_h/2;

// M2.5 standoffs for the Rock 5C (per Hive convention: 2.1mm pilots, thread-forming)
standoff_d = 6;
standoff_pilot = 2.1;
// Rock 5C mounting holes (typical M2, ~4mm from each edge) - VERIFY
rk_hole_pos = 3.5;

$fn = 48;

// ============================================================
module screen_board(extra=0) {
    // the 7" screen PCB as a simple block (dummy for layout)
    translate([0,0,-sc_t])
      cube([sc_w+extra, sc_h+extra, sc_t], center=true);
}

module rock5c_holes() {
    // 4 mounting holes at corners of Rock 5C
    for (sx=[-1,1], sy=[-1,1])
      translate([sx*(rk_w/2 - rk_hole_pos), sy*(rk_h/2 - rk_hole_pos), 0])
        cylinder(d=rk_screw_d, h=pkt_depth+2, center=true);
}

// ============================================================
// FIT COUPON: verify screen board + Rock 5C actually sit in the pockets
// before committing to the full case. Two pockets + corner hole markers.
module coupon() {
    difference() {
        // plate: screen pocket on top half, Rock 5C pocket on bottom half
        cube([sc_w+20, sc_h+20, 4]);
        // screen pocket (trace) - top
        translate([10,10,1.5])
          cube([sc_w+fit, sc_h+fit, 3]);
        // rock5c pocket (trace) - bottom
        translate([10, 10+sc_h+8, 1.5])
          cube([rk_w+fit, rk_h+fit, 3]);
        // corner hole markers for the screen (drill points)
        for (sx=[0,1], sy=[0,1])
          translate([10+ (sx? sc_w : 0) + sx*(sc_hole_inset) , 10+(sy? sc_h:0)+sy*(sc_hole_inset), 0])
            cylinder(d=sc_hole_d, h=4, center=true);
        // rock5c mounting hole markers
        for (sx=[-1,1], sy=[-1,1])
          translate([10+sc_w/2+sx*(rk_w/2-rk_hole_pos), 10+sc_h+8+rk_h/2+sy*(rk_h/2-rk_hole_pos), 0])
            cylinder(d=rk_screw_d, h=4, center=true);
    }
}

// ============================================================
// BACKPLATE: mounts Rock 5C + cable pass-throughs. Screen faces forward.
module backplate() {
    difference() {
        // outer backplate shell (screen side open)
        cube([sc_w+2*wall, sc_h+2*wall, sc_t+wall]);
        // inner cavity: screen board drops in from front
        translate([wall, wall, wall])
          cube([sc_w, sc_h, sc_t+1]);
        // Rock 5C pocket recessed into backplate floor (bottom end)
        translate([pkt_cx, pkt_cy, wall])
          cube([pkt_w, pkt_h, pkt_depth]);
        // cable pass-throughs: HDMI + USB-C/power (top end, behind screen top)
        // HDMI (center, ~12mm wide)
        translate([(sc_w+2*wall)/2 - 6, -1, wall+3])
          cube([12, wall+2, 10]);
        // power/data (offset to one side)
        translate([wall+8, -1, wall+3])
          cube([10, wall+2, 10]);
        // Rock 5C mounting holes through backplate
        translate([pkt_cx, pkt_cy, 0])
          rock5c_holes();
    }
    // Rock 5C standoffs (on floor of pocket)
    // Extend DOWN into the floor material (past the wall plane) so each
    // cylinder merges with the base — otherwise it floats as a loose shell.
    translate([pkt_cx, pkt_cy, 0])
      for (sx=[-1,1], sy=[-1,1])
        translate([sx*(rk_w/2-rk_hole_pos), sy*(rk_h/2-rk_hole_pos), 0])
          cylinder(d=standoff_d, h=rk_standoff_h);
}

// ============================================================
// BEZEL: front frame that holds the screen against the backplate.
module bezel() {
    difference() {
        // outer frame
        cube([sc_w+2*wall, sc_h+2*wall, bezel_w]);
        // active-area window
        translate([(sc_w+2*wall)/2, (sc_h+2*wall)/2, -1])
          cube([sc_active_w, sc_active_h, bezel_w+2], center=true);
        // board recess lip (screw the board to the frame)
        translate([wall, wall, 0])
          cube([sc_w, sc_h, bezel_w-2]);
        // screen mounting holes (4 corners) - thread into bezel
        for (sx=[0,1], sy=[0,1])
          translate([wall + (sx? sc_w-sc_hole_inset : sc_hole_inset),
                     wall + (sy? sc_h-sc_hole_inset : sc_hole_inset), -1])
            cylinder(d=sc_hole_d, h=bezel_w+2);
    }
}

// ============================================================
if (PART == "coupon") coupon();
else if (PART == "backplate") backplate();
else if (PART == "bezel") bezel();
else if (PART == "preview") {
    // assemble for preview only
    color("white") backplate();
    translate([0,0,sc_t+wall]) color("silver") bezel();
    color("green") screen_board();
    translate([pkt_cx, pkt_cy, wall])
      color("darkgreen") cube([rk_w, rk_h, rk_t], center=false);
}
