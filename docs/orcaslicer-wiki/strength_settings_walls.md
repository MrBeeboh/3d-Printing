# SOURCE: https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls#walls)

# Walls [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls\#walls)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `wall_loops`.

In 3D printing, "walls" refer to the outer layers of a printed object that provide its shape and structural integrity.

Adjusting wall settings can significantly affect layer adhesion, strength, appearance and print time of your model.

![walls](https://www.orcaslicer.com/wiki/images/walls/walls.png?raw=true)

- [Wall loops](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls#wall-loops)
- [Alternate extra wall](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls#alternate-extra-wall)
- [Detect thin wall](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls#detect-thin-wall)

Tip

**Recommended**

Advanced tips on improving strength.

[![makers-muse-walls-strength](https://www.orcaslicer.com/wiki/images/video/makers-muse-walls-strength.png?raw=true)](https://www.youtube.com/watch?v=c7CI6yBTKMc)

Video by **Maker's Muse**, with consent.

## Wall loops [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls\#wall-loops)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `wall_loops`.

"Wall loops" refers to the number of times the outer wall is printed in a loop.

Increasing the wall loops will:

- Enhance:
  - Layer adhesion
  - Strength
  - Rigidity
- Reduce infill ghosting
- Increase print time

## Alternate extra wall [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls\#alternate-extra-wall)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `alternate_extra_wall`.

This setting adds an extra wall to every other layer. This way the infill gets wedged vertically between the walls, resulting in stronger prints.

When this option is enabled, the ensure vertical shell thickness option needs to be disabled.

Warning

It's not recommended to use this option with:

- [Lightning infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#lightning) as there is limited infill to anchor the extra perimeters to.
- **[Ensure vertical shell thickness: ALL](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced.html#ensure-vertical-shell-thickness)**

## Detect thin wall [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls\#detect-thin-wall)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `detect_thin_wall`.

By default, walls are printed as closed loops. When a wall is too thin to contain two line widths, enabling "Detect thin walls" prints it as a single extrusion line.

Thin walls printed this way may have reduced surface quality and strength because they are not closed loops.

Tip

Usually, it is recommended to use [Arachne wall generator](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_generator.html#arachne) which will disable "Detect thin walls" because it uses a different approach to wall generation.

- In small details it can generate details that wouldn't be possible with traditional wall generation methods.

![walls-small-detect-thin-off](https://www.orcaslicer.com/wiki/images/walls/walls-small-detect-thin-off.png?raw=true)![walls-small-detect-thin-on](https://www.orcaslicer.com/wiki/images/walls/walls-small-detect-thin-on.png?raw=true)
- In large prints, it can generate defects more easily due to the reduced wall thickness.
![walls-big-detect-thin-off-on](https://www.orcaslicer.com/wiki/images/walls/walls-big-detect-thin-off-on.png?raw=true)

Back to top