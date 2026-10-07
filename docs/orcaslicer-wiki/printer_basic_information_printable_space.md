# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#printable-space)

# Printable Space [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#printable-space)

This section defines the printer’s physical build area and how the slicer maps models to it. Configure the bed shape, dimensions and origin so the virtual bed matches your machine; use a circular or rectangular profile for standard beds or supply an STL for custom shapes. Add a texture or model to improve visual alignment in the 3D view.

Specify any excluded (unprintable) regions as a polygon so the arranger avoids them. Set the printable height to your maximum Z travel, and use Z offset to correct endstop inaccuracies (this value is added to every Z coordinate in exported G‑code). The best object position is a normalized \[0–1\] preference used by automatic arranging, and preferred orientation controls automatic Z-axis alignment on import.

- [Printable area (Bed Shape)](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#printable-area-bed-shape)
  - [Shape](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#shape)
  - [Settings](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#settings)
  - [Texture](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#texture)
  - [Model](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#model)
- [Excluded bed area](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#excluded-bed-area)
- [Printable height](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#printable-height)
- [Support multi bed types](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#support-multi-bed-types)
- [Best object position](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#best-object-position)
- [Z offset](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#z-offset)
- [Preferred orientation](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space#preferred-orientation)

## Printable area (Bed Shape) [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#printable-area-bed-shape)

Defines the printable area on the print bed.

### Shape [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#shape)

Shape of the printable area on the print bed.

- Rectangular: Standard rectangular print bed.
- Circular: Circular print bed.
- Custom: Custom shape defined by STL file.

### Settings [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#settings)

- Size: Size in X and Y of the rectangular plate.
- Origin: Distance of the 0,0 G-code coordinate from the front left corner of the rectangle.

### Texture [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#texture)

SVG or PNG texture image file to be used as a background for the print bed in the 3D view.

### Model [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#model)

STL file defining the custom shape of the print bed.

## Excluded bed area [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#excluded-bed-area)

Unprintable area in XY plane. For example, X1 Series printers use the front left corner to cut filament during filament change. The area is expressed as polygon by points in following format: "XxY, XxY, ..."

## Printable height [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#printable-height)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `printable_height`.

This is the maximum printable height which is limited by the height of the build area.

## Support multi bed types [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#support-multi-bed-types)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_multi_bed_types`.

Once enabled, you can select the bed type in the drop-down menu, corresponding bed temperature will be set automatically.

![bed_type_selector](https://www.orcaslicer.com/wiki/images/bed/bed_type_selector.png?raw=true)

This also enabled you to set each bed type in the [filament settings](https://www.orcaslicer.com/wiki/material_settings/filament/material_temperatures.html#bed).

![bed_type_material_temperature](https://www.orcaslicer.com/wiki/images/bed/bed_type_material_temperature.png?raw=true)

Orca also support `curr_bed_type` variable in custom G-code.
For example, the following sample G-codes can detect the selected bed type and adjust the G-code offset accordingly for Klipper:

```
{if curr_bed_type=="Textured PEI Plate"}
  SET_GCODE_OFFSET Z=-0.05
{else}
  SET_GCODE_OFFSET Z=0.0
{endif}
```

Available bed types are:

- Smooth Cool Plate
- Smooth High Temp Plate
- Textured Cool Plate
- Textured PEI Plate
- Engineering Plate
- Cool Plate (SuperTack)

## Best object position [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#best-object-position)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `best_object_pos`.

Best auto arranging position in range \[0,1\] w.r.t. bed shape.

## Z offset [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#z-offset)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `z_offset`.

This value will be added (or subtracted) from all the Z coordinates in the output G-code. It is used to compensate for bad Z endstop position: for example, if your endstop zero actually leaves the nozzle 0.3mm far from the print bed, set this to -0.3 (or fix your endstop).

## Preferred orientation [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_printable_space\#preferred-orientation)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `preferred_orientation`.

Automatically orient STL files on the Z axis upon initial import.

Back to top