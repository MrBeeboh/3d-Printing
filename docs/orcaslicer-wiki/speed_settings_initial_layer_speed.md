# SOURCE: https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed#initial-layer-speed)

# Initial layer speed [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed\#initial-layer-speed)

Printing the first layer slower than the rest of the print is a widely recommended practice. This helps ensure strong adhesion to the print bed, reduces the chances of warping or curling at the edges, and allows better compensation for minor leveling inconsistencies.

## Initial layer [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed\#initial-layer)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `initial_layer_speed`.

This setting determines the printing speed for the first layer, excluding [solid infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html) regions. It applies to the [outer/inner walls](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls.html), [sparse infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html) when [bottom layers](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html#shell-layers) is set to 0.

Adjusting this speed helps ensure proper adhesion and print quality for the initial layer.

## Initial layer infill [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed\#initial-layer-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `initial_layer_infill_speed`.

Defines the speed used specifically for [solid infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html#shell-layers) regions on the first layer. These areas require more precise and consistent extrusion to create a flat and stable surface for subsequent layers. Printing this section too fast may result in high internal stresses (increased risk of warping), poor layer uniformity, or adhesion failures.

## Initial layer travel speed [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed\#initial-layer-travel-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `initial_layer_travel_speed`.

Sets the travel (non-printing movement) speed for the first layer. This doesn't affect the printing quality and can be set to a percentage of the [travel speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_travel.html).

Usually, this is set to 100% of the [travel speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_travel.html), but it can be reduced if you want to minimize vibrations or if your printer has issues with high-speed travel movements.

## Number of slow layers [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_initial_layer_speed\#number-of-slow-layers)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `slow_down_layers`.

Specifies how many of the first layers should be printed at a reduced speed. Instead of jumping straight to full speed after the first layer, the speed gradually increases in a linear fashion over this number of layers. This gradual ramp-up helps maintain adhesion and gives the print more stability in its early stages, especially on prints with a small contact area or materials prone to warping.

![number-of-slow-layers](https://www.orcaslicer.com/wiki/images/speed/number-of-slow-layers.png?raw=true)

Back to top