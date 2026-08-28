# Lesson 1 — Your First Part: the JeNo7 Antenna + CV50 Bracket Plate

**Part you'll recreate:** the `JeNo7 ant and cv50 bracket.3mf` you already have
(now in `DRONE Builds/JeNo7/Sentinel-on-JeNo7/`). We're going to rebuild it from
scratch in Fusion — and because you build it from measurements, you end up with a
**parametric** part you can change later (thicker plate? bigger holes? done in 30
seconds instead of redrawing).

**Time:** 45–60 min. **Skills:** sketch → dimension → extrude → cut → holes →
fillet → export STL.

---

## The measured part (from the actual 3MF mesh)

| Feature | Value |
|---------|-------|
| Plate outline | elongated hexagon, rounded ends, **112.4 × 40.0 mm** |
| Plate thickness | **3.0 mm** |
| 2× end through-holes | **6.4 mm** dia, on centerline (y=20), 9.2 mm from each tip |
| 4× corner through-holes | **3.2 mm** dia, at (19.75, 4.75), (19.75, 35.25), (50.25, 4.75), (50.25, 35.25) |
| 4× inner through-holes | **2.7 mm** dia, at (25, 10), (25, 30), (45, 10), (45, 30) |

Hardware guess: 3.2 mm = M3 clearance, 2.7 mm = M2.5, 6.4 mm = antenna/SMA pass.
**Verify with calipers before trusting the print** — mesh numbers are close, not gospel.

All coordinates are relative to the plate's bottom-left corner (x = along length, y = across width).

---

## Steps

### Stage 1 — Start and check units (2 min)

1. Open Fusion on the KAMRUI. New design: **File → New Design** (or Ctrl+N).
2. Check units: **Tools → Document Settings → Units** → `mm`. (Usually already mm.)
3. You'll see three planes (XY, XZ, YZ) and a cube in the corner (ViewCube). We work on **XY** = the top face of the plate.

### Stage 2 — Sketch the outline (15 min)

4. Press **`S`** to open the Sketch palette → **Create Sketch** (or click the
   Sketch icon) → click the **XY plane** (the grid).
5. Press **`R`** (Rectangle) → click near the origin, drag to about 100 × 40.
   Doesn't need to be exact — dimensions come next.
6. Press **`D`** (Dimension) → click the rectangle's left edge, then the right
   edge → type `112.4` → Enter.
7. Click the bottom edge, then the top edge → type `40` → Enter.
8. Dimension the left edge's distance from the origin → type `21.19` → Enter.
   (This centers the plate so x=0 is the left tip. If you'd rather keep it
   simple, type `0` — position doesn't matter for a print, only shape.)
9. **Rounded ends:** press **`F`**... no wait, that's Fillet and it's for 3D
   edges. In the sketch, use the **Fillet** tool in the Sketch palette (or press
   `F` inside the sketch) → click a corner → type `10` → Enter. Do all four
   corners. (Checkpoint: corners become arcs, the rectangle turns into a rounded
   plate.)
10. Look at the sketch lines: blue = under-defined, **black = fully defined**.
    When all lines are black, the sketch is locked down. Press **Finish Sketch**
    (top-right of the canvas, or press `S` → Finish Sketch).

### Stage 3 — Make it 3D (5 min)

11. Press **`E`** (Extrude) → click the sketch face → drag up or type `3` →
    Enter → **OK**. You now have a 3 mm plate.
12. Press **`6`** on the keyboard or **ViewCube → Top** to look straight down.

### Stage 4 — Cut the holes (15 min)

13. Press **`S`** → Create Sketch → click the **top face** of the plate (the flat
    face you just made).
14. Press **`C`** (Circle) → click anywhere → type the diameter. Draw **all ten
    circles** using the table above:
    - 2 circles, 6.4 mm — near the ends, on the centerline (y=20)
    - 4 circles, 3.2 mm — near the corners
    - 4 circles, 2.7 mm — between them
15. Dimension them into place with **`D`**:
    - Click a circle, then the left edge of the plate → type its x from the table
    - Click the circle, then the bottom edge → type its y
    - Repeat for all ten. (This is the tedious part the first time. It gets fast.)
    - Tip: to move the whole sketch instead of one circle, press **`M`** (Move),
      window-select everything, drag. But dimensioning is the skill — do it the
      long way today.
16. **Finish Sketch.** Press **`Q`** (Press-Pull) → click the middle of any
    circle → drag **down** (or type `3`) → this cuts through the plate. Press-Pull
    asks "Cut?" — click **Cut** → OK. Do this for all ten circles.
    (Alternative: press `E` and choose **Cut** — same result.)
17. Checkpoint: looking from above you see 10 clean holes through the plate.

### Stage 5 — Round the edges (5 min)

18. Press **`F`** (Fillet) → click the plate's **top edge** (the outline, not the
    holes) → type `0.8` → Enter → **OK**. Do the same for the bottom edge.
    (Slightly rounded edges = stronger print, nicer feel. Optional.)

### Stage 6 — Export (5 min)

19. Right-click the body in the browser (left sidebar, under "Bodies") → **Save
    as STL** (or **3MF** — matches the file you have).
20. In the dialog: **Format** STL, **Unit** mm. Use the default refinement (fine
    is fine for a plate this size). Save it somewhere obvious like `Desktop`.
21. Drag it into OrcaSlicer on HAL (or send it to me — I'll slice and print it).

**You just did 90% of all Fusion work.** Sketch → dimension → extrude → cut.
Everything else in this software is a variation.

---

## What's next

- Lesson 2: a **TPU cradle** (LR900/RP3) — introduces sketching on a **side**
  plane, mirroring, and the Shell tool. This is where mounts get comfortable.
- Play with Lesson 1 first: change the thickness to 4 mm (double-click the
  extrude feature in the timeline at the bottom → type 4). Watch the whole part
  update. That's the magic of parametric.
