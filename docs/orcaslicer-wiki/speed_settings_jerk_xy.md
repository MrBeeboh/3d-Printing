# SOURCE: https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy.html

[Skip to content](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#jerk-xy)

# Jerk XY [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#jerk-xy)

**Jerk** is the rate of change of acceleration and how quickly your printer can change between different accelerations. It controls direction changes and velocity transitions during movement.

- [Key Effects](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#key-effects)
- [Cornering Control Types](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#cornering-control-types)
  - [Junction Deviation](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#junction-deviation)
- [Default](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#default)
  - [Outer wall](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#outer-wall)
  - [Inner wall](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#inner-wall)
  - [Infill](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#infill)
  - [Top surface](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#top-surface)
  - [Initial layer](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#initial-layer)
  - [Initial layer travel](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#initial-layer-travel)
  - [Travel](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#travel)
- [Useful links](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#useful-links)

## Key Effects [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#key-effects)

- **Corner Control**:
  - Lower values = smoother corners, better quality.
  - Higher values = faster cornering, potential artifacts.
- **Print Speed**: Higher jerk reduces deceleration at direction changes, increasing overall speed.
- **Surface Quality**: Lower jerk minimizes vibrations and ringing, especially important for outer walls.

This setting overrides firmware jerk values when different motion types need specific settings. Orca limits jerk to not exceed the Printer's Motion Ability settings.

Tip

Jerk can work in conjunction with [Pressure Advance](https://www.orcaslicer.com/wiki/calibration/pressure_advance_calib.html), [Adaptive Pressure Advance](https://www.orcaslicer.com/wiki/calibration/adaptive_pressure_advance_calib.html), and [Input Shaping](https://www.orcaslicer.com/wiki/calibration/input_shaping_calib.html) to optimize print quality and speed.

It's recommended to follow the [calibration guide](https://www.orcaslicer.com/wiki/guides/calibration_guide.html) order for best results.

## Cornering Control Types [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#cornering-control-types)

- **Jerk**: Traditional method, sets a maximum speed for direction changes.
  - Klipper: [Square corner velocity](https://www.klipper3d.org/Config_Reference.html#printer)
  - RepRapFirmware: [Maximum instantaneous speed changes](https://docs.duet3d.com/User_manual/Reference/Gcodes#m566-set-allowable-instantaneous-speed-change)
  - Marlin 2: [Classic Jerk](https://marlinfw.org/docs/configuration/configuration.html#jerk-) (deprecated in favor of [Junction Deviation](https://marlinfw.org/docs/configuration/configuration.html#junction-deviation-)) but can still be used.
  - Marlin Legacy: [Classic Jerk](https://marlinfw.org/docs/configuration/configuration.html#jerk-).
- **[Junction Deviation](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#junction-deviation)**: Modern method, calculates cornering speed based on acceleration.

Tip

Calibrate your Cornering Values using the [Cornering Calibration guide](https://www.orcaslicer.com/wiki/calibration/cornering_calib.html).

### Junction Deviation [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#junction-deviation)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `default_junction_deviation`.

Alternative to Jerk, Junction Deviation is the default method for controlling cornering speed in Marlin 2 printers.

Instead of setting a cornering speed for each line type, it calculates the cornering speed based on the [each line's acceleration](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_acceleration.html) and speed using the formula:

JD=0,4⋅Jerk2Accel.
JD = 0,4 \\cdot \\frac{\\text{Jerk}^2}{\\text{Accel.}}
JD=0,4⋅Accel.Jerk2​

Higher values result in faster and more aggressive cornering speeds, while lower values produce smoother, more controlled cornering.

Note

Classic Jerk can still be used in Marlin 2, but it is deprecated in favor of Junction Deviation.

If your printer uses Classic Jerk, you need to set your Junction Deviation to `0` to enable the use of Classic Jerk.

This value is limited by [Printer settings > Motion ability > Maximum Junction Deviation](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability.html#maximum-junction-deviation).

## Default [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#default)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `default_jerk`.

Default Jerk value.

Note

If this value is set to 0, the jerk will be set to the printer's default jerk.

### Outer wall [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#outer-wall)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `outer_wall_jerk`.

Jerk for outer wall printing. This is usually set to a lower value than normal printing to ensure better quality.

### Inner wall [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#inner-wall)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `inner_wall_jerk`.

Jerk for inner wall printing. This is usually set to a higher but still reasonable value than outer wall printing to improve speed.

### Infill [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#infill)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `infill_jerk`.

Jerk for infill printing. This is usually set to a value higher than inner wall printing to improve speed.

### Top surface [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#top-surface)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `top_surface_jerk`.

Jerk for top surface printing. This is usually set to a lower value than infill to ensure better quality.

### Initial layer [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#initial-layer)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `initial_layer_jerk`.

Jerk for initial layer printing. This is usually set to a lower value than top surface to improve adhesion.

### Initial layer travel [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#initial-layer-travel)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `initial_layer_travel_jerk`.

Jerk for initial layer travel.
Using a lower value can improve build plate adhesion. If the value is expressed as a percentage (e.g. 50%), it will be calculated based on the [Travel Jerk](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy#travel).

### Travel [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#travel)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `travel_jerk`.

Jerk for travel printing. This is usually set to a higher value than infill to reduce travel time.

## Useful links [¶](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy\#useful-links)

- [Klipper Kinematics](https://www.klipper3d.org/Kinematics.html?h=accelerat#acceleration)
- [Marlin Junction Deviation](https://marlinfw.org/docs/configuration/configuration.html#junction-deviation-)
- [JD Explained and Visualized, by Paul Wanamaker](https://reprap.org/forum/read.php?1,739819)
- [Computing JD for Marlin Firmware](https://blog.kyneticcnc.com/2018/10/computing-junction-deviation-for-marlin.html)
- [Improving GRBL: Cornering Algorithm](https://onehossshay.wordpress.com/2011/09/24/improving_grbl_cornering_algorithm/)
- [Pressure Advance Calibration](https://www.orcaslicer.com/wiki/calibration/pressure_advance_calib.html)
- [Adaptive Pressure Advance](https://www.orcaslicer.com/wiki/calibration/adaptive_pressure_advance_calib.html)

Back to top