# Radxa Zero 3W → Creality Ender-3 V3 SE

## Comprehensive Capability Upgrade Plan

### Objective

Transform the Creality Ender-3 V3 SE from a conventional standalone Marlin printer into a networked, instrumented, remotely managed Klipper printer with substantially greater control, automation, diagnostic capability, and tuning potential.

The objective is not simply to make the SE "run Klipper." The goal is to characterize the machine, identify its actual mechanical and thermal limitations, and then optimize or upgrade those limitations systematically.

The resulting machine should be evaluated against the Ender-3 V3 KE on measurable performance rather than advertised speed.

---

## 1. CONTROL AND WORKFLOW

| Capability | Stock V3 SE | Radxa + Klipper |
|---|---|---|
| Printer control | Primarily local touchscreen/SD workflow | Web interface, API, SSH and existing controls |
| Network printing | Limited | Direct network upload and print management |
| Web interface | No native full printer-management interface | Fluidd or Mainsail |
| SSH access | No general-purpose Linux host | Full Linux computer on printer |
| Macro system | Limited firmware functions | Extensive G-code/Jinja2 macro system |
| Custom controls | Fixed interface | Custom web buttons and macros |
| Conditional operations | Limited | Full macro logic |
| Calibration sequences | Manual | Automated/customizable |
| Pause/resume | Basic printer implementation | Highly configurable pause/resume procedures |
| Emergency stop | Hardware/software printer controls | Web/API ESTOP plus existing hardware controls |
| Firmware configuration | Firmware recompilation often required | Edit "printer.cfg" and restart Klipper |

The Radxa is not merely replacing the touchscreen. It provides a general-purpose Linux computer that can run the printer-management software independently of the printer's MCU.

---

## 2. MOTION CONTROL AND PRINT QUALITY

This is one of the fundamental advantages of Klipper.

Klipper uses the host computer for motion planning while the printer's MCU remains responsible for real-time execution of the generated step commands.

| Capability | Stock SE | Klipper |
|---|---|---|
| Advanced motion planning | Marlin implementation | Klipper motion-planning architecture |
| Input Shaper | Not part of the normal stock configuration | Supported |
| Pressure Advance | Not normally configured | Supported |
| Acceleration tuning | Firmware-defined limits | Easily configurable |
| Square-corner velocity | Firmware parameter | Configurable |
| Resonance measurement | No standard workflow | Accelerometer-based characterization |
| Motion-system characterization | Limited | Extensive |
| Rapid parameter changes | Firmware changes may require flashing | Configuration changes and restart |

### Input Shaper

An ADXL345 or compatible accelerometer can be used to measure the printer's mechanical resonances.

The goal is to determine the actual resonance characteristics of the SE and configure Input Shaper accordingly.

This can substantially reduce ringing/ghosting caused by the printer's mechanical resonances.

It does not make the machine immune to vibration. Mechanical rigidity, belts, wheels, frame alignment, and acceleration still matter.

### Pressure Advance

Pressure Advance compensates for pressure changes in the nozzle caused by acceleration and deceleration.

Potential benefits include:

- Cleaner corners
- Reduced blobs
- More consistent extrusion during acceleration
- Better dimensional consistency
- Reduced extrusion artifacts

Pressure Advance does not eliminate all stringing and does not compensate for wet filament, poor extrusion calibration, or inadequate hotend performance.

### Calibration data (community-converged, Aug 2026)

Starting points only — verify on the actual machine:

- rotation_distance: X=40, Y=40, Z=8, extruder=**7.44**; microsteps 16; TMC2208 UART run_current X/Y 0.60, Z 0.8, sense 0.150.
- Extruder PID (200°C): Kp 27.142, Ki 1.371, Kd 134.351. Bed PID (70°C): 66.371 / 0.846 / 1301.702.
- Probe offsets x −23, y −14.5, z_offset 2.65; bed_mesh 5×5 bicubic, mesh_min 30,30 / max 207,215.5.
- max_velocity 250, max_accel 2500, SCV 5.0, max_z_accel 100.
- **Pressure Advance disagreement is real:** stock brass nozzle ≈ **0.06**; CHT nozzle + PETG-Rapid ≈ **0.403**. No single value — the tower method works where the Ellis pattern fails. Calibrate per filament.
- **Input Shaper: no converged SE value exists.** Typical Ender band 35–45 Hz; measure with the ADXL345. Install `libopenblas-base` on the host or resonance tuning fails.

