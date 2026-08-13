# Printer arrival checklist (Ender-3 V3 SE → Zero 3W)

The printer arrives **~Aug 13, 2026**. Everything below is staged and verified except the physical steps.

## Current state (Aug 11)

- Zero 3W: **online** at 192.168.0.18, Moonraker v0.10.0 on :7125, Fluidd installed, root SSH works from HAL
- Klipper service: running but **blocked** — `printer.cfg` on the host is a 1-line placeholder (no `[mcu]`), so klippy exits with `Option 'serial' in section 'mcu' must be specified`. Expected; nothing to fix until the printer exists.
- Configs staged in `../configs/` (main cfg, prtouch, macros)

## Day-of steps

1. **Flash printer firmware — SD card, not USB.** Copy `firmware/e3v3se_klipper_with_display_C13.bin` to a FAT32 microSD (use the card from the box), printer **powered off**, insert, power on, wait ~2 min. **The bin filename must differ from the last flashed firmware** (e.g. `firmw.bin` — the bootloader skips same-named files). Marlin GUI still showing = flash didn't take → rename + retry. Bin also staged on the Radxa at `/home/pi/firmware/` (hash `a193cf05…`).
2. **Connect** — printer USB → Zero 3W USB port.
3. **Verify serial appears**: `ls -l /dev/serial/by-id/` on the host. Expect `usb-1a86_USB_Serial-if00-port0` (CH340). If different, update `[mcu] serial:` in `printer.cfg`.
4. **Deploy configs** — follow `configs/README.md` (copy 3 files, add includes, display section, restart klipper).
5. **Confirm klippy connects** — `systemctl status klipper`, check `~/printer_data/logs/klippy.log` for `Starting Klippy...` → MCU connected. Fluidd at **`http://radxa-zero3.local:4408`** should show live temps (Moonraker API is on :7125; :7125 root shows Moonraker's own page, not the UI).
6. **Calibrate** — follow the jpcurti fork's `e3v3se_docs/calibration.md` (Z offset, bed mesh, pressure advance, input shaping later — ADXL is optional, manual tuning works).

## Watch-outs

- **MCU variant**: C13 (GD32F303) vs C14 (STM32F401) — firmware binaries are NOT interchangeable. Check the board before flashing the .bin.
- Klipper's `restart_method: command` in the stock config requires the firmware built for serial command restart — the staged C13 bin supports it.
- If the display doesn't wake after flash, re-check the `[e3v3se_display]` section and `klippy_uds_address` in moonraker.conf.
