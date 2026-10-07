// Probe: arm silhouette only (no pad), to read its true XY footprint in the shared frame.
arm_stl = "stl/twnzl_truss_arm_only.stl";
linear_extrude(3)
    translate([-8, 46, 0])
        projection(cut = false)
            multmatrix([[0,1,0,0],[0,0,1,0],[1,0,0,0],[0,0,0,1]])
                import(arm_stl, convexity = 8);
