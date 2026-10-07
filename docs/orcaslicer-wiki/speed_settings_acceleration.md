# SOURCE: https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#acceleration)

# Acceleration [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#acceleration)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `accel_to_decel_enable`, `accel_to_decel_factor`.

Acceleration in 3D printing is usually set on the printer's firmware settings.

This setting will try to override the acceleration when [normal printing acceleration](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#normal-printing) value is different than 0.

Orca will limit the acceleration to not exceed the acceleration set in the Printer's Motion Ability settings.

- [Normal printing](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#normal-printing)
- [Outer wall](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#outer-wall)
- [Inner wall](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#inner-wall)
- [Bridge](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#bridge)
- [Sparse infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#sparse-infill)
- [Internal solid infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#internal-solid-infill)
- [Initial layer](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#initial-layer)
- [Initial layer travel](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#initial-layer-travel)
- [Top surface](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#top-surface)
- [Travel](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#travel)

## Normal printing [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#normal-printing)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `default_acceleration`.

The default acceleration of both normal printing and travel.

Note

If this value is set to 0, the acceleration will be set to the printer's default acceleration.

## Outer wall [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#outer-wall)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `outer_wall_acceleration`.

Acceleration for [outer wall](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed.html#outer-wall) printing. This is usually set to a lower value than normal printing to ensure better quality.

## Inner wall [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#inner-wall)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `inner_wall_acceleration`.

Acceleration for [inner wall](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed.html#inner-wall) printing. This is usually set to a higher value than outer wall printing to improve speed.

## Bridge [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#bridge)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `bridge_acceleration`.

Acceleration of [bridges](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_overhang_speed.html#bridge-speed). If the value is expressed as a percentage (e.g. 50%), it will be calculated based on the outer wall acceleration.

## Sparse infill [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#sparse-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `sparse_infill_acceleration`.

Acceleration of [sparse infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed.html#sparse-infill). If the value is expressed as a percentage (e.g. 100%), it will be calculated based on the default acceleration.

## Internal solid infill [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#internal-solid-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `internal_solid_infill_acceleration`.

Acceleration of [internal solid infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed.html#internal-solid-infill). If the value is expressed as a percentage (e.g. 100%), it will be calculated based on the default acceleration.

## Initial layer [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#initial-layer)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `initial_layer_acceleration`.

Acceleration of [initial layer](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed.html). Using a lower value can improve build plate adhesion.

## Initial layer travel [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#initial-layer-travel)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `initial_layer_travel_acceleration`.

Acceleration of [initial layer travel](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed.html#initial-layer-travel-speed).
Using a lower value can improve build plate adhesion. If the value is expressed as a percentage (e.g. 50%), it will be calculated based on the [Travel Acceleration](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#travel).

## Top surface [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#top-surface)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_acceleration`.

Acceleration of [top surface infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed.html#top-surface). Using a lower value may improve top surface quality.

Recommended to use a similar value to the [outer wall acceleration](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration#outer-wall).

## Travel [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration\#travel)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `travel_acceleration`.

Acceleration of [travel](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_travel.html) moves. This is usually set to a higher value than normal printing to reduce travel time.

Back to top