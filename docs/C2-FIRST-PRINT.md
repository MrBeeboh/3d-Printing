# Centauri Carbon 2 — first PETG / test print path

Updated: 2026-09-08 19:45 PDT (Ernie)  
Printer: `192.168.0.24` (MQTT :1883, cam :8080)  
Slicer: ElegooSlicer on Fred (installed **1.5.3.5**)  
Companion: `C2-PETG-preset.md` · `C2-OrcaSlicer-cheat-sheet.md`

## Currency (as of this note)

| Piece | House status | Upstream note |
|-------|--------------|---------------|
| ElegooSlicer | **1.5.3.5 on Fred** | GitHub `elegooofficial/ElegooSlicer` latest tagged **1.5.3.4** (2026-08-06). 1.5.3.5 is ≥ that — treat as current unless Elegoo site shows newer. |
| Matrix app | Target was **1.2.6** (Fred staging) | Confirm on phone/store when convenient. Not required for LAN print via ElegooSlicer. |
| Printer FW | **Unknown from LAN** (MQTT needs access code; HTTP has no public version API) | OpenCentauri archive newest stock mirror: **v02.00.02.00** (2026-05-28). Read version on touchscreen: Settings → About / Firmware. **Do not OTA “for fun”** — from 02.00.02.00 Elegoo disabled SSH and blocked downgrades. Update only if you have a bug it fixes. |

## Preconditions (before slicing)

1. Filament **dry** — PETG **60 °C / 6 h** (Formfortis).
2. Plate: **textured PEI** (matches preset bed 65 °C).
3. ElegooSlicer → Device: printer `192.168.0.24` still connects (access code as already saved).
4. Optional: run printer full auto calibration once if not done after unbox / move.
5. Read FW version on screen → jot it into `live/cc2-updates.md`.

## ElegooSlicer process knobs (PETG)

From `C2-PETG-preset.md` / Formfortis `dkzzk8ULsX0`:

| Setting | Value |
|---------|--------|
| Nozzle | **240 °C** |
| Bed | **65 °C** textured PEI |
| Flow | **0.96** |
| Max volumetric speed | **6 mm³/s** |
| Part cooling | **30% / 30%**; **first 3 layers off** |
| Retraction | **0.2 mm @ 30 mm/s** |
| Z-hop | **0.4 mm** |

Start from **system CC2 + PETG** profile, then apply orange overrides above. Don’t freestyle beyond this for print #1.

## Recommended first object

**Small calibration / single-wall cube or short benchy** — not a tall multi-color job.

1. Import model in ElegooSlicer **Prepare**.
2. Orient flat large face on bed; no giant bridges.
3. Slice → **Preview** first layer fully solid on bed (same gate mindset as SE shop: prove L1 before send).
4. Send via LAN (ElegooLink / Device). Prefer USB only if Wi‑Fi flakes.
5. **Operator GO** before start — no auto-start from agents.

## Pass / fail watch

- First layer: even squish, no peel at corners.
- PETG stringing: if bad, dry longer before chasing retract.
- Wi‑Fi drop mid-print: fall back USB next job; note FW if drops are chronic.

## Blocked without operator

- Confirm touchscreen **FW version** (and Matrix version if installed).
- Dry cycle timing / which PETG spool.
- Explicit **GO** to start any job.
