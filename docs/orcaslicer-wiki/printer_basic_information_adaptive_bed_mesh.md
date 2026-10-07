# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#adaptive-bed-mesh)

# Adaptive Bed Mesh [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#adaptive-bed-mesh)

OrcaSlicer introduces comprehensive support for adaptive bed meshing across a variety of firmware, including Marlin, Klipper, and RepRapFirmware (RRF).

This feature allows users to seamlessly integrate adaptive bed mesh commands within the Machine Start G-code.

The implementation is designed to be straightforward, requiring no additional plugins or alterations to firmware settings, thereby enhancing user experience and print quality directly from OrcaSlicer.

![ABM-PrinterConfig](https://www.orcaslicer.com/wiki/images/Adaptative-Bed-Mesh/ABM-PrinterConfig.png?raw=true)

- [Bed mesh](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#bed-mesh)
- [Probe point distance](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#probe-point-distance)
- [Mesh margin](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#mesh-margin)
- [Available g-code variables for Adaptive Bed Mesh Command](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#available-g-code-variables-for-adaptive-bed-mesh-command)
- [Example of Adaptive Bed Mesh usage in OrcaSlicer](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#example-of-adaptive-bed-mesh-usage-in-orcaslicer)
  - [Marlin](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#marlin)
  - [Klipper](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#klipper)
  - [RRF](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh#rrf)

## Bed mesh [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#bed-mesh)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `bed_mesh_min`, `bed_mesh_max`.

This option sets the min and max point for the allowed bed mesh area. Due to the probe's XY offset, most printers are unable to probe the entire bed. To ensure the probe point does not go outside the bed area, the minimum and maximum points of the bed mesh should be set appropriately.

OrcaSlicer ensures that adaptive\_bed\_mesh\_min/adaptive\_bed\_mesh\_max values do not exceed these min/max points. This information can usually be obtained from your printer manufacturer.

The default setting is (-99999, -99999), which means there are no limits, thus allowing probing across the entire bed.

## Probe point distance [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#probe-point-distance)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `bed_mesh_probe_distance`.

This option sets the preferred distance between probe points (grid size) for the X and Y directions, with the default being 50mm for both X and Y.

## Mesh margin [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#mesh-margin)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `adaptive_bed_mesh_margin`.

This option determines the additional distance by which the adaptive bed mesh area should be expanded in the XY directions.

Note

Klipper users: OrcaSlicer will adjust adaptive bed mesh area according to the margin. It is recommended to set the margin to 0 in Klipper config or pass 0 when calling BED\_MESH\_CALIBRATE command(please refer to the example below).

## Available g-code variables for Adaptive Bed Mesh Command [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#available-g-code-variables-for-adaptive-bed-mesh-command)

`bed_mesh_probe_count`: Represents the probe count in the X and Y directions. This value is calculated based on the size of the adaptive bed mesh area and the distance between probe points.

`adaptive_bed_mesh_min`: Specifies the minimum coordinates of the adaptive bed mesh area, defining the starting point of the mesh.

`adaptive_bed_mesh_max`: Determines the maximum coordinates of the adaptive bed mesh area, indicating the endpoint of the mesh.

`ALGORITHM`: Identifies the algorithm used for adaptive bed mesh interpolation. This variable is useful for Klipper users. If bed\_mesh\_probe\_count is less than 4, the algorithm is set to `lagrange`. Otherwise, it is set to `bicubic`.

## Example of Adaptive Bed Mesh usage in OrcaSlicer [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#example-of-adaptive-bed-mesh-usage-in-orcaslicer)

### Marlin [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#marlin)

```
; Marlin don't support specify the probe count yet, so we only specify the probe area
G29 L{adaptive_bed_mesh_min[0]} R{adaptive_bed_mesh_max[0]} F{adaptive_bed_mesh_min[1]} B{adaptive_bed_mesh_max[1]} T V4
```

### Klipper [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#klipper)

```
; Always pass `ADAPTIVE_MARGIN=0` because Orca has already handled `adaptive_bed_mesh_margin` internally
; Make sure to set ADAPTIVE to 0 otherwise Klipper will use it's own adaptive bed mesh logic
BED_MESH_CALIBRATE mesh_min={adaptive_bed_mesh_min[0]},{adaptive_bed_mesh_min[1]} mesh_max={adaptive_bed_mesh_max[0]},{adaptive_bed_mesh_max[1]} ALGORITHM=[bed_mesh_algo] PROBE_COUNT={bed_mesh_probe_count[0]},{bed_mesh_probe_count[1]} ADAPTIVE=0 ADAPTIVE_MARGIN=0
```

### RRF [¶](https://www.orcaslicer.com/wiki/printer_settings/basic%20information/printer_basic_information_adaptive_bed_mesh\#rrf)

```
M557 X{adaptive_bed_mesh_min[0]}:{adaptive_bed_mesh_max[0]} Y{adaptive_bed_mesh_min[1]}:{adaptive_bed_mesh_max[1]} P{bed_mesh_probe_count[0]}:{bed_mesh_probe_count[1]}
```

![ABM-Machine-G-code](https://www.orcaslicer.com/wiki/images/Adaptative-Bed-Mesh/ABM-Machine-G-code.png?raw=true)

Back to top