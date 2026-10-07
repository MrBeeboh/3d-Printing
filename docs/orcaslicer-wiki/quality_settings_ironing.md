# SOURCE: https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing#ironing)

# Ironing [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#ironing)

Ironing is a process used to improve the surface finish of 3D prints by smoothing out the top layers. This is achieved by printing a second time at the same height, but with a very [low flow rate](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing#flow) and a specific [pattern](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing#pattern). The result is a smoother surface that can enhance the aesthetic quality of the print increasing print time.

![ironing](https://www.orcaslicer.com/wiki/images/ironing/ironing.png?raw=true)

Tip

For Multi-material print, consider using [Material Setting Overrides](https://www.orcaslicer.com/wiki/material_settings/setting%20overrides/material_setting_overrides.html#ironing) to customize ironing settings for each material.

Important

Ironing can cause filament to move very slowly through the hotend, which increases the risk of heat creep and potential clogging. Monitor your printer during ironing and ensure your hotend cooling is adequate to prevent jams.

## Type [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#type)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ironing_type`.

This setting controls which layer being ironed.

- **Top Surfaces**: All [top surfaces](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html) will be ironed. This is the most common setting and is used to smooth out the top layers of the print.

![ironing-top-surfaces](https://www.orcaslicer.com/wiki/images/ironing/ironing-top-surfaces.png?raw=true)
- **Topmost Surface**: Only the last [top layer](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html) of the print will be ironed. This is useful for prints where only the last layer needs to be smoothed.

![ironing-topmost-surface](https://www.orcaslicer.com/wiki/images/ironing/ironing-topmost-surface.png?raw=true)
- **All solid layers**: All solid layers, including [internal solid infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill) and [top layers](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html), will be ironed. This can be useful for prints that require a very smooth finish on all solid surfaces but may increase print time significantly.

![ironing-all-solid-layers](https://www.orcaslicer.com/wiki/images/ironing/ironing-all-solid-layers.png?raw=true)

## Pattern [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#pattern)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ironing_pattern`.

The pattern that will be used when ironing. Usually, the best pattern is the one with the most efficient coverage of the surface.

Tip

See [Infill Patterns Wiki List](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html) with **detailed specifications**, including their strengths and weaknesses.

The ironing patterns are:

- **[Concentric](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#concentric)**
- **[Rectilinear](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#rectilinear)**

## Flow [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#flow)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ironing_flow`.

The amount of material to extrude during ironing.

This % is a percentage of the normal flow rate. A lower value will result in a smoother finish but may not cover the surface completely. A higher value may cover the surface better but can lead to over extrusion or rougher finish.

A lower layer height may require higher flow due to less volumetric extrusion per distance.

## Line spacing [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#line-spacing)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ironing_spacing`.

The distance between the lines of ironing.

It's recommended to set this value to be equal to or less than the nozzle diameter for optimal coverage and surface finish.

## Inset [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#inset)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ironing_inset`.

The distance to keep from the edges, which can help prevent over-extrusion at the edges of the surface being ironed.

![ironing-inset](https://www.orcaslicer.com/wiki/images/ironing/ironing-inset.png?raw=true)

If this value is set to 0, the ironing toolpath will start directly at the perimeter edges without any inward offset. This means the [ironing pattern](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing#pattern) will extend all the way to the outer boundaries of the top surface being ironed.

## Angle Offset [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#angle-offset)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ironing_angle`.

The angle of ironing lines offset relative to the top surface solid infill direction.

Commonly used ironing angle offsets are 0°, 45°, and 90° each producing a [different surface finish](https://github.com/OrcaSlicer/OrcaSlicer/issues/10834#issuecomment-3322628589) which will depend on your printer nozzle.

Tip

Enable [Align directions to model](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced.html#align-directions-to-model) to make the ironing direction follow the model's orientation on the build plate.

## Fixed Angle [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#fixed-angle)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ironing_angle_fixed`.

Use a fixed absolute angle for ironing that is not offset from the top surface infill direction. This results in an ironing finish that does not have alternating line directions and may result in a more uniform surface finish and reduced tiger striping effect when reflecting light.

Set the Ironing Angle Offset to an angle with optimal ironing angle offsets from all affected top surface solid infill directions.

Suggested fixed ironing angles are 0° and 90° if you are using the default solid infill direction of 45°.

## Speed [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing\#speed)

See [Speed settings for other layers](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed.html#ironing-speed) for more information about ironing speed.

Back to top