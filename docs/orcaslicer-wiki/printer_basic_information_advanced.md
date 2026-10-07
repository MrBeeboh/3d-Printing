# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#advanced-printer-settings)

# Advanced Printer Settings [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#advanced-printer-settings)

Advanced settings related to the printer configuration.

- [Printer structure](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#printer-structure)
- [G-code flavor](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#g-code-flavor)
- [Skip G-code config block](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#skip-g-code-config-block)
- [Pellet Modded Printer](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#pellet-modded-printer)
- [Use 3rd-party print host](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#use-3rd-party-print-host)
- [Scan first layer](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#scan-first-layer)
- [Power Loss Recovery](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#power-loss-recovery)
- [Disable set remaining print time](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#disable-set-remaining-print-time)
- [G-code thumbnails](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#g-code-thumbnails)
- [Use relative E distances](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#use-relative-e-distances)
- [Use firmware retraction](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#use-firmware-retraction)
- [Bed temperature type](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#bed-temperature-type)
- [Time cost](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced#time-cost)

## Printer structure [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#printer-structure)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Developer`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `printer_structure`.

The physical arrangement and components of a printing device.

## G-code flavor [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#g-code-flavor)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `gcode_flavor`.

What kind of G-code the printer is compatible with.

## Skip G-code config block [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#skip-g-code-config-block)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `gcode_skip_config_block`.

Important

NEW FEATURE: **Skip G-code config block**

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Removes the `CONFIG_BLOCK` (the commented-out block listing every resolved slicer setting) from the exported G-code file.

Some printer firmware parsers crash when reading certain lines in this block, most notably Anycubic's go-klipper choking on `; filament_colour_type = 1;1;1;1`. Enabling this option avoids those upload/parsing failures by not writing the block at all.

Caution

The G-code file will no longer contain the resolved slicer settings, so it can no longer be used to recover the print configuration afterward.

## Pellet Modded Printer [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#pellet-modded-printer)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `pellet_flow_coefficient`, `pellet_modded_printer`.

Enable this option if your printer uses pellets instead of filaments.
Large format printers with print volumes in the order of 1m^3 generally use pellets for printing.
The overall tech is very similar to FDM printing.
It is FDM printing, but instead of filaments, it uses pellets.

The difference here is that where filaments have a filament\_diameter that is used to calculate the volume of filament ingested, pellets have a particular flow\_coefficient that is empirically devised for that particular pellet.

pellet\_flow\_coefficient is basically a measure of the packing density of a particular pellet.
Shape, material and density of an individual pellet will determine the packing density and the only thing that matters for 3d printing is how much of that pellet material is extruded by one turn of whatever feeding mehcanism/gear your printer uses. You can emperically derive that for your own pellets for a particular printer model.

We are translating the pellet\_flow\_coefficient into filament\_diameter so that everything works just like it does already with very minor adjustments.

filament\_diameter=4pellet\_flow\_coefficient⋅π
\\text{filament\\\_diameter} = \\sqrt{\\frac{4}{\\text{pellet\\\_flow\\\_coefficient} \\cdot \\pi}}
filament\_diameter=pellet\_flow\_coefficient⋅π4​​

sqrt just makes the relationship between flow\_coefficient and volume linear.

Higher packing density -> more material extruded by single turn -> higher pellet\_flow\_coefficient -> treated as if a filament of larger diameter is being used. All other calculations remain the same for slicing.

## Use 3rd-party print host [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#use-3rd-party-print-host)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `bbl_use_printhost`.

Allow controlling BambuLab's printer through 3rd party print hosts.

## Scan first layer [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#scan-first-layer)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `scan_first_layer`.

Enable this to enable the camera on printer to check the quality of first layer.

## Power Loss Recovery [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#power-loss-recovery)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `enable_power_loss_recovery`.

Enable or Disable power loss recovery by inserting commands in generated G-code.

Set `Printer configuration` to use the current printer's power loss recovery configuration.

Note

Only for [Bambu Lab](https://wiki.bambulab.com/en/knowledge-sharing/power-loss-recovery) or [Marlin 2 firmware](https://marlinfw.org/docs/gcode/M413.html) based printers.

Power loss recovery saves the current execution point to non-volatile memory (SD card) but this can introduce some issues:

- When the slicer generates many short moves (e.g. curves), frequent save/read operations can introduce pauses that may leave blobs.
- Repeated writes also increase wear on the memory device and its Terabytes Written (TBW).

Tip

If enabled, it's recommended to enable [Arc fitting](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_precision.html#arc-fitting) in `Quality Settings > Precision` to reduce the number of G-code commands.

Caution

High warping models or materials will not be recovered properly due to bed adhesion loss after power-off.

## Disable set remaining print time [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#disable-set-remaining-print-time)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `disable_m73`.

Disable generating of the M73: Set remaining print time in the final G-code.

## G-code thumbnails [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#g-code-thumbnails)

Picture sizes to be stored into a .gcode and .sl1 / .sl1s files, in the following format: "XxY, XxY, ..."

## Use relative E distances [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#use-relative-e-distances)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `use_relative_e_distances`.

Relative extrusion is recommended when using "label\_objects" option. Some extruders work better with this option unchecked (absolute extrusion mode). Wipe tower is only compatible with relative mode. It is recommended on most printers. Default is checked.

## Use firmware retraction [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#use-firmware-retraction)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `use_firmware_retraction`.

This experimental setting uses G10 and G11 commands to have the firmware handle the retraction. This is only supported in recent Marlin.

## Bed temperature type [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#bed-temperature-type)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `bed_temperature_formula`.

This option determines how the bed temperature is set during slicing: based on the temperature of the first filament or the highest temperature of the printed filaments.

## Time cost [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_advanced\#time-cost)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `time_cost`.

The printer cost per hour.

Back to top