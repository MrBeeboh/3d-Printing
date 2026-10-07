# SOURCE: https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#patterns)

# Patterns [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#patterns)

Patterns determine how material is distributed within a print. Different patterns can affect strength, flexibility and print speed using the same density setting.

The infill pattern also impacts the uniformity of the layer times, since the patterns may be constant, or present significant variations between adjacent layers.

There is no one-size-fits-all solution, as the best pattern depends on the specific print and its requirements.

Many patterns may look similar and have similar overall specifications, but they can behave very differently in practice.

As most settings in 3D printing, experience is the best way to determine which pattern works best for your specific needs.

Tip

Quickly compare patterns with the [Patterns Quick Reference Table](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns_quick_reference.html).

## Analysis parameters [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#analysis-parameters)

### Strength [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#strength)

- **X-Y Direction**: The strength of the print in the "Horizontal" X-Y plane. Affected by the pattern's connections between walls, contact between layers, and path.
- **Z Direction**: The strength of the print in the "Vertical" Z direction. Affected by contact between layers.

### Material Usage [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#material-usage)

Not all patterns use the same amount of material due to their **Density Calculations** and adjustments to the paths.

This leads to patterns that do not use the specified percentage but rather variations of it.

### Print Time [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#print-time)

Print time can vary significantly between patterns due to differences in their pathing and infill strategies.

Some patterns may complete faster due to more efficient use of the print head's movement, while others may take longer due to more complex paths.

Note

OrcaSlicer Time estimations are not always accurate, especially with complex patterns.

