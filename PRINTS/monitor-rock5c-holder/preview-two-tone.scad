// monitor-rock5c-holder-preview.scad
// Two-tone render matching on-shelf filament: backplate BLACK, bezel WHITE.
// For preview only — printable parts come from monitor-rock5c-holder.scad.
use <monitor-rock5c-holder.scad>
backplate();
translate([0,0,14]) color("#f2f2f2") bezel();   // sc_t(7)+wall(2.8) ~ 9.8; 14 opens gap to see both
