# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information#basic-extruder-information)

# Basic Extruder Information [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information\#basic-extruder-information)

This section contains the basic information about the extruder.

When using multiple extruders, you can set different values for each extruder.

- [Nozzle diameter](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information#nozzle-diameter)
- [Nozzle volume](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information#nozzle-volume)
- [Extruder Layer Height Limits](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information#extruder-layer-height-limits)
- [Extruder offset Position](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information#extruder-offset-position)

## Nozzle diameter [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information\#nozzle-diameter)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `nozzle_diameter[extruder_idx]`.

The diameter of the nozzle for each extruder.

Tip

You can use different nozzle diameters for each extruder to achieve different print qualities and speeds.

Follow the [Mixed Nozzle Sizes](https://www.orcaslicer.com/wiki/guides/mixed_nozzle_sizes.html) guide for more information on how to use this feature.

## Nozzle volume [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information\#nozzle-volume)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `nozzle_volume[extruder_idx]`.

Volume of nozzle between the filament cutter and the end of the nozzle

## Extruder Layer Height Limits [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information\#extruder-layer-height-limits)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `extruder_printable_height[extruder_idx]`, `min_layer_height[extruder_idx]`, `max_layer_height[extruder_idx]`.

Min and max layer height limits for the extruder. These settings are used when adaptive layer height is enabled.

## Extruder offset Position [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_basic_information\#extruder-offset-position)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `extruder_offset[extruder_idx]`.

If your firmware doesn't handle the extruder displacement you need the G-code to take it into account. This option lets you specify the displacement of each extruder with respect to the first one. It expects positive coordinates (they will be subtracted from the XY coordinate).

Back to top