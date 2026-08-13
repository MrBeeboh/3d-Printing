# Tips & troubleshooting

## Starting points

- The jpcurti fork's official docs cover install/config/calibration/troubleshooting for the stock-board Klipper setup:
  `~/Downloads/zero3-flash/ender3-v3-se-klipper-with-display/e3v3se_docs/`
- Creality's own wiki/forum pages (cached locally under `~/.hermes/cache/web/`) are secondary — fork docs take precedence for Klipper-specific issues.

## Known gotchas (this setup)

1. **MCU variant matters** — C13 vs C14 binaries are not interchangeable. Confirm the board variant before flashing.
2. **Zero 3W may be offline** — if Moonraker won't answer on `radxa-zero3.local:7125`, check the host is powered/connected before blaming Klipper.
3. **Stock board ≠ official Klipper** — Creality's official Klipper firmware is Pad-only; the stock board needs the jpcurti fork.

## To be filled in from experience

- First-layer/leveling quirks
- Retraction values that work
- Bed adhesion notes per material
- Anything that bites more than once

Add entries as they're learned — receipts over vibes.
