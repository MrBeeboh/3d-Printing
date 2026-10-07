# FRED Orca Bible — HAL2026 / Ender-3 V3 SE / OrcaSlicer 2.4.2

**Slicer of record:** OrcaSlicer 2.4.2 AppImage  
`/home/mike/Applications/OrcaSlicer.AppImage` → `OrcaSlicer_V2.4.2.AppImage`  
**Printer:** Creality Ender-3 V3 SE, 0.4 mm nozzle, Klipper (Moonraker `http://192.168.0.18:7125`)  
**Filament this bible assumes:** PLA (Creality Generic PLA @Ender-3V3-all). TPU is a different process — see `docs/TPU.md`.  
**Written:** 2026-09-02. Do not start a print from this file.

Official wiki: https://www.orcaslicer.com/wiki/  
Local mirror: `docs/orcaslicer-wiki/`  
Companion shop notes: `docs/ORCA.md`, `docs/PRINT-OPERATIONS.md`, `PRINTS/slice_print.py`

This file supersedes older “let Orca auto-orient everything” and “always strip `SET_VELOCITY_LIMIT`” rules **for trays, cases, lids, dual-object plates, and first-layer text**. Those older rules remain in `ORCA.md` / `AI-QUICKSTART.md` / `slice_print.py`. Where they conflict, **this bible wins**, with evidence cited.

---

## 0. Hard lessons (ESP32-32E case, 2026-09-02) — do not contradict without new evidence

Measured on HAL from the actual slices in `/tmp/ESP32-32E-*` and `PRINTS/ESP32-32E/`.

| Failure | What the slice actually did | Gate |
|---|---|---|
| `--orient 1` / `--allow-rotations` on a tray/case | Back STL stood an ~8 mm part on a 92 mm edge. Gcode: `; max_z_height: 92.00`. First layer bbox **44.7 × 5.1 mm**, 176 moves, 1 outer + 1 inner wall. | If `max_z_height` ≈ the **long** edge, not the intended thickness → **DO NOT PRINT**. |
| Rims on the bed, floor in the air | Bed-down slice: 9× `;TYPE:Bridge` at Z 0.4, 2 more at 0.8. First layer is walls, then it bridges the floor. | First-layer plot of **only corner arcs / rim walls, no filled floor** → **DO NOT PRINT**. |
| Proud 0.8 mm letters on the outer face, that face on the bed | Letters become stilts. First-layer squish is the whole glyph. | Flatten letters to **≤ first-layer height**, or put letters **UP** (not on the bed). |
| `slice_print.py --load-settings` “quality” | Every ESP32 `result.json`: `return_code: -100`, `wall_loops: 2`, `sparse_infill_density: 15`. Gcode CONFIG_BLOCK confirms `; wall_loops = 2` / `; sparse_infill_density = 15%` / `crosshatch`. Shop quality is **3 / 20% gyroid**. | Trust **gcode comments**, not `result.json`, not the unused `QUALITY = [--perimeters=3, …]` list in `slice_print.py`. |
| Shop splice strips `SET_VELOCITY_LIMIT` | Unspliced Orca Klipper gcode emits `SET_VELOCITY_LIMIT ACCEL=500` (first layer) then `1000` (outer wall) then `1500` (travel / default, machine-capped). After splice: **zero** `SET_VELOCITY_LIMIT`. Live Klipper then runs first layer at **5000**. | That smears text and can **skip** on travel between two parts. Dual-object travel is ~one-part-width; a skip looks like a **56 mm shift**. **KEEP `SET_VELOCITY_LIMIT` on this Klipper.** |

`slice_print.py` still does the old (now-wrong-for-cases) things: `--orient 1 --arrange 1 --allow-rotations`, loads the **system** 2-wall/15% process, never passes its own `QUALITY` flags, injects **wrong support JSON keys**, and **strips every `SET_VELOCITY_LIMIT`**. Do not drive a case/tray/lid through that script unchanged.

---

## 1. This machine’s real presets (read from disk, 2026-09-02)

### 1.1 Machine — `~/.config/OrcaSlicer/user/default/machine/Ender-3 V3 SE (Klipper).json`

Must stay `"from": "user"` and `"instantiation": "true"` or CLI dies with `file ...'s from unsupported`.

| Key | Value | Notes |
|---|---|---|
| `inherits` | `Creality Ender-3 V3 SE 0.4 nozzle` | Stock parent is `gcode_flavor: marlin2`. This override sets `klipper`. |
| `printable_area` | 220×220 | Parent already 220; do not fall back to 200×200 stubs. |
| `printable_height` | 250 | |
| `gcode_flavor` | `klipper` | Causes Orca to emit `SET_VELOCITY_LIMIT`, not Marlin `M204`. |
| `machine_start_gcode` | `PRINT_START BED=[bed_temperature_initial_layer_single] EXTRUDER=[nozzle_temperature_initial_layer]` | Splice still rewrites this. |
| `machine_end_gcode` | `PRINT_END` | |
| `machine_max_acceleration_x/y` | **5000** | User override. Parent 0.4-nozzle JSON is 2500. |
| `machine_max_acceleration_z` | 500 | |
| `machine_max_speed_x/y` | 250 | Matches Klipper `max_velocity: 250`. |
| `exclude_object` | true | Needed for adaptive purge / cancel-object. |
| `print_host` | `http://192.168.0.18:7125` | GUI only. Agents upload via curl. |

