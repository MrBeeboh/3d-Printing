# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_semm_parameters.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_semm_parameters#single-extruder-multi-material-parameters)

# Single Extruder Multi-Material Parameters [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_semm_parameters\#single-extruder-multi-material-parameters)

This section describes the parameters specific to single extruder multi-material (SEMM) printing.

## Cooling tube position [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_semm_parameters\#cooling-tube-position)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `cooling_tube_retraction`.

Distance of the center-point of the cooling tube from the extruder tip.

## Cooling tube length [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_semm_parameters\#cooling-tube-length)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `cooling_tube_length`.

Length of the cooling tube to limit space for cooling moves inside it.

## Filament parking position [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_semm_parameters\#filament-parking-position)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `parking_pos_retraction`.

Distance of the extruder tip from the position where the filament is parked when unloaded. This should match the value in printer firmware.

## Extra loading distance [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_semm_parameters\#extra-loading-distance)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `extra_loading_move`.

When set to zero, the distance the filament is moved from parking position during load is exactly the same as it was moved back during unload. When positive, it is loaded further, if negative, the loading move is shorter than unloading.

## High extruder current on filament swap [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_semm_parameters\#high-extruder-current-on-filament-swap)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `high_current_on_filament_swap`.

It may be beneficial to increase the extruder motor current during the filament exchange sequence to allow for rapid ramming feed rates and to overcome resistance when loading a filament with an ugly shaped tip.

Back to top