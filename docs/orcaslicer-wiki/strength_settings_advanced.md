# SOURCE: https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#strength-advanced)

# Strength Advanced [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#strength-advanced)

- [Align directions to model](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#align-directions-to-model)
- [Bridge infill direction](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#bridge-infill-direction)
- [Relative Bridge Angle](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#relative-bridge-angle)
- [Minimum sparse infill threshold](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#minimum-sparse-infill-threshold)
- [Infill Combination](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#infill-combination)
  - [Max layer height](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#max-layer-height)
- [Detect narrow internal solid infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#detect-narrow-internal-solid-infill)
- [Ensure vertical shell thickness](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#ensure-vertical-shell-thickness)

## Align directions to model [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#align-directions-to-model)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `align_infill_direction_to_model`.

Aligns [infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#direction), [bridge](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#bridge-infill-direction), [ironing](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing.html#angle-offset) and [top/bottom surface fill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html#surface-pattern) directions to follow the model's orientation on the build plate.

When enabled, these directions rotate together with the model so the printed features keep their intended orientation relative to the part, preserving optimal strength and surface characteristics regardless of how the model is placed.

![fill-direction-to-model](https://www.orcaslicer.com/wiki/images/fill/fill-direction-to-model.png?raw=true)

## Bridge infill direction [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#bridge-infill-direction)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `bridge_angle`, `internal_bridge_angle`.

If left to zero, the bridging angle will be calculated automatically for each specific bridge.

Otherwise the provided angle will be used according to:
\- The absolute coordinates
\- The absolute coordinates + Model rotation: If [Align directions to model](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#align-directions-to-model) is enabled
\- The optimal automatic angle + this value: If [Relative Bridge Angle](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced#relative-bridge-angle) is enabled

Note

Use 180° for zero absolute angle.

## Relative Bridge Angle [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#relative-bridge-angle)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `relative_bridge_angle`.

When enabled, the bridge angle values are added to the automatically calculated bridge direction instead of overriding it.

Recommended to add a small angle (<10°) to improve bridge covering in closed shapes.

![bridge-angle-0](https://www.orcaslicer.com/wiki/images/bridging/bridge-angle-0.png?raw=true)![bridge-angle-2](https://www.orcaslicer.com/wiki/images/bridging/bridge-angle-2.png?raw=true)![bridge-angle-8](https://www.orcaslicer.com/wiki/images/bridging/bridge-angle-8.png?raw=true)

## Minimum sparse infill threshold [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#minimum-sparse-infill-threshold)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `minimum_sparse_infill_area`.

Sparse infill areas smaller than the threshold value are replaced by [internal solid infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill).
This setting helps to ensure that small areas of sparse infill do not compromise the strength of the print. It is particularly useful for models with intricate designs or small features where sparse infill may not provide sufficient support.

## Infill Combination [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#infill-combination)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `infill_combination`.

Automatically combine [sparse infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html) of several layers so they print together and reduce print time and while increasing strength. While walls are still printed with the original [layer height](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_layer_height.html).

![fill-combination](https://www.orcaslicer.com/wiki/images/fill/fill-combination.png?raw=true)

### Max layer height [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#max-layer-height)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `infill_combination_max_layer_height`.

Maximum layer height for the combined sparse infill.

Set it to 0 or 100% to use the nozzle diameter (for maximum reduction in print time), or to a value of ~80% to maximize sparse infill strength.

The number of layers over which infill is combined is derived by dividing this value by the layer height and rounding down to the nearest decimal.

Use either absolute mm values (e.g., 0.32mm for a 0.4mm nozzle) or percentages (e.g., 80%). This value must not be larger than the nozzle diameter.

## Detect narrow internal solid infill [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#detect-narrow-internal-solid-infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `detect_narrow_internal_solid_infill`.

This option auto-detects narrow internal solid infill areas. If enabled, the [concentric pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#concentric) will be used in those areas to speed up printing. Otherwise, the [rectilinear pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#rectilinear) will be used by default.

## Ensure vertical shell thickness [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced\#ensure-vertical-shell-thickness)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `ensure_vertical_shell_thickness`.

Add solid infill near sloping surfaces to guarantee the vertical shell thickness (top and bottom solid layers).

- **None**: No solid infill will be added anywhere. **Caution:** Use this option carefully if your model has sloped surfaces.
- **Critical Only**: Avoid adding solid infill for walls.
- **Moderate**: Add solid infill for heavily sloping surfaces only.
- **All (default)**: Add solid infill for all suitable sloping surfaces.

Back to top