# Firmware

## Current firmware

- **Klipper with display** — jpcurti fork: `github.com/jpcurti/ender3-v3-se-klipper-with-display`
- Binary: `firmware/e3v3se_klipper_with_display_C13.bin` (GD32F303 / C13 board)
- Local source tree + official fork docs: `~/Downloads/zero3-flash/ender3-v3-se-klipper-with-display/`

## Flash notes

- Firmware is MCU-specific: `C13` = GD32F303, `C14` = STM32F401. Never cross-flash.
- **Delivery method: SD card, NOT USB.** The USB cable is for the printer→host serial link, not flashing. No ST-Link, no DFU.
- Procedure (per jpcurti `e3v3se_docs/install.md`):
  1. Copy the `.bin` to an empty **FAT32 microSD card** (the card that ships with the printer works).
  2. Printer **powered off** → insert card → power on → wait ~2 minutes.
  3. **Rename gotcha:** the filename must be **different from the last flashed firmware** (max 8.3 name, e.g. `firmw.bin` if `firmware.bin` was last used). The bootloader compares filenames — same name = no flash.
  4. If the old Marlin GUI shows on the display, the flash didn't take: rename the file and retry.
- **Display firmware baseline:** the fork is based on **E3V3SE display firmware 1.0.6**. If Creality shipped a newer display firmware on the screen, the display assets may need re-mapping. Verify the screen's firmware version on first boot.
- Keep the known-good binary in `firmware/` — `~/Downloads` is not a durable home. Staged copies: `firmware/e3v3se_klipper_with_display_C13.bin` (HAL, in-tree) and `/home/pi/firmware/` (Radxa, hash-verified identical).

## Source-of-truth docs

The jpcurti repo ships an `e3v3se_docs/` folder:

- `install.md`
- `configuration.md`
- `calibration.md`
- `troubleshooting.md`

Treat those as authoritative for this fork. Summaries or deltas go here in `docs/`.
