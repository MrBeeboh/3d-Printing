#!/usr/bin/env python3
"""Overlay magenta-chroma OpenSCAD PNGs onto a base image (or a gray canvas)."""
import sys
from PIL import Image

CHROMA = (255, 0, 255)
FUZZ = 40
CANVAS = (248, 248, 248, 255)


def chroma_to_alpha(path):
    im = Image.open(path).convert("RGBA")
    px = im.load()
    w, h = im.size
    cr, cg, cb = CHROMA
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if abs(r - cr) <= FUZZ and abs(g - cg) <= FUZZ and abs(b - cb) <= FUZZ:
                px[x, y] = (0, 0, 0, 0)
    return im


def main():
    if len(sys.argv) < 3:
        sys.exit("usage: overlay-chroma.py OUT.png BASE.png [LAYER.png ...]")
    out = sys.argv[1]
    base_path = sys.argv[2]
    layers = sys.argv[3:]
    if base_path == "--canvas":
        sample = Image.open(layers[0])
        acc = Image.new("RGBA", sample.size, CANVAS)
    else:
        acc = Image.open(base_path).convert("RGBA")
    for path in layers:
        acc = Image.alpha_composite(acc, chroma_to_alpha(path))
    acc.convert("RGB").save(out)


if __name__ == "__main__":
    main()
