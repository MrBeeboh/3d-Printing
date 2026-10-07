// Preview of the REAL boot + truss + 3mm pad
// Boot + truss = vendor mesh (Y>=41.5, capped). Pad = 3mm slab + M2.5 pilots.

part = "preview"; // [preview]

boot_pad_stl = "stl/twnzl_boot_pad.stl";

$fn = 24;

module part() {
    color([0.10, 0.10, 0.11])
        import(boot_pad_stl, convexity = 12);
}

module dummy_z3w() {
    // Zero 3W 65x30 on the pad -X face (pad YZ center 27,-11 in vendor coords)
    // pad X range 2.13..5.13, Y 8..46, Z -46..24
    color([0.15, 0.45, 0.18])
        translate([2.13, 27 - 15, -11 - 32.5])
            cube([1.6, 30, 65]);
}

module dummy_cam() {
    // 36x36 tape on the +X face of the pad
    color([0.22, 0.22, 0.25])
        translate([5.13, 27 - 18, -11 - 18])
            cube([1.6, 36, 36]);
}

part();
dummy_z3w();
dummy_cam();
