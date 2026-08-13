# Ender-3 V3 SE — hardware notes

## Board / MCU

- Stock mainboard (the one shipped with the printer).
- Two MCU variants exist in the wild:
  - **C13 → GD32F303** (GigaDevice)
  - **C14 → STM32F401** (ST)
- **Firmware binaries are MCU-specific.** A C13 build will not run on a C14 board and vice versa. Check which variant you have before flashing.

## Identifying your MCU

- Marking on the MCU chip itself (GD32F303 vs STM32F401).
- The printer screen / firmware filename convention (`..._C13.bin` = GD32F303).

## Firmware options (stock board)

| Option | Notes |
|---|---|
| Official Creality stock (V1.1.0) | Marlin-based, as shipped |
| Official Creality Klipper | **Pad-only** — does not run on the stock board |
| jpcurti `ender3-v3-se-klipper-with-display` | Community fork adding Klipper + display support on the **stock board**. This is the one in use. |

## Mechanical baseline (V3 SE)

- Direct-drive extruder, auto-level (CR Touch style), 220×220×250 mm build volume.
- Full spec sheet belongs here once verified from the manual — do not guess values.
