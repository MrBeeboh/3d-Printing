# SOURCE: https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#other-layers-speed)

# Other layers speed [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#other-layers-speed)

## Speed limitations [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#speed-limitations)

Important

Every speed setting is limited by several parameters like:

- [Maximum Volumetric Speed](https://www.orcaslicer.com/wiki/calibration/volumetric_speed_calib.html)
- Machine / Motion ability
- [Acceleration](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration.html)
- [Jerk settings](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy.html)

- [Speed limitations](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#speed-limitations)
- [Outer wall](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#outer-wall)
- [Inner wall](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#inner-wall)
- [Small perimeters](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-perimeters)
  - [Small perimeters threshold](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-perimeters-threshold)
- [Sparse infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#sparse-infill)
- [Internal solid infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#internal-solid-infill)
- [Top surface](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#top-surface)
- [Gap infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#gap-infill)
- [Ironing speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#ironing-speed)
- [Support](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#support)
- [Support interface](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#support-interface)
- [Small tree support perimeters](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-tree-support-perimeters)
  - [Small tree support perimeters threshold](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-tree-support-perimeters-threshold)

## Outer wall [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#outer-wall)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `outer_wall_speed`.

Speed of outer wall which is outermost and visible. It's used to be slower than [inner wall speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#inner-wall) to get better quality and good layer adhesion.
This setting is also limited by [Machine / Motion ability / Resonance avoidance speed settings](https://www.orcaslicer.com/wiki/calibration/vfa_calib.html).

## Inner wall [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#inner-wall)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `inner_wall_speed`.

Speed of inner wall which is printed faster than outer wall to reduce print time but is still recommended to be slower than the [maximum volumetric speed](https://www.orcaslicer.com/wiki/calibration/volumetric_speed_calib.html) to ensure good layer adhesion and reduce material internal stresses.

## Small perimeters [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#small-perimeters)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `small_perimeter_speed`.

Speed of outer wall with theoretical radius <= [small perimeters threshold](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-perimeters-threshold).
Any shape (not only circles) will be considered as a small perimeter.

If expressed as percentage (for example: 80%) it will be calculated on the [outer wall speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#outer-wall).

Note

Zero will use [50%](https://github.com/OrcaSlicer/OrcaSlicer/blob/7d2a12aa3cbf2e7ca5d0523446bf1d1d4717f8d1/src/libslic3r/GCode.cpp#L4698) of [outer wall speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#outer-wall).

### Small perimeters threshold [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#small-perimeters-threshold)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `small_perimeter_threshold`.

**Radius** in millimeters below which the speed of perimeters will be reduced to the [small perimeters speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-perimeters).

To know the length of the perimeter, you can use the formula:

Perimeter Length2π≤Threshold
\\frac{\\text{Perimeter Length}}{2\\pi} \\leq \\text{Threshold}
2πPerimeter Length​≤Threshold

For example, if the threshold is set to 5 mm, then the perimeter length must be less than or equal to 31.4 mm `(2 * π * 5 mm)` to be considered a small perimeter.

- A Circle with a diameter of 10 mm will have a perimeter length of approximately 31.4 mm, which is equal to the threshold, so it will be considered a small perimeter.
- A Cube of 10mm x 10mm will have a perimeter length of 40 mm, which is greater than the threshold, so it will not be considered a small perimeter.
- A Cube of 5mm x 5mm will have a perimeter length of 20 mm, which is less than the threshold, so it will be considered a small perimeter.

Note

Zero will disable [small perimeters speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-perimeters) and will use the [outer wall speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#outer-wall).

## Sparse infill [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#sparse-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `sparse_infill_speed`.

Speed of [sparse infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html) which is printed faster than solid infill to reduce print time.

In case you are using your [Infill Pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html) as aesthetic feature, you may want to set it closer to the [outer wall speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#outer-wall) to get better quality.

## Internal solid infill [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#internal-solid-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `internal_solid_infill_speed`.

Speed of internal solid infill, which fills the interior of the model with solid layers.

This is typically set faster than the [top surface speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#top-surface) to optimize print time, while still ensuring adequate strength and layer adhesion. Adjusting this speed can help balance print quality and efficiency, especially for models requiring strong internal structures.

Solid infill is also considered when [infill % is set to 100%](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill).

## Top surface [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#top-surface)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_speed`.

Speed of the [topmost solid layers](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html) of the print. This is usually set similar to the [outer wall speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#outer-wall) to achieve a smoother and higher-quality finish on visible surfaces. Lower speeds help minimize surface defects and improve the appearance of the final printed object.

## Gap infill [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#gap-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `gap_infill_speed`.

Speed of [gap infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#apply-gap-fill), which is used to fill small gaps or holes in the print.

## Ironing speed [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#ironing-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ironing_speed`.

[Ironing](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing.html) and [Support Ironing](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_ironing.html) speed, typically slower than the top surface speed to ensure a smooth finish.

## Support [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#support)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_speed`.

Speed at which [support](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support.html) material is printed. Slower speeds help ensure that supports are stable and effective during the print process.

## Support interface [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#support-interface)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_interface_speed`.

Speed for the support interface layers, which are the layers directly contacting the model. This is usually set even slower than the main [support speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#support) to maximize surface quality where the support meets the model and to make support removal easier.

## Small tree support perimeters [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#small-tree-support-perimeters)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `small_support_perimeter_speed`.

Important

NEW FEATURE: **Small tree support perimeters** (speed and threshold)

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Same as [Small perimeters](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-perimeters), but for supports.

This separate setting affects the speed of support for areas with a perimeter length <= [small tree support perimeters threshold](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-tree-support-perimeters-threshold).

If expressed as a percentage (for example: 80%), it will be calculated on the [support](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#support) or [support interface](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#support-interface) speed.

Set to zero for auto.

### Small tree support perimeters threshold [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed\#small-tree-support-perimeters-threshold)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `small_support_perimeter_threshold`.

Sets the threshold for small support perimeter length below which [small tree support perimeters](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed#small-tree-support-perimeters) speed is applied.

The default threshold is 0 mm.

Back to top