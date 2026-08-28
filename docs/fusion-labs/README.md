# Fusion 360 — Learning Track (Michael)

Goal: learn Fusion 360 well enough to design your own drone/FPV print parts
(brackets, TPU cradles, plates) and push them straight to the Ender-3 V3 SE.

Fusion runs **only on the KAMRUI Pinova P2** (Windows). HAL2026 is Linux — it
cannot run Fusion. Lessons are done at the KAMRUI, with this repo holding the
syllabus and notes.

---

## Lesson zero — install (do this first, at the KAMRUI)

1. Power on the KAMRUI, log into Windows.
2. Go to `https://www.autodesk.com/products/fusion-360/personal` → download
   Fusion (Personal Use is **free** for hobby/3D-printing work — that's all we need).
3. Create an Autodesk account if you don't have one. Use the same Google account
   you use for everything (`firesuppression@gmail.com`) so the login is one click.
4. Install, launch, sign in. The default "Design" workspace is what we use.
5. Confirm it opens and you see a grid + a cube (ViewCube) in the corner.

That's it. When it's installed, tell the agent and we start Lesson 1.

Notes:
- Do NOT install Cursor, an LLM, or anything else on the KAMRUI. It's the Fusion
  box, period. (16 GB RAM / Vega 6 iGPU is fine for one part at a time.)
- Designs auto-save to Autodesk cloud. Fine — we also export STL/3MF locally.

## Lessons

| # | Part you'll make | Skills | Est. time |
|---|------------------|--------|-----------|
| 1 | **JeNo7 antenna + CV50 bracket plate** (the 3MF you already have) | Sketch, dimension, extrude, cut, holes, fillet, export STL | 45–60 min |
| 2 | **TPU cradle** (LR900 or RP3 mount, remade from measurements) | Sketch on a side plane, extrude, shell, mirror, fillets | 60–90 min |
| 3 | **Parametric plate** (GNSS roof plate style) | User parameters, driven by measured hardware, hole table | 60 min |
| 4 | **Stack plate + hubs** (CV50 frame plate style) | Multi-body, circular pattern, countersunk holes | 90 min |

After lesson 4 you can design most of what this hobby needs. Anything fancier
(lofts, surfaces, assemblies) is on-demand later.

## House rules (same as the printer)

- **Measure first.** Calipers beat guesses. Every dimension in Fusion comes from
  real hardware or a real drawing — never "looks about right."
- **The slicer decides orientation and supports.** Fusion exports the part;
  OrcaSlicer owns how it prints. Never fight the slicer.
- Export STL (or 3MF) → OrcaSlicer → `AI-QUICKSTART.md` pipeline → print.
- One component at a time on the KAMRUI. No giant assemblies.

## Keyboard shortcuts (learn these, they're 90% of the work)

| Key | Action |
|-----|--------|
| `R` | Rectangle |
| `L` | Line |
| `C` | Circle |
| `D` | Dimension |
| `E` | Extrude |
| `Q` | Press-Pull (quick extrude/cut) |
| `H` | Hole |
| `F` | Fillet |
| `M` | Move / Copy |
| `Ctrl+Z` | Undo |
| scroll | Zoom |
| middle-drag | Orbit |
| Shift+middle-drag | Pan |
| double-click middle | Zoom to fit |

## Can the agent drive Fusion too?

Yes — later. Fusion has a built-in MCP server (`docs/fusion-mcp-setup.md`):
once you're comfortable driving it yourself, enabling that lets the agent take
the wheel for boring iterations (hole patterns, thickness changes) while you
stay in the seat for design decisions. Not needed for lessons 1–4.

## Progress log

| Date | Lesson | Part | Notes |
|------|--------|------|-------|
| — | 0 | Install | Pending (at KAMRUI) |
| — | 1 | JeNo7 ant + CV50 bracket plate | Written (real dimensions pulled from the 3MF mesh) |
