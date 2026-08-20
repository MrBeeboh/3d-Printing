# MCU USB Autosuspend Incident — 2026-08-19 (RESOLVED)

**Status: RESOLVED. No physical action was required.** Printer READY, MCU link stable.

## Summary

The Ender-3 V3 SE's host→MCU USB link (CH340, `/dev/ttyUSB0`) repeatedly dropped during
CAMERA-MOUNT-001d (2026-08-19), ending the print at the end-gcode stage (71.8 min of clean
layers). The failure was initially diagnosed as needing physical recovery (power-cycle,
endstop inspection). Root cause turned out to be **software, on the host side**.

## Root cause

The **Radxa Zero 3W Klipper host** was suspending its USB bus, dropping the CH340 serial
link to the printer mainboard:

- 11 lost-comm shutdowns / 7 USB disconnects recorded in one prior boot (host dmesg).
- This boot's failure chain: G28 X0 "No trigger on stepper_x" → mcu_awake decay → EOF →
  "Timeout with MCU" → safe klippy shutdown.
- Prior-boot TMC `GSTAT reset=1` on all three drivers (x/y/z) — brown-out *class* symptom
  consistent with the link dying mid-operation, NOT a mainboard power fault.

**"No trigger on stepper_x" was a SYMPTOM of the dead MCU link, not an endstop fault.**
X endstop (PA5, `~!PA5`) is intact and was never faulty.

## Fix applied (host-level, remote — no machine-side action)

1. **Kernel cmdline:** `usbcore.autosuspend=-1` added to `/boot/armbianEnv.txt` (or the
   distro's cmdline mechanism) + `u-boot-update`; verified live in `/proc/cmdline`.
2. **USB power keep-on:** `/etc/tmpfiles.d/usb-power-on.conf` forces all USB ports on at
   boot (prevents runtime PM from re-arming).
3. **Auto-recovery timer:** `klipper-recover.timer` — 30 s poll, print-aware; fires
   `FIRMWARE_RESTART` on klippy error/shutdown **when the MCU is present** (so it never
   loops blindly against a dead link). Enabled + active.
4. Zero 3W rebooted to load the cmdline fix.

## Verification (foreman, 2026-08-19 ~21:10 PDT, live)

| Check | Result |
|---|---|
| `/proc/cmdline` contains `usbcore.autosuspend=-1` | ✓ |
| `/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0` | ✓ (→ ttyUSB0) |
| klipper / moonraker service | active / active |
| `klipper-recover.timer` | enabled + active (30 s poll) |
| `klipper-recover.service` last run | success, exit 0 |
| USB disconnect events this boot | **0** |
| Moonraker :7125 from HAL2026 | open |
| Host uptime at check | 1 h 11 m (post-reboot) |

## DoD gate (still in force)

No re-dispatch of prints beyond the approved queue until the MCU link **survives a full
print + end homing** on the new config. The next print job is the natural proof.

## References

- Prior (superseded) physical run sheet: `Sentinel-on-JeNo7/docs/MCU_USB_RECOVERY_001.md`
  (commit 7b89a20) — NOT needed; keep for the checklist value.
- Host reliability pitfalls: `klipper-host-operations` skill (pitfall 14: Zero 3W
  USB/power reliability).
- Canonical print workflow: `docs/PRINT-OPERATIONS.md`, `docs/ORCA.md`.
