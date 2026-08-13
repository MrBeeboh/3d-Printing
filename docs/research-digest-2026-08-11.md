# Research Digest — Pre-arrival (2026-08-11)

Compiled from 3 parallel research subagents (fork/printer lane, SBC host lane, hardware lane).
Tags: [V] verified primary source · [C] community report · [S] speculative.
Full citations kept in chat history; key URLs inline below.

## Critical corrections to existing plan

1. **No CRTouch on this machine.** V3 SE uses Creality strain-gauge probe ("PRTouch") for bed probing + HX711 load-cell in hotend for auto Z-offset. Only the jpcurti fork (and 0xD34D configs) support the load-cell Z-offset — vanilla Klipper cannot. [V] https://github.com/0xD34D/ender3-v3-se-klipper-config
2. **Y-axis bed rides on LINEAR RODS, not v-wheels.** Bed wobble is a rod problem, not eccentric-nut. X gantry = v-wheels with eccentric nuts. [V] https://www.crealityexperts.com/creality-ender-3-v3-se-vs-ender-3-v3-ke
3. **Menuconfig target is STM32F103 + 28KiB bootloader + USART1 PA10/PA9 — even on the GD32F303 C13 board.** Do NOT pick STM32F303 in menuconfig. [V] https://github.com/0xD34D/ender3-v3-se-klipper-config

## Fork / firmware (jpcurti)

- Display FW must be **1.0.6** — newer Creality display FW moves assets, fork mapping breaks ("display went crazy" → install 1.0.6). [V]
- Menuconfig must enable: extra low-level options + **serial bridge + USART2** (MCU bridges USB↔display). Add `[e3v3se_display]` + `language:` to printer.cfg. [V]
- Open fork issues to know about: #148 C14/STM32F401 unsupported (we're C13 — fine); #85 live Z-offset broken with Pr_touch; #63 idle screen freeze; #95 Chinese menu; #136 purge off bed edge; #121 no temp tuning mid-print; #123 no print preview. [C]
- Filament runout: `[filament_switch_sensor]` on **^PC15** (PC15 correct; PA15 is Z-limit). Reports of "detected but never pauses" — verify with a real test. [C]
- Flash: rename .bin to a DIFFERENT ≤8.3-char filename than last flashed or bootloader ignores it. Flash failure = display stays on Marlin GUI; rename + reflash; bootloader survives. [V]
- Host: **remove brltty** (blocks USB serial), add user to `tty` group. [V]
- `/dev/serial/by-id` may fail to enumerate; fall back to `/dev/serial/by-path` and keep the same USB port. [C]

## First-boot / calibration

- **Do NOT set Z-offset via web UI "Z Offset" field — ephemeral, resets on G28.** Use fork macros + SAVE_CONFIG. [C]
- Protect the bed first run — bad Z-offset digs nozzle into plate (reported plate ruined). Run `PRTOUCH_PROBE_ZOFFSET` several times, `PRTOUCH_ACCURACY SAMPLES=10 PROBE_SPEED=1`, then `PRTOUCH_PROBE_ZOFFSET APPLY_Z_ADJUST=1` + SAVE_CONFIG. [V/firsthand] https://schnoog.eu/hobbies/3dprinting/ender-3-v3-se-klippered
- Z-offset constant until nozzle replacement — measure once, don't redo per print. Mesh every print via KAMP (scales probe to print area). [V/firsthand]
- Arrival day: check Y belt tension + X eccentric nuts (all three belts tensionable, no factory guidance). Stock prints Benchy ~20 min after unboxing — run stock leveling first. [C]

## Converged config values (0xD34D cfg, community)

- rotation_distance: X=40, Y=40, Z=8, extruder=**7.44**; microsteps 16; TMC2208 UART run_current X/Y 0.60, Z 0.8, sense 0.150.
- Extruder PID (200°C): Kp 27.142, Ki 1.371, Kd 134.351. Bed PID (70°C): 66.371 / 0.846 / 1301.702.
- Probe offsets x −23, y −14.5, z_offset 2.65; bed_mesh 5×5 bicubic, mesh_min 30,30 / max 207,215.5.
- max_velocity 250, max_accel 2500, SCV 5.0, max_z_accel 100.
- **Pressure Advance disagreement is real:** stock brass ≈ 0.06; CHT nozzle + PETG-Rapid ≈ 0.403. Tower method works where Ellis pattern fails. Calibrate per filament. [C]
- **Input shaper: no converged SE value.** Typical Ender band 35–45 Hz; measure with ADXL345. **Install `libopenblas-base` or resonance tuning fails.** [V]