Parent `Creality Ender-3 V3 SE 0.4 nozzle.json` still supplies `machine_max_acceleration_extruding` / `_travel` (2500 in the system file). ESP32 gcode CONFIG_BLOCK showed `machine_max_acceleration_extruding = 1500,1250` and travel `SET_VELOCITY_LIMIT ACCEL=1500` — Orca **caps** process accel to Motion Ability. Wiki: *“Orca will limit the acceleration to not exceed the acceleration set in the Printer's Motion Ability settings.”* (`speed_settings_acceleration`)

Live Klipper `printer.cfg` copy in `configs/printer-creality-ender3-v3-se-2023.cfg` has `max_accel: 2500`. Shop ops docs and the ESP32 skip say the **running** host is **5000**. Do not assume the repo copy is live. After splice-stripping, first layer is whatever Klipper `max_accel` is — on this host that is **5000**.

### 1.2 System process — `0.20mm Standard @Creality Ender3V3SE 0.4.json`

**This is NOT shop quality.** It is Creality’s Standard. `inherits: fdm_process_creality_common` (which has `wall_loops: 3`, `skirt_loops: 1`) and then **overrides down**:

| Key | System Standard (what CLI actually loads today) | Shop quality (intended) | Fast / draft |
|---|---|---|---|
| `layer_height` | 0.2 | 0.2 | 0.28 |
| `initial_layer_print_height` | **0.25** | 0.20–0.25 (text: 0.20) | 0.28 |
| `initial_layer_line_width` | **0.46** | **0.42–0.45 for first-layer text**; 0.46 ok for bulk | 0.46 |
| `initial_layer_speed` | 30 | 30 | 40 |
| `initial_layer_infill_speed` | 80 | 30–50 for text/floors | 50 |
| `initial_layer_acceleration` | **500** | **500 — must reach the printer** | 1000 (V3SE Speed user preset) |
| `wall_loops` | **2** | **3** | 2 |
| `sparse_infill_density` | **15%** | **20%** | 15% |
| `sparse_infill_pattern` | **crosshatch** | **gyroid** | rectilinear |
| `elefant_foot_compensation` | **0** | **0** (0.05 max). 0.2 erases letter strokes | 0 |
| `ironing_type` | `no ironing` | **off** — irons smear letters | off |
| `brim_type` | `no_brim` | no brim for cases; **6 mm brim + mouse ears** for large disks | no_brim |
| `skirt_loops` | **0** | **1**, `skirt_distance: 4` | 1 |
| `outer_wall_speed` / inner / infill | 60 / 90 / 180 | keep | faster |
| `default_acceleration` | 2500 | 2500 | 5000 (V3SE Speed) |
| `outer_wall_acceleration` | 1000 | 1000 | 3000 |
| `inner_wall_acceleration` | 2000 | 2000 | 4000 |
| `travel_acceleration` | 2500 | 2500 (emitted as 1500 if machine extruding cap is 1500) | 6000 |
| `enable_support` | 0 | JSON-only when needed | 0 |
| `support_type` | `normal(auto)` | `tree(auto)` + organic, or `normal(auto)` + grid | — |
| `wall_generator` (CONFIG_BLOCK) | **arachne** | keep Arachne for thin glyphs | classic ok |
| `bottom_shell_layers` / top | 4 / 4 | 4 / 4 | 3 |
| `bridge_flow` / `bridge_speed` | 0.95 / 100 | keep; **count bridges by layer** | — |

`fdm_process_creality_common` still has `wall_loops: 3` and `skirt_loops: 1`. The Ender3V3SE Standard **overrides those to 2 and 0**. Loading “0.20mm Standard” will **never** give 3/20% gyroid. That is why `result.json` says 2/15% even when `--load-settings` “worked.”

User process `V3SE Speed.json` only overrides speeds/accels; it still inherits 2 walls / 15%. Do not use it for show parts or text.

### 1.3 Filament — `Creality Generic PLA @Ender-3V3-all.json`

| Key | Value |
|---|---|
| `nozzle_temperature` | 195 |
| `nozzle_temperature_initial_layer` | **200** |
| All plate temps (cool/eng/hot/textured, first layer too) | **55** |
| `filament_flow_ratio` | 1.095 |
| `filament_max_volumetric_speed` | 18 |

Temps are owned by `PRINT_START BED=55 EXTRUDER=200`. Strip slicer `M104/M109/M140/M190`. Do **not** strip `M83`.

Wiki start-gcode uses `G90` + `M83`. This Klipper has **no** `relative_extrusion` in `printer.cfg`. Orca E is relative (`; use_relative_e_distances = 1`). No `M83` → first layer starves. Paid for 2026-08-17.

---

## 2. CLI that actually exists (Orca 2.4.2)

Live `AppImage --help` was blocked in this session (Auto-review: executable AppImage). Flag table below is from the shop Hermes skill dump of **`--help` on this 2.4.2 binary** plus the Printago 2.4.0 `--help` grouping (2.4.2 adds `--logfile` only).

```
OrcaSlicer.AppImage [ OPTIONS ] [ file.3mf/file.stl ... ]
```

Priority (Orca): **CLI PrintConfig keys > `--load-settings` / `--load-filaments` > 3MF**.

### 2.1 Flags that matter here

