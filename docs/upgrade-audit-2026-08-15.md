# Upgrade Audit — Ender 3 V3 SE + Radxa Zero 3W Klipper (2026-08-15)

Status: SYSTEM WORKING, GAINS ~60% DELIVERED. Performance items pending.

## Working
- Klipper fork d74d36bb (latest master), MCU flashed (C13/GD32F303, stm32f103xe target)
- Display FW 1.0.6 (downgraded via TJC_SET), fork GUI + 6 screen macros
- Moonraker :7125 + Fluidd :4408 — remote/WiFi printing
- Adaptive bed mesh per print (PRINT_START)
- First Klipper print (20mm cube) completing

## Fixed during session (13 items)
1. pi user → tty/dialout (serial perms)
2. [virtual_sdcard] added (print_stats dependency, fork removed core object)
3. MCU shutdown "Command request" recovery (power cycle; caused by host crash path)
4. klipper.service: added `-a /home/pi/printer_data/comms/klippy.sock`
5. moonraker.conf: klippy_uds_address corrected to comms/klippy.sock
6. prtouch.py: `z_probe = list(...)` patch (fork bug #85, probe_result item assignment)
7. [exclude_object] added (ADAPTIVE_LINE_PURGE dependency)
8. Z-offset: fork auto-cal garbage → manual paper calibration → BAKED at 1.700
9. [stepper_z] position_min -3 → -10 (calibration travel; relax confirmed OK)
10. Runtime speed cap 100mm/s / accel 1200 (temporary crash workaround)
11. Purge fixed: [extruder] max_extrude_cross_section: 5.0 (was silently skipping)
12. PID tuned + saved: extruder 24.812/1.207/127.470, bed 64.610/0.649/1608.793
13. Fixed corrupted SAVE_CONFIG autosave block (empty #*# [bltouch] + section below marker)

## Open issues / missing
1. Z-offset not baked into config (converge + verify + save)
2. Purge skipped: [extruder] max_extrude_cross_section missing (<5 → purge skip)
3. PID not tuned (defaults: extruder 27.142/1.371/134.351, bed 66.371/0.846/1301.702)
4. Speed blocker: fork firmware stepcompress/comm-loss at high step rates (3 crashes today: 4%, 4%, 6% — all first-layer infill @180mm/s). Suspect STEPPER_BOTH_EDGE=1. Path: raise cap stepwise; if crash → rebuild MCU bin without both-edge, reflash via SD.
5. Input shaping: no [input_shaper], no ADXL345 (hardware needed)
6. Pressure advance: not configured
7. Filament runout: [filament_switch_sensor] missing (PC15); verify real trigger
8. OrcaSlicer: user machine preset "Ender-3 V3 SE (Klipper)" created + CLI-verified; built-in printable area 200x200 vs real 220x220; retraction untested
9. Project docs (docs/) not updated for today's changes — THIS FILE is the start
10. Radxa Zero 3W power: research recommends powered USB hub for printer serial; UNKNOWN if in place — comm-loss may be power-related
11. TESTZ command missing in fork (manual probe UI broken) — manual G1 paper method used instead

## Gains matrix
| Gain | Status |
|---|---|
| Remote/WiFi printing | DONE |
| Adaptive mesh | DONE |
| Screen macros | DONE |
| Speed > stock | PENDING (currently capped below stock) |
| Input shaping | PENDING (needs ADXL345) |
| Pressure advance | PENDING |
| PID | PENDING |

## Recommended order
1. Bake Z-offset, fix purge, PID tune (no hardware)
2. Speed investigation: stepwise raise; firmware rebuild if crash
3. Filament runout config + test
4. Order ADXL345 → input shaping
5. Pressure advance
6. Orca profile fixes
7. Powered USB hub for Radxa
