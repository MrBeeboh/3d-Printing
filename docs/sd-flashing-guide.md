# E3V3SE (Ender-3 V3 SE) — SD-Card Firmware Flashing Guide (Klipper)

**Board:** Creality Ender-3 V3 SE **stock board** · **Fork:** `jpcurti/ender3-v3-se-klipper-with-display`
**Source-of-truth:** fork `e3v3se_docs/install.md` + `troubleshooting.md` (local: `~/Downloads/zero3-flash/ender3-v3-se-klipper-with-display/`)
**Known-good binary:** `firmware/e3v3se_klipper_with_display_C13.bin` (md5 `8dd5c57f2a77b567eec13ef91181c47e`)

> ⚠️ **Delivery is SD card only.** The printer's USB-C is the host→MCU serial link (CH340), **not** a flashing port. No ST-Link, no DFU, no `make flash` for the initial/board flash.

---

## 1. Get the right binary (MCU variant matters — FIRST)

The V3 SE ships with two MCU variants and the `.bin` files are **not interchangeable**:

| Variant | MCU | Target |
|---------|-----|--------|
| **C13** | GD32F303 | `stm32f103xe` (28 KiB bootloader offset) |
| **C14** | STM32F401 | (different target — never mix) |

How to identify your board:
- Screen / firmware filename convention (`..._C13.bin` = GD32F303).
- Silkscreen/marking on the MCU chip itself (GD32F303 vs STM32F401).

Never flash a C14 bin on a C13 board or vice versa — it won't run.

---

## 2. SD card requirements

- **Format:** **FAT32** (a brand-new card may be exFAT or unformatted — reformat it).
- **Allocation unit size:** **4096 bytes** (4 KiB).
- **Size:** ≤ **8 GB** preferred. Large cards (>32 GB) and SDHC/SDXC can be rejected by the bootloader. The card that ships with the printer works.
  - **⚠️ 2026-08-19 lesson:** a prior flash on this machine likely DIDN'T take because a **32 GB
    card (the Zero 3W's) was used**. Use a **small (≤8 GB) card only** for this board.
- **Empty:** remove all other files first. Only the `.bin` should be present.
- **No write protection** and healthy (a bad/corrupt card is a common "ignored bin" cause).

Format command (Linux, adjust `/dev/sdX` to your card):
```sh
sudo mkfs.fat -F 32 -S 4096 /dev/sdX     # -S 4096 sets allocation size 4096
```
Windows: `SD Card Formatter` or right-click → Format → FAT32, allocation unit size = 4096.

---

## 3. Filename rules (the #1 gotcha)

- **Max 8.3 filename** (8 chars + `.bin`), e.g. `firmw.bin` or `firmware.bin`. A long source name like `e3v3se_klipper_with_display_C13.bin` **must be renamed** to ≤8.3.
- **The name MUST differ from the last-flashed firmware.** The bootloader skips a file whose name matches the previous flash — same name = silently ignored. So if `firmware.bin` was used last time, rename to `firmw.bin` (or any other different ≤8.3 name).
- **Rename on every retry.** After a failed flash you must pick a *different* name again, or it will still be skipped.
- Lowercase is conventional; keep it simple.

Practical example — flashing the project's known-good C13 bin:
```sh
cp firmware/e3v3se_klipper_with_display_C13.bin /media/<mount>/firmw.bin
sync
```

---

## 4. Power-cycle / flash sequence (exact)

1. **Printer POWERED OFF** (switch off / unplug — board not powered).
2. Insert the prepared microSD card.
3. **Power the printer ON.**
4. **Wait ~2 minutes** — do not interrupt. The bootloader reads the `.bin` at power-on and flashes it.
5. Success signal: the **Klipper/Creality display UI appears** (not the old Marlin GUI).
   - If the **old Marlin GUI shows → the flash did NOT take**: power off, rename the file (new, different name), re-insert, power on, wait again.
6. After confirming, power off and **remove the SD card** (leaving it in can cause an MCU-connect failure on subsequent boots).

> Display baseline: the fork targets **E3V3SE display firmware 1.0.6**. If Creality shipped a newer display firmware on the screen, the display may need re-mapping — verify the screen firmware version on first boot.

---

## 5. Verify the flash succeeded (klippy.log MCU version)

After flashing, start Klipper on the host (Radxa Zero 3W) and confirm the MCU version matches the build you flashed.

Log path on host: `~/printer_data/logs/klippy.log` (also symlinked to `/tmp/klippy.log`).

**Check the `Loaded MCU` line** (the version string here comes from the firmware image the MCU reports over the serial protocol — it changes when you flash a different build):

```sh
grep -i "Loaded MCU\|Configured MCU\|Starting Klippy" ~/printer_data/logs/klippy.log
```

What you're looking for:
```
Starting Klippy...
Loaded MCU 'mcu' <N> commands (<version> / <build>)
MCU 'mcu' config: ...
Configured MCU 'mcu' (<moves> moves)
```

- **`Loaded MCU 'mcu' N commands (… / …)`** — the version/build reflects the **flashed** firmware. It should match the build you flashed (e.g. the fork's git version/hash). A stale/old version here means the flash didn't take or the old firmware is still running.
- **`Configured MCU 'mcu' (N moves)`** — confirms the MCU fully initialized and Klipper established the serial connection.

**Also confirm host→MCU link** (from `docs/printer-arrival.md`):
```sh
ls -l /dev/serial/by-id/            # expect usb-1a86_USB_Serial-if00-port0 (CH340)
systemctl status klipper            # service running, no errors
```
Fluidd UI: `http://radxa-zero3.local:4408` should show live temps (Moonraker API is on :7125).

---

## 6. Common failure modes & fixes

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| **.bin ignored / no flash** | Filename same as last-flashed | Rename to a different ≤8.3 name |
| **.bin ignored** | Not FAT32, or wrong allocation size | Reformat FAT32, 4096 alloc |
| **.bin ignored** | Card too big / SDHC/SDXC | Use ≤8 GB card |
| **Old Marlin GUI after power-on** | Flash didn't take | Power off, rename, power on, wait 2 min |
| **MCU "Unable to connect" on boot** | SD card left inserted | Power off, remove card, power on |
| **Wrong firmware / won't boot** | C13 vs C14 mismatch | Flash the correct variant bin |
| **Display "goes crazy"** | Display FW ≠ 1.0.6 baseline | Update display to 1.0.6 (Creality) |
| **Flash never detects new file after retries** | Same filename reused | New unique filename each attempt |

General "renamed and still won't flash" — try a slightly different name again; the bootloader is picky and it can take a few attempts (per fork `troubleshooting.md`).

---

## 7. Reference

- Fork install docs: `~/Downloads/zero3-flash/ender3-v3-se-klipper-with-display/e3v3se_docs/install.md`
- Fork troubleshooting: `.../e3v3se_docs/troubleshooting.md`
- Known-good bin + stock Creality `Ender-3-V3-SE_HWCR4NS200320C13_SWV1.0.6_GD303.zip` (display FW 1.0.6): `firmware/`
- Project hardware facts: `docs/printer-hardware.md`, `docs/firmware.md`
