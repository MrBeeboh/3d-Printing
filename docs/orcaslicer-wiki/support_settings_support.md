# SOURCE: https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#support)

# Support [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#support)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Developer`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `enable_support`, `enforce_support_layers`.

Support structures are used in 3D printing to provide stability to overhangs and complex geometries.

- [Type](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#type)
  - [Normal](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#normal)
  - [Tree](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#tree)
    - [Support critical regions only](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#support-critical-regions-only)
  - [Auto](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#auto)
  - [Manual](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#manual)
- [Style](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#style)
  - [Grid](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#grid)
  - [Snug](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#snug)
  - [Organic](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#organic)
  - [Tree Slim](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#tree-slim)
  - [Tree Strong](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#tree-strong)
  - [Tree Hybrid](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#tree-hybrid)
- [Threshold angle](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#threshold-angle)
- [Threshold overlap](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#threshold-overlap)
- [Initial layer density](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#initial-layer-density)
- [Initial layer expansion](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#initial-layer-expansion)
- [On build plate only](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#on-build-plate-only)
- [Ignore small overhangs](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support#ignore-small-overhangs)

## Type [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#type)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_type`.

Support structures can be generated in various styles, each suited for different printing needs:

### Normal [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#normal)

Normal support structures are generated in a grid pattern, providing a stable base for overhangs and complex geometries.

### Tree [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#tree)

Tree-like support structures are designed to minimize material usage while still providing adequate support. They branch out from a central trunk, allowing for more efficient printing.

#### Support critical regions only [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#support-critical-regions-only)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_critical_regions_only`.

Only create support for critical regions including sharp tail, cantilever, etc.

### Auto [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#auto)

Automatically generates support structures where needed, based on the model's geometry and overhangs and manual placement in the prepare view.

### Manual [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#manual)

Limit support generation to specific areas defined by manual placement in the prepare view.

## Style [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#style)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_style`.

Style and shape of the support.

### Grid [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#grid)

Default in normal support, projecting the supports into a regular grid will create more stable supports.

### Snug [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#snug)

Snug support towers will save material and reduce object scarring.

### Organic [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#organic)

Default style for tree support, which merges slim and organic style branches more aggressively and saves material.

### Tree Slim [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#tree-slim)

Slim tree support branches are designed to be more delicate and use less material while still providing adequate support.

### Tree Strong [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#tree-strong)

Strong tree support branches are designed to be more robust and provide additional support for heavier overhangs.

### Tree Hybrid [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#tree-hybrid)

Create similar structure to normal support under large flat overhangs.

## Threshold angle [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#threshold-angle)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_threshold_angle`.

Support will be generated for overhangs whose slope angle is below the threshold.

## Threshold overlap [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#threshold-overlap)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_threshold_overlap`.

If threshold angle is zero, support will be generated for overhangs whose overlap is below the threshold.
The smaller this value is, the steeper the overhang that can be printed without support.

## Initial layer density [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#initial-layer-density)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `raft_first_layer_density`.

Density of the first raft or support layer.

## Initial layer expansion [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#initial-layer-expansion)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `raft_first_layer_expansion`.

Expand the first raft or support layer to improve bed plate adhesion.

## On build plate only [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#on-build-plate-only)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_on_build_plate_only`.

Don't create support on model surface, only on build plate.

## Ignore small overhangs [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_support\#ignore-small-overhangs)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `support_remove_small_overhang`.

With this setting small overhangs that possibly need no supports will be ignored from support generation.

Back to top