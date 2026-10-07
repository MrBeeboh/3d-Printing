# SOURCE: https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree#tree-support)

# Tree Support [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree\#tree-support)

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `tree_support_auto_brim`, `tree_support_brim_width`.

This section contains specific settings for tree support structures.

## Tip Diameter [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree\#tip-diameter)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `tree_support_tip_diameter`.

Branch tip diameter for organic supports.

## Branch Distance [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree\#branch-distance)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `tree_support_branch_distance`, `tree_support_branch_distance_organic`.

This setting determines the distance between neighboring tree support nodes.

## Branch Density [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree\#branch-density)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `tree_support_top_rate`.

Adjusts the density of the support structure used to generate the tips of the branches. A higher value results in better overhangs but the supports are harder to remove, thus it is recommended to enable top support interfaces instead of a high branch density value if dense interfaces are needed.

## Branch Diameter [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree\#branch-diameter)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `tree_support_branch_diameter`, `tree_support_branch_diameter_organic`.

This setting determines the initial diameter of support nodes.

## Branch Diameter Angle [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree\#branch-diameter-angle)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `tree_support_branch_diameter_angle`.

The angle of the branches' diameter as they gradually become thicker towards the bottom. An angle of 0 will cause the branches to have uniform thickness over their length. A bit of an angle can increase stability of the organic support.

## Branch Angle [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree\#branch-angle)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `tree_support_branch_angle`, `tree_support_branch_angle_organic`.

This setting determines the maximum overhang angle that the branches of tree support are allowed to make. If the angle is increased, the branches can be printed more horizontally, allowing them to reach farther.

### Preferred Branch Angle [¶](https://www.orcaslicer.com/wiki/print_settings/support/support_settings_tree\#preferred-branch-angle)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `tree_support_angle_slow`.

The preferred angle of the branches, when they do not have to avoid the model. Use a lower angle to make them more vertical and more stable. Use a higher angle for branches to merge faster.

Back to top