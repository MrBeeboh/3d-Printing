#!/usr/bin/env bash
# Re-render Hive / coupon PNGs in actual shelf filament: black + white PLA.
# Uses --render (F6) so OpenSCAD does not paint CSG cuts orange/blue.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p preview
OSCAD=(xvfb-run -a openscad --imgsize=1400,1000 --render --viewall --autocenter --projection=p --colorscheme=Tomorrow)

"${OSCAD[@]}" -D 'part="preview"' -o preview/hive-assembled.png zero3w_hive.scad
"${OSCAD[@]}" -D 'part="base"'    -o preview/hive-base.png      zero3w_hive.scad
"${OSCAD[@]}" -D 'part="lid"'     -o preview/hive-lid.png       zero3w_hive.scad
"${OSCAD[@]}" -D 'part="print"'   -o preview/hive-print.png     zero3w_hive.scad
"${OSCAD[@]}"                    -o preview/coupon.png         zero3w_coupon.scad
# Port wall: assembled, camera on the HDMI/USB edge
xvfb-run -a openscad --imgsize=1400,900 --render --projection=p --colorscheme=Tomorrow \
  --camera=36,0,12,70,0,25,160 \
  -D 'part="preview"' -o preview/hive-ports.png zero3w_hive.scad

echo "Wrote PRINTS/preview/*.png (black PLA base, white PLA lid, white coupon)"