## SBC host (Radxa Zero 3W)

- Zero 3W is a documented, community-accepted Klipper host (Radxa KIAUH docs cover RK3528 ROCK3C; same SoC family). "Klipper does not care about SBC" — klippy is low-CPU, serial saturates first. [V]
- Compute/RAM/USB-serial: non-issues. 4GB is overkill-good.
- ⚠️ **WiFi is the #1 real risk:** GitHub ubuntu-rockchip #886 — periodic wlan termination with system freeze (archived Apr 2026, unresolved); antenna picky (4 Mb/s on metal shelf vs good on desk). Mitigations: placement, wifi power-save off, mask `systemd-networkd-wait-online`, **USB-Ethernet dongle as primary print channel** (no onboard Ethernet).
- ⚠️ **Thermals:** runs 70–85°C under load; heatsink effectively required (Pi-Zero-style sink: idle >70°C → ~44°C). Passive sink adequate for headless Klipper.
- USB power: board needs >500 mA, USB-C powered; **powered hub recommended** for board + printer serial.
- No "don't use this SBC" warning exists anywhere. [V]

## Hardware limits / SE vs KE

- **Hotend flows >30 mm³/s** (SE owner, 0.4 nozzle) — SE out-flows KE in community tests (KE wall ~17–25). SE hotend = standard Sprite 260°C/40W; KE = all-metal volcano 300°C/60W bimetallic. Plan limit ≈30–32 mm³/s PLA; **hotend is NOT the bottleneck.** [C]/[V]
- Extruder: dual-gear direct-drive Sprite-style (same family as KE), rotation_distance 7.44, PA ~0.04. Recurring failure: **clogging/heat-creep from hotend cooling fan** (debris/dead fan). [C]
- ADXL345 mounts exist: Printables #745761 (toolhead), #713280 (Y/bed), #267008 (Sprite). Reported **Y ≈ 34–35 Hz** (shaper_freq_y 35, mzv; obico 34.6). X higher but unstable — cleaned up by gantry-support mod + belt tension. Toolhead mount for X, bed mount for Y. [C]
- Out-of-box issues: bed wobble/unstable Y, slanted gantry, poor mesh → **10mm bed-rod upgrade** fixes. [C] https://www.youtube.com/watch?v=vzOEuqaEv_4
- KE advantages over SE: X linear rail, all-metal hotend, PEI bed, Klipper-based OS + ADXL, runout sensor, 500W PSU, touchscreen. Shared: Sprite DD extruder, dual-Z single-motor belt, Y linear rods, strain-gauge Z offset. [V]
- **Verdict: SE can approach KE once Klipper + IS are on it; biggest structural gap = X-axis v-wheel carriage + gantry stiffness** (Linear X Rail Mod exists: Printables #716958). [S]
- First upgrades that measurably matter: PEI plate, hotend cooling fan, 10mm bed rod, gantry/X-rail rigidity. Feet/dampeners = cosmetic. [C]

## Thursday action list (derived)

1. Run stock leveling + first print (benchmark baseline per upgrade plan Stage 1).
2. Before Klipper: remove brltty, add user to tty group, fit heatsink on Zero 3W (has one? verify), decide WiFi placement / order USB-Ethernet dongle.
3. Flash C13 bin — rename to new filename, expect display 1.0.6 requirement (verify display FW on first boot).
4. Menuconfig: STM32F103 + 28KiB bootloader + USART1 PA10/PA9 + serial bridge + USART2. Add `[e3v3se_display]` to printer.cfg.
5. First Klipper boot: `PRTOUCH_PROBE_ZOFFSET` loop → `PRTOUCH_ACCURACY` → apply + SAVE_CONFIG. Protect bed.
6. Install `libopenblas-base` before any resonance tuning.
7. Order list (before Thursday): ADXL345 + mounts (toolhead + bed), USB-Ethernet dongle, powered USB hub, Pi-Zero-style heatsink, PEI plate.
