# SOURCE: https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features#filament-for-features)

# Filament for Features [¶](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features\#filament-for-features)

These settings allow you to specify which extruder to use for different features of the print, such as walls, infill, and wipe tower.

[![filament-for-features-video](https://img.youtube.com/vi/hcuQw55OzjU/maxresdefault.jpg)](https://www.youtube.com/watch?v=hcuQw55OzjU)

![filament_for_features](https://www.orcaslicer.com/wiki/images/filament-for-features/filament_for_features.png?raw=true)

## Outer Walls [¶](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features\#outer-walls)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `outer_wall_filament_id`.

Filament to print outer walls.

This can also be used to use a translucent filament for outer walls to achieve a frosted glass effect.

When using a [mixed nozzle size setup](https://www.orcaslicer.com/wiki/guides/mixed_nozzle_sizes.html), it's recommended to use the smaller nozzle for outer walls to achieve better surface quality and detail.

## Inner Walls [¶](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features\#inner-walls)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `inner_wall_filament_id`.

Filament to print inner walls.

When using a [mixed nozzle size setup](https://www.orcaslicer.com/wiki/guides/mixed_nozzle_sizes.html), you can use a larger nozzle for inner walls to speed up printing while maintaining good layer adhesion.

## Sparse Infill [¶](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features\#sparse-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `sparse_infill_filament_id`.

Filament to print internal sparse infill.

When using a [mixed nozzle size setup](https://www.orcaslicer.com/wiki/guides/mixed_nozzle_sizes.html), you can use a larger nozzle for infill to speed up printing while maintaining good layer adhesion.

## Internal Solid Infill [¶](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features\#internal-solid-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `internal_solid_filament_id`.

Filament to print internal solid infill.
When using a [mixed nozzle size setup](https://www.orcaslicer.com/wiki/guides/mixed_nozzle_sizes.html), you can use a larger nozzle for internal solid infill to speed up printing while maintaining good layer adhesion.

## Top Surface [¶](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features\#top-surface)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_filament_id`.

Filament to print top surfaces.

It's recommended to use the same filament for top surfaces as for outer walls to achieve a consistent appearance.

When using a [mixed nozzle size setup](https://www.orcaslicer.com/wiki/guides/mixed_nozzle_sizes.html), it's recommended to use the smaller nozzle for top surfaces to achieve better surface quality and detail.

## Bottom Surface [¶](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features\#bottom-surface)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `bottom_surface_filament_id`.

Filament to print bottom surfaces.

This can be used to use a different filament for the bottom layer, such as a more adhesive filament to improve bed adhesion.

When using a [mixed nozzle size setup](https://www.orcaslicer.com/wiki/guides/mixed_nozzle_sizes.html), you can use a larger nozzle for bottom surfaces to speed up printing while maintaining good layer adhesion.

## Wipe Tower [¶](https://www.orcaslicer.com/wiki/print_settings/multimaterial/multimaterial_settings_filament_for_features\#wipe-tower)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `wipe_tower_filament`.

The extruder to use when printing perimeter of the wipe tower. Set to 0 to use the one that is available (non-soluble would be preferred).

Back to top