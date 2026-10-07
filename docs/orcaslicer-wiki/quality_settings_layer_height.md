# SOURCE: https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height#layer-height)

# Layer Height [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height\#layer-height)

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `layer_height`, `initial_layer_print_height`.

Layer height defines the vertical thickness of each printed layer, playing a crucial role in both print quality and printing speed.

Note

You can use a variable layer height with the [Variable Layer Height](https://www.orcaslicer.com/wiki/print_prepare/prepare_variable_layer_height.html) feature.

Using smaller layer heights increases print time but results in:

- Smoother surface finishes
- Less noticeable layer lines
- Enhanced detail on curves
- [Better performance on overhangs](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height#layer-height-overhangs-impacts)

![layer-height-spheres](https://www.orcaslicer.com/wiki/images/Precision/layer-height-spheres.png?raw=true)

- [Quick Reference](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height#quick-reference)
- [Layer Height Guidelines](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height#layer-height-guidelines)
- [First Layer Height](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height#first-layer-height)
- [Layer Height Overhangs Impacts](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height#layer-height-overhangs-impacts)

## Quick Reference [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height\#quick-reference)

| Nozzle Size | Min | Max | [First Layer Height](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height#first-layer-height) |
| --- | --- | --- | --- |
| 0.2mm | 0.04mm | 0.16mm | 0.12mm |
| 0.3mm | 0.06mm | 0.24mm | 0.18mm |
| 0.4mm | 0.08mm | 0.32mm | 0.25mm |
| 0.5mm | 0.10mm | 0.40mm | 0.30mm |
| 0.6mm | 0.12mm | 0.48mm | 0.35mm |
| 0.8mm | 0.16mm | 0.64mm | 0.45mm |
| 1.0mm | 0.20mm | 0.80mm | 0.55mm |

## Layer Height Guidelines [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height\#layer-height-guidelines)

Usually, the optimal range for layer height is between 20% and 80% of the nozzle diameter.

- **Below 20%:** Flow inconsistencies and "fish scale" patterns may occur, especially at high speeds.
- **Over 80%:** Increased risk of layer adhesion issues and reduced print quality.

## First Layer Height [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height\#first-layer-height)

Controls the thickness of the initial layer.

A thicker first layer improves bed adhesion and compensates for build surface imperfections.

**Recommended:** 0.25mm for 0.4mm nozzle (62.5% of nozzle diameter)

**Maximum:** 65% of nozzle diameter

## Layer Height Overhangs Impacts [¶](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height\#layer-height-overhangs-impacts)

Layer height directly affects [overhang angle](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_overhangs.html#maximum-angle) capability and quality.

![layer-height](https://www.orcaslicer.com/wiki/images/Precision/layer-height.svg?raw=true)

**Smaller layer heights** enable steeper overhangs by reducing the unsupported distance between layers, while **larger layer heights** increase this gap, leading to more sagging and requiring support material at shallower angles.

Back to top