| Flag | Meaning | Shop rule |
|---|---|---|
| `--slice 0` | Slice **all** plates (`i` = plate i) | Always `0` for STL CLI. Output `*_1.gcode` + `result.json` in `--outputdir`. |
| `--outputdir DIR` | Where gcode lands | Always set. Default names `plate_1.gcode`. |
| `--load-settings "A.json;B.json"` | Process + machine, semicolon-separated, **real Orca presets** (`"type": "process"` / `"machine"`) | **This shop (2.4.2 `--help` + working `slice_print.py`): process THEN machine.** Reverse order is what Printago documents; do not mix blindly. Bare dumps → `unknown config type` / `setup params error`. |
| `--load-filaments "fila.json"` | Filament preset | Always the Creality Generic PLA path above. |
| `--orient 0\|1` | `0` disable, `1` enable, other = auto | **`0` for trays / cases / lids / anything with a designed floor.** `1` stood the ESP32 back on a 92 mm edge. |
| `--arrange 0\|1` | Pack the plate | `1` is ok **after** orientation is locked. Still verify pairwise gaps — arrange can overlap (~1.3 mm X / 3 mm Y, Walksnail 2026-08-20). |
| `--allow-rotations` | Arrange may yaw parts | **OFF for trays/cases.** Combined with `--orient 1` it is how the 92 mm tower happened. |
| `--ensure-on-bed` | Lift if mesh is below Z=0 (off by default) | **ON.** `--rotate-x 180` **SIGSEGV’d** without it (CYD 2026-08-31). |
| `--rotate` / `--rotate-x` / `--rotate-y` | Degrees | Prefer **pre-flip the mesh** (trimesh). `--orient 1` **re-flips** an operator flip. |
| `--assemble` | Merge inputs into one object | Do not use to fake a layout. |
| `--export-3mf FILE` | Project 3MF (gcode inside if sliced) | Use this to set part spacing via instance transforms. `object_spacing` is **not** a process key (silently ignored). |
| `--no-check` | Skip path-conflict checks | Do not use as a crutch. |
| `--debug N` / `--logfile FILE` | 0 fatal … 5 trace | Use when `--load-settings` looks dead. |
| `--info` | Model info, no slice | |
| `--help` / `-h` | This table | Re-run after any Orca upgrade. |

**There are no `--printer` / `--filament` / `--process` name flags in 2.4.2.** There are **no support CLI flags**. Prusa `--support-material`, `--export-gcode`, `--perimeters`, `--fill-density` are **invalid or inert** here. `slice_print.py` defines `QUALITY = ["--perimeters=3", "--fill-density=20%", …]` and **never passes them**. Even if it did, those are Prusa names. Orca keys are `--wall_loops` and `--sparse_infill_density`.

Any PrintConfig key can be passed as a CLI flag (Printago; `src/libslic3r/PrintConfig.cpp`). That is how quality 3/20 actually sticks — see §7.

### 2.2 `result.json` is a liar when `return_code` is -100

ESP32 slices **wrote valid `plate_1.gcode`** and also:

```json
"return_code": -100,
"error_string": "Failed slicing the model. Please verify the slicing of all plates on Orca Slicer before uploading.",
"wall_loops": 2,
"sparse_infill_density": 15.0
```

`-100` here is **not** “no gcode.” It is Orca asking for a GUI verify. `wall_loops: 2` is the **system Standard process**, not proof that `--load-settings` failed to load a file. It **is** proof that shop quality 3/20 was never in the file that loaded.

**Always verify the gcode CONFIG_BLOCK** (`grep` the keys in §4). If gcode exists, inspect it. Do not abort solely on `-100`, and do not treat 2/15 in `result.json` as “quality loaded.”

---

## 3. Orientation — trays vs lids vs cases

### 3.1 Law

1. **Bake orientation into the STL** (OpenSCAD / trimesh). Then slice with `--orient 0 --ensure-on-bed`. `--arrange 1` only to pack **already-correct** parts.
2. **NEVER `--orient 1` / `--allow-rotations` on a tray, dish, box, case half, or lid.** Auto-orient optimizes contact area / unprintability heuristics. It will stand a shallow shell on a rim. Evidence: `; max_z_height: 92.00` for an 8 mm back.
3. **Largest functional floor on the bed.** Rims, lips, and window openings point **+Z**. Openings on the bed = hole rims bed-supported **and** the floor becomes a bridge.
4. **Proud features (letters, pads, barbs) are not feet** unless they are designed as feet and you accept stilts.

### 3.2 Trays / dishes / boxes (floor + rim)

| Want | First layer | `max_z_height` | Fail signature |
|---|---|---|---|
| Floor on bed, rims up | Filled rectangle ≈ tray outline. Many extrusion moves. `;TYPE:Bottom surface` present. **No** `;TYPE:Bridge` on layer 1 / Z≈0.2–0.4. | ≈ wall height (a few mm … tens of mm), **not** the diagonal of the floor | **Only corner arcs / rim loops**, few hundred moves, bbox is a **thin strip** (e.g. 45 × 5 mm), or bridges at Z 0.4 spanning the floor. **DO NOT PRINT.** |

RTK Ø155 disk also taught: large flat floors warp. Use **skirt + 6 mm brim / mouse ears at stress risers + bed 60 °C**, not auto-orient.

### 3.3 Lids

Hive lid (2026-08-16): as-exported, lattice panel floated 5.2 mm on two 1.35 mm barbs = 70 mm lattice bridge. **Flip 180° about Y so the large panel is on the bed.** Barbs print up as walls.

- Flip about **Y**, not X, or labels land in cutouts (CGAL drops the difference with no warning).
- If the lid has **proud letters on the outer face**: those letters must **not** be the bed contact. Either engrave (negative, ≤ first-layer height) so the **panel** is still the bed, or print letters-up and accept the inner face on the bed **only if** that inner face is a real floor (not rims).

### 3.4 Case halves (ESP32 / CYD)