---

## 3. AUTOMATED CALIBRATION

A major opportunity is to turn calibration from a collection of manual procedures into repeatable automated workflows.

Possible sequence:

1. Heat bed
2. Heat nozzle
3. Home axes
4. Establish appropriate Z offset
5. Probe bed
6. Generate or select appropriate bed mesh
7. Load filament-specific parameters
8. Apply Pressure Advance
9. Apply Input Shaper parameters
10. Begin print

Different filament profiles can maintain their own:

- nozzle temperature
- bed temperature
- Pressure Advance
- extrusion parameters
- maximum volumetric flow
- cooling parameters
- acceleration limits
- other material-specific settings

---

## 4. BED LEVELING AND Z CONTROL

Klipper provides a substantially more flexible bed-mesh system.

**Machine-specific note (verified Aug 2026):** the V3 SE has **no CRTouch**. It uses Creality's strain-gauge probe ("PRTouch") for bed probing plus an HX711 load cell in the hotend for auto Z-offset. Vanilla Klipper cannot do the load-cell Z-offset — this is a core reason the jpcurti fork is required. Community-firsthand guidance:

- **Do NOT set Z-offset via the web UI "Z Offset" field — it is ephemeral and resets to 0 on G28.** Use the fork's `PRTOUCH_PROBE_ZOFFSET` macros and SAVE_CONFIG.
- Z-offset stays constant until nozzle replacement — measure once, fine-tune, don't redo per print.
- Protect the bed on the first run: a bad Z-offset digs the nozzle into the plate (reported plate ruined). Run `PRTOUCH_PROBE_ZOFFSET` several times, then `PRTOUCH_ACCURACY SAMPLES=10 PROBE_SPEED=1`, then `PRTOUCH_PROBE_ZOFFSET APPLY_Z_ADJUST=1` + SAVE_CONFIG; only trust stable values.

Potential capabilities include:

- Adaptive bed mesh
- Higher-density probing grids
- Stored mesh profiles
- Material/temperature-specific calibration
- Live Z-offset adjustment
- Automated probing sequences
- Custom pre-print mesh procedures

However:

A mesh compensates for surface variation; it does not mechanically level the bed.

Mechanical alignment remains important.

A useful future goal is to determine how often the machine actually needs to probe rather than blindly probing every print.

---

## 5. THERMAL CONTROL AND CHARACTERIZATION

The stock V3 SE already has thermal monitoring and thermal-runaway protection. Klipper does not invent those protections.

The improvement is primarily visibility, control, logging and characterization.

Potential measurements:

- Hotend heat-up time
- Bed heat-up time
- Thermal overshoot
- Temperature stability
- Cool-down characteristics
- Fan response
- Ambient temperature
- Thermal behavior at different printing speeds

Klipper PID tuning can then be used to optimize temperature control.

The Radxa can also log temperature behavior over time, making thermal problems easier to diagnose.

---

## 6. PRINT MONITORING AND DIAGNOSTICS

The Radxa provides the computing and network infrastructure for much more extensive monitoring.

Potential capabilities:

- Live nozzle temperature
- Live bed temperature
- Position
- Velocity
- Acceleration
- Print progress
- Estimated remaining time
- Print history
- Klipper logs
- Webcam feed
- Timelapse
- Remote status
- Automated notifications

The "klippy.log" file also provides substantially more useful diagnostic information than a conventional printer LCD.

---

## 7. WEBCAM AND COMPUTER VISION

A USB or network camera can be integrated into the printer-management system.

Possible functions:

- Live viewing
- Timelapse
- Remote inspection
- First-layer monitoring
- Failed-print detection
- Spaghetti detection
- Print-detachment detection
- Automated failure notifications
- Potential automated print cancellation

Software such as Obico can extend this into AI-assisted print-failure detection.

Important distinction:

AI failure detection is not inherent to Klipper.

It is an additional software capability made practical by having the Radxa available as a networked Linux computer.

---

## 8. PRINT JOB MANAGEMENT

The printer becomes a network-managed production device rather than an SD-card appliance.

