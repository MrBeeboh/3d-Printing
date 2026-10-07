# SOURCE: https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information.html

[Skip to content](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#material-basic-information)

# Material Basic Information [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#material-basic-information)

This section contains basic information about the filament material.

- [Type](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#type)
- [Vendor](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#vendor)
- [Soluble material](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#soluble-material)
- [Support material](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#support-material)
- [Filament ramming length](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#filament-ramming-length)
- [Required nozzle HRC](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#required-nozzle-hrc)
- [Default color](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#default-color)
- [Diameter](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#diameter)
- [Adhesiveness Category](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#adhesiveness-category)
- [Density](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#density)
- [Shrinkage (XY)](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#shrinkage-xy)
- [Shrinkage (Z)](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#shrinkage-z)
- [Price](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#price)
- [Softening temperature](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#softening-temperature)
- [Idle temperature](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#idle-temperature)
- [Recommended nozzle temperature](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information#recommended-nozzle-temperature)

## Type [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#type)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_type`.

Material base type (e.g., PLA, ABS, PETG, etc.).

This setting affects coefficients used in various calculations, such as brim width or temperature warnings.

## Vendor [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#vendor)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_vendor`.

Vendor of filament. For show only.

## Soluble material [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#soluble-material)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_soluble`.

Soluble material is commonly used to print supports and support interfaces.

## Support material [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#support-material)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_is_support`.

Support material is commonly used to print supports and support interfaces.

## Filament ramming length [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#filament-ramming-length)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_change_length`.

When changing the extruder, it is recommended to extrude a certain length of filament from the original extruder. This helps minimize nozzle oozing.

## Required nozzle HRC [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#required-nozzle-hrc)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Developer`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `required_nozzle_HRC`.

Minimum HRC of nozzle required to print the filament. A value of 0 means no checking of the nozzle's HRC.

## Default color [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#default-color)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `default_filament_colour`.

Default filament color.

Right click to reset value to system default.

## Diameter [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#diameter)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_diameter`.

Filament diameter is used to calculate extrusion variables in G-code, so it is important that this is accurate and precise.

## Adhesiveness Category [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#adhesiveness-category)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Developer`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_adhesiveness_category`.

Filament category.

## Density [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#density)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_density`.

Filament density, for statistical purposes only.

## Shrinkage (XY) [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#shrinkage-xy)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_shrink`.

Enter the shrinkage percentage that the filament will get after cooling (94% if you measure 94mm instead of 100mm).

The part will be scaled in XY to compensate. Only the filament used for the perimeter is taken into account.

Be sure to allow enough space between objects, as this compensation is done after the checks.

## Shrinkage (Z) [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#shrinkage-z)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_shrinkage_compensation_z`.

Enter the shrinkage percentage that the filament will get after cooling (94% if you measure 94mm instead of 100mm). The part will be scaled in Z to compensate.

## Price [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#price)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_cost`.

Filament price, for statistical purposes only.

## Softening temperature [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#softening-temperature)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `temperature_vitrification`.

The material softens at this temperature, so when the bed temperature is equal to or greater than this, it's highly recommended to open the front door and/or remove the upper glass to avoid clogs.

## Idle temperature [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#idle-temperature)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `idle_temperature`.

Nozzle temperature when the tool is currently not used in multi-tool setups. This is only used when 'Ooze prevention' is active in Print Settings. Set to 0 to disable.

## Recommended nozzle temperature [¶](https://www.orcaslicer.com/wiki/material_settings/filament/material_basic_information\#recommended-nozzle-temperature)

Min and max recommended nozzle temperature for this filament.

Back to top