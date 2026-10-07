# SOURCE: https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#wall-and-surfaces)

# Wall and surfaces [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#wall-and-surfaces)

- [Walls printing order](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#walls-printing-order)
  - [Inner/Outer](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#innerouter)
  - [Inner/Outer/Inner](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#innerouterinner)
  - [Outer/Inner](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#outerinner)
  - [Print infill first](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#print-infill-first)
- [Wall loop direction](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#wall-loop-direction)
- [Surface flow ratio](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#surface-flow-ratio)
- [Only one wall](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#only-one-wall)
  - [Threshold](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#threshold)
- [Avoid crossing walls](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#avoid-crossing-walls)
  - [Max detour length](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#max-detour-length)
- [Small area flow compensation](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#small-area-flow-compensation)
  - [Flow Compensation Model](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#flow-compensation-model)

## Walls printing order [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#walls-printing-order)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `wall_sequence`.

Print sequence of the internal (inner) and external (outer) walls.

### Inner/Outer [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#innerouter)

Use Inner/Outer for best overhangs. This is because the overhanging walls can adhere to a neighboring perimeter while printing. However, this option results in slightly reduced surface quality as the external perimeter is deformed by being squashed to the internal perimeter.

![inner-outer](https://www.orcaslicer.com/wiki/images/Wall-Order/inner-outer.gif?raw=true)

### Inner/Outer/Inner [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#innerouterinner)

Use Inner/Outer/Inner for the best external surface finish and dimensional accuracy as the external wall is printed undisturbed from an internal perimeter. However, overhang performance will reduce as there is no internal perimeter to print the external wall against. This option requires a minimum of 3 walls to be effective as it prints the internal walls from the 3rd perimeter onwards first, then the external perimeter and, finally, the first internal perimeter. This option is recommended against the Outer/Inner option in most cases.

![inner-outer-inner](https://www.orcaslicer.com/wiki/images/Wall-Order/inner-outer-inner.gif?raw=true)

### Outer/Inner [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#outerinner)

Use Outer/Inner for the same external wall quality and dimensional accuracy benefits of [Inner/Outer/Inner](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#innerouterinner) option. However, the z seams will appear less consistent as the first extrusion of a new layer starts on a visible surface.

![outer-inner](https://www.orcaslicer.com/wiki/images/Wall-Order/outer-inner.gif?raw=true)

### Print infill first [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#print-infill-first)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `is_infill_first`.

When this option is enabled, the [infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html) and [top/bottom shells](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html) are printed first, followed by the walls. This can be useful for some overhangs where the infill can support the walls.

![infill-first](https://www.orcaslicer.com/wiki/images/Wall-Order/infill-first.gif?raw=true)

**However**, the infill will slightly push out the printed walls where it is attached to them, resulting in a worse external surface finish. It can also cause the infill to shine through the external surfaces of the part.

![infill-ghosting](https://www.orcaslicer.com/wiki/images/Wall-Order/infill-ghosting.png?raw=true)

When using this option is recommended to use the [Precise Wall](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_precision.html#precise-wall), [Inner/Outer/Inner](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces#innerouterinner) wall printing order or reduce [Infill/Wall Overlap](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#infill-wall-overlap) to avoid the infill pushing out the external wall.

## Wall loop direction [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#wall-loop-direction)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `wall_direction`.

The direction which the **contour** wall loops are extruded when looking down from the top.

Holes are printed in the opposite direction to the contour to maintain alignment with layers whose contour polygons are incomplete and change direction, also partially forming the contour of a hole.
Check [PR 12669](https://github.com/OrcaSlicer/OrcaSlicer/pull/12669) for more details about reversing hole direction.

The usage of [Reverse on even](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_overhangs.html#reverse-on-even) will reverse wall direction based on this setting.

Note

This option will be disabled if spiral vase mode is enabled.

## Surface flow ratio [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#surface-flow-ratio)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `print_flow_ratio`, `top_solid_infill_flow_ratio`, `bottom_solid_infill_flow_ratio`, `set_other_flow_ratios`, `first_layer_flow_ratio`, `outer_wall_flow_ratio`, `inner_wall_flow_ratio`, `overhang_flow_ratio`, `sparse_infill_flow_ratio`, `internal_solid_infill_flow_ratio`, `gap_fill_flow_ratio`, `support_flow_ratio`, `support_interface_flow_ratio`.

This factor affects the amount of material for [top or bottom solid infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html). You can decrease it slightly to have smooth surface finish.

The actual top or bottom surface flow used is calculated by multiplying this value by the [filament flow ratio](https://www.orcaslicer.com/wiki/material_settings/filament/material_flow_ratio_and_pressure_advance.html#flow-ratio), and if set, the object's flow ratio.

Other flow ratios, such as ratios for the first layer (does not affect brims and skirts), outer and inner walls, overhang perimeters, sparse infill, internal solid infill, gap fill, support, and support interfaces, can also be adjusted after enabling the "Set other flow ratios" option.

Tip

Before using a value other than 1, it is recommended to [calibrate the flow ratio](https://www.orcaslicer.com/wiki/calibration/flow_ratio_calib.html) to ensure that the flow ratio is set correctly for your printer and filament.

## Only one wall [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#only-one-wall)

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `only_one_wall_first_layer`, `only_one_wall_top`.

Use only one wall on flat surfaces, to give more space to the [top infill pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html#surface-pattern).
Specially useful in small features, like letters, where the top surface is very small and [concentric pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#concentric) from walls would not cover it properly.

![only-one-wall](https://www.orcaslicer.com/wiki/images/Wall-Order/only-one-wall.gif?raw=true)

Each option needs the shell it acts on, so they are only available when the matching [Shell Layers](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html#shell-layers) is greater than 0: without a top shell there is no top surface for the top option to act on, and the same applies to the first layer and the bottom shell.

Tip

See [Surface Expansion and Only One Wall](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html#surface-expansion-and-only-one-wall) for how the inner walls are handled over an expanded top surface when using more than one wall.

### Threshold [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#threshold)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `min_width_top_surface`.

If a top surface has to be printed and it's partially covered by another layer, it won't be considered at a top layer where its width is below this value. This can be useful to not let the 'one perimeter on top' trigger on surface that should be covered only by perimeters.

This value can be a mm or a % of the perimeter extrusion width.

![only-one-wall-threshold](https://www.orcaslicer.com/wiki/images/Wall-Order/only-one-wall-threshold.png?raw=true)

Warning

If enabled, artifacts can be created if you have some thin features on the next layer, like letters. Set this setting to 0 to remove these artifacts.

## Avoid crossing walls [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#avoid-crossing-walls)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `reduce_crossing_wall`.

This option instructs the slicer to avoid crossing perimeters (walls) during travel moves.

Instead of traveling directly through a wall, the print head will detour around it, which can significantly reduce surface defects and stringing.

While this increases print time slightly, the improvement in print quality—especially with materials prone to stringing like **PETG** or **TPU**, often justifies the tradeoff.

Highly recommended for detailed or aesthetic prints.

![avoid-crossing-walls](https://www.orcaslicer.com/wiki/images/Wall-Order/avoid-crossing-walls.png?raw=true)

Note

This feature is not compatible with Timelapse mode, as it can cause unexpected travel moves.

### Max detour length [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#max-detour-length)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `max_travel_detour_distance`.

Defines the maximum distance the printer is allowed to detour to avoid crossing a wall.
Can be set as:

- **Absolute value in millimeters:** exactly how far the detour can extend (e.g., `5mm`).
- **Percentage** of the direct travel path (e.g., `50%`).
- **0** disables the **limit** and allows detours of **any length**.

Use this setting to balance between print time and wall quality—longer detours mean fewer wall crossings but slower prints.

## Small area flow compensation [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#small-area-flow-compensation)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `small_area_infill_flow_compensation`.

Enables adaptive flow control for small infill areas.
This feature helps address extrusion problems that often occur in small regions of solid infill, such as the tops of narrow letters or fine features.

In these cases, standard extrusion flow may be too much for the available space, leading to over-extrusion or poor surface quality.

![flow-compensation-model](https://www.orcaslicer.com/wiki/images/Wall-Order/flow-compensation-model.png?raw=true)

It works by dynamically adjusting the extrusion flow based on the length of the extrusion path, ensuring more precise material deposition in small spaces.

This is a native implementation of @Alexander-T-Moss [Small Area Flow Compensation](https://github.com/Alexander-T-Moss/Small-Area-Flow-Comp).

### Flow Compensation Model [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces\#flow-compensation-model)

The model uses a list of Extrusion Length and Flow Correction Factor value pairs. Each pair defines how much flow should be used for a specific Extrusion Length.

For values between the listed points, the flow is calculated using linear interpolation.

![flow-compensation-model-graph](https://www.orcaslicer.com/wiki/images/Wall-Order/flow-compensation-model-graph.png?raw=true)

For example for the following model:

| Extrusion Length | Flow Correction Factor |
| --- | --- |
| 0 | 0 |
| 0.2 | 0.4444 |
| 0.4 | 0.6145 |
| 0.6 | 0.7059 |
| 0.8 | 0.7619 |
| 1.5 | 0.8571 |
| 2 | 0.8889 |
| 3 | 0.9231 |
| 5 | 0.952 |
| 10 | 1 |

You should write it as:

```
0,0;
0.2,0.4444;
0.4,0.6145;
0.6,0.7059;
0.8,0.7619;
1.5,0.8571;
2,0.8889;
3,0.9231;
5,0.9520;
10,1;
```

Back to top