Potential workflow:

CAD → Slicer → Network Upload → Queue → Print → Monitor → History

Possible capabilities:

- Direct upload from compatible slicers
- Print queues
- Sequential printing
- Automatic start/end macros
- Material-specific print profiles
- Remote cancellation
- Remote pause
- Print history
- Automatic notifications
- Timelapse generation

The exact slicer integration depends on the slicer and Moonraker support rather than Klipper alone.

---

## 9. REMOTE ACCESS

The Radxa provides:

- Wi-Fi/network connectivity
- SSH
- Web management
- API access
- Remote configuration
- Remote file management

The printer can therefore be managed from:

- Desktop computer
- Laptop
- Tablet
- Phone
- Other computers on the LAN

Remote access beyond the home network should be implemented through a proper VPN or similarly secure mechanism rather than exposing the printer-management interface directly to the Internet.

---

## 10. CONFIGURATION MANAGEMENT

One of the major advantages over traditional firmware is the separation between firmware and configuration.

The main printer configuration can be maintained as text:

"printer.cfg"

This makes it practical to:

- Back up configurations
- Compare changes
- Experiment
- Revert changes
- Maintain multiple profiles
- Document settings
- Use Git/version control
- Change parameters without reflashing the printer MCU

This makes experimentation dramatically easier.

---

## 11. FILAMENT MANAGEMENT

Filament profiles can be maintained for different materials.

Example:

PLA

- Nozzle temperature
- Bed temperature
- Pressure Advance
- Maximum volumetric flow
- Cooling
- Acceleration

PETG

- Different temperature
- Different Pressure Advance
- Different cooling
- Different volumetric-flow limit

ASA / Nylon / Other Materials

Corresponding material-specific parameters can be maintained.

Spoolman

Spoolman can provide spool inventory and estimated filament tracking.

However:

Spoolman does not physically weigh the spool.

True weight-based monitoring would require additional hardware such as a load cell and appropriate electronics/software integration.

---

## 12. MAXIMUM VOLUMETRIC FLOW

This is an important capability that should be part of the performance project.

Linear print speed by itself is a poor measure of printer capability.

The more meaningful limitation is often:

How many cubic millimeters of plastic per second can the hotend reliably melt and extrude?

For example, the machine could be experimentally characterized:

20 mm³/s — reliable
25 mm³/s — reliable
30 mm³/s — marginal
35 mm³/s — under-extrusion

The numbers above are examples only and must be measured on the actual printer.

**Community pre-characterization (Aug 2026):** an SE owner reports the stock ceramic hotend pushes **over 30 mm³/s** on a 0.4 mm nozzle, while KE owners commonly hit a wall around 17–25 mm³/s. The SE's hotend is a standard (non-all-metal) Sprite unit, 260 °C / 40 W. Working hypothesis: the SE's practical limit is ≈ **30–32 mm³/s PLA**, and **the hotend is NOT the SE's primary bottleneck** — verify on the actual machine, but do not expect to spend money here first.

Once characterized, the slicer can impose a maximum volumetric-flow limit.

This prevents the common mistake of claiming extremely high linear speed while the hotend cannot actually supply the required plastic flow.

---

## 13. PERFORMANCE CHARACTERIZATION

Rather than arbitrarily increasing the speed to advertised numbers, the SE should be experimentally characterized.

Test variables should include:

- Print speed
- Acceleration
- Volumetric flow
- Temperature
- Cooling
- Pressure Advance
- Input Shaper
- Layer height
- Line width

Measure:

- Surface quality
- Ringing
- Dimensional accuracy
- Layer adhesion
- Extrusion consistency
- Print time
- Failure rate

The result should be a machine-specific performance envelope.

---

## 14. ACCELERATION PROFILES

Instead of one arbitrary acceleration setting, several profiles can be created.

Example:

| Profile | Acceleration |
|---|---|
| QUALITY | 1000 mm/s² |
| NORMAL | 2500 mm/s² |
| FAST | 4000 mm/s² |
| EXPERIMENTAL | 6000+ mm/s² |

These are starting examples, not recommended final values.

The actual limits should be established experimentally.

The objective is to determine:

Maximum acceleration that maintains acceptable print quality and mechanical reliability.

---

