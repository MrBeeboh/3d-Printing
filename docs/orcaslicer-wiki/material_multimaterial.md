# SOURCE: https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial.html

[Skip to content](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#material-multimaterial-settings)

# Material Multimaterial Settings [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#material-multimaterial-settings)

This page documents the settings used when printing with multiple materials in Orca Slicer. It explains wipe-tower parameters, tool-change behaviour for both single-extruder and multi-extruder multimaterial setups, and ramming/purge options that help ensure reliable, contamination-free material changes.

- [Multimaterial Wipe Tower Parameters](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#multimaterial-wipe-tower-parameters)
  - [Minimal purge on wipe tower](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#minimal-purge-on-wipe-tower)
- [Multi Filament](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#multi-filament)
- [Tool change parameters with single extruder](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#tool-change-parameters-with-single-extruder)
  - [Loading speed at the start](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#loading-speed-at-the-start)
  - [Loading speed](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#loading-speed)
  - [Unloading speed at the start](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#unloading-speed-at-the-start)
  - [Unloading speed](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#unloading-speed)
  - [Delay after unloading](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#delay-after-unloading)
  - [Number of cooling moves](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#number-of-cooling-moves)
  - [Speed of the first cooling move](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#speed-of-the-first-cooling-move)
  - [Speed of the last cooling move](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#speed-of-the-last-cooling-move)
  - [Stamping loading speed](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#stamping-loading-speed)
  - [Stamping distance](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#stamping-distance)
  - [Ramming parameters](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#ramming-parameters)
    - [Total ramming](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#total-ramming)
    - [Ramming line](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#ramming-line)
- [Tool change parameters with multi extruder](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#tool-change-parameters-with-multi-extruder)
  - [Enable ramming for multi-tool setups](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#enable-ramming-for-multi-tool-setups)
    - [Multi-tool ramming volume](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#multi-tool-ramming-volume)
    - [Multi-tool ramming flow](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial#multi-tool-ramming-flow)

## Multimaterial Wipe Tower Parameters [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#multimaterial-wipe-tower-parameters)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_minimal_purge_on_wipe_tower`, `filament_tower_interface_pre_extrusion_dist`, `filament_tower_interface_pre_extrusion_length`, `filament_tower_ironing_area`, `filament_tower_interface_purge_volume`, `filament_tower_interface_print_temp`.

Wipe towers are sacrificial structures printed alongside the main object to purge excess material from the nozzle after a tool change in multimaterial printing. This ensures that the next extrusion uses the correct filament color or type without contamination from the previous material.

### Minimal purge on wipe tower [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#minimal-purge-on-wipe-tower)

After a tool change, the exact position of the newly loaded filament inside the nozzle may not be known, and the filament pressure is likely not yet stable. Before purging the print head into an infill or a sacrificial object, Orca Slicer will always prime this amount of material into the wipe tower to produce successive infill or sacrificial object extrusions reliably.

## Multi Filament [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#multi-filament)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `long_retractions_when_ec`, `retraction_distances_when_ec`.

Enable long retraction when the extruder changes and set its retraction distance value for extruder changes.

## Tool change parameters with single extruder [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#tool-change-parameters-with-single-extruder)

These settings control filament loading and unloading for single-extruder multimaterial systems (where multiple filaments are fed to a single hotend). They govern how much filament is primed or purged on the wipe tower, the speeds used during load/unload phases, delays for flexible materials, cooling-move behaviour, stamping and the ramming routine. Proper tuning reduces cross-contamination between filaments and improves tool-change reliability.

### Loading speed at the start [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#loading-speed-at-the-start)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_loading_speed_start`.

Speed used at the very beginning of loading phase.

### Loading speed [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#loading-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_loading_speed`.

Speed used for loading the filament on the wipe tower.

### Unloading speed at the start [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#unloading-speed-at-the-start)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_unloading_speed_start`.

Speed used for unloading the tip of the filament immediately after ramming.

### Unloading speed [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#unloading-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_unloading_speed`.

Speed used for unloading the filament on the wipe tower (does not affect initial part of unloading just after ramming).

### Delay after unloading [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#delay-after-unloading)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_toolchange_delay`.

Time to wait after the filament is unloaded. May help to get reliable tool changes with flexible materials that may need more time to shrink to original dimensions.

### Number of cooling moves [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#number-of-cooling-moves)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_cooling_moves`.

Filament is cooled by being moved back and forth in the cooling tubes. Specify desired number of these moves.

### Speed of the first cooling move [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#speed-of-the-first-cooling-move)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_cooling_initial_speed`.

Cooling moves are gradually accelerating beginning at this speed.

### Speed of the last cooling move [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#speed-of-the-last-cooling-move)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_cooling_final_speed`.

Cooling moves are gradually accelerating towards this speed.

### Stamping loading speed [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#stamping-loading-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_stamping_loading_speed`.

Speed used for stamping.

### Stamping distance [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#stamping-distance)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_stamping_distance`.

Stamping distance measured from the center of the cooling tube.
If set to non-zero value, filament is moved toward the nozzle between the individual cooling moves ("stamping"). This option configures how long this movement should be before the filament is retracted again.

### Ramming parameters [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#ramming-parameters)

This string is edited by RammingDialog and contains ramming specific parameters.

#### Total ramming [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#total-ramming)

The total amount of filament that will be forcibly extruded (rammed) into the nozzle during the ramming stage. This value represents the full volume (or equivalent extrusion length) applied by the ramming routine to ensure the nozzle contains the intended material and pressure before printing resumes.

#### Ramming line [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#ramming-line)

Defines the geometry or pattern used when ramming material (for example a short line or dot on the wipe tower). The ramming line parameters control where the rammed material is deposited so it is reliably captured by the wipe structure instead of contaminating the printed part.

## Tool change parameters with multi extruder [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#tool-change-parameters-with-multi-extruder)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_multitool_ramming`.

These options apply to printers that use multiple independent extruders or hotends (multi-tool setups). When enabled, ramming and related parameters define a small, controlled extrusion on the wipe tower immediately before a tool change to ensure the outgoing tool is cleared and the incoming tool begins with consistent filament at the nozzle. Use these settings to tune multi-tool handoffs and avoid color or material mixing.

### Enable ramming for multi-tool setups [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#enable-ramming-for-multi-tool-setups)

Perform ramming when using multi-tool printer (i.e. when the 'Single Extruder Multimaterial' in Printer Settings is unchecked). When checked, a small amount of filament is rapidly extruded on the wipe tower just before the tool change. This option is only used when the wipe tower is enabled.

#### Multi-tool ramming volume [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#multi-tool-ramming-volume)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_multitool_ramming_volume`.

The volume to be rammed before the tool change.

#### Multi-tool ramming flow [¶](https://www.orcaslicer.com/wiki/material_settings/multimaterial/material_multimaterial\#multi-tool-ramming-flow)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `filament_multitool_ramming_flow`.

Flow used for ramming the filament before the tool change.

Back to top