This analysis was estimated with [Klipper Estimator](https://github.com/Annex-Engineering/klipper_estimator).

### Layer Time Variability [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#layer-time-variability)

Layer time variability refers to the differences in time it takes to print each layer of a pattern. Some patterns may have consistent layer times, while others may experience significant fluctuations. These variations can potentially impact the outer appearance of the print due to differences in cooling and material flow between layers.

![fill-layer-time-variability](https://www.orcaslicer.com/wiki/images/fill/fill-layer-time-variability.png?raw=true)

## Monotonic [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#monotonic)

[Rectilinear](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#rectilinear) in a uniform direction for a smoother visual surface.

- **Strength**
  - **Horizontal (X-Y):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
  - **Vertical (Z):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** N/A
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** N/A
- **Applies to:**
  - **[Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill)**
  - **[Surface](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html)**

![infill-top-monotonic](https://www.orcaslicer.com/wiki/images/fill/infill-top-monotonic.png?raw=true)

## Monotonic line [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#monotonic-line)

[Monotonic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#monotonic) but avoids overlapping with the perimeter, reducing excess material at joints. May introduce visible seams and increase print time.

- **Strength**
  - **Horizontal (X-Y):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
  - **Vertical (Z):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** N/A
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** N/A
- **Applies to:**
  - **[Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill)**
  - **[Surface](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html)**

![infill-top-monotonic-line](https://www.orcaslicer.com/wiki/images/fill/infill-top-monotonic-line.png?raw=true)

## Rectilinear [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#rectilinear)

Parallel lines spaced according to infill density. Each layer is printed perpendicular to the previous, resulting in low vertical bonding. Consider using new [Zig Zag](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#zig-zag) infill instead.

- **Strength**
  - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
  - **Vertical (Z):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**
  - **[Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill)**
  - **[Surface](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html)**
  - **[Ironing](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing.html)**

![infill-top-rectilinear](https://www.orcaslicer.com/wiki/images/fill/infill-top-rectilinear.png?raw=true)

## Aligned Rectilinear [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#aligned-rectilinear)

Parallel lines spaced by the infill spacing, each layer printed in the same direction as the previous layer. Good horizontal strength perpendicular to the lines, but terrible in parallel direction.
Recommended with layer anchoring to improve not perpendicular strength.

- **Strength**
  - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
  - **Vertical (Z):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**
  - **[Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill)**
  - **[Surface](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html)**

![infill-top-aligned-rectilinear](https://www.orcaslicer.com/wiki/images/fill/infill-top-aligned-rectilinear.png?raw=true)

## Zig Zag [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#zig-zag)

Similar to [rectilinear](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#rectilinear) with consistent pattern between layers.

- **Strength**
  - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
  - **Vertical (Z):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** No
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** Yes
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-zig-zag](https://www.orcaslicer.com/wiki/images/fill/infill-top-zig-zag.png?raw=true)

## Cross Zag [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#cross-zag)

Similar to [Zig Zag](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#zig-zag) but displacing each layer with Infill shift step parameter.

- **Strength**
  - **Horizontal (X-Y):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
  - **Vertical (Z):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** No
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** Yes
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-cross-zag](https://www.orcaslicer.com/wiki/images/fill/infill-top-cross-zag.png?raw=true)

## Locked Zag [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#locked-zag)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `skin_infill_density`, `skeleton_infill_density`, `infill_lock_depth`, `skin_infill_depth`, `skin_infill_line_width`, `skeleton_infill_line_width`.

Version of [Zig Zag](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#zig-zag) that adds extra skin.
When using this fill, you can individually modify the density of the skeleton and skin, as well as the size of the skin and how much interconnection there is between the skin and the skeleton (a lock depth of 50% of the skin depth is recommended).

- **Strength**
  - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
  - **Vertical (Z):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
- **Density Calculation:** Similar to [Zig Zag](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#zig-zag).
Skin density \* ( Infill Area - Skin Area + lock depth area) + ( Skin density \* Skin area).
  - **Material Usage:** Normal-High ![level-to-worse-5](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-5.svg?raw=true)
  - **Print Time:** Normal-High ![level-to-worse-5](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-5.svg?raw=true)
    - **Material/Time (Higher better):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** No
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** Yes
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-locked-zag](https://www.orcaslicer.com/wiki/images/fill/infill-top-locked-zag.png?raw=true)

## Line [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#line)

Similar to [rectilinear](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#rectilinear), but each line is slightly rotated to improve print speed.

- **Strength**
  - **Horizontal (X-Y):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
  - **Vertical (Z):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** No
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-line](https://www.orcaslicer.com/wiki/images/fill/infill-top-line.png?raw=true)

## Grid [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#grid)

Two-layer pattern of perpendicular lines, forming a grid. Overlapping points may cause noise or artifacts.

- **Strength**
  - **Horizontal (X-Y):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
  - **Vertical (Z):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Low ![level-to-worse-2](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-2.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Non-Crossing](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#non-crossing-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-grid](https://www.orcaslicer.com/wiki/images/fill/infill-top-grid.png?raw=true)

## Triangles [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#triangles)

Triangle-based grid, offering strong X-Y strength but with triple overlaps at intersections.

- **Strength**
  - **Horizontal (X-Y):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
  - **Vertical (Z):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Non-Crossing](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#non-crossing-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-triangles](https://www.orcaslicer.com/wiki/images/fill/infill-top-triangles.png?raw=true)

## Tri-hexagon [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#tri-hexagon)

Similar to the [triangles](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#triangles) pattern but offset to prevent triple overlaps at intersections. This design combines triangles and hexagons, providing excellent X-Y strength.

- **Strength**
  - **Horizontal (X-Y):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
  - **Vertical (Z):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Non-Crossing](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#non-crossing-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-tri-hexagon](https://www.orcaslicer.com/wiki/images/fill/infill-top-tri-hexagon.png?raw=true)

## Cubic [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#cubic)

3D cube pattern with corners facing down, distributing force in all directions. Triangles in the horizontal plane provide good X-Y strength.

- **Strength**
  - **Horizontal (X-Y):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
  - **Vertical (Z):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-cubic](https://www.orcaslicer.com/wiki/images/fill/infill-top-cubic.png?raw=true)

## Adaptive Cubic [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#adaptive-cubic)

[Cubic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#cubic) pattern with adaptive density: denser near walls, sparser in the center. Saves material and time while maintaining strength, ideal for large prints.

- **Strength**
  - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
  - **Vertical (Z):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:** Same as [Cubic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#cubic) but reduced in the center
  - **Material Usage:** Low ![level-to-worse-2](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-2.svg?raw=true)
  - **Print Time:** Low ![level-to-worse-2](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-2.svg?raw=true)
    - **Material/Time (Higher better):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-adaptive-cubic](https://www.orcaslicer.com/wiki/images/fill/infill-top-adaptive-cubic.png?raw=true)

## Quarter Cubic [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#quarter-cubic)

[Cubic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#cubic) pattern with extra internal divisions, improving X-Y strength.

- **Strength**
  - **Horizontal (X-Y):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
  - **Vertical (Z):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-quarter-cubic](https://www.orcaslicer.com/wiki/images/fill/infill-top-quarter-cubic.png?raw=true)

## Support Cubic [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#support-cubic)

Support \|Cubic is a variation of the [Cubic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#cubic) infill pattern that is specifically designed for support top layers. Will use more material than Lightning infill but will provide better strength. Nevertheless, it is still a low-density infill pattern.

- **Strength**
  - **Horizontal (X-Y):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
  - **Vertical (Z):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**% of layer before top shell layers
  - **Material Usage:** Extra-Low ![level-to-worse-1](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-1.svg?raw=true)
  - **Print Time:** Extra-Low ![level-to-worse-1](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-1.svg?raw=true)
    - **Material/Time (Higher better):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
    - **Layer time Variability:** Likely Noticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-support-cubic](https://www.orcaslicer.com/wiki/images/fill/infill-top-support-cubic.png?raw=true)

## Lightning [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#lightning)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Expert`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `lightning_overhang_angle`, `lightning_prune_angle`, `lightning_straightening_angle`.

Ultra-fast, ultra-low material infill. Designed for speed and efficiency, ideal for quick prints or non-structural prototypes.

### Overhang Angle [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#overhang-angle)

Similar to the [overhang](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_overhangs.html) angle used for support generation, but specifically for Lightning infill.

It determines how far the infill can extend from walls before needing support.

### Prune Angle [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#prune-angle)

Controls how aggressively short/unsupported branches of the Lightning infill are pruned.

A lower angle will result in more pruning, while a higher angle will allow for more unsupported branches.

### Straightening Angle [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#straightening-angle)

Limits how far junctions in the Lightning infill can be moved to straighten lines.

Using a low value will result in a low lateral distortion between layers, but may cause more pruning.

A higher value will allow for more straightening, improving strength but increasing lateral distortion.

![infill-top-lightning-straightening](https://www.orcaslicer.com/wiki/images/fill/infill-top-lightning-straightening.png?raw=true)

![infill-top-front-lightning-straightening](https://www.orcaslicer.com/wiki/images/fill/infill-top-front-lightning-straightening.png?raw=true)

![infill-front-lightning-straightening](https://www.orcaslicer.com/wiki/images/fill/infill-front-lightning-straightening.png?raw=true)

- **Strength**
  - **Horizontal (X-Y):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
  - **Vertical (Z):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**% of layer before top shell layers
  - **Material Usage:** Ultra-Low ![level-to-worse-0](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-0.svg?raw=true)
  - **Print Time:** Ultra-Low ![level-to-worse-0](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-0.svg?raw=true)
    - **Material/Time (Higher better):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
    - **Layer time Variability:** Likely Noticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-lightning](https://www.orcaslicer.com/wiki/images/fill/infill-top-lightning.png?raw=true)

## Honeycomb [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#honeycomb)

Hexagonal pattern balancing strength and material use. Double walls in each hexagon increase material consumption.

- **Strength**
  - **Horizontal (X-Y):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
  - **Vertical (Z):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** High ![level-to-worse-6](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-6.svg?raw=true)
  - **Print Time:** Ultra-High ![level-to-worse-8](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-8.svg?raw=true)
    - **Material/Time (Higher better):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Non-Crossing](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#non-crossing-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-honeycomb](https://www.orcaslicer.com/wiki/images/fill/infill-top-honeycomb.png?raw=true)

## 3D Honeycomb [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#3d-honeycomb)

This infill tries to generate a printable honeycomb structure by printing squares and octagons maintaining a vertical angle high enough to maintain contact with the previous layer.

- **Strength**
  - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
  - **Vertical (Z):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:**Unknown
  - **Material Usage:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
  - **Print Time:** Extra-High ![level-to-worse-7](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-7.svg?raw=true)
    - **Material/Time (Higher better):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
    - **Layer time Variability:** Possibly Noticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-3d-honeycomb](https://www.orcaslicer.com/wiki/images/fill/infill-top-3d-honeycomb.png?raw=true)

## Lateral Honeycomb [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#lateral-honeycomb)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `infill_overhang_angle`.

Vertical Honeycomb pattern. Acceptable torsional stiffness. Developed for low densities structures like wings. Improve over [Lateral Lattice](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#lateral-lattice) offers same performance with lower densities.This infill includes a Overhang angle parameter to improve the point of contact between layers and reduce the risk of delamination.

- **Strength**
  - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
  - **Vertical (Z):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** Possibly Noticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-lateral-honeycomb](https://www.orcaslicer.com/wiki/images/fill/infill-top-lateral-honeycomb.png?raw=true)

## Lateral Lattice [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#lateral-lattice)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `lateral_lattice_angle_1`, `lateral_lattice_angle_2`.

Low-strength pattern with good flexibility. You can adjust **Angle 1** and **Angle 2** to optimize the infill for your specific model. Each angle adjusts the plane of each layer generated by the pattern. 0° is vertical.

- **Strength**
  - **Horizontal (X-Y):** Normal-Low ![level-to-better-3](https://www.orcaslicer.com/wiki/images/misc/level-to-better-3.svg?raw=true)
  - **Vertical (Z):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-lateral-lattice](https://www.orcaslicer.com/wiki/images/fill/infill-top-lateral-lattice.png?raw=true)

## Cross Hatch [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#cross-hatch)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `infill_shift_step`.

Similar to [Gyroid](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#gyroid) but with linear patterns, creating weak points at internal corners.
Easier to slice but consider using [TPMS-D](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#tpms-d) or [Gyroid](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#gyroid) for better strength and flexibility.

- **Strength**
  - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
  - **Vertical (Z):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** High ![level-to-worse-6](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-6.svg?raw=true)
    - **Material/Time (Higher better):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
    - **Layer time Variability:** Likely Noticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-cross-hatch](https://www.orcaslicer.com/wiki/images/fill/infill-top-cross-hatch.png?raw=true)

## TPMS-D [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#tpms-d)

Triply Periodic Minimal Surface (Schwarz Diamond). Hybrid between [Cross Hatch](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#cross-hatch) and [Gyroid](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#gyroid), combining rigidity and smooth transitions. Isotropic and strong in all directions. This geometry is faster to slice than Gyroid, but slower than Cross Hatch.

- **Strength**
  - **Horizontal (X-Y):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
  - **Vertical (Z):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** High ![level-to-worse-6](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-6.svg?raw=true)
    - **Material/Time (Higher better):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
    - **Layer time Variability:** Possibly Noticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-tpms-d](https://www.orcaslicer.com/wiki/images/fill/infill-top-tpms-d.png?raw=true)

## TPMS-FK [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#tpms-fk)

Triply Periodic Minimal Surface (Fischer–Koch S) pattern. Its smooth, continuous geometry resembles trabecular bone microstructure, offering a balance between rigidity and energy absorption. Compared to [TPMS-D](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#tpms-d), it has more complex curvature, which can improve load distribution and shock absorption in functional parts.

- **Strength**
  - **Horizontal (X-Y):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
  - **Vertical (Z):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Ultra-High ![level-to-worse-8](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-8.svg?raw=true)
    - **Material/Time (Higher better):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
    - **Layer time Variability:** Possibly Noticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-tpms-fk](https://www.orcaslicer.com/wiki/images/fill/infill-top-tpms-fk.png?raw=true)

## Gyroid [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#gyroid)

Mathematical, isotropic surface providing equal strength in all directions. Excellent for strong, flexible prints and resin filling due to its interconnected structure. Since it does not contain straight lines over long stretches, it helps reduce warping, as the material's contraction is distributed along its curved lines. This pattern may require more time to slice because of all the points needed to generate each curve. If your model has complex geometry, consider using a simpler infill pattern like [TPMS-D](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#tpms-d) or [Cross Hatch](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns#cross-hatch).

### Gyroid Optimized [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#gyroid-optimized)

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `gyroid_optimized`.

Tightens the gyroid wave along the Z (vertical) axis at low infill density to shorten the effective vertical column length and improve Z-axis compression buckling resistance. Filament use is preserved. No effect at ~30% sparse infill density and above. Only applies when Sparse infill pattern is set to Gyroid.

- **Strength**
  - **Horizontal (X-Y):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
  - **Vertical (Z):** High ![level-to-better-6](https://www.orcaslicer.com/wiki/images/misc/level-to-better-6.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Ultra-High ![level-to-worse-8](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-8.svg?raw=true)
    - **Material/Time (Higher better):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
    - **Layer time Variability:** Unnoticeable
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**

![infill-top-gyroid](https://www.orcaslicer.com/wiki/images/fill/infill-top-gyroid.png?raw=true)

## Concentric [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#concentric)

Fills the area with progressively smaller versions of the outer contour, creating a concentric pattern. Ideal for 100% infill or flexible prints.

- **Strength**
  - **Horizontal (X-Y):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
  - **Vertical (Z):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**
  - **[Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill)**
  - **[Surface](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html)**
  - **[Ironing](https://www.orcaslicer.com/wiki/print_settings/quality/quality_settings_ironing.html)**

![infill-top-concentric](https://www.orcaslicer.com/wiki/images/fill/infill-top-concentric.png?raw=true)

## Hilbert Curve [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#hilbert-curve)

Hilbert Curve is a space-filling curve that can be used to create a continuous infill pattern. It is known for its aesthetic appeal and ability to fill space efficiently.
Print speed is very low due to the complexity of the path, which can lead to longer print times. It is not recommended for structural parts but can be used for aesthetic purposes.

### Sparse Infill Smooth Factor [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#sparse-infill-smooth-factor)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `sparse_infill_smooth_factor`.

Important

NEW FEATURE: **Sparse infill smooth factor**

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

Rounds the corners of the Hilbert Curve infill path using quintic Bézier curves instead of the original right-angle turns.

`0%` keeps the original right-angle path, while `100%` produces the largest possible curves between adjacent infill lines. Currently only applies to the Hilbert Curve pattern.

Note

Unlike a simple rounded corner (an arc with constant curvature), a quintic Bézier curve eases into and out of the turn gradually, starting and ending straight. This lets the nozzle change direction smoothly instead of snapping into a curve, which is what actually cuts down on vibration and ringing, compared to a plain round-over.

Smoothing the corners reduces plastic shrinkage at each turn and helps keep the nozzle from scratching the infill during travel moves made with little or no Z-hop.

- **Strength**
  - **Horizontal (X-Y):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
  - **Vertical (Z):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Extra-High ![level-to-worse-7](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-7.svg?raw=true)
    - **Material/Time (Higher better):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**
  - **[Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill)**
  - **[Surface](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html)**

![infill-top-hilbert-curve](https://www.orcaslicer.com/wiki/images/fill/infill-top-hilbert-curve.png?raw=true)

## Archimedean Chords [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#archimedean-chords)

Spiral pattern that fills the area with concentric arcs, creating a smooth and continuous infill. Can be filled with resin thanks to its interconnected hollow structure, which allows the resin to flow through it and cure properly.

- **Strength**
  - **Horizontal (X-Y):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
  - **Vertical (Z):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal-Low ![level-to-worse-3](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-3.svg?raw=true)
    - **Material/Time (Higher better):** Normal-High ![level-to-better-5](https://www.orcaslicer.com/wiki/images/misc/level-to-better-5.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**
  - **[Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill)**
  - **[Surface](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html)**

![infill-top-archimedean-chords](https://www.orcaslicer.com/wiki/images/fill/infill-top-archimedean-chords.png?raw=true)

## Octagram Spiral [¶](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_patterns\#octagram-spiral)

Aesthetic pattern with low strength and high print time.

- **Strength**
  - **Horizontal (X-Y):** Low ![level-to-better-2](https://www.orcaslicer.com/wiki/images/misc/level-to-better-2.svg?raw=true)
  - **Vertical (Z):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
- **Density Calculation:**% of total infill volume
  - **Material Usage:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
  - **Print Time:** Normal ![level-to-worse-4](https://www.orcaslicer.com/wiki/images/misc/level-to-worse-4.svg?raw=true)
    - **Material/Time (Higher better):** Normal ![level-to-better-4](https://www.orcaslicer.com/wiki/images/misc/level-to-better-4.svg?raw=true)
    - **Layer time Variability:** None
- **Extra:**
  - **[Multiline](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#fill-multiline):** [Classic](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#classic-strategy)
  - **[Symmetric infill Y axis](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#symmetric-infill-y-axis):** No
- **Applies to:**
  - **[Sparse Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#sparse-infill-density)**
  - **[Solid Infill](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_infill.html#internal-solid-infill)**
  - **[Surface](https://www.orcaslicer.com/wiki/print_settings/strength/strength_settings_top_bottom_shells.html)**

![infill-top-octagram-spiral](https://www.orcaslicer.com/wiki/images/fill/infill-top-octagram-spiral.png?raw=true)