## 15. MECHANICAL LIMITS

Klipper cannot overcome mechanical limitations.

The SE's physical components remain important:

- **X-axis: v-wheel system** (eccentric nuts — tighten the 3rd wheel to kill wobble; no factory belt-tension guidance, all three belts are tensionable)
- **Y-axis: linear rods, NOT v-wheels** — bed wobble/unstable Y is a rod problem, commonly fixed by a 10 mm bed-rod upgrade
- Belts
- Frame rigidity
- **Gantry stiffness — the X-resonance weak point** (slanted gantry/twist is a known out-of-box issue; a Linear X Rail Mod exists specifically to stiffen this axis)
- Gantry alignment
- X-axis mechanics
- Y-axis mechanics
- Z-axis mechanics
- Hotend
- Extruder
- Cooling system

If the printer reaches a mechanical limit, software cannot eliminate it.

That is why the upgrade should proceed in stages.

---

## 16. HOTEND AND COOLING OPTIMIZATION

**Known weak point first (community-verified):** recurring clogs/heat-creep on the SE trace back to the **hotend cooling fan** — debris or a dead fan jams the heat-break fan → jams. Before blaming the hotend, verify the cooling fan is clean and spinning. Also note: the stock SE hotend is a standard (non-all-metal) Sprite unit, 260 °C / 40 W — community data suggests it flows >30 mm³/s, so it is likely NOT the primary bottleneck on this machine.

If testing shows that the hotend is the bottleneck, potential future upgrades include:

- Higher-flow hotend
- Improved heatsink
- Improved part cooling
- Higher-performance fan
- Hardened nozzle
- Different nozzle diameter
- Improved extruder components

These should be evaluated after establishing the stock SE's measured limits.

There is little value in replacing hardware before determining what is actually limiting performance.

---

## 17. ADVANCED SENSOR INTEGRATION

The Radxa provides a platform for experimental instrumentation.

Potential additions include:

ADXL345

Used for:

- Resonance measurement
- Input Shaper calibration

