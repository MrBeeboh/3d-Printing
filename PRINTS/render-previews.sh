#!/usr/bin/env bash
# Re-render Hive / coupon PNGs in actual shelf filament: black + white PLA.
#
# OpenSCAD 2021.01 --render (F6 / CGAL) ignores color() and paints the
# colorscheme: Tomorrow is teal #3e999f / yellow #eab700. That is why the
# previous exports still looked like Cornfield preview.
# Fix: custom schemes with matching CGAL front+back (black or white PLA),
# --render=true, and chroma overlay for two-tone assembled / print views.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p preview /tmp/hive-render
chmod +x overlay-chroma.py

SCHEME_DST="$PWD/xdg-config/OpenSCAD/color-schemes/render"
mkdir -p "$SCHEME_DST"
cp -f color-schemes/render/*.json "$SCHEME_DST/"
export XDG_CONFIG_HOME="$PWD/xdg-config"

# --render=true: 2021.01 requires a value or it swallows the next flag.
OSCAD=(xvfb-run -a openscad --imgsize=1400,1000 --render=true --viewall --autocenter --projection=p)
OSCAD_CAM=(xvfb-run -a openscad --imgsize=1400,1000 --render=true --projection=p)
OVERLAY=(python3 ./overlay-chroma.py)

# --- single-color parts (one scheme is enough) ---
"${OSCAD[@]}" --colorscheme=PLA-Black -D 'part="base"' -o preview/hive-base.png zero3w_hive.scad
"${OSCAD[@]}" --colorscheme=PLA-White -D 'part="lid"'  -o preview/hive-lid.png  zero3w_hive.scad
"${OSCAD[@]}" --colorscheme=PLA-White                  -o preview/coupon.png    zero3w_coupon.scad

# --- two-tone: same camera, black canvas + chroma lid (+ board) ---
HIVE_ASM_CAM=36,18,10,65,0,32,180
HIVE_PRINT_CAM=78,18,8,65,0,28,280
HIVE_PORT_CAM=36,0,12,70,0,25,160

"${OSCAD_CAM[@]}" --camera="$HIVE_ASM_CAM" --colorscheme=PLA-Black \
  -D 'part="preview"' -D 'show_lid=false' -D 'show_board=false' \
  -o /tmp/hive-render/asm-base.png zero3w_hive.scad
"${OSCAD_CAM[@]}" --camera="$HIVE_ASM_CAM" --colorscheme=PLA-White-Chroma \
  -D 'part="preview"' -D 'show_base=false' -D 'show_board=false' \
  -o /tmp/hive-render/asm-lid.png zero3w_hive.scad
"${OSCAD_CAM[@]}" --camera="$HIVE_ASM_CAM" --colorscheme=PCB-Chroma \
  -D 'part="preview"' -D 'show_base=false' -D 'show_lid=false' \
  -o /tmp/hive-render/asm-board.png zero3w_hive.scad
"${OVERLAY[@]}" preview/hive-assembled.png /tmp/hive-render/asm-base.png \
  /tmp/hive-render/asm-lid.png /tmp/hive-render/asm-board.png

"${OSCAD_CAM[@]}" --camera="$HIVE_PRINT_CAM" --colorscheme=PLA-Black \
  -D 'part="print"' -D 'show_lid=false' \
  -o /tmp/hive-render/print-base.png zero3w_hive.scad
"${OSCAD_CAM[@]}" --camera="$HIVE_PRINT_CAM" --colorscheme=PLA-White-Chroma \
  -D 'part="print"' -D 'show_base=false' \
  -o /tmp/hive-render/print-lid.png zero3w_hive.scad
"${OVERLAY[@]}" preview/hive-print.png /tmp/hive-render/print-base.png \
  /tmp/hive-render/print-lid.png

"${OSCAD_CAM[@]}" --camera="$HIVE_PORT_CAM" --colorscheme=PLA-Black \
  -D 'part="preview"' -D 'show_lid=false' -D 'show_board=false' \
  -o /tmp/hive-render/port-base.png zero3w_hive.scad
"${OSCAD_CAM[@]}" --camera="$HIVE_PORT_CAM" --colorscheme=PLA-White-Chroma \
  -D 'part="preview"' -D 'show_base=false' -D 'show_board=false' \
  -o /tmp/hive-render/port-lid.png zero3w_hive.scad
"${OSCAD_CAM[@]}" --camera="$HIVE_PORT_CAM" --colorscheme=PCB-Chroma \
  -D 'part="preview"' -D 'show_base=false' -D 'show_lid=false' \
  -o /tmp/hive-render/port-board.png zero3w_hive.scad
"${OVERLAY[@]}" preview/hive-ports.png /tmp/hive-render/port-base.png \
  /tmp/hive-render/port-lid.png /tmp/hive-render/port-board.png

# --- measured screw-together tray ---
CASE=../cad/radxa-zero-3w-case
mkdir -p "$CASE/preview"
CASE_ASM_CAM=36,18,10,65,0,32,180
CASE_PRINT_CAM=76,18,8,65,0,28,260
CASE_PORT_CAM=36,0,12,70,0,25,160

"${OSCAD[@]}" --colorscheme=PLA-Black -D 'part="base"' -o "$CASE/preview/base.png" "$CASE/zero3w_case.scad"
"${OSCAD[@]}" --colorscheme=PLA-White -D 'part="lid"'  -o "$CASE/preview/lid.png"  "$CASE/zero3w_case.scad"

"${OSCAD_CAM[@]}" --camera="$CASE_ASM_CAM" --colorscheme=PLA-Black \
  -D 'part="preview"' -D 'show_lid=false' -D 'show_board=false' \
  -o /tmp/hive-render/case-asm-base.png "$CASE/zero3w_case.scad"
"${OSCAD_CAM[@]}" --camera="$CASE_ASM_CAM" --colorscheme=PLA-White-Chroma \
  -D 'part="preview"' -D 'show_base=false' -D 'show_board=false' \
  -o /tmp/hive-render/case-asm-lid.png "$CASE/zero3w_case.scad"
"${OSCAD_CAM[@]}" --camera="$CASE_ASM_CAM" --colorscheme=PCB-Chroma \
  -D 'part="preview"' -D 'show_base=false' -D 'show_lid=false' \
  -o /tmp/hive-render/case-asm-board.png "$CASE/zero3w_case.scad"
"${OVERLAY[@]}" "$CASE/preview/assembled.png" /tmp/hive-render/case-asm-base.png \
  /tmp/hive-render/case-asm-lid.png /tmp/hive-render/case-asm-board.png

"${OSCAD_CAM[@]}" --camera="$CASE_PRINT_CAM" --colorscheme=PLA-Black \
  -D 'part="print"' -D 'show_lid=false' \
  -o /tmp/hive-render/case-print-base.png "$CASE/zero3w_case.scad"
"${OSCAD_CAM[@]}" --camera="$CASE_PRINT_CAM" --colorscheme=PLA-White-Chroma \
  -D 'part="print"' -D 'show_base=false' \
  -o /tmp/hive-render/case-print-lid.png "$CASE/zero3w_case.scad"
"${OVERLAY[@]}" "$CASE/preview/print-plate.png" /tmp/hive-render/case-print-base.png \
  /tmp/hive-render/case-print-lid.png

"${OSCAD_CAM[@]}" --camera="$CASE_PORT_CAM" --colorscheme=PLA-Black \
  -D 'part="base"' -o "$CASE/preview/base-ports.png" "$CASE/zero3w_case.scad"

echo "Wrote PRINTS/preview/*.png and cad/radxa-zero-3w-case/preview/*.png"
echo "(black PLA base, white PLA lid, white coupon)"
