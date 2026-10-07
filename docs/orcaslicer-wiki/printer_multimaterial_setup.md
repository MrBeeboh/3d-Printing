# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_setup.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_setup#multimaterial-setup)

# Multimaterial setup [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_setup\#multimaterial-setup)

Basic setup for multimaterial printing.

## Single Extruder Multi Material [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_setup\#single-extruder-multi-material)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `single_extruder_multi_material`.

Allow using a single extruder to print with multiple filaments.

If your printer has an MultiMaterialUnit, this will run the [Change filament G-code](https://www.orcaslicer.com/wiki/printer_settings/machine%20gcode/printer_machine_gcode.html#change-filament-g-code) when changing filament is needed.
If your printer does not have an MultiMaterialUnit, you will need to enable [Manual Filament Change](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_setup#manual-filament-change).

## Extruders [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_setup\#extruders)

Number of extruders of the printer.

## Manual Filament Change [¶](https://www.orcaslicer.com/wiki/printer_settings/multimaterial/printer_multimaterial_setup\#manual-filament-change)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `manual_filament_change`.

Manual filament change is a feature that allows the user to change the filament during the print. This can be useful for multi-material prints or when changing colors. The user can specify the position and timing of the filament change, as well as the speed and distance of the ramming process.

Enable this option to omit the custom Change filament G-code only at the beginning of the print. The tool change command (e.g., T0) will be skipped throughout the entire print. This is useful for manual multi-material printing, where we use M600/PAUSE to trigger the manual filament change action.

Back to top