| Part | Orientation | Why |
|---|---|---|
| **Back with proud 0.8 mm letters** | Letters **UP**. Outer labeled face is **not** the bed. | 0.8 mm glyphs on the bed = stilts. First-layer squish irons them. |
| **Back with letters flattened ≤ first-layer height** | Labeled face **may** be the bed, as a **flat plate**. | Only if the letters are no taller than `initial_layer_print_height`. |
| **Front with window/lip** | Window/lip as designed. Do **not** flip “to avoid bridging” without re-checking. | CYD: flipping the flanged front put the flange in the air → 9 bridges at Z 7.4–11.6 + “floating cantilever.” Back (no flange) flipped clean: 0 bridges. |
| **Two halves on one plate** | Each pre-oriented. `--orient 0 --arrange 1` **without** `--allow-rotations`. Gap ≥ 8 mm, verify extrusion-only pairwise gap. | Travel between parts ≈ one-part-width. A skip looks like a 56 mm shift. Keep first-layer / travel accel via `SET_VELOCITY_LIMIT` (§6). |

Operator-directed flip: **pre-flip the mesh**, then `--orient 0 --ensure-on-bed`. Present **both** orientations with `max_z_height`, first-layer bbox, bridge counts, and `warning_message` when a flip creates a new cantilever.

### 3.5 How to pre-flip (do this, not `--rotate-x 180` as the only step)

```python
import trimesh, numpy as np
m = trimesh.load("part.stl")
m.apply_transform(trimesh.transformations.rotation_matrix(
    np.pi, [0, 1, 0], point=m.bounds.mean(axis=0)))  # 180 about Y
# or [1,0,0] for 180 about X — only after you know which axis
m.export("part-print.stl")
```

Then STL bbox Z-extent must equal the **intended print height**.

---

## 4. How to verify a slice (mandatory, every plate)

Do this on the **unspliced** `plate_1.gcode` first (header + CONFIG_BLOCK live there), then again on the spliced file for `M83` / temps / `SET_VELOCITY_LIMIT`.

### 4.1 Header (`HEADER_BLOCK`)

```
; HEADER_BLOCK_START
; generated by OrcaSlicer 2.4.2 on ...
; max_z_height: 8.40
; HEADER_BLOCK_END
```

| Check | Pass | Fail |
|---|---|---|
| `; max_z_height:` | ≈ designed thickness | 92 mm for an 8 mm case; 148 mm tower (old Sentinel) |
| `; generated by OrcaSlicer 2.4.2` | This binary | Anything else |

### 4.2 Object names

```
; printing object ESP32-32E-Back-print.stl id:… copy 0
; stop printing object ESP32-32E-Back-print.stl id:… copy 0
```

- Every intended STL appears. Dual plate: **two** names, alternating per layer (`print_sequence: by layer`).
- Names tell you **which orientation file** was loaded (`*-bed.stl` vs `*-print.stl` vs `*-flat.stl`). If the name says `bed` you are on the rim-down path.
- Layout plots must use **extrusion-only** moves (`G1 … E>0`) between these markers. Travel jumps **between** objects fake overlap (2026-08-21).

### 4.3 CONFIG_BLOCK (end of file, before splice-appended `M104 S0`)

```
; CONFIG_BLOCK_START
; wall_loops = 3
; sparse_infill_density = 20%
; sparse_infill_pattern = gyroid
; initial_layer_print_height = …
; initial_layer_line_width = …
; initial_layer_speed = 30
; initial_layer_acceleration = 500
; elefant_foot_compensation = 0
; ironing_type = no ironing
; brim_type = no_brim
; skirt_loops = 1
; enable_support = 0
; support_type = tree(auto)
; layer_height = 0.2
; first_layer_height = 0.200
; CONFIG_BLOCK_END
```

**This is the quality preset verification.** If `; wall_loops = 2` and `; sparse_infill_density = 15%`, you loaded Standard, not quality — even if you *meant* 3/20.

Also confirm:

```
grep -E '^; (wall_loops|sparse_infill_density|sparse_infill_pattern|initial_layer_acceleration|elefant_foot|ironing_type|skirt_loops|enable_support|support_type|max_z_height) ' plate_1.gcode
```

(`max_z_height` is in the **header**, not CONFIG_BLOCK.)

### 4.4 First-layer move count + plot

Parse extrusion moves at `;Z:` ≈ first layer (`0.20` or `0.25`).

| Signature | Meaning | Action |
|---|---|---|
| One large filled rectangle, thousands of E-moves, bbox ≈ designed floor, center near 110,110 | Floor on bed | Continue checks |
| Thin strip, e.g. 45 × 5 mm, ~100–200 moves, 1 outer + 1 inner | Part on an **edge** (92 mm tower class) | **DO NOT PRINT** |
| Two small islands ~fastener spacing apart | Standoffs as feet, air bridge between | **DO NOT PRINT** |
| Outer-wall loops only at the four corners / rim, little or no `;TYPE:Bottom surface` | **Rims on bed** | **DO NOT PRINT** |
| Dual objects, two filled islands, gap ≥ 8 mm, travel between them | OK **if** `SET_VELOCITY_LIMIT` kept | Measure gap from extrusion bbox only |

ESP32 standing: 176 L1 moves, bbox 44.7 × 5.1. ESP32 bed-down (rims + letters): 9987 L1 moves, 47 outer-wall groups — not a thin strip, but **9 bridges at Z 0.4** (floor in the air). Move count alone is not enough; **types + bridges + bbox** together are.

### 4.5 Bridges by layer

```
;Z:0.4
;TYPE:Bridge
```

