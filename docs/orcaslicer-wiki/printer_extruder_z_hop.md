# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop#z-hop)

# Z Hop [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop\#z-hop)

Z-Hop is a feature that lifts the nozzle slightly during travel moves to avoid collisions with the printed object. This is particularly useful for prints with tall, thin features or when printing multiple objects on the build plate.

## On surfaces [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop\#on-surfaces)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retract_lift_enforce[extruder_idx]`.

Enforce Z-Hop behavior. This setting is impacted by the above settings (Only lift Z above/below).

## Z-hop type [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop\#z-hop-type)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `z_hop_types[extruder_idx]`.

\- Auto: Selects automatically between Spiral based on whether the travel move crosses over overhang areas
\- Normal Lift: The nozzle is lifted vertically during retraction and lowered back down before resuming printing.
\- Slope: The nozzle moves diagonally (at an angle) during retraction, creating a sloped path.
\- Spiral: The nozzle moves in a spiral pattern while lifting, which can help reduce stringing and improve print quality.

## Z-hop height [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop\#z-hop-height)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Simple`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `z_hop[extruder_idx]`.

Whenever there is a retraction, the nozzle is lifted a little to create clearance between the nozzle and the print. This prevents the nozzle from hitting the print when traveling more. Using spiral lines to lift z can prevent stringing.

## Traveling angle [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop\#traveling-angle)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `travel_slope[extruder_idx]`.

Traveling angle for Slope and Spiral Z-hop type. Setting it to 90° results in Normal Lift.

## Only lift Z above [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop\#only-lift-z-above)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retract_lift_above[extruder_idx]`.

If you set this to a positive value, Z lift will only take place above the specified absolute Z.

## Only lift Z below [¶](https://www.orcaslicer.com/wiki/printer_settings/extruder/printer_extruder_z_hop\#only-lift-z-below)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `retract_lift_below[extruder_idx]`.

If you set this to a positive value, Z lift will only take place below the specified absolute Z.

Back to top