# SOURCE: https://www.orcaslicer.com/wiki/material_settings/filament/material_volumetric_speed_limitation.html

[Skip to content](https://www.orcaslicer.com/wiki/material_settings/filament/material_volumetric_speed_limitation#material-volumetric-speed-limitation)

# Material Volumetric Speed Limitation [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_volumetric_speed_limitation\#material-volumetric-speed-limitation)

Each material profile includes a **maximum volumetric speed** setting, which limits your [print speed](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_other_layers_speed.html) to prevent issues like nozzle clogs, under-extrusion, or poor layer adhesion.

Tip

Calibrating the maximum volumetric speed for each filament you use is highly recommended. Refer to the [Max Volumetric Speed (FlowRate) Calibration](https://www.orcaslicer.com/wiki/calibration/volumetric_speed_calib.html) guide for detailed instructions on how to perform this calibration.

## Adaptive volumetric speed [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_volumetric_speed_limitation\#adaptive-volumetric-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Developer`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_adaptive_volumetric_speed`.

Warning

Experimental and incomplete feature imported from BBS.

Functional for some profiles that already have the variable saved.

When enabled, the extrusion flow is limited by the smaller of the fitted value (calculated from line width and layer height) and the user-defined maximum flow. When disabled, only the user-defined maximum flow is applied.

## Max volumetric speed [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_volumetric_speed_limitation\#max-volumetric-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_max_volumetric_speed`.

This setting is the volume of filament that can be melted and extruded per second. Printing speed is limited by max volumetric speed, in case of too high and unreasonable speed setting. This value cannot be zero.

Back to top