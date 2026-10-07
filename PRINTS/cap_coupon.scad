// Cap fit coupon — 40mm o/c slots, rotate 90° to test both orientations
difference() {
    cube([56, 24, 3]);
    for (sx = [-20, 20])
        translate([sx + 28, 12, -1]) hull() {
            translate([0, -2, 0]) cylinder(d = 3.4, h = 5);
            translate([0,  2, 0]) cylinder(d = 3.4, h = 5);
        }
}