Count `;TYPE:Bridge` grouped by the preceding `;Z:`.

| Where | Meaning |
|---|---|
| Z ≈ first 1–2 layers, spanning the floor | Rims on bed / floor bridged. **DO NOT PRINT** that orientation. |
| Z at a window/lip after an operator flip | Flip created a new cantilever. Show both orients. |
| Z high, small count, local | Often acceptable (screw bosses, letter bridges). Still report the numbers. |
| Zero bridges after enabling supports | Supports actually took. Confirm `;TYPE:Support interface` exists. |

CYD: `support_type: "normal"` (bare) → 20 bridges. Same part with `tree(auto)` → 0 bridges.

### 4.6 `result.json`

Read `sliced_plates[].warning_message` when present. `"floating regions"` / `"floating cantilever"` = act (re-orient, supports, or operator override). **Never** “just a label.”

If the file is the `-100` shape with **no** `sliced_plates`, ignore `wall_loops`/`sparse_infill_density` from it and use CONFIG_BLOCK.

### 4.7 After splice

1. First lines: `PRINT_START BED=55 EXTRUDER=200`, then `M220`, `M221`, `M106`, `G90`, `G21`, **`M83`**.
2. **No** `M104/M109/M140/M190` in the body (macro owns temps). The splice may append `M104 S0` / `M140 S0` / `M84` at end — that is shutdown, fine.
3. **`SET_VELOCITY_LIMIT` still present** on this Klipper (§6). `grep -c '^SET_VELOCITY_LIMIT' spliced.gcode` should be hundreds to thousands, not 0. First occurrences must include `ACCEL=500`.
4. Do not upload unspliced gcode (bed target 0 — burned twice). Do not upload spliced gcode that stripped `M83` or stripped all accel limits.

---

## 5. Readable first-layer text on a 0.4 mm nozzle

Wiki: first layer **0.25 mm** recommended for 0.4 mm (62.5% of nozzle; max 65% = 0.26). Layer height 20–80% of nozzle (0.08–0.32). (`quality_settings_layer_height`)

Shop ESP32 notes + Orca emboss thread: features **thinner than first-layer height get merged away**. Proud 0.8 mm letters on the bed become stilts; 0.12–0.16 mm strokes are half a line and illegible.

### 5.1 Geometry first

| Rule | Number |
|---|---|
| Stroke width | **≥ 0.5 mm** (one full perimeter on 0.4 mm). 0.12–0.16 mm strokes are trash. |
| If letters are **on the bed** (engraved or flattened) | Height **≤ `initial_layer_print_height`** (0.20–0.25). Flatten proud bosses. |
| If letters are **proud on the outer face** | Print that face **UP**. Do not put 0.8 mm bosses on the bed. |
| If letters are **on top** (last layers) | `only_one_wall_top` can help small glyphs; wiki warns artifacts if `min_width_top_surface` is wrong. Prefer CAD that leaves a real top surface. |
| Ironing | **Off.** Irons = smear. (`ironing_type: no ironing`) |
| Elephant foot | **0** (0.05 mm max). 0.2 mm (Prusa MK3.5 3MF) erases strokes. Wiki key is **`elefant_foot_compensation`** (sic). Compensation insets the first-layer outer wall — that **kills** first-layer glyphs. |

### 5.2 Slice settings for bed-text (0.4 mm PLA)

| Key | Value | Why |
|---|---|---|
| `initial_layer_print_height` | **0.20** (not 0.25) | Standard’s 0.25 buries 0.20-deep engraving. Wiki 0.25 is for adhesion on bulk parts. |
| `initial_layer_line_width` | **0.42–0.45** | Standard 0.46 (and 0.5–0.6) merges strokes. |
| `initial_layer_speed` | **30** | Wiki: slow first layer for adhesion. Faster smears glyphs. |
| `initial_layer_infill_speed` | **30–50** (not 80) | Standard 80 is too fast for letter bowls. |
| `initial_layer_acceleration` | **500** | Must actually reach Klipper — **keep `SET_VELOCITY_LIMIT`**. |
| `wall_loops` | **3** | Letter islands need walls. |
| `detect_thin_wall` | 1 (already on Standard) | Single-line strokes. Arachne is on in CONFIG_BLOCK — keep it. |
| `elefant_foot_compensation` | 0 | |
| `ironing_type` | `no ironing` | |
| `only_one_wall_first_layer` | consider **1** if the letter is a tiny top-of-island on layer 1 | Wiki: one wall on flat surfaces so infill can fill letter bowls. |
| `small_area_infill_flow_compensation` | consider **1** | Wiki: small letter tops over-extrude without it. |
| Skirt | `skirt_loops: 1`, `skirt_distance: 4` | Prime before glyphs. Best print 2026-08-19 used a skirt. Standard has `skirt_loops: 0` — override. |

Z-offset: paper should **drag with a little catch**. Glossy ironed square → raise Z +0.04. Shop baked Z-offset 1.70 (2026-08-19 coupon) — do not chase text by mashing Z negative.

### 5.3 Emboss tool (wiki `prepare_emboss`)

