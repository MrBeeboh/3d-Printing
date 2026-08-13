# Klipper host — Radxa Zero 3W

## Host unit

- **D4E0H0** — 4GB RAM, no eMMC, no header — this is the Klipper host.
- Spare: **D2E0H1** — 2GB, header.
- SKU decode: `Dx` = RAM size, `E0` = no eMMC, `H0`/`H1` = no/yes 40-pin header.

## Access (verified Aug 11, 2026)

- Hostname: `radxa-zero3.local` → **192.168.0.18** (WiFi)
- **SSH: `root@radxa-zero3.local`** — key auth works from HAL (mike@HAL2026 key). No password needed.
- **Moonraker API: `http://radxa-zero3.local:7125`** — Moonraker **v0.10.0-31-gd5ee171** (current upstream)
- **Fluidd UI: `http://radxa-zero3.local:4408`** — v1.37.4 (current release); served by a simple systemd unit (`fluidd.service`, python3 http.server on 4408)
- The Zero 3W is **not always connected** — it was offline earlier the same day it came online. Check reachability first.

## Version audit (2026-08-11)

| Component | Version | Upstream latest | Status |
|---|---|---|---|
| Klipper (host) | jpcurti fork `d74d36bb6` (v0.13.0-919) | fork master `d74d36bb6` (Jul 29) | ✅ current |
| Moonraker | `d5ee171` (v0.10.0-31) | upstream `d5ee171` (Jun 29) | ✅ current |
| Fluidd | v1.37.4 | v1.37.4 (Aug 11) | ✅ current |
| klippy-env | Python 3.9.2 | — | ✅ fixed (was broken py2.7 venv) |
| Firmware bin | C13 build from fork master | fork master | ✅ current (see `firmware.md`) |

**Fixes applied Aug 11:** host klipper switched from vanilla Klipper3d/klipper → **jpcurti fork** (vanilla lacks `e3v3se_display.py` — would have rejected the `[e3v3se_display]` config on arrival day); klippy venv rebuilt on Python 3.9 (was a dead Python 2.7 venv — klippy could never actually run); Fluidd made reachable on :4408 (was installed but not served).

## Services

- Klipper (klippy) — running, but **blocked on empty `printer.cfg`** (placeholder, no `[mcu]`) until the printer arrives (Aug 13). See `printer-arrival.md`.
- Moonraker (API, port 7125) — running, klippy_connected: false (expected, see above)
- Fluidd (web UI) — installed under `/home/pi/fluidd`

## Layout on host (user `pi`, rootfs at `/home/pi/`)

- `/home/pi/klipper` + `/home/pi/klippy-env` — Klipper + venv
- `/home/pi/moonraker` + `/home/pi/moonraker-env` — Moonraker + venv
- `/home/pi/printer_data/` — config/, logs/, gcodes/
- `/home/pi/fluidd` — web UI

## OS / flashing

- Image: `radxa-zero3_debian_bullseye_xfce_b6.img` (in `~/Downloads/zero3-flash/` on HAL)
- Maskrom flash tooling in `~/Downloads/zero3-flash/`:
  - `rkdeveloptool/` — Rockchip flashing utility
  - `rk3528_ddr_1056MHz_v` + `rk3528_usbplug_v1` — maskrom loaders
- See the `rockchip-sbc-flashing` skill for the maskrom procedure.
