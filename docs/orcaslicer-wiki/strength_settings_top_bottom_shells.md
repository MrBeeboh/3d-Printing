# SOURCE: https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#top-and-bottom-shells)

# Top and Bottom Shells [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#top-and-bottom-shells)

Controls how the top and bottom solid layers (shells) are generated.

![top-bottom-shells](https://www.orcaslicer.com/wiki/images/top-bottom-shells/top-bottom-shells.png?raw=true)

- [Shell Layers](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#shell-layers)
- [Shell Thickness](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#shell-thickness)
- [Surface Density](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-density)
- [Infill/Wall Overlap](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#infillwall-overlap)
- [Surface Pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-pattern)
- [Surface Expansion](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-expansion)
  - [Surface Expansion Margin](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-expansion-margin)
  - [Surface Expansion Direction](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-expansion-direction)
  - [Surface Expansion and Only One Wall](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-expansion-and-only-one-wall)
- [Center Surface Pattern On](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#center-surface-pattern-on)
- [Fill Order](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#fill-order)

## Shell Layers [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#shell-layers)

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_shell_layers`, `bottom_shell_layers`.

This is the number of solid shell layers, including the surface layer.

When the thickness calculated from this value is less than [shell thickness](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#shell-thickness), the shell layers will be increased.

These layers are printed over the [sparse infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html), so increasing **shell layers** will increase overall part strength and top surface quality.
It's usually recommended to have at least 3 shell layers for most prints.

## Shell Thickness [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#shell-thickness)

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_shell_thickness`, `bottom_shell_thickness`.

The number of solid layers is increased during slicing if the thickness calculated from shell layers is thinner than this value. This avoids having too thin a shell when layer height is small.

0 means this setting is disabled and shell thickness is determined entirely by [shell layers](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#shell-layers).

## Surface Density [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#surface-density)

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_density`, `bottom_surface_density`.

This setting controls the density of the top and bottom surfaces. A value of 100% means a solid surface, while lower values create a sparse surface.

This can be used for aesthetic purposes, improving grip or creating interfaces.

## Infill/Wall Overlap [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#infillwall-overlap)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_bottom_infill_wall_overlap`.

The top solid infill area is slightly enlarged to overlap with walls for better bonding and to minimize pinholes where the infill meets the walls.

A value of 25-30% is a good starting point. The percentage value is relative to the line width of the sparse infill.

Tip

Check [Monotonic Line](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#monotonic-line) to learn about its overlaying differences with [Monotonic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#monotonic) and [Rectilinear](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#rectilinear).

## Surface Pattern [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#surface-pattern)

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_pattern`, `bottom_surface_pattern`.

This setting controls the pattern of the surfaces.

If [Shell Layers](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#shell-layers) is greater than 1, the surface pattern will be applied to the outermost shell layer only and the rest will use [Internal Solid Infill Pattern](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill).

Tip

See [Infill Patterns Wiki List](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html) with **detailed specifications**, including their strengths and weaknesses.

The surface patterns are:

- **[Concentric](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#concentric)**
- **[Rectilinear](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#rectilinear)**
- **[Monotonic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#monotonic)**
- **[Monotonic Line](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#monotonic-line)** Usually Recommended for Top.
- **[Aligned Rectilinear](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#aligned-rectilinear)**
- **[Hilbert Curve](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#hilbert-curve)**
- **[Archimedean Chords](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#archimedean-chords)**
- **[Octagram Spiral](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#octagram-spiral)**

Tip

Enable [Align directions to model](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_advanced.html#align-directions-to-model) to make the top/bottom surface fill direction follow the model's orientation on the build plate.

## Surface Expansion [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#surface-expansion)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_expansion`.

Important

NEW FEATURE: **Top surface expansion** (expansion, margin and direction)

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Expands the top surfaces by this distance (in mm) to connect distinct top surfaces and fill the gaps left where a feature rises through them.

This is useful when the top surface is interrupted by a raised feature, such as text or a boss on a plane, or when overlapping objects would otherwise split it: expanding the surface removes the holes beneath these features, keeps the top-surface pattern uninterrupted, and anchors the solid infill for a cleaner finish when printing on top. It also improves [concentric](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#concentric) top surfaces, whose pattern would otherwise be broken up by those small holes.

The expansion is applied to the original top surface, before any other processing such as bridging or overhang detection. Set to `0` to disable it.

- **Original**

![surface_expansion_original](https://www.orcaslicer.com/wiki/images/top-bottom-shells/surface_expansion_original.png?raw=true)

- **Expanded by 5 mm**

![surface_expansion_direction_inward_and_outward](https://www.orcaslicer.com/wiki/images/top-bottom-shells/surface_expansion_direction_inward_and_outward.png?raw=true)

- Improved [concentric](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#concentric) top surface.
  - Before:![surface_expansion_concentric_before](https://www.orcaslicer.com/wiki/images/top-bottom-shells/surface_expansion_concentric_before.png?raw=true)
  - After:![surface_expansion_concentric_after](https://www.orcaslicer.com/wiki/images/top-bottom-shells/surface_expansion_concentric_after.png?raw=true)

Note

Surface expansion needs a top solid surface to grow. It does nothing when [Shell Layers](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#shell-layers) is `0` (the top surfaces are then treated as internal) or when [Surface Density](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-density) is `0%` (the top surface is left unfilled).

### Surface Expansion Margin [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#surface-expansion-margin)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_expansion_margin`.

Using [Surface Expansion](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-expansion) may cause a surface that did not previously touch the model's outer walls to now reach them, which can create contraction marks (such as a hull line) on the outer walls.

Adding a margin (in mm) keeps the expansion away from the walls where possible, so no hull line is created. The example below uses a 5 mm expansion with a 2 mm margin — compare it with the 5 mm expansion above, which reaches the walls.

The margin is the real clearance left between the expanded top surface and the walls, so it is measured from the band the walls occupy. When [Only one wall](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces.html#only-one-wall) on top surfaces is enabled, that band is a single wall, since that is all that remains over a top surface.

![surface_expansion_margin](https://www.orcaslicer.com/wiki/images/top-bottom-shells/surface_expansion_margin.png?raw=true)

### Surface Expansion Direction [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#surface-expansion-direction)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_expansion_direction`.

Direction in which the [Surface Expansion](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-expansion) grows:

- **Inward:** grows into the holes and gaps left by features rising from the middle of a top surface.
![surface_expansion_direction_inward](https://www.orcaslicer.com/wiki/images/top-bottom-shells/surface_expansion_direction_inward.png?raw=true)
- **Outward:** grows the outer edge of the surface, connecting surfaces separated by features that can divide a surface, such as a lattice pattern.
![surface_expansion_direction_outward](https://www.orcaslicer.com/wiki/images/top-bottom-shells/surface_expansion_direction_outward.png?raw=true)
- **Inward and Outward:** does both. This is the default.
![surface_expansion_direction_inward_and_outward](https://www.orcaslicer.com/wiki/images/top-bottom-shells/surface_expansion_direction_inward_and_outward.png?raw=true)

### Surface Expansion and Only One Wall [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#surface-expansion-and-only-one-wall)

[Only one wall](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_and_surfaces.html#only-one-wall) on top surfaces keeps a single wall where a top surface is detected. With more than one [wall loop](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_walls.html#wall-loops), the remaining inner walls used to be rerouted around the top surface, which could ring a feature with walls that were not needed, and cut up — or overlap with — an expanded top surface.

When **Surface Expansion** is in use, those inner walls are removed over the top surface instead, so the expanded surface stays continuous and the pattern is not interrupted:

- **[Classic](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_generator.html#classic)** wall generator: the inner walls running over the top are dropped whole. The space they leave is taken by the expanded top surface, and whatever it does not cover becomes [internal solid infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill).
- **[Arachne](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_wall_generator.html#arachne)** wall generator: the inner walls are cut instead of dropped, so only the part running over the top surface is removed and the rest is kept where the geometry continues upward.

Note

This behavior needs a top fill that can actually take that space. With **Surface Expansion** at `0` or [Surface Density](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells#surface-density) at `0%`, the inner walls are generated as before, preserving the internal support.

## Center Surface Pattern On [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#center-surface-pattern-on)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Expert`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `center_of_surface_pattern`.

Important

NEW FEATURE: **Center surface pattern on**

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Chooses where the centering point of centered top/bottom surface patterns ( [Archimedean Chords](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#archimedean-chords), [Octagram Spiral](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#octagram-spiral)) is placed.

By default these patterns are centered individually on each surface, which does not keep the pattern continuous across a whole product — a drawback for some artistic prints where the surfaces should read as one piece. This setting widens the scope of the shared center:

- **Each Surface:** centers the pattern on every individual surface region, so each island is symmetric on its own. This is the previous behavior.

![center_of_surface_pattern_each_surface](https://www.orcaslicer.com/wiki/images/top-bottom-shells/center_of_surface_pattern_each_surface.png?raw=true)

- **Each Model:** combines all the surfaces of one model — or each shape in the assembly — under a single center. Parts that touch or overlap share one center; parts detached from the rest each get their own.

![center_of_surface_pattern_each_model](https://www.orcaslicer.com/wiki/images/top-bottom-shells/center_of_surface_pattern_each_model.png?raw=true)

- **Each Assembly:** all the surfaces of the assembly fall under a single shared center. Well suited for articulated models that should keep one continuous pattern across their parts.

![center_of_surface_pattern_each_assembly](https://www.orcaslicer.com/wiki/images/top-bottom-shells/center_of_surface_pattern_each_assembly.png?raw=true)

## Fill Order [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells\#fill-order)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_fill_order`, `bottom_surface_fill_order`.

Important

NEW FEATURE: **Fill order**

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Direction in which the top and bottom surfaces are filled when using a center-based pattern ( [Concentric](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#concentric), [Archimedean Chords](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#archimedean-chords), [Octagram Spiral](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html#octagram-spiral)). The spirals/rings are then deposited consistently inward or outward instead of following the default shortest path.

![fill-order](https://www.orcaslicer.com/wiki/images/directions/fill-order.jpg?raw=true)

- **Default:** uses legacy ordering.
- **Outward:** starts at the center of the surface, so any excess material is pushed towards the edge where it is least visible. Preferred for **top** surfaces, as it hides small imperfections better.
- **Inward:** starts at the edge and ends with the tight curves at the center. Preferred for **bottom** surfaces, as starting each surface with the wider outer curves improves first layer adhesion on build plates where the tight curves at the center may not stick.

Back to top