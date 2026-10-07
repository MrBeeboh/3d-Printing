# Centauri Carbon 2 — file-drop workflow (2026-09-07)

Operator decision **(a)**: CC2 stays on **Fred's Win11 box** (Elegoo Slicer there).
HAL2026 does **not** run Elegoo Slicer (no Linux build — vendor ships Windows/macOS
only). Files travel to Fred via the existing Samba share.

## The machines

| Machine | Runs | Role |
|---|---|---|
| CC2 printer | 192.168.0.24 (libhv :80, cam :8080) | ELEGOO OS, NOT Klipper/Moonraker |
| Fred Win11 | 192.168.0.22 (SSH open; user `fires`, key in ~/.ssh/config) | **Elegoo Slicer** drives CC2 |
| HAL2026 | Linux | Orca 2.4.2 drives Ender-3 V3 SE only |

CC2 = ELEGOO OS. No :7125, no Moonraker routes on :80 (probed 2026-09-07: all
`/printer/info`, `/api`, `/moonraker` = 404). Do **not** wire it like the Ender.

## The share (drop files for Fred)

Samba `DroneBuilds` on HAL2026:
- path = `/home/mike/Documents/DRONE Builds`
- `guest_ok=n`, Everyone:F → connect as `mike`
- Fred's box sees it as a normal Windows network share.

Drop CC2 jobs into `/home/mike/Documents/DRONE Builds/<project>/` (or a
`CC2_PRINTS/` subfolder) and tell Fred — he slices/sends from Elegoo Slicer.

## Split (binding)

- **Elegoo Slicer drives CC2** — lives on Fred's Win11.
- **Stock Orca drives Ender-3 V3 SE** via Moonraker .18 — unchanged.
- HAL2026 Orca is *not* CC2-capable anyway (CC2 support landed in Orca May-2026
  merge; local 2.4.2 predates it).

## Notes for Fred / whoever drives Elegoo Slicer

- Connect in slicer to `192.168.0.24` (LAN mode on the CC2 touchscreen; optional
  access code). No cloud/account needed for local network use.
- First job per arrival brief: single-color Benchy (shelf PLA) → then 2-color →
  4-color; read purge/waste numbers before trusting flush totals.
- Ender stays untouched until operator decides its role (parallel/fallback/retire).
