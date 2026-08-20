# Printer Status — CURRENT (2026-08-19, evening)

**Status: READY. Bed clear. No print running.**

- **MCU USB-drop incident RESOLVED** — root cause was Radxa Zero 3W **USB autosuspend**
  dropping the CH340/MCU link, NOT hardware, NOT an endstop fault. Fix: `usbcore.autosuspend=-1`
  in kernel cmdline + tmpfiles USB keep-on + print-aware `klipper-recover.timer` (30 s poll).
  Verified live: 0 USB disconnects this boot, MCU present, klipper/moonraker active.
  Full detail: `docs/MCU-USB-AUTOSUSPEND-INCIDENT-2026-08-19.md`.
- CAMERA-MOUNT-001 part: printed clean to 71.8 min, crashed at end-gcode in the (now fixed)
  MCU drop. Camera (OV5647) exposure fixed today: gain 160→700; hardware-encoded, CPU 61%→15%.
- `zoff_coupon.gcode` printed clean (217 s) — thin, consistent, well-adhered pad with a skirt.
  **Coupon calibration is DONE.** Do NOT re-verify bed level / first-layer before the next job.
- Klipper: ready. Moonraker: 192.168.0.18:7125. Fluidd: :4408.

Next job: slice with OrcaSlicer 2.4.2, verify first-layer footprint, show preview, wait for
Mike's **go**. Never auto-chain.
