// 3 mm sketch coupon — side silhouette of Twnzl shoe+truss + pad.
// Size/shape check only. Not the final part.

arm_stl = "stl/twnzl_truss_arm_only.stl";

$fn = 32;
thick = 3.0;
m3 = 3.4;

// Vendor YZ -> XY: X=Y_vendor, Y=Z_vendor
// arm min after we shift: vendor Y 40.1..99.3, Z -36.3..58.4
// pad vendor Y 8..46, Z -46..24
// shift so min is 0: subtract (8, -46)

module silhouette() {
    translate([-8, 46, 0]) {
        // vendor (X,Y,Z) -> (Y,Z,X) so YZ lands on XY for projection
        projection(cut = false)
            multmatrix([[0, 1, 0, 0],
                        [0, 0, 1, 0],
                        [1, 0, 0, 0],
                        [0, 0, 0, 1]])
                import(arm_stl, convexity = 8);
        translate([8, -46, 0])
            square([38, 70]);
    }
}

difference() {
    linear_extrude(thick)
        silhouette();
    // holes: vendor (Y,Z)=(94.4, 14.61) and (94.4, 54.53)
    translate([94.4 - 8, 14.61 + 46, -1])
        cylinder(d = m3, h = thick + 2);
    translate([94.4 - 8, 54.53 + 46, -1])
        cylinder(d = m3, h = thick + 2);
}