**SE-specific (community-verified, Aug 2026):** dedicated mounts exist — toolhead mount (Printables #745761) and bed/Y-axis mount (#713280, also fits the KE). Standard practice: **toolhead mount for X, bed mount for Y**. Reported resonance: **Y ≈ 34–35 Hz** (community cfg uses `shaper_freq_y 35, mzv`; Obico Ender-3 example 34.6 Hz). X is higher but unstable — it only cleaned up after a gantry-support mod + belt tensioning, so plan to harden the gantry before final Input Shaper tuning. Install `libopenblas-base` on the host or resonance tuning fails.

Ambient temperature sensor

Potentially useful for:

- Environmental monitoring
- Thermal characterization

Load cell

Potential applications:

- Spool weight measurement
- Advanced probing
- Experimental force measurement

Filament motion sensor

Potential applications:

- Filament-motion verification
- Jam/runout detection

Extruder encoder

Potential applications:

- Detecting discrepancies between commanded and actual filament movement

Hotend force/pressure sensing

Potential future experiment:

- Detect abnormal extrusion force
- Detect possible nozzle blockage

These are advanced custom projects, not standard capabilities obtained simply by installing Klipper.

---

## 18. FILAMENT JAM DETECTION

A sophisticated jam-detection system could potentially combine:

- Filament-motion sensing
- Extruder encoder information
- Extrusion commands
- Motor behavior
- Pressure/force sensing

The objective would be:

Detect abnormal extrusion before the printer produces a large failed print.

This is an experimental upgrade rather than a guaranteed Klipper feature.

---

## 19. PRINT RECOVERY

Klipper provides highly configurable pause/resume behavior.

A custom pause procedure could:

1. Stop motion safely
2. Retract filament
3. Move the toolhead to a safe location
4. Maintain or change temperatures
5. Allow manual intervention
6. Reheat if required
7. Restore position
8. Prime the nozzle
9. Resume printing

Power-loss recovery is more complicated and should not be treated as guaranteed "exact-position" recovery without appropriate hardware/software design.

---

## 20. MAINTENANCE AND TROUBLESHOOTING

The Radxa provides a much better diagnostic environment.

Instead of relying primarily on LCD messages, the system can provide:

- Klipper logs
- Configuration files
- Historical data
- Temperature graphs
- Error messages
- Network diagnostics
- SSH access
- Software logs
- Version-controlled configuration

A failed experiment can be documented and reverted rather than becoming a firmware archaeology project.

---

## 21. SOFTWARE ECOSYSTEM

The Linux host makes it possible to integrate additional services.

Potential ecosystem:

- Klipper
- Moonraker
- Fluidd
- Mainsail
- Crowsnest
- Spoolman
- Obico
- MQTT
- Home Assistant
- Git
- Custom Python utilities
- Custom APIs
- Custom monitoring scripts

The exact combination should be kept lean.

Installing everything merely because it is available defeats the purpose of having a reliable printer.

---

## 22. AUTOMATION

The ultimate goal is to reduce repetitive human intervention.

A mature workflow could look like:

```
Select print
      ↓
Upload from slicer
      ↓
Select material profile
      ↓
Automatic preparation
      ↓
Heat bed/nozzle
      ↓
Home
      ↓
Mesh/calibration as required
      ↓
Print
      ↓
Monitor temperatures and progress
      ↓
Camera monitoring
      ↓
Automatic completion
      ↓
Cooldown
      ↓
Record print history
      ↓
Notify user
```

---

## 23. WHAT THE RADXA DOES — AND DOES NOT — DO

The Radxa directly provides:

- Linux host
- Klipper host
- Network connectivity
- Web interface
- SSH
- API access
- Logging
- Storage
- Additional software
- Computing resources for motion planning
- Platform for sensors and automation

Klipper provides:

- Advanced motion planning
- Input Shaper support
- Pressure Advance
- Flexible macros
- Bed mesh
- Configuration flexibility
- Extensive printer control

Additional hardware provides:

- Resonance measurement
- Camera monitoring
- Weight measurement
- Filament-motion detection
- Advanced probing
- Experimental force/pressure measurement

Mechanical upgrades provide:

- Higher physical acceleration capability
- Higher volumetric flow
- Better motion accuracy
- Better cooling
- Higher temperature capability
- Greater mechanical rigidity

Keeping these categories separate prevents unrealistic expectations.

---

## 24. END-TO-END UPGRADE STRATEGY

The conversion should be performed in stages.

### Stage 1 — Establish the baseline

Before modifying the machine:

- Identify exact motherboard revision
- Identify MCU (expect GD32F303 / C13)
- Document stock firmware + **display firmware version (must be 1.0.6 for the fork)**
- Check all mechanical components — **belt tension (no factory guidance; all three belts tensionable), X-carriage eccentric nuts, Y linear rods, gantry squareness**
- Run stock leveling + a stock benchmark print (a stock unit prints a Benchy ~20 min after unboxing)
- Measure baseline print quality
- Measure baseline speed
- Measure baseline acceleration
- Verify extrusion calibration
- Verify bed behavior
- Verify hotend performance + **hotend cooling fan spins clean**

### Stage 2 — Install Radxa + Klipper

Install:

- Linux
- Klipper
- Moonraker
- Fluidd or Mainsail

Host prep (verified pitfalls):

- **Remove `brltty`** — it blocks USB serial; add user to `tty` group
- Fit a heatsink (board runs 70–85 °C; Pi-Zero-style sink drops idle >70 °C → ~44 °C)
- **WiFi is the #1 reliability risk** (known Zero 3W wlan termination/freeze bug, archived unresolved) — good antenna placement, disable wifi power-save, and prefer a **USB-Ethernet dongle** for the print channel
- Use a powered USB hub / solid 5 V PSU for board + printer serial
- Install `libopenblas-base` before any resonance tuning

Establish:

- Network access
- SSH
- Web interface
- Printer communication
- Backup configuration

### Stage 3 — Basic Klipper calibration

Firmware flash notes (verified pitfalls):

- Menuconfig target: **STM32F103 + 28KiB bootloader + serial USART1 PA10/PA9 — even on the GD32F303 C13 board**. Do NOT pick STM32F303.
- Enable "extra low-level options" + **serial bridge + USART2** (MCU bridges USB↔display).
- Rename the `.bin` to a **different ≤8.3-char filename than last flashed** or the bootloader ignores it. If the display stays on Marlin GUI, the flash didn't take — rename and reflash; bootloader survives.
- Add `[e3v3se_display]` + `language:` to printer.cfg or the screen won't drive.

Tune:

- PID
- Rotation distance
- Z offset — **use `PRTOUCH_PROBE_ZOFFSET` macros + SAVE_CONFIG, NOT the web UI field** (ephemeral, resets on G28); run `PRTOUCH_ACCURACY SAMPLES=10 PROBE_SPEED=1` and protect the bed first run
- Bed mesh (KAMP scales probe to print area; mesh per print)
- Pressure Advance (tower method; per-filament — stock brass ≈ 0.06, CHT+PETG-Rapid ≈ 0.403)
- Input Shaper (after `libopenblas-base`; ADXL345 toolhead-for-X + bed-for-Y; Y ≈ 34–35 Hz expected)

### Stage 4 — Characterize the machine

Measure:

- Resonance
- Maximum volumetric flow
- Acceleration limits
- Thermal behavior
- Cooling performance
- Dimensional accuracy

### Stage 5 — Optimize

Create:

- Quality profile
- Normal profile
- Fast profile
- Experimental profile

Then compare the results.

### Stage 6 — Add instrumentation

Only after the basic system is stable:

- Accelerometer
- Webcam
- Ambient sensor
- Filament sensor
- Load cell
- Other experimental sensors

### Stage 7 — Hardware upgrades

Only upgrade hardware that testing demonstrates is a bottleneck.

---

## 25. SE VS. KE: THE REAL TEST

The goal should not be to claim that Klipper automatically makes the SE better than the KE.

The KE has physical advantages that software cannot create.

**What the KE physically has that the SE lacks (verified spec comparison):**
- **X-axis linear rail** (SE: v-wheels) — the single biggest structural gap
- **All-metal volcano-style hotend, 300 °C / 60 W, bimetallic heatbreak** (SE: standard 260 °C / 40 W)
- PEI bed (SE: PC spring steel)
- Klipper-based Creality OS + optional ADXL vibration sensor (SE: Marlin)
- Filament runout sensor (SE: optional)
- 500 W PSU (SE: 350 W)
- Touchscreen (SE: knob)

**Shared between both:** Sprite-style dual-gear direct-drive extruder, dual-Z single-motor belt, Y linear rods, strain-gauge Z-offset.

**Implication (community-data-backed):** the SE's hotend already out-flows the KE in community tests (>30 mm³/s vs ~17–25 mm³/s), so the SE *can* approach KE speed once Klipper + Input Shaper are on it. The gating factors will be the X-axis v-wheel carriage and gantry stiffness — addressed by the Linear X Rail Mod (Printables #716958) if measurements show X resonance is the limit.

The meaningful comparison is:

| Category | SE + Radxa/Klipper |
|---|---|
| Software flexibility | Potentially exceptional |
| Automation | Potentially exceptional |
| Remote management | Excellent |
| Monitoring | Excellent |
| Diagnostics | Excellent |
| Customization | Excellent |
| Motion control | Strong |
| Print quality | Dependent on tuning |
| Maximum acceleration | Mechanically limited |
| Maximum speed | Hotend/motion-system limited |
| Maximum volumetric flow | Hotend dependent |
| Mechanical rigidity | SE hardware |
| High-temperature capability | SE hardware dependent |

The interesting question is therefore:

«How close can the SE's physical hardware get to the KE once both machines are given comparable motion-control software, and how much further can the SE be pushed through targeted modifications?»

That is measurable.

---

## 26. FINAL OBJECTIVE

The finished project should not simply be called:

"An Ender-3 V3 SE running Klipper."

It should be treated as:

A characterized, networked, instrumented and automated 3D-printing platform.

The Radxa Zero 3W provides the computational and networking foundation.

Klipper provides the advanced motion-control architecture.

Sensors provide measurement.

Macros and automation provide repeatability.

Testing determines the actual limits.

Mechanical upgrades are added only where measurements demonstrate a bottleneck.

The final performance target is therefore not an arbitrary advertised speed.

It is:

Maximum useful print performance at an acceptable level of quality, reliability, dimensional accuracy and mechanical stress.

That is the correct way to determine whether the modified V3 SE can actually outperform a V3 KE.
