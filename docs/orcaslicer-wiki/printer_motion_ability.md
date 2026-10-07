# SOURCE: https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability.html

[Skip to content](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#motion-ability)

# Motion Ability [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#motion-ability)

Settings related to the motion capabilities of the printer.

- [Emit limits to G-code](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#emit-limits-to-g-code)
- [Resonance Compensation](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#resonance-compensation)
  - [Resonance Avoidance](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#resonance-avoidance)
  - [Input Shaping](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#input-shaping)
    - [Input Shaping Type](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#input-shaping-type)
      - [Default](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#default)
      - [Version Table](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#version-table)
        - [Fixed-Time Motion](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#fixed-time-motion)
- [Speed limitation](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#speed-limitation)
- [Acceleration limitation](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#acceleration-limitation)
- [Jerk limitation](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#jerk-limitation)
  - [Maximum Jerk](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#maximum-jerk)
  - [Maximum Junction Deviation](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability#maximum-junction-deviation)

## Emit limits to G-code [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#emit-limits-to-g-code)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `emit_machine_limits_to_gcode`.

If enabled, the machine limits will be emitted to G-code file.
This option will be ignored if the G-code flavor is set to Klipper.

## Resonance Compensation [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#resonance-compensation)

Resonance Compensations are the methods used to reduce the vibrations of the printer during high-speed movements, which can cause ringing on the surface of the model.

### Resonance Avoidance [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#resonance-avoidance)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `resonance_avoidance`, `min_resonance_avoidance_speed`, `max_resonance_avoidance_speed`.

By reducing the speed of the outer wall to avoid the resonance zone of the printer, ringing on the surface of the model are avoided.

Tip

Check the [VFA Calibration](https://www.orcaslicer.com/wiki/calibration/vfa_calib.html).

### Input Shaping [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#input-shaping)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Expert`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `input_shaping_emit`, `input_shaping_freq_x`, `input_shaping_freq_y`, `input_shaping_damp_x`, `input_shaping_damp_y`.

During high-speed movements, vibrations can cause a phenomenon called "ringing," where periodic ripples appear on the print surface. Input Shaping provides an effective solution by counteracting these vibrations, improving print quality and reducing wear on components without needing to significantly lower print speeds.

Note

Some Printers have built-in accelerometers that can be used to **automatically** measure the resonant frequencies of the printer.

If your printer has one, consider using it as it can provide more accurate results in less time and usually is autosaved into the printer firmware.

Tip

It's usually recommended to perform [Input Shaping calibration](https://www.orcaslicer.com/wiki/calibration/input_shaping_calib.html) once a year or after any mechanical or structural changes such as relocation, changing the support surface, new belts, motors, frame, etc.

Important

**RepRap** can only set one frequency for both X and Y axes so you will need to select a frequency that works well for both axes.

![inputshaping_printer](https://www.orcaslicer.com/wiki/images/InputShaping/inputshaping_printer.png?raw=true)

#### Input Shaping Type [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#input-shaping-type)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Expert`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `input_shaping_type`.

The Input Shaping type determines the algorithm used to counteract the vibrations.

It is usually recommended to use MZV, EI (specially for Delta printers) or ZV as a simple and effective solution.

Not all Input Shaping types are available in all firmware and their performance may vary depending on the firmware implementation and the printer's mechanics.

##### Default [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#default)

When "Default" is selected, the firmware's default input shaper will be used.

Every firmware and even its version may have a different default type but usually are:

- Klipper: MZV
- Marlin: ZV
- RepRap:
  - Version >= 3.4: MZV
  - Version < 3.4: DAA
  - Version < 3.2: DAA (without damping option)

##### Version Table [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#version-table)

| Type | Name | [Klipper](https://www.klipper3d.org/Resonance_Compensation.html#technical-details) | [RepRap](https://docs.duet3d.com/User_manual/Reference/Gcodes#m593-configure-input-shaping) | [Marlin 2](https://marlinfw.org/docs/features/ft_motion.html#more-complexity-zv-input-shaper) |
| --- | --- | --- | --- | --- |
| MZV | Modified Zero Vibration | >=0.9.0 | >=3.4 | - |
| ZV | Zero Vibration | >=0.9.0 | = 3.5 | >2.1.2 |
| ZVD | Zero Vibration Derivative | >=0.9.0 | >=3.4 | - |
| ZVDD | Zero Vibration Double Derivative | - | >=3.4 | - |
| ZVDDD | Zero Vibration Triple Derivative | - | >=3.4 | - |
| EI | Extra Insensitive | >=0.9.0 | - | - |
| 2HUMP\_EI / EI2 | Two-Hump Extra Insensitive | >=0.9.0 | >=3.4 | - |
| 3HUMP\_EI / EI3 | Three-Hump Extra Insensitive | >=0.9.0 | >=3.4 | - |
| [FT\_MOTION](https://marlinfw.org/docs/features/ft_motion.html#fixed-time-motion-by-ulendo) | Fixed-Time Motion | - | - | >2.1.3 |
| DAA | Damped Anti-Resonance | - | < 3.4 | - |

###### Fixed-Time Motion [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#fixed-time-motion)

TODO: This calibration test is currently under development. See the [Marlin documentation](https://marlinfw.org/docs/gcode/M493.html) for more information.

## Speed limitation [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#speed-limitation)

Safeguard maximum speeds for all axes.
This will cap the speed set by the process if it exceeds these values.

## Acceleration limitation [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#acceleration-limitation)

[Modes](https://www.orcaslicer.com/wiki/general_settings/option_mode.html):

`Simple` [Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `machine_max_acceleration_extruding`, `machine_max_acceleration_retracting`.

`Advanced` [Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `machine_max_acceleration_travel`.

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `machine_max_acceleration_e`, `machine_max_acceleration_z`, `machine_max_acceleration_x`, `machine_max_acceleration_y`.

Safeguard maximum accelerations for all axes.
This will cap the acceleration set by the process if it exceeds these values.

## Jerk limitation [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#jerk-limitation)

Safeguard maximum jerks for all axes.

Tip

Check the [Cornering Calibration](https://www.orcaslicer.com/wiki/calibration/cornering_calib.html).

### Maximum Jerk [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#maximum-jerk)

[Variables](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `machine_max_jerk_z`, `machine_max_jerk_e`, `machine_max_jerk_x`, `machine_max_jerk_y`.

Maximum [jerk](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy.html) for each axis (M205 X, Y, Z, E, only apply if JD = 0 for Marlin 2 Firmware)

### Maximum Junction Deviation [¶](https://www.orcaslicer.com/wiki/printer_settings/motion%20ability/printer_motion_ability\#maximum-junction-deviation)

[Mode](https://www.orcaslicer.com/wiki/general_settings/option_mode.html): `Advanced`.

[Variable](https://www.orcaslicer.com/wiki/developer_reference/built_in_placeholders_variables.html): `machine_max_junction_deviation`.

Maximum [junction deviation](https://www.orcaslicer.com/wiki/print_settings/speed/speed_settings_jerk_xy.html#junction-deviation) (M205 J, only apply if JD > 0 for Marlin Firmware. If your Marlin 2 printer uses Classic Jerk set this value to 0.)

Back to top