# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#retraction)

# Retraction [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#retraction)

Retraction is the process of pulling the filament back into the nozzle to prevent oozing and stringing during non-print moves.

If the retraction length is too short, it may not effectively prevent oozing, while if it's too long, it can lead to clogs or under-extrusion.

Filaments like PETG and TPU are more prone to stringing, so they may require longer retraction lengths compared to PLA or ABS. You can override your printer's default retraction settings for each filament in [Material Setting Overrides](https://www.orcaslicer.com/wiki/material_settings/setting%20overrides/material_setting_overrides.html#retraction).

Tip

Check out the [Retraction Test](https://www.orcaslicer.com/wiki/calibration/retraction_calib.html) to help determine the optimal retraction settings for your filament.

- [Length](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#length)
- [Extra length on restart](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#extra-length-on-restart)
- [Retraction speed](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#retraction-speed)
- [Deretraction speed](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#deretraction-speed)
- [Travel distance threshold](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#travel-distance-threshold)
- [Retract on layer change](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#retract-on-layer-change)
- [Wipe while retracting](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#wipe-while-retracting)
- [Wipe distance](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#wipe-distance)
- [Retract amount before wipe](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#retract-amount-before-wipe)
- [Retract amount after wipe](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#retract-amount-after-wipe)
- [Retraction When Switching Materials](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#retraction-when-switching-materials)
  - [Long retraction when cut (beta)](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#long-retraction-when-cut-beta)

## Length [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#length)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retraction_length[extruder_idx]`.

When retraction is triggered before changing tool, filament is pulled back by the specified amount (the length is measured on raw filament, before it enters the extruder).

## Extra length on restart [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#extra-length-on-restart)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retract_restart_extra[extruder_idx]`.

When the retraction is compensated after changing tool, the extruder will push this additional amount of filament.

## Retraction speed [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#retraction-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retraction_speed[extruder_idx]`.

Speed for retracting filament from the nozzle.

## Deretraction speed [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#deretraction-speed)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `deretraction_speed[extruder_idx]`.

Speed for reloading filament into the nozzle. Zero means same speed of retraction.

## Travel distance threshold [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#travel-distance-threshold)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retraction_minimum_travel[extruder_idx]`.

Only trigger retraction when the travel distance is longer than this threshold.

## Retract on layer change [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#retract-on-layer-change)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retract_when_changing_layer[extruder_idx]`.

This forces a retraction on layer changes.

## Wipe while retracting [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#wipe-while-retracting)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `wipe[extruder_idx]`.

This moves the nozzle along the last extrusion path when retracting to clean any leaked material on the nozzle. This can minimize blobs when printing a new part after traveling.

## Wipe distance [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#wipe-distance)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `wipe_distance[extruder_idx]`.

Describe how long the nozzle will move along the last path when retracting.

Depending on how long the wipe operation lasts, how fast and long the extruder/filament retraction settings are, a retraction move may be needed to retract the remaining filament.
Setting a value in the retract amount before wipe setting below will perform any excess retraction before the wipe, else it will be performed after.

## Retract amount before wipe [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#retract-amount-before-wipe)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retract_before_wipe[extruder_idx]`.

This is the length of fast retraction before a wipe, relative to retraction length.

## Retract amount after wipe [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#retract-amount-after-wipe)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Expert`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retract_after_wipe[extruder_idx]`.

Important

NEW FEATURE: **Retract amount after wipe**

Available in: [Nightly builds](https://github.com/OrcaSlicer/OrcaSlicer/releases/tag/nightly-builds) or Releases greater than **2.4.2**.

This is the length of fast retraction after a wipe, relative to retraction length.

Together with [Retract amount before wipe](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction#retract-amount-before-wipe), this lets you split the retraction across the wipe: some before, some after, and the remainder performed during the wipe move itself. The value is clamped by 100% minus the retract amount before wipe, so the two combined never exceed the total retraction length.

Moving more of the retraction to after the wipe allows shorter wipe distances while keeping seams clean, which is helpful for high-detail models and stringing-prone filaments.

## Retraction When Switching Materials [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#retraction-when-switching-materials)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retract_length_toolchange[extruder_idx]`, `retract_restart_extra_toolchange[extruder_idx]`.

Retraction settings specifically for material changes during tool changes in multi-material prints.

### Long retraction when cut (beta) [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_retraction\#long-retraction-when-cut-beta)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Developer`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `long_retractions_when_cut[extruder_idx]`, `retraction_distances_when_cut[extruder_idx]`.

Experimental feature: Retracting and cutting off the filament at a longer distance during changes to minimize purge. While this reduces flush significantly, it may also raise the risk of nozzle clogs or other printing problems.

Back to top