# Thursday Run-Sheet — Ender-3 V3 SE + Radxa Zero 3W + Klipper

Goal: go from box to printing on Klipper in one afternoon. Follow in order. Check each box before moving on.
Sources: `research-digest-2026-08-11.md` (pre-arrival research) + `upgrade-plan.md` (master plan). Printer arrival: Aug 13.

---

## Phase 0 — Pre-arrival (do BEFORE the box opens, 30 min)

- [ ] Confirm Zero 3W online: `ping radxa-zero3.local` (or 192.168.0.18)
- [ ] `ssh root@radxa-zero3.local` works
- [ ] Heatsink fitted on Zero 3W (idle temp check: `cat /sys/class/thermal/thermal_zone0/temp` — expect <60°C, not 70+)
- [ ] `brltty` removed / disabled on host (blocks USB serial): `systemctl status brltty` → masked/absent
- [ ] User in `tty` group: `usermod -aG tty pi`
- [ ] `libopenblas-base` installed on host (required for resonance tuning)
- [ ] WiFi power-save disabled (`iw dev wlan0 set power_save off` or config)
- [ ] USB-Ethernet dongle ready as fallback print channel (WiFi is the #1 known risk)
- [ ] Powered USB hub ready (board + printer serial draw >500 mA)
- [ ] Firmware bin copied to FAT32 microSD with a FRESH filename (≤8.3 chars, e.g. `fw0813.bin` — must differ from any previously flashed name)
- [ ] Confirm which C13 bin: `firmware/e3v3se_klipper_with_display_C13.bin` (GD32F303 — never C14)
- [ ] ADXL345 + mounts on hand (toolhead #745761, bed #713280) — not needed Thursday, verify delivery
- [ ] KAMP planned (or use fork's stock mesh macros — decide before first print)

## Phase 1 — Unbox & mechanical once-over (45-60 min)

- [ ] Visual: frame squareness, gantry level/slant check, connector seating (all JSTs seated)
- [ ] X-carriage v-wheel eccentric nuts — tighten 3rd wheel to kill wobble (no factory guidance; all 3 belts tensionable)
- [ ] Y linear rods — check bed movement smoothness, no binding (rods, NOT v-wheels on Y)
- [ ] Belt tension on all three belts — firm but not twangy
- [ ] Hotend cooling fan spins free + clean (heat-creep clog is the #1 SE failure)
- [ ] Run stock leveling wizard per Creality manual (do NOT skip — first-run bed protection)
- [ ] Stock baseline print: Benchy (~20 min) — record time, quality, artifacts. This is upgrade-plan Stage 1 baseline.

## Phase 2 — Flash firmware (30-45 min)

- [ ] Printer POWERED OFF → insert microSD → power ON
- [ ] Wait ~2 min. Display must leave Marlin GUI. If still Marlin: rename bin (different filename) and reflash — bootloader survives, do not panic
- [ ] Verify display FW version if possible: must be 1.0.6 (newer breaks fork mapping)
- [ ] Connect printer USB → Zero 3W (through powered hub)
- [ ] Check serial: `ls /dev/serial/by-id/` — if empty try `ls /dev/serial/by-path/` (then keep the same USB port)
- [ ] Confirm klippy starts: `systemctl status klipper` on host, tail `klippy.log` for errors

## Phase 3 — First Klipper boot & Z-offset (60-90 min)

- [ ] printer.cfg active (see `configs/` — add `[e3v3se_display]` + `language: en` if not present)
- [ ] Menuconfig verified: STM32F103 + 28KiB bootloader + USART1 PA10/PA9 + serial bridge + USART2 (NOT STM32F303)
- [ ] Home axes — verify all moves correct direction, no grinding
- [ ] **Z-offset — use fork macros, NOT web UI field (ephemeral, resets on G28):**
  - [ ] `PRTOUCH_PROBE_ZOFFSET` several times until stable
  - [ ] `PRTOUCH_ACCURACY SAMPLES=10 PROBE_SPEED=1`
  - [ ] `PRTOUCH_PROBE_ZOFFSET APPLY_Z_ADJUST=1` + `SAVE_CONFIG`
  - [ ] Paper test at corners. Any doubt → redo. A bad offset digs the nozzle into the plate.
- [ ] First mesh: 5×5 (mesh_min 30,30 / max 207,215.5 per community cfg)
- [ ] PID tune extruder + bed (community start: extruder Kp 27.142 Ki 1.371 Kd 134.351 @200°C; bed 66.371/0.846/1301.702 @70°C)
- [ ] Filament runout sensor test — feed through, trigger sensor by hand, verify pause actually fires (PC15; known flaky, verify with a REAL test)
- [ ] Emergency stop test (M112 / ESTOP from Fluidd)

## Phase 4 — First Klipper print (30 min)

- [ ] Small calibration cube or test print (not full Benchy yet)
- [ ] Verify: first layer squish, no dragging, extrusion consistent
- [ ] Tune Z-offset micro-adjustments via fork macro if first layer looks off
- [ ] **STOP HERE for the day if time-boxed.** Everything below is tuning, not critical path.

## Phase 5+ — Subsequent days (not Thursday)

- [ ] KAMP mesh (scale probe to print area) or decide fixed mesh frequency
- [ ] Pressure Advance tower (per filament; brass ≈ 0.06 start, tower method not Ellis pattern)
- [ ] Input Shaper: install ADXL345 (toolhead for X, bed for Y) → `MEASURE_AXES_NOISE`, resonance measurements → expected Y ≈ 34–35 Hz
- [ ] Volumetric flow test (hotend expected >30 mm³/s — confirm, don't trust)
- [ ] Acceleration profiles: QUALITY 1000 / NORMAL 2500 / FAST 4000 / EXPERIMENTAL 6000 (verify each)
- [ ] Decide gantry/X-rail mod only IF X resonance measurements show it's the limit
- [ ] Consider PEI plate + 10mm bed rod only if mesh/quality measurements justify

---

## Thursday definition of done

1. Stock baseline printed and documented
2. Klipper running on C13, display working
3. Z-offset set via macros + saved
4. First Klipper print successful
5. Runout sensor verified (or knowingly deferred)