GUI Emboss creates a 3D text volume (emboss / engrave / **modifier**). For a **flat** first-layer label, use **modifier / negative** so the bottom stays planar. Thickness < first-layer height → slicer merges the text into the body (Orca PR #2819). CLI does not expose Emboss; bake text in CAD.

---

## 6. `SET_VELOCITY_LIMIT` — KEEP on THIS Klipper

### 6.1 What Orca emits (measured, ESP32 letters-up plate, 1918 commands)

| `SET_VELOCITY_LIMIT` | Count (that plate) | Source process/machine key |
|---|---|---|
| `ACCEL=500 ACCEL_TO_DECEL=250` | 111 | `initial_layer_acceleration = 500` (accel_to_decel 50%) |
| `ACCEL=1000 ACCEL_TO_DECEL=500` | 875 | `outer_wall_acceleration = 1000` |
| `ACCEL=1500 ACCEL_TO_DECEL=750` | 932 | default / travel, **capped** by machine extruding/travel ability (~1500 in that CONFIG_BLOCK) |

Wiki (`speed_settings_acceleration`): per-feature accel (initial layer, outer, inner, travel, top, infill, bridge). Lower initial-layer accel **improves bed adhesion**. Wiki Motion Ability: `emit_machine_limits_to_gcode` is **ignored for Klipper flavor** — that flag is Marlin `M201` limits, **not** these per-feature `SET_VELOCITY_LIMIT` lines. Klipper flavor **does** emit `SET_VELOCITY_LIMIT` from process accel keys.

The old shop claim “Orca injects one low ACCEL and never resets” is **false** on 2.4.2 Klipper gcode. It toggles every feature change (thousands of times per plate).

### 6.2 What the splice does today

`slice_print.py` `splice()`:

```python
body = [ln for ln in body if not ln.startswith('SET_VELOCITY_LIMIT')]
```

After splice: **0** limits. First layer then runs at live Klipper `max_accel` (**5000** on this host per ops docs / ESP32 skip). Text smears. Travel between two parts at 5000 with a ~part-width hop **skips**; the next extrusion lands ~56 mm off.

`PRINT-OPERATIONS.md` §3, `AI-QUICKSTART.md` §4, and Hermes `orcaslicer` skill still say strip it so “Klipper owns 5000.” That was a **speed** rule for chunky functional parts. It is the **wrong** rule for this printer when:

- first-layer text / fine perimeters exist, or
- two objects share a plate (long travel), or
- `initial_layer_acceleration` is 500 for a reason.

### 6.3 Rule for THIS Klipper (PLA, E3V3SE)

**KEEP `SET_VELOCITY_LIMIT`.** Stop stripping it.

Still strip `M104/M109/M140/M190`. Still keep `M83`. Still call `PRINT_START`.

If a future functional-only, no-text, single-object slab needs raw 5000 everywhere, that is an **explicit operator exception**, not the default. Do not restore stripping in `slice_print.py` without changing this file.

Optional (not required if Orca already emits 500/1000/1500): after `PRINT_START`, you may add a safety floor:

```
SET_VELOCITY_LIMIT ACCEL=500 ACCEL_TO_DECEL=250
```

before layer 1, but **do not delete** the rest of Orca’s per-feature commands.

Klipper will still clamp to `[printer] max_accel`. If live `max_accel` is 2500, you will never see 5000 even with limits stripped. The ESP32 skip says the running host **can** 5000 — treat 5000 as the danger number.

---

## 7. CLI recipe that actually loads shop quality (3 walls / 20% gyroid)

### 7.1 Why `--load-settings` “fails”

Three separate bugs, often stacked:

1. **Wrong file contents.** System `0.20mm Standard @Creality Ender3V3SE 0.4.json` **is** 2 / 15% crosshatch. Loading it “successfully” produces exactly the `result.json` you have been reading.
2. **Prusa flag names never applied.** `QUALITY = ["--perimeters=3", "--fill-density=20%", "--fill-pattern=gyroid", …]` is dead code. Orca wants `--wall_loops 3 --sparse_infill_density 20% --sparse_infill_pattern gyroid`.
3. **`return_code: -100` with gcode still written.** Do not interpret -100 as “settings did not load.” Verify CONFIG_BLOCK.

`--load-settings` **does** load JSON when the files are real presets (`type` + `from` + `instantiation`). User machine must be `"from": "user"`. Order on this 2.4.2: **process;machine**.

### 7.2 Build a shop quality process (do not edit the system file)

Write `/tmp/v3se_quality_0.20.json` (or a user preset under `~/.config/OrcaSlicer/user/default/process/`) as a **full instantiation** that inherits Standard and then overrides the shop deltas:

```json
{
  "type": "process",
  "name": "0.20mm Quality @E3V3SE 0.4",
  "from": "user",
  "instantiation": "true",
  "inherits": "0.20mm Standard @Creality Ender3V3SE 0.4",
  "layer_height": "0.2",
  "initial_layer_print_height": "0.2",
  "initial_layer_line_width": "0.42",
  "initial_layer_speed": "30",
  "initial_layer_infill_speed": "40",
  "initial_layer_acceleration": "500",
  "wall_loops": "3",
  "sparse_infill_density": "20%",
  "sparse_infill_pattern": "gyroid",
  "elefant_foot_compensation": "0",
  "ironing_type": "no ironing",
  "brim_type": "no_brim",
  "skirt_loops": "1",
  "skirt_distance": "4",
  "skirt_height": "1",
  "enable_support": "0"
}
```

For **text on the bed**, keep `initial_layer_line_width` 0.42. For **bulk no-text**, 0.46 is fine.

Supports: copy this JSON and apply §8 keys; do not use `slice_print.py --supports` until its `SUPPORT_KEYS` are fixed.

### 7.3 Command (trays / cases / lids — orientation locked in the STL)

```bash
ORCA=/home/mike/Applications/OrcaSlicer.AppImage
PROC=/tmp/v3se_quality_0.20.json
MACHINE="/home/mike/.config/OrcaSlicer/user/default/machine/Ender-3 V3 SE (Klipper).json"
FILA="/home/mike/.config/OrcaSlicer/system/Creality/filament/Creality Generic PLA @Ender-3V3-all.json"
OUT=/tmp/part_orca
mkdir -p "$OUT"

"$ORCA" /path/to/floor-down.stl \
  --slice 0 --outputdir "$OUT" \
  --orient 0 --arrange 1 --ensure-on-bed \
  --load-settings "${PROC};${MACHINE}" \
  --load-filaments "$FILA" \
  --wall_loops 3 \
  --sparse_infill_density 20% \
  --sparse_infill_pattern gyroid \
  --skirt_loops 1 \
  --skirt_distance 4 \
  --elefant_foot_compensation 0 \
  --ironing_type "no ironing"

# Belt-and-suspenders: CLI keys outrank JSON (Orca priority).
```

Two STLs on one plate: pass both paths, still `--orient 0`, **no** `--allow-rotations`. Then verify pairwise extrusion gaps.

Chunky functional part with **no** designed floor (a bracket you *want* auto-orient for): `--orient 1 --arrange 1 --allow-rotations --ensure-on-bed` is legal **after** you still pass the §4 gates. Do not use that set on shells.

### 7.4 Immediately after slice

```bash
G="$OUT/plate_1.gcode"   # or *_1.gcode
echo "=== header ==="
sed -n '1,20p' "$G"
echo "=== quality keys ==="
rg -n '^; (wall_loops|sparse_infill_density|sparse_infill_pattern|initial_layer_print_height|initial_layer_line_width|initial_layer_acceleration|elefant_foot_compensation|ironing_type|skirt_loops|enable_support|support_type) ' "$G"
echo "=== max_z ==="
rg '^; max_z_height:' "$G"
echo "=== objects ==="
rg '^; printing object ' "$G" | sort -u
echo "=== SET_VELOCITY unique ==="
rg '^SET_VELOCITY_LIMIT' "$G" | sort | uniq -c
echo "=== result.json ==="
python3 -c "import json,sys; print(json.load(open('$OUT/result.json')))"
```

**Pass:** `; wall_loops = 3`, `; sparse_infill_density = 20%`, `; sparse_infill_pattern = gyroid`, `; max_z_height:` matches design, first-layer bbox is the floor, `SET_VELOCITY_LIMIT ACCEL=500` exists.

Then splice **without** deleting `SET_VELOCITY_LIMIT`. Keep `M83`. Strip only `M104/M109/M140/M190`.

### 7.5 Fast profile (functional, no text)

`/tmp/v3se_0.28_draft.json` as already used in ops docs: 0.28 / 2 walls / 15% rectilinear. Still `--orient 0` for trays. Still keep `SET_VELOCITY_LIMIT` on dual-object plates.

---

## 8. Supports — JSON keys only

Wiki: `enable_support`, `support_type`, `support_style`, `support_threshold_angle`, `support_on_build_plate_only`, interface layers/spacing/Z. (`support_settings_support`, `support_settings_advanced`, `support_settings_tree`)

**Orca CLI has no support flags.** `slice_print.py --supports` injects keys into a temp process copy — but the current dict is **wrong** and **silently ignored** (CYD 2026-08-31):

| Script key (WRONG) | Real Orca key | Shop PLA breakaway |
|---|---|---|
| `support_type: "normal"` | `support_type` | **`tree(auto)`** or **`normal(auto)`**. Bare `tree` / `normal` are ignored. |
| `support_style: "organic"` | `support_style` | `organic` with tree; `grid` with normal |
| `support_interface_layers` | `support_interface_top_layers` **and** `support_interface_bottom_layers` | **3** |
| `support_buildplate_only` | `support_on_build_plate_only` | **true** (PLA welds to PLA) |
| `support_angle` | `support_threshold_angle` (wiki; `support_angle` is **pattern rotation**) | **40** |
| `support_object_xy_distance: 0.3` | `support_object_xy_distance` | `0.3` or `60%` |
| `support_interface_spacing: 0.3` | `support_interface_spacing` | `0.3` (0 = solid, harder to peel) |
| — | `support_top_z_distance` / `support_bottom_z_distance` | **0.3** |
| `support_interface_loop_pattern: True` | `support_interface_loop_pattern` | **true** |

Correct inject:

```python
{
  "enable_support": True,
  "support_type": "tree(auto)",
  "support_style": "organic",
  "support_threshold_angle": 40,
  "support_on_build_plate_only": True,
  "support_interface_top_layers": 3,
  "support_interface_bottom_layers": 3,
  "support_top_z_distance": 0.3,
  "support_bottom_z_distance": 0.3,
  "support_interface_spacing": 0.3,
  "support_object_xy_distance": 0.3,
  "support_interface_loop_pattern": True,
  "skirt_loops": 1,
  "skirt_distance": 4,
}
```

Verify gcode has `;TYPE:Support interface` (or `SupportMaterialInterface`), not only support body. Re-count `;TYPE:Bridge` — should drop to 0 on the previously-bridged opening.

**Do not support a tray floor.** Re-orient. Supports under a floor weld and still leave a scar. Wave overhangs are an alpha fork (`WAVE_OVERHANG` markers); stock 2.4.2 slices on this shop had **no** markers as of 2026-08-19. Do not gamble a case on wave.

---

## 9. Dual-object plates

- Pass **separate STLs**, one Orca invocation. Do not trimesh-merge and claim Orca laid them out (`; preferred_orientation = 0` exposed that lie, 2026-08-17).
- `--orient 0 --arrange 1 --ensure-on-bed`. **No** `--allow-rotations` for cases.
- `--arrange 1` can **overlap**. `object_spacing` is not a process key. Real spacing: `--export-3mf`, edit `3D/3dmodel.model` `<item … transform="… tx ty tz">`, re-slice the 3MF.
- Travel between parts ≈ **one part width**. Keep `SET_VELOCITY_LIMIT`. A skip looks like a **56 mm shift**, not a tangle.
- Verify pairwise **positive gap** from extrusion-only first-layer bboxes.

---

## 10. Splice header for THIS printer (updated)

```
; SENTINEL - spliced via shop recipe
PRINT_START BED=55 EXTRUDER=200
M220 S100
M221 S100
M106 S255
G90
G21
M83
```

Then the Orca body:

- Drop lines matching `^M104`, `^M109`, `^M140`, `^M190`.
- **Do not drop `SET_VELOCITY_LIMIT`.**
- Keep `; printing object`, `;TYPE:`, `;Z:`, CONFIG_BLOCK (harmless comments).
- End: `M104 S0` / `M140 S0` / `M84` if `PRINT_END` is missing.

`PRINT_START` (host macros.cfg): heat bed → preheat 150 → `G28` → nozzle → `BED_MESH_CALIBRATE ADAPTIVE=1` → wait → `ADAPTIVE_LINE_PURGE`.

15 s after start: `heater_bed.target == 55`. Target 0 = unspliced file → emergency stop (`/printer/print/cancel` is broken on this fork).

---

## 11. Wiki map (fetched 2026-09-02)

| Topic | URL | JSON keys used here |
|---|---|---|
| Layer / first-layer height | https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height.html | `layer_height`, `initial_layer_print_height` |
| Line width | https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_line_width.html | `line_width`, `initial_layer_line_width`, walls |
| Precision / elephant foot / arc fitting | https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_precision.html | `elefant_foot_compensation`, `elefant_foot_compensation_layers`, `enable_arc_fitting` |
| Ironing | https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing.html | `ironing_type` … **off for letters** |
| Walls | https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls.html | `wall_loops`, `detect_thin_wall` |
| Wall & surfaces / one-wall / small-area flow | https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces.html | `only_one_wall_first_layer`, `small_area_infill_flow_compensation` |
| Initial layer speed | https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed.html | `initial_layer_speed`, `initial_layer_infill_speed` |
| Acceleration | https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration.html | `initial_layer_acceleration`, `outer_wall_acceleration`, `travel_acceleration`, … |
| Motion ability / Klipper emit | https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability.html | `emit_machine_limits_to_gcode` ignored for Klipper; per-feature `SET_VELOCITY_LIMIT` still emitted |
| Support | https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support.html | `enable_support`, `support_type`, `support_on_build_plate_only` |
| Support advanced | https://www.orcaslicer.com/wiki/print_settings/support/support_settings_advanced.html | interface layers, Z gap, XY distance |
| Tree | https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree.html | `tree_support_*` |
| Emboss | https://www.orcaslicer.com/wiki/print_prepare/prepare_emboss.html | GUI text; bake in CAD for CLI |

Local copies: `docs/orcaslicer-wiki/`.

Arc fitting: wiki says **not a quality feature**; Klipper default arc segmentation is 1.0 mm/segment (rough). Standard has `enable_arc_fitting: 0`. Leave it off. V3SE Speed turns it on — do not use that for text.

---

## 12. Do-not-print checklist (copy)

- [ ] STL already floor-down / letters-up as designed. **`--orient 0`.** No `--allow-rotations` on shells.
- [ ] `; max_z_height:` ≈ designed thickness (not the long edge).
- [ ] `; printing object` names are the intended STLs.
- [ ] CONFIG_BLOCK: `wall_loops = 3`, `sparse_infill_density = 20%`, `sparse_infill_pattern = gyroid` (quality) — **not** 2 / 15% / crosshatch.
- [ ] First-layer extrusion bbox is the **floor**, not a 5 mm strip, not corner arcs, not standoff islands.
- [ ] `;TYPE:Bridge` counts by `;Z:` — none on the floor.
- [ ] `result.json` warnings read. `-100` alone is not a reason to skip gcode inspection.
- [ ] Unspliced gcode contains `SET_VELOCITY_LIMIT ACCEL=500`. Splice **kept** those lines.
- [ ] Spliced gcode has `PRINT_START BED=55 EXTRUDER=200` and `M83`, no body `M104/M109/M140/M190`.
- [ ] Dual plate: extrusion-only gap ≥ 8 mm.
- [ ] Proud letters not on the bed, or flattened ≤ first-layer height. Elephant foot 0. Ironing off. First-layer width ≤ 0.45.
- [ ] Operator saw a real preview and said go. Never auto-start. Never auto-chain.

---

## 13. What is still wrong in the shop scripts (do not “fix” silently mid-print)

| File | Defect vs this bible |
|---|---|
| `PRINTS/slice_print.py` | `--orient 1 --allow-rotations`; loads system 2/15%; unused Prusa `QUALITY` flags; strips `SET_VELOCITY_LIMIT`; `SUPPORT_KEYS` use bare `normal` and non-Orca names. |
| `docs/ORCA.md` / `AI-QUICKSTART.md` | Still teach auto-orient-everything and strip accel limits. |
| System `0.20mm Standard @…0.4.json` | Not quality. Do not edit in place (Creality will overwrite). User process overlay instead. |

This bible is the operator reference until those files are updated on purpose.

