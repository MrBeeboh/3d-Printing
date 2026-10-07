# SOURCE: https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#infill)

# Infill [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#infill)

Infill is the internal structure of a 3D print, providing strength and support. It can be adjusted to balance material usage, print time, and part strength.

- [Sparse infill density](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#sparse-infill-density)
- [Fill Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#fill-multiline)
  - [Use cases](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#use-cases)
  - [Strategy](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#strategy)
    - [Classic Strategy](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#classic-strategy)
    - [Non-Crossing Strategy](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#non-crossing-strategy)
- [Direction and Rotation](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#direction-and-rotation)
  - [Direction](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#direction)
  - [Rotation](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#rotation)
  - [Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#symmetric-infill-y-axis)
- [Infill Wall Overlap](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#infill-wall-overlap)
- [Apply gap fill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#apply-gap-fill)
- [Filter out tiny gaps](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#filter-out-tiny-gaps)
- [Anchor](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#anchor)
- [Internal Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#internal-solid-infill)
- [Extra Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#extra-solid-infill)
  - [Interval Pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#interval-pattern)
  - [Explicit Layer List](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#explicit-layer-list)
- [Sparse Infill Pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#sparse-infill-pattern)
- [Top-Bottom Direction](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#top-bottom-direction)
- [Separated Infills](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#separated-infills)
- [Credits](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#credits)

## Sparse infill density [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#sparse-infill-density)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `sparse_infill_density`.

Infill density determines the amount of material used to fill the interior of a 3D print. It is usually expressed as a percentage, with 100% being completely solid.

- Higher density increases
  - Strength
  - Material usage
  - Print time.

Note

Density usually is calculated as a % of the total infill volume, not the total print volume.

Nevertheless, **not all patterns interpret density the same way**, so the actual material usage may vary.

You can see each pattern's material usage in the [Patterns section](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html).

## Fill Multiline [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#fill-multiline)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `fill_multiline`.

This setting allows the selected [infill pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#sparse-infill-pattern) to be generated using up to 10 parallel extrusion lines per path, while preserving both the defined [infill density](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#sparse-infill-density) and the overall material usage.

To check which patterns support multiline infill, see the Patterns Quick Reference table in the [Infill Patterns Wiki List](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns_quick_reference.html) or each pattern's specifics in the [Patterns section](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html).

![multiline-infill](https://www.orcaslicer.com/wiki/images/fill/multiline-infill.png?raw=true)

Note

Orca's approach is different from other slicers that simply multiply the number of lines and material usage, generating a denser infill than expected.

Orca Slicer keeps the cross-section constant for the set density.

| Infill Density % | Infill Lines | Orca Density | Other Slicers Density |
| --- | --- | --- | --- |
| 10% | 2 | 10% | 20% |
| 25% | 2 | 25% | 50% |
| 40% | 2 | 40% | 80% |
| 10% | 3 | 10% | 30% |
| 25% | 3 | 25% | 75% |
| 40% | 3 | 40% | 100% |
| 10% | 5 | 10% | 50% |
| 25% | 5 | 25% | 100% |
| 40% | 5 | 40% | 100% |

### Use cases [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#use-cases)

- Increasing the number of lines (e.g., 2 or 3) can **improve part strength** and **print speed** without increasing material usage.
- **Fire-retardant applications:** Some flame-resistant materials (like PolyMax PC-FR) require a minimum printed wall/infill thickness—often 1.5–3 mm—to comply with standards. Since infill contributes to overall part thickness, using multiple lines helps achieve the necessary thickness without switching to a large nozzle or printing with 100% infill. This is especially useful for high-temperature materials like PC, which are prone to warping when fully solid.
- Creating **aesthetic** infill patterns (like [Grid](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#grid) or [Honeycomb](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#honeycomb)) with multiple line widths—without relying on CAD modeling or being limited to a single extrusion width.
- Increase stability for weak infill patterns like [Lightning](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#lightning).
- Printing gears and other mechanisms, because multiline infill transfer torque better.

![infill-multiline-aesthetic](https://www.orcaslicer.com/wiki/images/fill/infill-multiline-aesthetic.gif?raw=true)

### Strategy [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#strategy)

The way multiple lines are generated depends on the selected infill pattern.

The following describes possible strategies for infill generation.

#### Classic Strategy [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#classic-strategy)

For most self intersecting infills (e.g. [Cubic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#cubic)) multiline will generate closed loops to avoid overlapping lines. This may lead to some increased print time.

In this example of [Cubic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#cubic) and [Gyroid](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#gyroid) patterns, you can see (in purple) the closed loops generated to avoid overlapping lines.

![infill-multiline-closed-loops](https://www.orcaslicer.com/wiki/images/fill/infill-multiline-closed-loops.png?raw=true)

#### Non-Crossing Strategy [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#non-crossing-strategy)

[Grid](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#grid) & [Triangles](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#triangles) patterns use a Non-crossing multiline strategy.
For these infill patterns, an alternative approach is used, generating trapezoidal trajectories designed to avoid self-intersections of the infill lines. In each layer, the pattern rotates to ensure isotropic strength.

This strategy improves printing times by avoiding closed loops in favor of continuous printing paths.

![infill-multiline-non-crossing](https://www.orcaslicer.com/wiki/images/fill/infill-multiline-non-crossing.gif?raw=true)

## Direction and Rotation [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#direction-and-rotation)

These settings control the orientation of the sparse infill lines to optimize strength and material usage.

### Direction [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#direction)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `infill_direction`, `solid_infill_direction`.

Controls the direction of the infill lines to optimize or strengthen the print.

![fill-direction](https://www.orcaslicer.com/wiki/images/fill/fill-direction.png?raw=true)

Tip

Enable [Align directions to model](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced.html#align-directions-to-model) to make this direction follow the model's orientation on the build plate.

### Rotation [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#rotation)

This parameter adds a rotation to the sparse infill direction for each layer according to the specified template.

The template is a comma-separated list of angles in degrees.

For example:

```
0,90
```

![fill-rotation](https://www.orcaslicer.com/wiki/images/fill/fill-rotation.png?raw=true)

The first layer uses 0°, the second uses 90°, and the pattern repeats for subsequent layers.

Other examples:

```
0,45,90
```

```
0,60,120,180
```

Note

If there are more layers than angles, the sequence repeats.

Tip

You can use [Template Metalanguage for infill rotation](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill_rotation_template_metalanguage.html) to create more complex patterns.

Important

Not all sparse [patterns](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html) support rotation.

### Symmetric infill Y axis [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#symmetric-infill-y-axis)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `symmetric_infill_y_axis`.

When enabled, the infill pattern will be mirrored along the Y-axis of the print bed. This can help achieve more uniform strength distribution in certain geometries.

Important

This setting may not be supported by all infill patterns.

You can apply this setting with multiple objects or using modifiers to control infill orientation for different parts of your print.

For example, you might want to mirror the infill pattern for specific components to enhance their structural integrity like planes's wings or boat hulls without the need of using 45° rotation.

![symmetric_infill_y_axis](https://www.orcaslicer.com/wiki/images/fill/symmetric_infill_y_axis.png?raw=true)

## Infill Wall Overlap [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#infill-wall-overlap)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `infill_wall_overlap`.

Infill area is enlarged slightly to overlap with wall for better bonding. The percentage value is relative to line width of sparse infill. Set this value to ~10-15% to minimize potential over extrusion and accumulation of material resulting in rough surfaces.

- **Infill Wall Overlap Off**

![InfillWallOverlapOff](https://www.orcaslicer.com/wiki/images/fill/InfillWallOverlapOff.svg?raw=true)

- **Infill Wall Overlap On**

![InfillWallOverlapOn](https://www.orcaslicer.com/wiki/images/fill/InfillWallOverlapOn.svg?raw=true)

## Apply gap fill [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#apply-gap-fill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `gap_fill_target`.

Enables gap fill for the selected solid surfaces.

The minimum gap length that will be filled can be controlled from the filter out tiny gaps option.

1. **Everywhere:** Applies gap fill to top, bottom and internal solid surfaces for maximum strength.
2. **Top and Bottom surfaces:** Applies gap fill to top and bottom surfaces only, balancing print speed, reducing potential over extrusion in the solid infill and making sure the top and bottom surfaces have no pinhole gaps.
3. **Nowhere:** Disables gap fill for all solid infill areas.

Note that if using the [classic perimeter generator](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_generator.html#classic), gap fill may also be generated between perimeters, if a full width line cannot fit between them.
That perimeter gap fill is not controlled by this setting.

If you would like all gap fill, including the classic perimeter generated one, removed, set the filter out tiny gaps value to a large number, like 999999.

However this is not advised, as gap fill between perimeters is contributing to the model's strength. For models where excessive gap fill is generated between perimeters, a better option would be to switch to the [arachne wall generator](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_generator.html#arachne) and use this option to control whether the cosmetic top and bottom surface gap fill is generated.

## Filter out tiny gaps [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#filter-out-tiny-gaps)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filter_out_gap_fill`.

Don't print gap fill with a length is smaller than the threshold specified (in mm).

This setting applies to top, bottom and solid infill and, if using the [classic perimeter generator](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_generator.html#classic), to wall gap fill.

## Anchor [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#anchor)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `infill_anchor_max`, `infill_anchor`.

Connect an infill line to an internal perimeter with a short segment of an additional perimeter. If expressed as percentage (example: 15%) it is calculated over infill extrusion width.
OrcaSlicer tries to connect two close infill lines to a short perimeter segment. If no such perimeter segment shorter than this parameter is found, the infill line is connected to a perimeter segment at just one side and the length of the perimeter segment taken is limited to infill\_anchor, but no longer than this parameter. If set to 0, the old algorithm for infill connection will be used, it should create the same result as with 1000 & 0.

- **Anchor Off**

![InfillAnchorOff](https://www.orcaslicer.com/wiki/images/fill/InfillAnchorOff.png?raw=true)

- **Anchor On**

![InfillAnchorOn](https://www.orcaslicer.com/wiki/images/fill/InfillAnchorOn.png?raw=true)

## Internal Solid Infill [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#internal-solid-infill)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `internal_solid_infill_pattern`.

Line pattern of internal solid infill. If the [detect narrow internal solid infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced.html#detect-narrow-internal-solid-infill) be enabled, the [concentric pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#concentric) will be used for the small area.

## Extra Solid Infill [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#extra-solid-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `extra_solid_infills`.

Insert extra solid infills at specific layers to add strength at critical points in your print. This feature allows you to strategically reinforce your part without changing the overall sparse infill density.

![extra-solid-infill](https://www.orcaslicer.com/wiki/images/fill/extra-solid-infill.gif?raw=true)

The pattern supports two formats:

### Interval Pattern [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#interval-pattern)

- **Simple interval**: `N` \- Insert 1 solid layer every N layers, equal to `N#1`
- **Multiple layers**: `N#K` \- Insert K consecutive solid layers every N layers
- **Optional K**: `N#` \- Shorthand for `N#1`

Examples:

```
5 or 5#1    # Insert 1 solid layer every 5 layers
5#          # Same as 5#1
10#2        # Insert 2 consecutive solid layers every 10 layers
```

### Explicit Layer List [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#explicit-layer-list)

Specify exact layer numbers (1-based) using comma-separated values. Each entry may be a single layer `N` or a range `N#K` to insert K consecutive solid layers starting at layer N:

```
1,7,9       # Insert solid layers at layers 1, 7, and 9
5,15,25     # Insert solid layers at layers 5, 15, and 25
5,9#2,18    # Insert at 5; at 9 and 10 (because #2); and at 18
```

Note

- Layer numbers are 1-based (first layer is layer 1)
- `#K` is optional in both interval and explicit list entries (`N#` equals `N#1`)
- Solid layers are inserted in addition to the normal sparse infill pattern

Tip

Use this feature to:

- Add strength at stress concentration points
- Reinforce mounting holes or attachment points
- Create internal structure for functional parts
- Add periodic reinforcement for tall prints
- Insert a single solid layer at a specific height by using an explicit list with a leading 0, which will be ignored because layer indices are 1-based. Example: `0,15` inserts a solid layer only at layer 15.

Warning

Layers that include solid infill can take significantly longer than surrounding layers. This time differential may lead to z-banding-like bulges. Consider adjusting cooling or speeds if you observe artifacts.

## Sparse Infill Pattern [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#sparse-infill-pattern)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `sparse_infill_pattern`.

Tip

See [Infill Patterns Wiki List](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html) with **detailed specifications**, including their strengths and weaknesses.

## Top-Bottom Direction [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#top-bottom-direction)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_layer_direction`, `bottom_layer_direction`.

Important

NEW FEATURE: **Top/Bottom layer direction**

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Fixed angle (in degrees) for the top and bottom solid infill lines.

![top-direction](https://www.orcaslicer.com/wiki/images/directions/top-direction.png?raw=true)

The top angle also applies to ironing lines.

Set to `-1` to follow the default solid infill [direction](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#direction).

## Separated Infills [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#separated-infills)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Expert`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `separated_infills`.

Important

NEW FEATURE: **Separated infills**

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Centers the internal infill of each part on itself, as if it were sliced on its own, instead of on the whole assembly.

By default the entire assembly is treated as a single whole, so a centered or rotated infill pattern is referenced to one common center and rotates around it. When enabled, each part is centered on its own full 3D bounding box — producing the same pattern you would get by slicing that part on its own.

![separated-infills](https://www.orcaslicer.com/wiki/images/fill/separated-infills.png?raw=true)
Parts are grouped by their real geometry when deciding what shares a center:

- **Touching or overlapping parts** are treated as one body and share a single center.
- **Separate parts** with disjoint projections — including distinct 3D objects — each get their own center.
- **Disconnected islands within a single mesh** are centered separately.
- **Interleaved parts that never touch** (chains) each get an independent center.

Useful when an assembly groups several objects that should each keep a consistent, self-centered infill.

Note

The main disadvantage is that, for complex and large slices, centering each part independently can increase slicing time.

Affects centered and [rotation-template](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#rotation) patterns as well as most line and grid [patterns](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html) — Rectilinear, Aligned Rectilinear, Zig Zag, Cross Zag, Locked Zag, Grid, Triangles, Tri-hexagon, Cubic, Quarter Cubic, Lateral Lattice, Lateral Honeycomb, Hilbert Curve, Archimedean Chords and Octagram Spiral. For rectilinear-based patterns the line grid is now phased through each part's bounding-box center instead of the global origin.

Patterns locked to global coordinates ( [Gyroid](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#gyroid), [Honeycomb](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#honeycomb), TPMS, ...) are unaffected.

- **Separated Infills Off:** the assembly is treated as a single whole, so the infill of every object is referenced to one common center.

![separated_infills_off](https://www.orcaslicer.com/wiki/images/fill/separated_infills_off.png?raw=true)

- **Separated Infills On:** each object in the assembly gets its own self-centered infill pattern.

![separated_infills_on](https://www.orcaslicer.com/wiki/images/fill/separated_infills_on.png?raw=true)

## Credits [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill\#credits)

- **[Fill Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill#fill-multiline) implementation** \- [@RF47](https://github.com/RF47)
- **Wiki page:** [IanAlexis](https://github.com/IanAlexis).

Back to top